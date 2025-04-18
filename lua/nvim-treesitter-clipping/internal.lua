local parsers = require("vim.treesitter")
local tsutils = require("nvim-treesitter.ts_utils")

local M = {}

---@alias parteditargs {from: integer, to: integer, pattern_id: integer, filetype?: string, prefix?: string, auto_prefix?: string, prefix_pattern?: string}

---range の列を受け取り、隣接している range をいい感じにマージする。
---@param clip_group {from: integer, to: integer, pattern_id: integer}[]
---@return {from: integer, to: integer, pattern_id: integer}[]
local function merge_clip_group(clip_group)
    -- パターン ID が異なるものはマージできないため
    -- パターン ID の若い順・開始が早い順にソート
    table.sort(clip_group, function(clip1, clip2)
        if clip1.pattern_id == clip2.pattern_id then
            return clip1.from < clip2.from
        else
            return clip1.pattern_id < clip2.pattern_id
        end
    end)

    local lst = {}
    local tmp
    for _, clip in ipairs(clip_group) do
        if tmp == nil then
            tmp = clip
        else
            if clip.pattern_id == tmp.pattern_id and clip.from - 1 <= tmp.to then
                -- merge する。
                tmp.to = clip.to
            else
                lst[#lst + 1] = tmp
                tmp = clip
            end
        end
    end
    if tmp ~= nil then
        lst[#lst + 1] = tmp
    end

    return lst
end

---partedit 可能な箇所のリストを返す。
---partedit 可能な箇所は query にマッチする箇所として判定する。具体的には
---`@clip`: partedit 可能な node をキャプチャする
---`@clip_group`: partedit 可能な node の一部をキャプチャする（連続したら連ねる）
---@param bufnr integer
---@return parteditargs[]
local function get_code_ranges(bufnr)
    if bufnr == nil then
        bufnr = 0
    end

    local tsparser = parsers.get_parser(bufnr)
    local lang = tsparser:lang()
    local tree = tsparser:parse()[1]

    local query = vim.treesitter.query.get(lang, "clipping")
    if query == nil then
        return {}
    end

    local clip_captures = {}
    local clip_group = {}

    for pattern_id, match, metadata in query:iter_matches(tree:root(), bufnr) do
        ---@type "clip" | "clip_group" | nil
        local kind
        local range
        local filetype

        if metadata.filetype ~= nil then
            filetype = metadata.filetype
        end
        local prefix = metadata.prefix
        local auto_prefix = metadata.auto_prefix
        local prefix_pattern = metadata.prefix_pattern
        local exclude_bounds = metadata.exclude_bounds

        for id, nodes in pairs(match) do
            -- TODO: 一旦マッチした最初のノードのみ取る。本当は node ごとに iterate すべき
            local node = nodes[1]
            local name = query.captures[id]
            -- `node` was captured by the `name` capture in the match
            if name == "clip" or name == "clip_group" then
                kind = name
                local metadata_match = metadata[id]
                if metadata_match ~= nil and metadata_match.range ~= nil then
                    range = metadata_match.range
                else
                    range = { node:range() }
                end
            elseif name == "filetype" then
                filetype = vim.treesitter.get_node_text(node, bufnr or 0, {})
            end
        end

        local offset_start = 0
        local offset_end = 0
        if exclude_bounds == "start" or exclude_bounds == "both" then
            offset_start = 1
        end
        if exclude_bounds == "end" or exclude_bounds == "both" then
            offset_end = 1
        end

        local capture_info = {
            from = range[1] + 1 + offset_start,
            to = range[3] + 1 - offset_end,
            pattern_id = pattern_id,
            filetype = filetype,
            prefix = prefix,
            auto_prefix = auto_prefix,
            prefix_pattern = prefix_pattern,
        }

        if kind == "clip" then
            clip_captures[#clip_captures + 1] = capture_info
        elseif kind == "clip_group" then
            clip_group[#clip_group + 1] = capture_info
        end
    end

    local merged_clip_group = merge_clip_group(clip_group)
    vim.list_extend(clip_captures, merged_clip_group)

    -- 開始が早い順・パターン ID の若い順にソート
    table.sort(clip_captures, function(clip1, clip2)
        if clip1.from == clip2.from then
            return clip1.pattern_id < clip2.pattern_id
        else
            return clip1.from < clip2.from
        end
    end)

    return clip_captures
end

---@type fun(bufnr): parteditargs[]
M.get_code_ranges = tsutils.memoize_by_buf_tick(get_code_ranges)

---現在のカーソル位置にあり、切り出せそうなところを新しいバッファに切り取る。
---切り出せそうなところは clipping.scm の @clip でキャプチャされたところ。
---@param bufnr? number
function M.clip(bufnr)
    -- LanguageTree object

    if bufnr == nil then
        bufnr = vim.fn.bufnr()
    end

    local cursor = vim.fn.getcurpos()
    local row_cursor = cursor[2]

    local code_ranges = M.get_code_ranges(bufnr)

    for _, d in ipairs(code_ranges) do
        if d.from <= row_cursor and row_cursor <= d.to then
            vim.fn["partedit#start"](d.from, d.to, {
                filetype = d.filetype or "",
                prefix = d.prefix,
                auto_prefix = d.auto_prefix,
                prefix_pattern = d.prefix_pattern,
            })
            return
        end
    end
end

local function select_in_visual_mode(from, to)
    if vim.fn.mode() ~= "V" then
        vim.cmd.normal("V")
    end
    vim.fn.cursor { from, 1 }
    vim.cmd.normal("o")
    vim.fn.cursor { to, 1 }
end

---現在のカーソル位置にあり、切り出せそうなところを選択する。
---切り出せそうなところは clipping.scm の @clip でキャプチャされたところ。
---@param bufnr? number
function M.select(bufnr)
    -- LanguageTree object

    if bufnr == nil then
        bufnr = vim.fn.bufnr()
    end

    local cursor = vim.fn.getcurpos()
    local row_cursor = cursor[2]

    local code_ranges = M.get_code_ranges(bufnr)

    for _, d in ipairs(code_ranges) do
        if d.from <= row_cursor and row_cursor <= d.to then
            select_in_visual_mode(d.from, d.to)
            return
        end
    end
end

function M.attach(_bufnr, lang) end

function M.detach(bufnr) end

return M

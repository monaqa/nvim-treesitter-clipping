local parsers = require "vim.treesitter"

local M = {}

---現在のカーソル位置にあり、切り出せそうなところを新しいバッファに切り取る。
---切り出せそうなところは clipping.scm の @clip でキャプチャされたところ。
---@param bufnr? number
function M.clip(bufnr)
    -- LanguageTree object
    local tsparser = parsers.get_parser(bufnr)
    local lang = tsparser:lang()
    local tree = tsparser:parse()[1]

    local cursor = vim.fn.getcurpos()
    local row_cursor = cursor[2]

    local query = vim.treesitter.get_query(lang, "clipping")
    vim.pretty_print { query = query, tree = tree:root() }
    for pattern, match, metadata in query:iter_matches(tree:root(), bufnr) do
        local range
        local filetype
        local prefix
        local auto_prefix
        local prefix_pattern

        for id, node in pairs(match) do
            local name = query.captures[id]
            -- `node` was captured by the `name` capture in the match
            if name == "clip" then
                local metadata_match = metadata[id]
                if metadata_match ~= nil and metadata_match.range ~= nil then
                    range = metadata_match.range
                else
                    range = { node:range() }
                end
                if metadata.filetype ~= nil then
                    filetype = metadata.filetype
                end
                -- prefix = metadata.prefix
                -- auto_prefix = metadata.auto_prefix
                -- prefix_pattern = metadata.prefix_pattern
            elseif name == "filetype" then
                filetype = vim.treesitter.get_node_text(node, bufnr or 0, {})
            end
        end

        -- local srow, scol, erow, ecol = node_clip:range()
        if range ~= nil then
            if filetype == nil then
                filetype = ""
            end

            local srow = range[1]
            local erow = range[3]

            if srow + 1 <= row_cursor and row_cursor <= erow then
                vim.fn["partedit#start"](srow + 1, erow, {
                    filetype = filetype,
                    prefix = prefix,
                    auto_prefix = auto_prefix,
                    prefix_pattern = prefix_pattern,
                })
                break
            end
        end
    end
end

function M.attach(bufnr, lang) end

function M.detach(bufnr)
    -- TODO: Fill this with what you need to do when detaching from a buffer
end

return M

local parsers = require "vim.treesitter"

local M = {}

---現在のカーソル位置にあり、切り出せそうなところを新しいバッファに切り取る。
---@param bufnr? number
function M.clip(bufnr)
    -- LanguageTree object
    local tsparser = parsers.get_parser(bufnr)
    local lang = tsparser:lang()
    local tree = tsparser:parse()[1]

    local cursor = vim.fn.getcurpos()
    local row_cursor = cursor[2]

    local query = vim.treesitter.get_query(lang, "clipping")
    for pattern, match, metadata in query:iter_matches(tree:root(), bufnr) do
        local range
        local filetype
        vim.pretty_print { metadata = metadata }

        for id, node in pairs(match) do
            local name = query.captures[id]
            -- `node` was captured by the `name` capture in the match
            if name == "clip" then
                local metadata_match = metadata[id]
                if metadata_match.range ~= nil then
                    range = metadata_match.range
                else
                    range = { node:range() }
                end
                if metadata.filetype ~= nil then
                    filetype = metadata.filetype
                end
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

            vim.pretty_print {
                row_cursor = row_cursor,
                range = { srow, erow },
                filetype = filetype,
            }

            if srow + 1 <= row_cursor and row_cursor <= erow then
                vim.fn["partedit#start"](srow + 1, erow, {
                    filetype = filetype,
                })
                break
            end
        end
        -- for id, node in pairs(match) do
        --     local name = query.captures[id]
        --     -- `node` was captured by the `name` capture in the match
        --
        --     local node_data = metadata[id] -- Node level metadata
        --
        --     vim.pretty_print {
        --         id = id,
        --         name = name,
        --         node = node,
        --     }
        -- end
    end
end

function M.attach(bufnr, lang)
    -- TODO: Fill this with what you need to do when attaching to a buffer
end

function M.detach(bufnr)
    -- TODO: Fill this with what you need to do when detaching from a buffer
end

return M

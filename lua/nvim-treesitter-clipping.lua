local queries = require "nvim-treesitter.query"

local M = {}

function M.init()
    require("nvim-treesitter").define_modules {
        module_template = {
            module_path = "nvim-treesitter-clipping.internal",
            is_supported = function(lang)
                return queries.get_query(lang, "clipping") ~= nil
            end,
        },
    }

    vim.keymap.set("n", "<Plug>(ts-clipping-clip)", function()
        require("nvim-treesitter-clipping.internal").clip()
    end)
end

return M

local M = {}

function M.init()
    -- require("nvim-treesitter").define_modules {
    --     clipping = {
    --         module_path = "nvim-treesitter-clipping.internal",
    --         is_supported = function(lang)
    --             return vim.treesitter.query.get(lang, "clipping") ~= nil
    --         end,
    --     },
    -- }

    vim.keymap.set("n", "<Plug>(ts-clipping-clip)", function()
        require("nvim-treesitter-clipping.internal").clip()
    end)

    vim.keymap.set({ "n", "v", "o" }, "<Plug>(ts-clipping-select)", function()
        require("nvim-treesitter-clipping.internal").select()
    end)
end

return M

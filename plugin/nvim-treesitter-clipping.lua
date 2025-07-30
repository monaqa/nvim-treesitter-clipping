if vim.g.loaded_nvim_treesitter_clipping then
    return
end
vim.g.loaded_nvim_treesitter_clipping = true

vim.keymap.set("n", "<Plug>(ts-clipping-clip)", function()
    require("nvim-treesitter-clipping").clip()
end)

vim.keymap.set({ "n", "v", "o" }, "<Plug>(ts-clipping-select)", function()
    require("nvim-treesitter-clipping").select()
end)

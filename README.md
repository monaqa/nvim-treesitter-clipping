# nvim-treesitter-clipping

This plugin uses [vim-partedit](https://github.com/thinca/vim-partedit).

## Requirements

* [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* [vim-partedit](https://github.com/thinca/vim-partedit)

## Usage

For example:

```lua
vim.keymap.set("n", "<Space>c", "<Plug>(ts-clipping-clip)")
```

Press `<Space>c` on

* Lua comments,
* Markdown code blocks,
* Python docstrings,
* Rust comments,

and see what happens.

## Supported Languages

- [x] Lua
- [x] Markdown
- [x] Python
- [x] Rust

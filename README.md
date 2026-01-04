# My Neovim configuration

Personal setup, maintained since December 2023. Completely rewritten in
January 2026.

Modular Neovim 0.11+ configuration using native LSP APIs, lazy-loaded plugins,
and treesitter for a fast, modern editing experience.

## Requirements

- Neovim 0.11+
- ripgrep, fd, git, node (for LSP servers)

### macOS

```sh
brew install neovim ripgrep fd git node
```

## Installation

```sh
git clone https://github.com/ThorstenRhau/neovim.git ~/.config/nvim
```

## Keymaps

Leader is `Space`. Press `<leader>?` to see all available mappings.

| Prefix      | Purpose            |
| ----------- | ------------------ |
| `<leader>b` | Buffers            |
| `<leader>c` | Code (LSP, format) |
| `<leader>f` | Find files         |
| `<leader>g` | Git                |
| `<leader>h` | Git hunks          |
| `<leader>o` | Oil file browser   |
| `<leader>s` | Search             |
| `<leader>t` | Toggles            |
| `<leader>w` | Windows            |
| `<leader>x` | Quickfix           |
| `g`         | Go to (LSP, align) |

## Structure

```txt
init.lua
├── lua
│   ├── config
│   │   ├── autocmds.lua    # auto commands
│   │   ├── keymaps.lua     # key mappings
│   │   ├── lazy.lua        # plugin manager bootstrap
│   │   └── options.lua     # editor options
│   └── plugins
│       ├── colorscheme.lua # modus-themes
│       ├── completion.lua  # blink.cmp
│       ├── editor.lua      # editing enhancements
│       ├── explorer.lua    # oil.nvim
│       ├── format.lua      # conform.nvim, nvim-lint
│       ├── git.lua         # gitsigns, neogit, diffview
│       ├── lsp.lua         # native LSP, mason
│       ├── mini.lua        # mini.nvim modules
│       ├── picker.lua      # fzf-lua
│       ├── terminal.lua    # toggleterm
│       ├── treesitter.lua  # syntax highlighting
│       ├── ui.lua          # which-key, lualine, trouble
│       └── ui-input.lua    # vim.ui.input handler
└── after
    └── ftplugin            # filetype-specific settings
```

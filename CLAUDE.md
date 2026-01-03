# Neovim Configuration

Personal Neovim config using lazy.nvim with 35 optional plugin files (~60+
total plugins with dependencies).

## Commands

```bash
make all           # Format and lint (pre-commit hook)
make format        # Format with stylua
make lint          # Lint with selene
```

Use the Claude Code skill **git-use** for git operations.

## Two-Mode System

Controlled by `NVIM_OPTIONAL_PLUGINS` environment variable:

- **Minimal** (default): Only loads `lua/config/` (options, keymaps, autocmds)
- **Full** (`=1`): Also loads `lua/optional/` (~37 plugins) and `lua/themes/`

Assume Full mode unless otherwise specified.

## Structure

```
├── CLAUDE.md
├── init.lua
├── lazy-lock.json
├── LICENSE
├── lua
│   ├── config
│   │   ├── autocmd.lua
│   │   ├── keymaps.lua
│   │   ├── options.lua
│   │   └── toggles.lua
│   ├── optional
│   │   ├── blink-cmp.lua
│   │   ├── claudecode.lua
│   │   ├── colorizer.lua
│   │   ├── colorpicker.lua
│   │   ├── debuggers.lua
│   │   ├── diffview.lua
│   │   ├── formatters.lua
│   │   ├── fzf-lua.lua
│   │   ├── gitsigns.lua
│   │   ├── indent-blankline.lua
│   │   ├── lazydev.lua
│   │   ├── linters.lua
│   │   ├── live-preview.lua
│   │   ├── lsp.lua
│   │   ├── lualine.lua
│   │   ├── mason-lspconfig.lua
│   │   ├── mason-tool-installer.lua
│   │   ├── mason.lua
│   │   ├── mini-nvim.lua
│   │   ├── neogit.lua
│   │   ├── neoscroll.lua
│   │   ├── nvim-web-devicons.lua
│   │   ├── oil.lua
│   │   ├── persistence.lua
│   │   ├── render-markdown.lua
│   │   ├── statuscol.lua
│   │   ├── tabout.lua
│   │   ├── toggleterm.lua
│   │   ├── treesitter-textobjects.lua
│   │   ├── treesitter.lua
│   │   ├── trouble.lua
│   │   ├── ui-input.lua
│   │   ├── vim-illuminate.lua
│   │   ├── vim-matchup.lua
│   │   └── whichkey.lua
│   └── themes
│       └── modus.lua
├── Makefile
├── neovim.yaml
├── README.md
├── selene.toml
├── spell
│   ├── en.utf-8.add
│   ├── en.utf-8.add.spl
│   ├── en.utf-8.spl
│   └── sv.utf-8.spl
└── taplo.toml
```

## Plugins (Full Mode)

### Completion & LSP

- **blink-cmp** - Completion with super-tab, fuzzy matching, ghost text
- **lsp** (nvim-lspconfig) - LSP with mason, jsonls/yamlls with schemastore
- **lazydev** - Lua development with type hints

### Formatting & Linting

- **formatters** (conform.nvim) - prettier, stylua, ruff_format, shfmt, taplo
- **linters** (nvim-lint) - eslint_d, jsonlint, selene, markdownlint, ruff,
  yamllint

### Git

- **gitsigns** - Signs, blame, hunk navigation (`]h`/`[h`)
- **neogit** - Magit-like interface (`<leader>gg`, `<leader>gC`)
- **diffview** - Diff viewer (`<leader>gd`, `<leader>gH`)

### Search & Navigation

- **fzf-lua** - Fuzzy finder (`<leader>ff`, `<leader>fg`, `<leader>/`,
  `<leader><leader>`, `<leader>n`)
- **trouble** - Diagnostics panel (`<leader>xx`, `<leader>xX`)

### UI

- **lualine** - Statusline with width-responsive sections
- **which-key** - Keymap popup guide (modern preset)
- **indent-blankline** - Indent guides with scope (`<leader>ug`)
- **statuscol** - Custom status column
- **neoscroll** - Smooth scrolling
- **ui-input** (nui.nvim) - Enhanced vim.ui.input
- **render-markdown** - Markdown rendering (`<leader>um`)
- **nvim-web-devicons** - File icons

### Text Editing

- **mini.nvim** - align, bracketed, operators, pairs, splitjoin, surround,
  jump2d
- **tabout** - Tab to exit quotes/brackets

### Code

- **treesitter** - Syntax, folding, indentation (with context)
- **treesitter-textobjects** - Text objects (`af/if`, `ac/ic`), navigation
  (`]]`/`[[`), swap
- **vim-illuminate** - Highlight word under cursor
- **vim-matchup** - Enhanced matching (`<C-k>` for context)

### Tools

- **oil** - File browser (`<leader>o`)
- **toggleterm** - Terminal (`<leader>t`, `<C-\>`)
- **debuggers** (nvim-dap) - DAP with UI (`<leader>d*`)
- **persistence** - Session management (`<leader>q*`)
- **mason** - Package manager for LSP/DAP/linters/formatters
- **colorizer** / **colorpicker** - Color display and picking
- **live-preview** - Browser preview for markdown/html

### AI

- **claudecode** - Claude integration (`<leader>a*`)

### Theme

- **modus** - Accessible, high-contrast colorscheme with light (Operandi) and dark (Vivendi) variants

Appearance changes between light and dark appearance based on 'vim.o.background'

## Key Mapping Groups

| Prefix              | Purpose                                    |
| ------------------- | ------------------------------------------ |
| `<leader>a`         | Claude AI                                  |
| `<leader>b`         | Buffer (close, split, keep only)           |
| `<leader>c`         | Code (LSP actions, rename, split/join)     |
| `<leader>f`         | Find (files, git files, buffers, oldfiles) |
| `<leader>g`         | Git (neogit, diffview, gitsigns)           |
| `<leader>l`         | Lazy plugin manager                        |
| `<leader>m`         | Mason package manager                      |
| `<leader>n`         | Messages history (fzf-lua)                 |
| `<leader>o`         | Oil file explorer                          |
| `<leader>q`         | Session                                    |
| `<leader>s`         | Search/grep                                |
| `<leader>u`         | UI toggles                                 |
| `<leader>x`         | Trouble diagnostics                        |
| `gd/gr/gI/gy`       | LSP go-to (via fzf-lua)                    |
| `ga/gA`             | Align (mini.align)                         |
| `s`                 | Surround (mini.surround)                   |
| `]h/[h`             | Git hunk nav                               |
| `]]/[[`             | Function/class navigation                  |
| `af/if/ac/ic/aa/ia` | Treesitter text objects                    |

## Config Files

- `.stylua.toml` - 120 cols, 2-space indent, single quotes
- `selene.toml` - Neovim standard
- `.prettierrc.toml` - Prose wrap always
- `taplo.toml` - TOML formatting

## Plugin Pattern

```lua
---@module "lazy"
---@type LazySpec
return {
  'plugin/name',
  ---@module "PluginName"
  ---@type PluginName.config
  opts = {},
}
```

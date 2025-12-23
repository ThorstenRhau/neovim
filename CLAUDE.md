# Neovim Configuration

Personal Neovim config using lazy.nvim with ~30 optional plugins. No Claude attribution in commits.

## Commands

```bash
make all           # Format and lint (pre-commit hook)
make format        # Format with stylua
make lint          # Lint with selene
make clean         # Remove nvim cache/state/data
make install-hooks # Enable git pre-commit hook
```

## Two-Mode System

Controlled by `NVIM_OPTIONAL_PLUGINS` environment variable:

- **Default**: Only loads `lua/plugins/` (mini-icons only)
- **Full** (`=1`): Also loads `lua/optional/` and `lua/themes/`

Assume Full mode unless otherwise specified.

## Structure

```
init.lua              # Entry point, bootstraps lazy.nvim, leader=Space, localleader='
lua/config/
  options.lua         # Editor settings (indent, search, undo, folds, LSP borders)
  keymaps.lua         # Core keymaps (window nav, buffer nav, smart j/k)
  autocmd.lua         # Format opts, filetype settings, yank highlight, cursor restore
lua/plugins/          # Always-loaded (mini-icons only)
lua/optional/         # Full mode plugins (~30 files)
lua/themes/           # Theme configs (catppuccin)
```

## Core Config Details

### options.lua
- 4-space indent with expandtab, smart case search
- Treesitter folding, persistent undo (~/.local/share/nvim/undo)
- Ripgrep for grep, rounded LSP borders, mouse in normal/visual

### keymaps.lua
- `j/k` wrap-aware, `<C-h/j/k/l>` window nav, `<S-h/l>` buffer nav
- `<Esc>` clears search, `x/X` don't yank

### autocmd.lua
- Remove auto-comment on new lines
- Markdown: wrap, spell, textwidth=80
- Git commit: textwidth=72, colorcolumn 50,73
- Close with `q`: help, qf, Trouble, lazy, mason, lspinfo, man, notify
- Persistent folds, cursor position restore, highlight on yank
- Disable undo for /tmp/*, *.env files
- Clean old undo files (>14 days) on startup

## Plugins

### Always Loaded
- **mini-icons** (`echasnovski/mini.icons`) - Icon provider, mocks nvim-web-devicons

### Completion & LSP
- **blink-cmp** (`saghen/blink.cmp`) - Completion with fuzzy matching, ghost text
- **lsp** (`neovim/nvim-lspconfig`) - LSP config with mason integration, jsonls/yamlls with schemas
- **lazydev** (`folke/lazydev.nvim`) - Lua development with type hints

### Formatting & Linting
- **formatters** (`stevearc/conform.nvim`) - prettier, stylua, ruff_format, shfmt, taplo
- **linters** (`mfussenegger/nvim-lint`) - eslint_d, jsonlint, selene, markdownlint, ruff, yamllint

### Git
- **gitsigns** (`lewis6991/gitsigns.nvim`) - Signs, blame, hunk navigation (`]h`/`[h`)
- **neogit** (`NeogitOrg/neogit`) - Magit-like interface (`<leader>gg`, `<leader>gc`)
- **diffview** (`sindrets/diffview.nvim`) - Diff viewer (`<leader>gd`, `<leader>gH`)

### Search & Navigation
- **fzf-lua** (`ibhagwan/fzf-lua`) - Fuzzy finder (`<leader>ff`, `<leader>fg`, `<leader>/`)
- **trouble** (`folke/trouble.nvim`) - Diagnostics panel (`<leader>xx`, `<leader>xX`)

### UI
- **noice** (`folke/noice.nvim`) - Modern cmdline/messages/notifications
- **lualine** (`nvim-lualine/lualine.nvim`) - Statusline
- **which-key** (`folke/which-key.nvim`) - Keymap popup guide
- **snacks** (`folke/snacks.nvim`) - Toggles (`<leader>u*` for spell, wrap, diagnostics, etc.)
- **indent-blankline** (`lukas-reineke/indent-blankline.nvim`) - Indent guides
- **statuscol** (`luukvbaal/statuscol.nvim`) - Custom status column

### Text Editing
- **mini.nvim** - ai, align, bracketed, operators, pairs, splitjoin, surround, jump2d
- **tabout** (`abecodes/tabout.nvim`) - Tab to exit quotes/brackets

### Code
- **treesitter** (`nvim-treesitter/nvim-treesitter`) - Syntax, context, folding
- **vim-illuminate** (`RRethy/vim-illuminate`) - Highlight word under cursor

### Tools
- **oil** (`stevearc/oil.nvim`) - File browser in buffer (`<leader>o`)
- **toggleterm** (`akinsho/toggleterm.nvim`) - Terminal (`<leader>t`, `<C-\>`)
- **debuggers** (`mfussenegger/nvim-dap`) - DAP with UI (`<leader>d*`)
- **persistence** (`folke/persistence.nvim`) - Session management (`<leader>q*`)
- **mason** - Package manager for LSP/DAP/linters/formatters
- **colorizer** / **colorpicker** - Color display and picking
- **live-preview** - Browser preview for markdown/html

### AI
- **claudecode** (`coder/claudecode.nvim`) - Claude integration (`<leader>a*`)

### Theme
- **catppuccin** - Default theme (latte/mocha variants)

## Key Mapping Groups

| Prefix | Purpose |
|--------|---------|
| `<leader>a` | Claude AI |
| `<leader>c` | Code (LSP, format, split/join) |
| `<leader>d` | Debug |
| `<leader>f` | Find files |
| `<leader>g` | Git |
| `<leader>o` | Oil file explorer |
| `<leader>q` | Session |
| `<leader>s` | Search/grep |
| `<leader>t` | Terminal |
| `<leader>u` | UI toggles |
| `<leader>x` | Trouble diagnostics |
| `gd/gr/gI` | LSP go-to |
| `]h/[h` | Git hunk nav |

## Config Files

- `.stylua.toml` - 120 cols, 2-space indent, single quotes, sort requires
- `selene.toml` - Neovim standard, allows lowercase_global
- `.prettierrc.toml` - Prose wrap always
- `taplo.toml` - TOML formatting

## Plugin Pattern

```lua
---@module "lazy"
---@type LazySpec
return {
  'plugin/name',
  opts = {},
}
```

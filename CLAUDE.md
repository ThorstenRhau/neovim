# Neovim Configuration

Personal Neovim config using lazy.nvim with ~37 optional plugins. No Claude
attribution in commits.

## Commands

```bash
make all           # Format and lint (pre-commit hook)
make format        # Format with stylua
make lint          # Lint with selene
make clean         # Remove nvim cache/state/data
make install-hooks # Enable git pre-commit hook
```

Use the Claude Code **git-skill** for git operations.

## Two-Mode System

Controlled by `NVIM_OPTIONAL_PLUGINS` environment variable:

- **Minimal** (default): Only loads `lua/config/` (options, keymaps, autocmds)
- **Full** (`=1`): Also loads `lua/optional/` (~37 plugins) and `lua/themes/`

Assume Full mode unless otherwise specified.

## Structure

```
init.lua              # Entry point, bootstraps lazy.nvim, leader=Space, localleader='
lua/config/
  options.lua         # Editor settings (indent, search, undo, folds, LSP borders)
  keymaps.lua         # Core keymaps (window nav, buffer nav, smart j/k)
  autocmd.lua         # Format opts, filetype settings, yank highlight, cursor restore
  toggles.lua         # UI toggle keymaps (full mode only)
lua/optional/         # Full mode plugins (~37 files)
lua/themes/           # Theme configs (catppuccin)
```

## Core Config Details

### options.lua

- 2-space indent with expandtab, smart case search
- Indent-based folding (foldlevel=99), persistent undo
  (~/.local/share/nvim/undo)
- Ripgrep for grep, rounded LSP borders, mouse in normal/visual
- Global statusline (laststatus=3)

### keymaps.lua

- `j/k` wrap-aware, `<C-h/j/k/l>` window nav, `<S-h/l>` buffer nav
- `<S-Up/Down/Left/Right>` window resize
- `<Esc>` clears search, `x/X` don't yank

### autocmd.lua

- Remove auto-comment on new lines
- Markdown: wrap, spell, textwidth=80
- Git commit: textwidth=72, colorcolumn 50,73
- Close with `q`: checkhealth, git, help, lspinfo, man, notify, qf, startuptime
- Persistent cursor position restore, highlight on yank
- Disable undo for /tmp/_, _.env, SSH/GPG dirs, credentials
- Clean old undo files (>14 days) on startup

### toggles.lua (full mode)

- `<leader>uf/uz/uw/uL/ud/ul/uc/us/uT/ub/uh` - Various UI toggles

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
  `<leader><leader>`)
- **trouble** - Diagnostics panel (`<leader>xx`, `<leader>xX`)

### UI

- **noice** - Modern cmdline/messages/notifications
- **lualine** - Statusline
- **which-key** - Keymap popup guide (modern preset)
- **indent-blankline** - Indent guides with scope
- **statuscol** - Custom status column
- **neoscroll** - Smooth scrolling
- **smear-cursor** - Animated cursor movement (`<leader>us`)
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

- **catppuccin** - latte (light) / mocha (dark) based on macOS appearance

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

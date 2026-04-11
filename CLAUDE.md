# CLAUDE.md - Neovim Configuration

Personal Neovim config (Lua, requires **Neovim 0.12+**).

## Structure

```txt
~/.config/nvim/
├── init.lua                    # Entry point (leaders, loads config/)
├── Makefile                    # format, lint, clean, install-hooks targets
├── .githooks/
│   └── pre-commit              # Runs `make all` before each commit
├── lua/
│   ├── config/                 # Core configuration
│   │   ├── autocmds.lua        # Auto-commands
│   │   ├── constants.lua       # Global constants (used by other modules)
│   │   ├── ftplugin.lua        # Filetype settings: table-driven autocmd + chainable helpers
│   │   ├── keymaps.lua         # Global keymaps (includes built-in difftool/undotree)
│   │   ├── options.lua         # Vim options
│   │   ├── pack.lua            # vim.pack plugin declarations (33 plugins)
│   │   └── terminal.lua        # Built-in terminal toggle
│   └── plugins/                # Plugin setup (one file per plugin)
│       ├── claudecode.lua      # Claude Code integration
│       ├── completion.lua      # blink.cmp
│       ├── diffview.lua        # diffview.nvim
│       ├── formatter.lua       # conform.nvim
│       ├── fzf.lua             # fzf-lua
│       ├── gitsigns.lua        # gitsigns.nvim
│       ├── ibl.lua             # indent-blankline.nvim
│       ├── linter.lua          # nvim-lint
│       ├── lsp.lua             # LSP servers
│       ├── mini.lua            # mini modules (icons, ai, align, splitjoin, surround, pairs, bracketed, move, statusline, sessions, clue)
│       ├── neogit.lua          # neogit (magit-style git UI)
│       ├── neoscroll.lua       # neoscroll.nvim
│       ├── nvim-tree.lua       # nvim-tree.lua
│       ├── oil.lua             # oil.nvim
│       ├── tabout.lua          # tabout.nvim
│       └── treesitter.lua      # Treesitter + textobjects
└── after/ftplugin/             # Complex filetype settings (5 filetypes)
```

## Plugin management

Uses native `vim.pack.add()`. Plugin declarations go in `config/pack.lua`, setup and keymaps go in `plugins/*.lua`. The `PackChanged` autocmd auto-runs `TSUpdate` after plugin updates. LSP servers, formatters, and linters are installed externally via Homebrew.

## Colorscheme

Uses [token](https://github.com/ThorstenRhau/token) (external plugin, declared in `config/pack.lua`). Supports dark/light via `vim.o.background`.

## Validation

```bash
make lint       # Selene (primary)
make format     # StyLua
make all        # Both (runs on pre-commit via .githooks/pre-commit)
```

No test suite. Validate with `make all` before committing.

## Style

- **StyLua**: 2-space indent, 120 line width, single quotes, trailing commas
- **Selene**: `neovim+selene_mini` std (selene_mini.yml adds mini.nvim globals)
- Plugin declarations go in `config/pack.lua`, setup/keymaps go in `plugins/*.lua`
- Always include `desc` on keymaps

## Commits

```txt
type(scope): description

Body text that explains the change
```

- Types: `feat`, `fix`, `chore`, `refactor`, `style`, `docs`
- Scope: filename or feature area (no extension)

# AGENTS.md - Neovim Configuration

Personal Neovim config (Lua, requires **Neovim 0.11.5+**).

## Structure

```txt
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── config/                 # Core configuration
│   │   ├── autocmds.lua        # Auto-commands
│   │   ├── constants.lua       # Global constants
│   │   ├── ftplugin.lua        # Filetype plugin helper
│   │   ├── keymaps.lua         # Global keymaps
│   │   ├── lazy.lua            # Plugin manager bootstrap
│   │   └── options.lua         # Vim options
│   └── plugins/                # Plugin specs (one file per category)
│       ├── claudecode.lua      # Claude Code integration
│       ├── colorscheme.lua     # Modus theme + custom highlights
│       ├── completion.lua      # blink.cmp
│       ├── editor.lua          # Editing aids
│       ├── explorer.lua        # oil.nvim
│       ├── format.lua          # conform.nvim + nvim-lint
│       ├── git.lua             # gitsigns, neogit, diffview
│       ├── lsp.lua             # LSP servers, Mason
│       ├── mini.lua            # mini.nvim modules
│       ├── picker.lua          # fzf-lua
│       ├── session.lua         # Session management
│       ├── terminal.lua        # built-in terminal
│       ├── treesitter.lua      # Treesitter + textobjects
│       └── ui.lua              # which-key, lualine, trouble
└── after/ftplugin/             # Filetype-specific settings
```

## Validation

```bash
make lint       # Selene (primary)
make format     # StyLua
make all        # Both (runs on pre-commit)
```

No test suite. Validate with `make all` before committing.

## Style

- **StyLua**: 2-space indent, 120 line width, single quotes, trailing commas
- **Selene**: `neovim` stdlib, global `vim` expected
- Prefer `opts = {}` over `config = function()` in plugin specs
- Always include `desc` on keymaps

## Commits

```txt
type(scope): description

Body text that explains the change
```

- Types: `feat`, `fix`, `chore`, `refactor`, `style`, `docs`
- Scope: filename or feature area (no extension)

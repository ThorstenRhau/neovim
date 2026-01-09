# AGENTS.md - Neovim Configuration

Personal Neovim config (Lua, requires **Neovim 0.11+**).

## Structure

```txt
~/.config/nvim/
├── init.lua              # Entry point
├── lua/config/           # options, keymaps, autocmds, lazy bootstrap
├── lua/plugins/          # Plugin specs (one file per category)
└── after/ftplugin/       # Filetype-specific settings
```

## Validation

```bash
make lint       # Selene (primary)
make format     # StyLua
make all        # Both (runs on pre-commit)
```

No test suite. Validate with `make lint` before committing.

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

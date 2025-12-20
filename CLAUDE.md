# Neovim Configuration

Personal Neovim config using lazy.nvim. No Claude attribution in commits.

## Commands

```bash
make all      # Format, check, and lint (runs via pre-commit hook)
make format   # Format with stylua
make lint     # Lint with selene
make check    # Run :checkhealth headless
```

## Two-Mode System

Controlled by `NVIM_OPTIONAL_PLUGINS` environment variable:

- **Default**: Only loads `lua/plugins/` (mini-icons)
- **Full** (`=1`): Also loads `lua/optional/` and `lua/themes/`

Assume Full mode unless otherwise specified.

## Structure

- `init.lua` - Entry point, bootstraps lazy.nvim, leader=Space
- `lua/config/` - options, keymaps, autocmd
- `lua/plugins/` - Always-loaded plugins
- `lua/optional/` - LSP, completion, formatters, linters, git tools
- `lua/themes/` - Theme configs (catppuccin default)

## Plugin Pattern

```lua
---@module "lazy"
---@type LazySpec
return {
  'plugin/name',
  opts = {},
}
```

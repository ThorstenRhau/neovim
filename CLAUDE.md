# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Rules for Claude

1. First think through the problem, read the codebase for relevant files, and write a plan to tasks/todo.md
2. The plan should have a list of todo items that you can check off as you complete them
3. Before you begin working, check in with me and I will verify the plan
4. Then, begin working on the todo items, marking them as complete as you go
5. Please every step of the way just give me a high level explanation of what changes you made
6. Make every task and code change you do as simple as possible. Every change should impact as little code as possible. Everything is about simplicity
7. Finally, add a review section to the todo.md file with a summary of the changes you made
8. Never add Claude attribution to commit messages
9. Find the root cause and fix it. No temporary fixes
10. Make all fixes and code changes as simple as possible. They should only impact necessary code relevant to the task and nothing else

## Commands

```bash
make all          # Run format, check, and lint (runs before commits via git hook)
make format       # Format Lua files with stylua
make lint         # Lint Lua files with luacheck
make check        # Run :checkhealth in headless mode
make install-hooks # Enable pre-commit hooks
```

## Architecture

This is a personal Neovim configuration using lazy.nvim as the plugin manager.

### Two-Mode System

The config runs in two modes controlled by the `NVIM_OPTIONAL_PLUGINS` environment variable:
- **Lightweight mode** (default): Only loads `lua/plugins/` (currently just mini-icons)
- **Full mode** (`NVIM_OPTIONAL_PLUGINS=1`): Also loads `lua/optional/` (LSP, linting, formatting, etc.) and `lua/themes/`

### Directory Structure

- `init.lua` - Entry point, bootstraps lazy.nvim, sets leader keys (Space/'), conditionally loads plugins
- `lua/config/options.lua` - Vim options
- `lua/config/keymaps.lua` - Core keymaps (window nav, buffer nav, etc.)
- `lua/config/autocmd.lua` - Autocommands (formatoptions, markdown settings, cursor restore, etc.)
- `lua/plugins/` - Always-loaded plugins
- `lua/optional/` - Conditionally loaded plugins (LSP, completion, formatters, linters, git tools, etc.)
- `lua/themes/` - Theme configurations (catppuccin is default)

### Key Plugins (when optional enabled)

- **snacks.nvim** - Core UI (picker, terminal, notifications, git browse, zen mode). Leader+Space for files, Leader+/ for grep
- **which-key.nvim** - Keymap discovery, defines leader menu groups
- **blink.cmp** - Completion engine
- **nvim-lspconfig + mason** - LSP with mason-lspconfig handlers
- **conform.nvim** - Formatting
- **nvim-lint** - Linting
- **oil.nvim** - File explorer (Leader+o)
- **neogit** - Git UI (Leader+gg)

### Plugin Spec Pattern

All plugin files return a lazy.nvim spec table:
```lua
---@module "lazy"
---@type LazySpec
return {
  'plugin/name',
  opts = {},
  config = function() end,
}
```

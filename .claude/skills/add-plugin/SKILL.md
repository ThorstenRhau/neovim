---
name: add-plugin
description: Add a new lazy.nvim plugin spec following project conventions
user-invocable: true
---

When adding a new plugin spec to this Neovim config, follow these conventions exactly:

## File placement

Put the spec in `lua/plugins/<category>.lua` based on the plugin's purpose:
- Editing aids → `editor.lua`
- Git tools → `git.lua`
- LSP/completion → `lsp.lua` or `completion.lua`
- UI/appearance → `ui.lua`
- Fuzzy finding/navigation → `picker.lua`
- Treesitter-related → `treesitter.lua`
- If unsure, look at existing file categories

## Spec format

Always use declarative `opts = {}` instead of `config = function()` unless setup
requires conditional logic or calling multiple functions.

```lua
{
  'author/plugin-name',
  event = 'VeryLazy',  -- or appropriate lazy-load trigger
  dependencies = {},
  opts = {
    -- plugin options here
  },
  keys = {
    { '<leader>xx', '<cmd>PluginCmd<cr>', desc = 'Plugin: action description' },
  },
},
```

## Required conventions

1. **Lazy loading**: always use `event`, `cmd`, or `keys` triggers. Only use
   `lazy = false` for plugins that must load at startup (colorscheme, etc.).

2. **Keymaps**: every keymap entry must have a `desc` field. Use the format
   `'Category: action'` (e.g. `'Git: open neogit'`, `'LSP: rename symbol'`).

3. **Border**: set `border = 'single'` for any UI component that accepts it
   (floating windows, pickers, hover docs, etc.).

4. **Leader prefix**: group related keymaps under a `<leader><letter>` prefix.
   Check `lua/config/keymaps.lua` to see existing prefixes and avoid conflicts.

5. **Style**: 2-space indent, single quotes, trailing commas after every item.
   StyLua enforces this, but match it manually for consistency.

## Example: adding a new picker integration

```lua
{
  'author/new-picker',
  cmd = 'NewPicker',
  opts = {
    border = 'single',
    layout = { width = 0.8, height = 0.6 },
  },
  keys = {
    { '<leader>fp', '<cmd>NewPicker<cr>', desc = 'Picker: find something' },
  },
},
```

After adding, run `make all` to validate formatting and lint.

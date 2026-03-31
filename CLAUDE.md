# CLAUDE.md - Neovim Configuration

Personal Neovim config (Lua, requires **Neovim 0.12+**).

## Structure

```txt
~/.config/nvim/
├── init.lua                    # Entry point (sets background, leaders, loads config/)
├── Makefile                    # format, lint, clean, install-hooks targets
├── colors/
│   └── claude-theme.lua        # Colorscheme entry point (calls claude-theme.load())
├── .githooks/
│   └── pre-commit              # Runs `make all` before each commit
├── lua/
│   ├── claude-theme/           # Custom colorscheme (dark/light, no external deps)
│   │   ├── init.lua            # load(): clears highlights, applies palette + groups
│   │   ├── palette.lua         # Returns color table for 'dark' or 'light' background
│   │   └── groups/             # Highlight group definitions (each returns fn(palette))
│   │       ├── base.lua        # Core editor highlights
│   │       ├── lsp.lua         # LSP semantic tokens, diagnostics
│   │       ├── plugins.lua     # Plugin-specific highlights
│   │       └── treesitter.lua  # Treesitter capture groups
│   ├── config/                 # Core configuration
│   │   ├── autocmds.lua        # Auto-commands
│   │   ├── constants.lua       # Global constants (used by other modules)
│   │   ├── ftplugin.lua        # Filetype helper: chainable .indent(n).treesitter().prose()
│   │   ├── keymaps.lua         # Global keymaps
│   │   ├── options.lua         # Vim options
│   │   ├── pack.lua            # vim.pack plugin declarations (28 plugins)
│   │   └── terminal.lua        # Built-in terminal toggle
│   └── plugins/                # Plugin setup (one file per category)
│       ├── claudecode.lua      # Claude Code integration
│       ├── completion.lua      # blink.cmp
│       ├── editor.lua          # Editing aids
│       ├── explorer.lua        # oil.nvim
│       ├── format.lua          # conform.nvim + nvim-lint
│       ├── git.lua             # gitsigns, neogit, diffview
│       ├── lsp.lua             # LSP servers, Mason
│       ├── mini.lua            # mini.nvim modules
│       ├── picker.lua          # fzf-lua
│       ├── session.lua         # Session management (persistence.nvim)
│       ├── treesitter.lua      # Treesitter + textobjects
│       └── ui.lua              # which-key, trouble, neoscroll
└── after/ftplugin/             # Filetype-specific settings (35 filetypes)
```

## Plugin management

Uses native `vim.pack.add()`. Plugin declarations go in `config/pack.lua`, setup and keymaps go in `plugins/*.lua`. The `PackChanged` autocmd auto-runs `TSUpdate` and `MasonUpdate` after plugin updates.

## Colorscheme (claude-theme)

Bundled colorscheme with dark and light variants. Not a plugin, loaded via `colors/claude-theme.lua`.

- `palette.lua` returns all colors keyed by `vim.o.background` ('dark'|'light')
- Each file in `groups/` exports a function that takes the palette and returns a `{ [group] = hl_opts }` table
- `init.lua` clears cache, merges all group tables, and calls `nvim_set_hl`
- Adding a new highlight group: add it to the appropriate `groups/*.lua` file
- Adding a new palette color: add it to both dark and light tables in `palette.lua`

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

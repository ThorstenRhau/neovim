# My Neovim Configuration

[![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?logo=neovim&logoColor=white)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?logo=lua&logoColor=white)](https://www.lua.org)
[![License](https://img.shields.io/badge/License-BSD--3--Clause-blue)](LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/ThorstenRhau/neovim)](https://github.com/ThorstenRhau/neovim/commits/main)
[![Last Rewrite](https://img.shields.io/badge/last%20rewrite-Jan%202026-blue)](https://github.com/ThorstenRhau/neovim)
[![First Commit](https://img.shields.io/badge/first%20commit-Dec%202023-gray)](https://github.com/ThorstenRhau/neovim)

Personal config, maintained since December 2023. After 1000+ commits it was time
for a full rewrite in January 2026.

The `main` branch is my daily driver. Well-tested but occasionally in flux.

Feel free to steal anything useful.

## Dependencies

Neovim 0.12+, fzf, ripgrep, fd, git, and node.

I manage all software, including LSP servers, formatters, and linters via
[Homebrew](https://brew.sh/):

```sh
brew install basedpyright bash-language-server fd fzf git \
  lua-language-server markdownlint-cli marksman neovim node prettier ripgrep \
  ruff selene shellcheck shfmt stylua tombi tree-sitter-cli \
  vscode-langservers-extracted yaml-language-server yamllint
```

`vscode-langservers-extracted` provides jsonls.

## Plugin updates

`nvim-pack-lock.json` is tracked to make native `vim.pack` installs reproducible.
Use `<leader>l` to run `vim.pack.update()`, then review the lockfile changes and
commit intended plugin revisions together with any related configuration updates.
Do not remove the lockfile with `make clean`.

Token normally loads the latest tagged GitHub release through `vim.pack`. For
local Token development, start Neovim with `TOKEN_DEV=1 nvim`; this prepends
`/Users/thorre/github/token` to `runtimepath` without changing the managed
package or `nvim-pack-lock.json`.

## Parser maintenance

Startup uses installed parsers without downloading them. Install the current set
explicitly with this command, then reopen buffers to activate newly installed parsers:

```vim
:TSInstall bash css diff editorconfig git_config git_rebase gitattributes gitcommit gitignore go gomod gosum gowork hcl html javascript jsdoc json latex lua make markdown markdown_inline python query regex rust scss swift toml tsx typescript typst vim vimdoc xml yaml yang
```

The `PackChanged` hook retains `:TSUpdate` when nvim-treesitter changes, as
[upstream recommends](https://github.com/nvim-treesitter/nvim-treesitter#installation).

## Editing and pickers

Oil is the file explorer: `-` and `<leader>e` open the parent directory in a
floating view. Native filetype indentation replaces the language matrix and
Treesitter indentation. Loose TypeScript, TSX, and Lua files now use the global
four-space fallback; EditorConfig still takes precedence. Markdown list editing
is unchanged in the checked examples. Makefile recipes use tabs. Prose settings
live in `after/ftplugin/` and are undone when the filetype changes.

Go, Rust, and Swift retain native filetype detection, Tree-sitter highlighting,
folding, and textobjects for occasional code review. Their language servers and
external formatters are not configured; file search and Git tools remain available.

| Binding | Picker |
| --- | --- |
| `<leader><space>` | Files |
| `<leader>ff` | Find files (alias) |
| `<leader>sg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fo` | Recent files |
| `<leader>sp` | Builtin picker |
| `<leader>sd` | Document diagnostics |
| `<leader>sD` | Workspace diagnostics |
| `gd` | Definitions |
| `<leader>cR` | References |
| `<leader>ca` | Code actions (normal and visual) |
| `<leader>ss` | Document symbols |
| `<leader>gs` | Git status |

The four LSP pickers are buffer-local on attach. There is no bare `gr` mapping;
the [native `gr…` mappings](https://neovim.io/doc/user/lsp/#lsp-defaults) remain
available. Other pickers are accessible through `<leader>sp` or `:FzfLua`.
Messages and the command line use Neovim's default UI, with native LSP progress.
Use `:messages` for message history.

## LSP configuration

The eight enabled servers inherit native configurations from
[nvim-lspconfig at `456f8cc`](https://github.com/neovim/nvim-lspconfig/tree/456f8cc94438de35ff2294454019e7b780b73514/lsp).
Local overrides retain PATH-based commands, filetype restrictions, Blink
capabilities, schemas, and language preferences.
`<leader>tL` still toggles LSP and automatic linting together.

Accepted upstream differences:

- Basedpyright prefers `pyrightconfig.json`, supplies open-file diagnostics,
  automatic search paths, and disables tagged hints. Lua prefers Lua/Emmy config
  markers over formatter/linter markers and enables hints and code lenses.
- Upstream adds JSON and YAML formatting, disabled Red Hat telemetry, and server
  helper commands. Existing explicit settings remain, including basedpyright
  standard checking, Ruff import ownership and hover suppression, and Tombi
  marker coverage.

## Validation

Run `make check` for Lua lint and formatting, `make smoke` for offline startup,
and `git diff --check` for whitespace. Pre-commit remains unchanged.

`make smoke` requires macOS `sandbox-exec`. Before startup it verifies every
locked plugin's local revision and tracked files, failing with installation
instructions rather than repairing dependencies. It copies configuration,
plugins, and installed parsers into disposable XDG directories. Internet access
is blocked for Neovim and its children; local Unix sockets support fzf-lua.
It checks eager setup, the colorscheme, eight enabled LSP configurations, removed
web and Typst tooling, filetypes, cleanup, native mappings, and Makefile tab
insertion, with a 45-second startup timeout. It disables servers and linters
before opening buffers. Missing parsers are skipped gracefully; install them
explicitly using the command above.

Smoke does not prove live server behavior or visual appearance. For LSP changes,
check roots, actual attachment, capabilities, hover ownership, and both toggle
directions separately. For indentation changes, compare newline insertion, `o`,
and `==` with and without EditorConfig. Check picker/Oil navigation and native
message/progress rendering interactively.

## Cloning the config to your machine

```sh
git clone --depth=1 https://github.com/ThorstenRhau/neovim.git ~/.config/nvim
```

## Thanks

Big thanks to the Neovim community. Plugin authors, core contributors, and
everyone sharing information and ideas. The ecosystem is what makes Neovim fun
to use for me.

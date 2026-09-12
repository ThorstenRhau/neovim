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

`nvim-pack-lock.json` is generated locally by native `vim.pack` and intentionally
untracked. Use `<leader>l` to run `vim.pack.update()`. Each installation keeps its
own revisions in the local lockfile, which `make smoke` uses as its dependency
baseline. `make clean` preserves the lockfile.

Token normally loads the latest tagged GitHub release through `vim.pack`. For
local Token development, start Neovim with `TOKEN_DEV=1 nvim`; this prepends
`/Users/thorre/github/token` to `runtimepath` without changing the managed
package or `nvim-pack-lock.json`.

## Parser maintenance

Startup uses installed parsers without downloading them. Install the current set
explicitly with this command, then reopen buffers to activate newly installed parsers:

```vim
:TSInstall bash diff editorconfig git_config git_rebase gitattributes gitcommit gitignore json lua make markdown markdown_inline python query regex toml vim vimdoc yaml
```

The `PackChanged` hook retains `:TSUpdate` when nvim-treesitter changes, as
[upstream recommends](https://github.com/nvim-treesitter/nvim-treesitter#installation).

## Editing and pickers

Oil is the file explorer: `-` and `<leader>e` open the parent directory in a
floating view. Native filetype indentation replaces the language matrix and
Treesitter indentation. Loose TypeScript, TSX, and Lua files now use the global
four-space fallback; EditorConfig still takes precedence. Markdown list editing
is unchanged in the checked examples. Makefile recipes use tabs. Prose settings
live in `after/ftplugin/` and are undone in every window displaying the buffer
when the filetype changes.

Use Escape or Ctrl-[ to leave Insert mode; `jk` and `jj` are literal text.
Tab retains Blink completion acceptance, snippet navigation, and Tabout fallback.
Buffer and diagnostic bracket navigation (`[b`/`]b`, `[d`/`]d`, and their
uppercase variants) uses Neovim defaults. MiniBracketed supplies additional
targets, and MiniClue retains its bracket navigation submodes.

`<leader>bo` deletes other listed buffers while preserving the current buffer,
its unsaved edits, and window layout. Modified targets use MiniBufremove's
confirmation; declining stops the remaining deletions. Earlier deletions are
not rolled back. Bundled gzip, tar, and zip support and `:Tutor` are available.

Go, Rust, and Swift retain native filetype detection and syntax highlighting for
occasional code review. Their Tree-sitter parsers, language servers, and external
formatters are not configured; file search and Git tools remain available.

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
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).
The local `nvim-pack-lock.json` records the installed revision.
Local overrides retain PATH-based commands, filetype restrictions, Blink
capabilities, schemas, and language preferences.
`<leader>tL` still toggles LSP and automatic linting together.
Document highlighting has one set of handlers per buffer, retained until its
last supporting client detaches. Bash workspace scanning inherits nvim-lspconfig's
nonrecursive default, or its `GLOB_PATTERN` environment override.

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
web and Typst tooling, filetypes, cleanup across windows, native mappings, and
Makefile tab insertion with and without this repository's EditorConfig, with a
45-second startup timeout. It disables servers and linters
before opening buffers. Missing parsers are skipped gracefully; install them
explicitly using the command above.

Additional smoke cases cover deleting other buffers without unloading the
current buffer, declining a modified target, simulated multi-client highlight
attachment/detachment, literal escape chords, native bracket navigation, inherited
Bash scanning, and reading synthetic gzip/tar/zip fixtures. All fixtures and
runtime writes stay inside the disposable directories.

Smoke does not prove live server behavior or visual appearance. For LSP changes,
check roots, actual attachment, capabilities, hover ownership, and both toggle
directions separately. For indentation changes, compare newline insertion, `o`,
and `==` with and without EditorConfig. Check picker/Oil navigation and native
message/progress rendering interactively.
Check Tab and Shift-Tab with a completion menu, active snippets, closing
delimiters, and absent parsers, plus MiniClue's bracket submodes, in a disposable
interactive session. Simulated LSP lifecycle checks do not establish live server
behavior.

## Cloning the config to your machine

```sh
git clone --depth=1 https://github.com/ThorstenRhau/neovim.git ~/.config/nvim
```

## Thanks

Big thanks to the Neovim community. Plugin authors, core contributors, and
everyone sharing information and ideas. The ecosystem is what makes Neovim fun
to use for me.

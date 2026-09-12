# My Neovim Configuration

[![Neovim](https://img.shields.io/badge/Neovim-0.12.5+-57A143?logo=neovim&logoColor=white)](https://neovim.io)
[![Version](https://img.shields.io/badge/config-v2.0.0-blue)](https://github.com/ThorstenRhau/neovim)
[![License](https://img.shields.io/badge/License-BSD--3--Clause-blue)](LICENSE)
[![Last Rewrite](https://img.shields.io/badge/last%20rewrite-2026--09--12-blue)](https://github.com/ThorstenRhau/neovim)

A small personal macOS configuration, maintained since December 2023.
Version **v2.0.0** uses six main Lua files, two prose ftplugins, and 19 plugins.
**Last Complete Rewrite: 2026-09-12.**

Neovim 0.12.5 is the tested baseline; subsequent compatible stable releases are
supported. Token Ultra supplies the colors and mini.statusline supplies the
statusline. Neovim supplies the gutter, ordinary editing, and sessions.
The gutter shows line numbers and signs, with no fold column.
The statusline shows the mode, Git changes, diagnostics, LSP status, parent
directory and filename, file details, search count, and cursor position.

## Installation

Clone into an unused configuration directory:

```sh
git clone --depth=1 https://github.com/ThorstenRhau/neovim.git ~/.config/nvim
```

Install tools with [Homebrew](https://brew.sh/):

```sh
brew install neovim git fzf bat fd ripgrep node tree-sitter-cli \
  basedpyright bash-language-server lua-language-server marksman \
  vscode-langservers-extracted yaml-language-server \
  prettier ruff shfmt stylua tombi \
  shellcheck selene markdownlint-cli yamllint
```

Parser compilation needs Xcode Command Line Tools (`xcode-select --install`) and
Tree-sitter CLI 0.26.1 or newer. Sidekick expects the existing authenticated
Codex CLI on PATH. No tmux, icon plugin, or Rust toolchain is required.

Start `nvim` to install packages with native `vim.pack`. Then install parsers
explicitly, wait for completion, and reopen buffers:

```vim
:TSInstall bash diff editorconfig git_config git_rebase gitattributes gitcommit gitignore json lua luadoc luap make markdown markdown_inline python query regex toml vim vimdoc yaml
```

Supported filetypes use Tree-sitter highlighting and folds. Missing required
parsers produce errors; other filetypes retain native syntax behavior.
Indentation follows native filetype rules, with a two-space fallback and
EditorConfig taking precedence. Makefile recipes use literal tabs.
Markdown and commit messages wrap and enable English spelling; native commit
handling sets a 72-column text width.

## Configuration and packages

`init.lua` loads five modules in order:

| Module | Responsibility |
| --- | --- |
| `lua/options.lua` | Meaningful native option overrides |
| `lua/plugins.lua` | Package declarations, update hook, and short setups |
| `lua/keymaps.lua` | Global mappings and MiniClue |
| `lua/lsp.lua` | Language servers, diagnostics, and LSP mappings |
| `lua/autocmds.lua` | Editor events, Tree-sitter, linting, and sessions |

The 19 plugins are Token, blink.cmp, friendly-snippets, nvim-lspconfig,
SchemaStore, lazydev, nvim-treesitter, fzf-lua, Oil, Gitsigns, Neogit, Conform,
nvim-lint, blink.indent, mini.icons, mini.statusline, mini.splitjoin, mini.clue,
and Sidekick.
All are configured during startup.
FzfLua uses the `fzf-native` profile with native `bat` file previews.
Indent guides use thin `│` lines, with a single scope color and scope underlining.

Token follows tagged releases, Blink follows stable 1.x, and Tree-sitter follows
`main`. Other plugins follow their default branches. To review and apply updates:

```vim
:lua vim.pack.update()
```

Press `<leader>l` to open the same update workflow. Write the native confirmation
buffer to apply updates, then restart Neovim.
The Tree-sitter package update hook runs `:TSUpdate`; parser installation remains
explicit. `nvim-pack-lock.json` records local revisions and stays untracked.
Removed package declarations do not uninstall local packages or parsers.

For local Token development, use `TOKEN_DEV=1 nvim`. This loads
`/Users/thorre/github/token` instead of declaring the managed Token package.

## Language tools

| Filetype | LSP | Manual formatter | External lint after save |
| --- | --- | --- | --- |
| Bash/sh | bashls | shfmt | ShellCheck |
| Python | basedpyright, ruff | ruff_format | None |
| Lua | lua_ls with lazydev | stylua | Selene |
| Markdown | marksman | prettier | markdownlint |
| JSON/JSONC | jsonls with SchemaStore | prettier | None |
| YAML and native YAML variants | yamlls with SchemaStore | prettier | yamllint |
| TOML | tombi | tombi | None |
| Git commit | None | Native text wrapping | None |
| Makefile | None | Native indentation | None |

Servers inherit commands, roots, and filetypes from nvim-lspconfig.
BasedPyright retains standard type checking and owns Python hover. Ruff supplies
lint diagnostics, fixes, imports, and formatting. BashLS's embedded ShellCheck
is disabled so ShellCheck runs only after saves. Linters use their default rules
or project configuration.

`<leader>cf` formats the whole buffer asynchronously, with LSP fallback when no
external formatter is configured. Saving never triggers formatting. Diagnostics
use native signs and underlines, with virtual lines on the current line.
Workspace diagnostic pickers show results already known to Neovim.

Blink uses its standard Super-Tab preset and native snippets with
friendly-snippets. Tab accepts completion and advances snippet placeholders;
Shift-Tab moves backward. Completion stays hidden inside snippets. Command-line
completion is Tab-triggered, with Tab and Shift-Tab cycling candidates. Closing
delimiters are ordinary input; no pair-navigation mapping is configured.

## Important mappings

Space is the leader. MiniClue describes the leader groups and native `g`, `z`,
bracket, and window commands.

| Mapping | Action |
| --- | --- |
| `<leader>l` | Review and update installed plugins |
| `<leader>ff` / `<leader>fb` / `<leader>fo` | Files / buffers / recent files |
| `<leader>fs` | Live workspace symbols, buffer-local on LSP attach |
| `<leader>sg` / `<leader>sh` | Live grep / help |
| `<leader>sd` / `<leader>sD` | Document / workspace diagnostics |
| `gd` / `grr` / `gO` | Definitions / references / document symbols, buffer-local |
| `<leader>cf` / `<leader>cd` | Format whole buffer / diagnostic float |
| `<leader>gg` / `<leader>gl` | Neogit status / log |
| `[h` / `]h` | Previous / next staged or unstaged hunk, buffer-local |
| `<leader>gp` / `<leader>gb` | Preview hunk / blame line, buffer-local |
| `<leader>aa` | Toggle or focus Codex |
| `<leader>af` | Send current file reference to Codex |
| `<leader>at` | Send position to Codex; visual mode sends selected text |
| `<leader>ad` | Send current-buffer diagnostics to Codex |
| `<leader>ts` | Toggle spelling in the current window |
| `<leader>S` | Restore last session |
| `-` | Open Oil in the current window |
| `gS` | Split/join arguments |

Files and grep include hidden files and follow symlinks while retaining ordinary
ignore rules. Oil shows hidden files, uses default confirmation, and sends deleted
files to trash. Neogit is the primary interface for Git actions.

Use native `K`, `gra`, `grn`, `gri`, `grt`, insert-mode `<C-s>`, buffer/diagnostic/
quickfix brackets, `<C-w>`, `%`, and text objects. Native `[c`/`]c` navigate diffs;
`gj`/`gk` move through screen lines; `<C-l>` clears search highlighting.

## Last session

Interactive exit saves one global `last-session.vim` in Neovim's state directory.
`<leader>S` restores files, splits, tabs, and working directory. Restoration is
manual; a missing session produces the native source-file error. The last
interactive instance to exit wins. Headless startup does not overwrite it.

Terminal processes and unsaved buffer contents are not restored. Old named
sessions remain on disk and are not imported.

## Full reset

Close all Neovim instances, then run this from the configuration directory:

```sh
make clean
```

This immediately removes Neovim's data, state, and cache directories, including
plugins, downloaded parsers, sessions, persistent undo, swap files, history, and
logs. It also removes `nvim-pack-lock.json`, `.codex-lsp-cache/`, and `nvim.log`
from the configuration directory when present. Configuration files, Git metadata,
personal spelling files, and Homebrew tools remain intact.

Paths follow Neovim's `stdpath()` values, including XDG environment settings and
`NVIM_APPNAME`. The command prints each removal, tolerates missing paths, and
refuses symlinked cleanup roots or runtime paths overlapping the configuration.
Deletion errors stop the command; earlier removals are not rolled back.

On the next startup, accept the native plugin installation prompt. Removing the
lockfile means plugin versions are resolved afresh and may be newer. Run the
`:TSInstall` command in Installation again, wait for completion, and reopen
buffers. Parser installation remains manual. An instance left open during cleanup
could write state back when it exits.

## Validation

```sh
make check
make startup
```

`make check` is the default target and runs Selene plus StyLua's formatting check.
`make startup` checks the installed configuration and dependencies; it is neither
isolated nor guaranteed offline. Neither command establishes interactive behavior.
Check completion, live language servers, pickers, Git/Oil, Codex, and session
restoration in an interactive instance after relevant changes.

`make lint` runs Selene only; `make format` explicitly rewrites Lua. Optionally
run `make install-hooks` to enable the pre-commit hook, which invokes `make check`.

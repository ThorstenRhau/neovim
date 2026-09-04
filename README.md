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

Neovim 0.12+, fzf, ripgrep, fd, git, node, Go, and Rust.

I manage all software, including LSP servers, formatters, and linters via
[Homebrew](https://brew.sh/):

```sh
brew install neovim fzf ripgrep fd git node tree-sitter-cli
brew install basedpyright bash-language-server biome lua-language-server \
  gopls marksman ruff rust-analyzer tombi tinymist \
  vscode-langservers-extracted vtsls yaml-language-server go gofumpt \
  goimports prettier rust shfmt stylua markdownlint-cli selene \
  shellcheck yamllint
```

`vscode-langservers-extracted` provides cssls, eslint, html, and jsonls. The
Homebrew `rust` formula provides rustc, cargo, rustfmt, and Clippy.
Xcode supplies SourceKit-LSP and Swift 6's `swift format` command for Swift
editing and formatting.

## Plugin updates

`nvim-pack-lock.json` is tracked to make native `vim.pack` installs reproducible.
Use `<leader>l` to run `vim.pack.update()`, then review the lockfile changes and
commit intended plugin revisions together with any related configuration updates.
Do not remove the lockfile with `make clean`.

Token normally loads the latest tagged GitHub release through `vim.pack`. For
local Token development, start Neovim with `TOKEN_DEV=1 nvim`; this prepends
`/Users/thorre/github/token` to `runtimepath` without changing the managed
package or `nvim-pack-lock.json`.

## Cloning the config to your machine

```sh
git clone --depth=1 https://github.com/ThorstenRhau/neovim.git ~/.config/nvim
```

## Thanks

Big thanks to the Neovim community. Plugin authors, core contributors, and
everyone sharing information and ideas. The ecosystem is what makes Neovim fun
to use for me.

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

## Showcase

| Dark                                          | Light                                           |
| --------------------------------------------- | ----------------------------------------------- |
| ![token-dark](https://rhau.se/token-dark.jpg) | ![token-light](https://rhau.se/token-light.jpg) |

I use my own color theme [token](https://github.com/ThorstenRhau/token/) and the
typeface Berkeley Mono

## Dependencies

Neovim 0.12+, ripgrep, fd, git, node.

I manage all software, including LSP servers, formatters, and linters via
[Homebrew](https://brew.sh/):

```sh
brew install neovim ripgrep fd git node
brew install basedpyright bash-language-server fish-lsp lua-language-server \
  marksman ruff taplo tinymist vscode-langservers-extracted vtsls \
  yaml-language-server fish prettier shfmt stylua markdownlint-cli selene \
  shellcheck yamllint
```

`vscode-langservers-extracted` provides cssls, eslint, html, and jsonls.

## Cloning the config to your machine

```sh
git clone --depth=1 https://github.com/ThorstenRhau/neovim.git ~/.config/nvim
```

## Thanks

Big thanks to the Neovim community. Plugin authors, core contributors, and
everyone sharing information and ideas. The ecosystem is what makes Neovim fun
to use for me.

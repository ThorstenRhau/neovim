# My Neovim Configuration

[![Neovim](https://img.shields.io/badge/Neovim-0.12.5+-57A143?logo=neovim&logoColor=white)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?logo=lua&logoColor=white)](https://www.lua.org)
[![License](https://img.shields.io/badge/License-BSD--3--Clause-blue)](LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/ThorstenRhau/neovim)](https://github.com/ThorstenRhau/neovim/commits/main)
[![Last Rewrite](https://img.shields.io/badge/last%20rewrite-2026--09--12-blue)](https://github.com/ThorstenRhau/neovim)
[![First Commit](https://img.shields.io/badge/first%20commit-Dec%202023-gray)](https://github.com/ThorstenRhau/neovim)

My personal macOS configuration for Neovim 0.12.5.

## Installation

```sh
git clone --depth=1 https://github.com/ThorstenRhau/neovim.git ~/.config/nvim
```

Install tools with [Homebrew](https://brew.sh/):

```sh
brew install neovim git fzf fd ripgrep node tree-sitter-cli \
  bash-language-server emmylua_ls pyrefly rumdl \
  vscode-langservers-extracted yaml-language-server \
  rust rust-analyzer go gopls typescript \
  prettier ruff shfmt stylua tombi \
  actionlint biome shellcheck selene swiftlint yamllint
```

Tree-sitter parser compilation needs Xcode Command Line Tools
(`xcode-select --install`) and Tree-sitter CLI 0.26.1 or newer. The Command
Line Tools also provide `clangd` and `sourcekit-lsp` for C and Swift. brygga
needs the Claude Code CLI (`claude`) on `PATH`.

Start `nvim` to install packages, then install the Tree-sitter parsers:

```vim
:TSInstall bash comment diff editorconfig git_config git_rebase gitattributes gitcommit gitignore go javascript json lua luadoc luap make markdown markdown_inline python query regex ruby rust swift toml tsx typescript vim vimdoc yaml
```

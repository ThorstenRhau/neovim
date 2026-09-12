# My Neovim Configuration

[![Neovim](https://img.shields.io/badge/Neovim-0.12.5+-57A143?logo=neovim&logoColor=white)](https://neovim.io)
[![Version](https://img.shields.io/badge/config-v2.0.0-blue)](https://github.com/ThorstenRhau/neovim)
[![License](https://img.shields.io/badge/License-BSD--3--Clause-blue)](LICENSE)
[![Last Rewrite](https://img.shields.io/badge/last%20rewrite-2026--09--12-blue)](https://github.com/ThorstenRhau/neovim)

A small personal macOS configuration for Neovim 0.12.5 and compatible stable
releases.

Files reopen at their last cursor position, except commit messages, rebase
instructions, and help buffers.

`<leader>o` opens the current file in its default macOS application, including
filenames containing spaces or quotes.

## Installation

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
Tree-sitter CLI 0.26.1 or newer. Sidekick expects an authenticated Codex CLI on
`PATH`.

Start `nvim` to install packages, then install the Tree-sitter parsers:

```vim
:TSInstall bash diff editorconfig git_config git_rebase gitattributes gitcommit gitignore json lua luadoc luap make markdown markdown_inline python query regex toml vim vimdoc yaml
```

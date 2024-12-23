# My NeoVim configuration

This setup is "by me for me", intended for my personal use.

In case you want to use my setup for for learning or something else I have
written some documentation that should help you to get started.

Since 2023-12-24 I consider this repo as stable. It should be safe to clone it
and stay on the main branch. There will be changes but all changes will be
documented and I hope that no breaking changes slip through the cracks.

2024 Christmas update: I have been using this configuration as my daily driver
for a year now. It has evolved quite a bit since the start. Here is a small clip
that shows a years worth of neovim tweaking:

If you want to make this configuration your own, just clone it and remove the
_.git_ directory from the root folder.

## Showcase

### Light

![light](./.images/light-2024-12-23.jpg)

### Dark

![dark](./.images/dark-2024-12-23.jpg)

## Installation

### Optional plugins

After maintaining a light and a fully fledged neovim configuration for about a
year I decided that that was to much work. So this configuration can now be both
a lightweight config, without LSP, Lingers, Formatters etc. Or it can contain
all those things.

The default is lightweight, to enable LSP, Lingers, and all the other plugins
that are found in **lua/optional** you only need to set the environment variable
**NVIM_OPTIONAL_PLUGINS**

_Example for fish shell_

```fish
set -gx NVIM_OPTIONAL_PLUGINS 1
```

_Example for zsh and bash_

```sh
export NVIM_OPTIONAL_PLUGINS=1
```

### Dependencies

I use macOS so here are the instructions for how to install dependencies with
homebrew on a mac.

```
brew install ripgrep fd cmake git node wget shellcheck python3 \
selene hg nvim lazygit viu chafa
```

```
npm install -g neovim
```

### Cloning the repository

When you have all the dependencies installed, clone the repo in to
_~/.config/nvim/_

Example:

```
git clone https://github.com/ThorstenRhau/neovim.git ~/.config/nvim
```

### First launch

When you launch Neovim for the first time after cloning the repository you will
see a lot going on. Plugins should be installed by Lazy and Treesitter should
install language parsers. Thereafter you can run **_:MasonToolsInstall_** to
install all LSPs, Linters, and Formatters for this configuration. When this is
done it is a good idea to quit or re-start Neovim.

### Verify your installation

Launch Neovim and run _:Lazy load all_ to load all the plugins. After you have
loaded all the plugins you can run _:checkhealth_ to see that everything is
configured and working properly before you start to use Neovim for your editing.

## Thank you

There are many individuals and projects that I have learnt and taken inspiration
from. Thank you to all of the fantastic Neovim community 🙏.

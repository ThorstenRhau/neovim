# My NeoVim setup

This setup is "by me for me", intended for my personal use.

In case you want to use my setup for for learning or something else I have
written some documentation that should help you to get started.

Since 2023-12-24 I consider this repo as stable. It should be safe to clone it
and stay on the main branch. There will be changes but all changes will be
documented and I hope that no breaking changes slip through the cracks.

If you want to make this configuration your own, just clone it and remove the
_.git_ directory from the root folder.

## Installation

### Dependencies

I use macOS so here are the instructions for how to install dependencies with
homebrew on mac.

```
brew install ripgrep fd cmake git node wget shellcheck python3 selene
```

```
npm install -g neovim
```

```
python3 -m pip install --upgrade --user pynvim
```

### Cloning the repository

When you have all the dependencies installed clone the repo in to
_~/.config/nvim/_

Example:

```
git clone https://github.com/ThorstenRhau/neovim.git ~/.config/nvim
```

### First launch

When you launch Neovim for the first time after cloning the repository you will
se a lot going on. Plugins should be installed by Lazy and Treesitter should
install some (~20) essential parsers. Thereafter you can run
**_:MasonToolsInstall_** to install all needed Mason components for this
configuration. When this is done it is a good idea to quit Neovim.

### Verify your installation

Launch Neovim and run _:Lazy load all_ to load all the plugins. There should be
no error messages on screen. After you have loaded all the plugins you can run
_:checkhealth_ to see that everything is configured and working properly before
you set of on your editing adventures.

## Thank you

There are many individuals and projects that I have learnt and taken inspiration
from. Thank you to all of the fantastic Neovim community 🙏.

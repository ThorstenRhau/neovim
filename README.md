# My NeoVim setup

This setup is "by me for me", intended for my personal use.

Since 2023-12-24 I consider this repo as stable. It should be safe to clone it
and stay on the main branch. There will be changes but all changes will be
documented and I hope that no breaking changes slip through the cracks.

If you want to make this configuration your own, just clone it and remove the
_.git_ directory from the root folder.

## Dependencies

```
brew install ripgrep fd cmake git node wget shellcheck eslint python3 selene
```

```
npm install -g neovim
```

```
python3 -m pip install --upgrade --user pynvim
```

When you have all the dependencies installed clone the repo in to
_~/.config/nvim/_

When you launch Neovim for the first time after cloning the repository you can
run _:MasonToolsInstall_ to install all needed Mason components for this
configuration.

After this. Quit neovim, re-open it and run _:Lazy load all_ to load all the
plugins. There should be no error messages on screen. After you have loaded all
the plugins you can run _:checkhealth_ to see that everything is configured and
working properly before you set of on your editing adventures.

## Thank you

There are many individuals and projects that I have learnt from and taken
inspiration from. Thank you to all of the fantastic Neovim community 🙏🏻.

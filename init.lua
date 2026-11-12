vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = 'ö'

require('options')
require('plugins')
require('statusline')
require('keymaps')
require('lsp')
require('autocmds')

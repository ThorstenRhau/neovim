-- Set leader keys first
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Load other config modules
require('config.options')
require('config.ftplugin')
require('config.pack')
vim.cmd.colorscheme('token')
require('config.terminal')
require('config.keymaps')
require('config.autocmds')

-- Set leader keys first
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Disable unused remote plugin providers to keep health output clean.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Load other config modules
require('config.options')
require('config.ftplugin')
require('config.pack')
vim.cmd.colorscheme('token')
require('config.terminal')
require('config.keymaps')
require('config.autocmds')

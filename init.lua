-- Early terminal background detection to prevent theme flash
-- Read from Fish shell's SYSTEM_APPEARANCE environment variable
vim.o.background = vim.env.SYSTEM_APPEARANCE or 'dark'

-- Set leader keys first
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Load other config modules
require('config.options')
require('config.pack')
vim.cmd.colorscheme('token')
require('config.terminal')
require('config.keymaps')
require('config.autocmds')

-- Lua module load (experimental)
if vim.loader then
  vim.loader.enable()
end

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    vim.cmd('cquit 1')
  end
end
vim.opt.rtp:prepend(lazypath)

-- Basic Neovim Settings
vim.g.mapleader = ' '
vim.g.maplocalleader = "'"
vim.opt.termguicolors = true

local ok, err = pcall(require, 'config.options')
if not ok then
  vim.notify('Failed to load config.options: ' .. tostring(err), vim.log.levels.ERROR)
end

local specs = {}

-- Check if optional plugins should be enabled
local enable_optional_plugins = os.getenv('NVIM_OPTIONAL_PLUGINS')

-- Conditionally add optional plugins
-- Define the plugin specifications
local active_theme = 'catppuccin'
if enable_optional_plugins == '1' then
  table.insert(specs, { import = 'themes.' .. active_theme })
  table.insert(specs, { import = 'optional' }) -- Load all optional plugins
end

-- Setup lazy.nvim
require('lazy').setup({
  spec = specs,
  defaults = {
    lazy = true, -- Set global lazy loading
  },
  install = {
    missing = true,
    colorscheme = { enable_optional_plugins == '1' and active_theme or 'default' },
  },
  checker = {
    enabled = true,
    notify = true,
    frequency = 604800, -- Check for updates every week
  },
  ui = {
    size = { width = 0.9, height = 0.9 },
    border = 'rounded',
  },
  performance = {
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  rocks = {
    hererocks = false,
    enabled = false,
  },
})

ok, err = pcall(require, 'config.autocmd')
if not ok then
  vim.notify('Failed to load config.autocmd: ' .. tostring(err), vim.log.levels.ERROR)
end

ok, err = pcall(require, 'config.keymaps')
if not ok then
  vim.notify('Failed to load config.keymaps: ' .. tostring(err), vim.log.levels.ERROR)
end

if enable_optional_plugins == '1' then
  ok, err = pcall(require, 'config.toggles')
  if not ok then
    vim.notify('Failed to load config.toggles: ' .. tostring(err), vim.log.levels.ERROR)
  end
else
  vim.cmd('colorscheme default')
end

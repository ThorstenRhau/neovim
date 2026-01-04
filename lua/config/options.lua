local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false
opt.linebreak = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10
opt.showmode = false

-- Split behavior
opt.splitbelow = true
opt.splitright = true

-- Behavior
opt.hidden = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = 'menu,menuone,noselect'

-- Disable builtin plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

-- Whitespace characters
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Fill chars
opt.fillchars = { eob = ' ', fold = ' ', foldsep = ' ' }

-- Folding (treesitter-based, configured per filetype)
opt.foldlevel = 99
opt.foldlevelstart = 99

local opt = vim.opt
local o = vim.o

-- Line numbers
o.number = true
o.relativenumber = true
o.signcolumn = 'yes'

-- Tabs & indentation
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = true
o.smartindent = true

-- Line wrapping
o.wrap = false
o.linebreak = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

-- Appearance
o.termguicolors = true
o.cursorline = true
o.scrolloff = 8
o.sidescrolloff = 8
o.pumheight = 10
o.showmode = false

-- Split behavior
o.splitbelow = true
o.splitright = true

-- Behavior
o.hidden = true
o.mouse = 'a'
o.clipboard = ''
o.undofile = true
o.undolevels = 10000
o.updatetime = 250
o.timeoutlen = 300
o.completeopt = 'menu,menuone,noselect'

-- Disable builtin plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

-- Whitespace characters
o.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Fill chars
opt.fillchars = { eob = ' ', fold = ' ', foldsep = ' ' }

-- Folding (treesitter-based, configured per filetype)
o.foldlevel = 99
o.foldlevelstart = 99

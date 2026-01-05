local opt = vim.opt
local o = vim.o

o.clipboard = ''
o.completeopt = 'menu,menuone,noselect'
o.cursorline = true
o.expandtab = true
o.hidden = true
o.hlsearch = true
o.ignorecase = true
o.incsearch = true
o.linebreak = true
o.mouse = 'nv'
o.number = true
o.pumheight = 10
o.relativenumber = true
o.scrolloff = 8
o.shiftwidth = 4
o.showmode = false
o.sidescrolloff = 8
o.signcolumn = 'yes'
o.smartcase = true
o.smartindent = true
o.softtabstop = 4
o.splitbelow = true
o.splitright = true
o.tabstop = 4
o.termguicolors = true
o.timeoutlen = 300
o.undofile = true
o.undolevels = 10000
o.updatetime = 250
o.wrap = false

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
opt.fillchars:append({
  diff = '░',
  eob = ' ',
  fold = '·',
  foldopen = '󰍝',
  foldclose = '󰍟',
  foldsep = '│',
  msgsep = '─',
})

-- Floating window border (Neovim 0.11+)
o.winborder = 'rounded'

-- Folding (treesitter-based, configured per filetype)
o.foldlevel = 99
o.foldlevelstart = 99

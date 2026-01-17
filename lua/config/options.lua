local opt = vim.opt
local o = vim.o

o.clipboard = ''
o.completeopt = 'menu,menuone,noselect'
o.cursorline = true
o.expandtab = true
o.ignorecase = true
o.linebreak = true
o.mouse = 'nv'
o.number = true
o.numberwidth = 2
o.pumheight = 10
o.relativenumber = true
o.signcolumn = 'auto:1'
o.statuscolumn = '%s%=%{v:relnum?v:relnum:v:lnum} '
o.scrolloff = 8
o.shiftwidth = 4
o.showmode = false
o.sidescrolloff = 8
o.smartcase = true
o.smartindent = true
o.softtabstop = 4
o.splitbelow = true
o.splitright = true
o.tabstop = 4
o.timeoutlen = 300
o.undofile = true
o.undolevels = 1000
o.updatetime = 250
o.wrap = false

-- Whitespace characters
o.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Fill chars
opt.fillchars:append({
  diff = '░',
  eob = ' ',
  fold = '⋯',
  foldopen = '▼',
  foldclose = '▶',
  foldsep = '┊',
  msgsep = '━',
})

-- Floating window border (Neovim 0.11+)
o.winborder = 'single'

-- Folding (treesitter-based, configured per filetype)
o.foldlevel = 99
o.foldlevelstart = 99

-- Spelling
o.spelllang = 'en_us'
o.spellsuggest = 'best,20' -- Limits to 20 suggestions

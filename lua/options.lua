vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.ruler = false
vim.o.showmode = false
vim.o.scrolloff = 10
vim.o.signcolumn = 'auto:2'
vim.o.list = true
vim.o.listchars = 'tab:→ ,trail:•,nbsp:+,extends:›,precedes:‹'

vim.o.guicursor = table.concat({
  'n-v-c-sm:block-Cursor',
  'i-ci-ve:ver25-Cursor',
  'r-cr-o:hor20-Cursor',
  'a:blinkwait500-blinkoff500-blinkon500',
}, ',')

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
vim.o.confirm = true

vim.o.wrap = false
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.winborder = 'single'
vim.o.spelllang = 'en_us'
vim.opt.sessionoptions:remove('terminal')

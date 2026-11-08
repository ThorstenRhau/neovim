-- Experimental message and cmdline UI: no "Press ENTER" prompts.
require('vim._core.ui2').enable()

-- Indentation (filetype plugins and EditorConfig override these)
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

-- Interface
vim.o.cursorline = true
vim.o.fillchars = 'eob: ,fold: '
vim.o.list = true
vim.o.listchars = 'tab:→ ,trail:•,nbsp:+,extends:›,precedes:‹'
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 10
vim.o.showmode = false
vim.o.signcolumn = 'auto'
vim.o.statuscolumn = '%s%=%{(&nu||&rnu)&&!v:virtnum ? (&rnu&&v:relnum ? v:relnum : v:lnum) . " " : ""}'
vim.o.winborder = 'single'

-- Cursor shape per mode
vim.o.guicursor = table.concat({
  'n-v-c-sm:block-Cursor',
  'i-ci-ve:ver25-Cursor',
  'r-cr-o:hor20-Cursor',
  't:block-TermCursor',
  'a:blinkwait500-blinkoff500-blinkon500',
}, ',')

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Windows
vim.o.splitbelow = true
vim.o.splitright = true

-- Text layout and folding
vim.o.breakindent = true
vim.o.foldlevelstart = 99
vim.o.foldtext = ''
vim.o.linebreak = true
vim.o.wrap = false

-- Behaviour
vim.o.confirm = true
vim.o.spelllang = 'en_us'
vim.o.undofile = true
vim.o.updatetime = 300
vim.opt.sessionoptions:remove({ 'blank', 'help', 'terminal' })

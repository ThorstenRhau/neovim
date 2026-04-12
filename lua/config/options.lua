-- Disable built-in plugins
local disabled_builtins = {
  'gzip',
  'matchit',
  'matchparen',
  'netrwPlugin',
  'tarPlugin',
  'tutor',
  'zipPlugin',
}
for _, plugin in ipairs(disabled_builtins) do
  vim.g['loaded_' .. plugin] = 1
end

local constants = require('config.constants')
local opt = vim.opt
local o = vim.o

o.autoread = true
o.breakindent = true
o.clipboard = ''
o.completeopt = 'fuzzy,noselect,popup'
o.confirm = true
o.cursorline = true
o.expandtab = true
o.foldlevel = 99
o.foldlevelstart = 99
o.ignorecase = true
o.inccommand = 'split'
o.incsearch = true
o.linebreak = true
o.mouse = 'nv'
o.number = true
o.numberwidth = 2
o.pumborder = constants.ui.border
o.pumheight = 15
o.pummaxwidth = 50
o.pumwidth = 50
o.relativenumber = true
o.ruler = false
o.scrolloff = 10
o.shiftround = true
o.shiftwidth = 4
o.showbreak = '↳ '
o.showmode = false
o.sidescrolloff = 10
o.signcolumn = 'auto:1'
o.smartcase = true
o.smartindent = true
o.smoothscroll = true
o.softtabstop = 4
o.spelllang = 'en_us'
o.spellsuggest = 'best,20'
o.splitbelow = true
o.splitkeep = 'screen'
o.splitright = true
o.statuscolumn = '%s%=%{v:relnum?v:relnum:v:lnum} '
o.tabstop = 4
o.termguicolors = true
o.timeoutlen = 300
o.undofile = true
o.undolevels = 1000
o.updatetime = 250
o.virtualedit = 'block'
opt.winborder = constants.ui.border
o.wrap = false

-- Diff settings (override default linematch:40, add word-level inline diffs)
opt.diffopt:remove('linematch:40')
opt.diffopt:append({ 'linematch:60', 'inline:word' })

-- Cursor appearance and blinking
o.guicursor = table.concat({
  'n-v-c-sm:block-Cursor', -- Normal, Visual, Command, Showmatch: block cursor
  'i-ci-ve:ver25-Cursor', -- Insert, Command-insert, Visual-exclusive: vertical bar (25% width)
  'r-cr-o:hor20-Cursor', -- Replace, Command-replace, Operator-pending: horizontal bar (20% height)
  'a:blinkwait500-blinkoff500-blinkon500',
}, ',')

-- Whitespace characters
o.list = true
opt.listchars = constants.ui.listchars

-- Fill chars
opt.fillchars:append(constants.ui.fillchars)

-- Disable built-in plugins
local disabled_builtins = {
  'gzip',
  'matchit',
  'matchparen',
  'netrwPlugin',
  'tarPlugin',
  'tohtml',
  'tutor',
  'zipPlugin',
}
for _, plugin in ipairs(disabled_builtins) do
  vim.g['loaded_' .. plugin] = 1
end

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
o.pumborder = 'single'
o.pumheight = 10
o.relativenumber = true
o.scrolloff = 8
o.shiftwidth = 4
o.showmode = false
o.sidescrolloff = 8
o.signcolumn = 'auto:1'
o.smartcase = true
o.smartindent = true
o.smoothscroll = true
o.softtabstop = 4
o.splitbelow = true
o.splitright = true
o.statuscolumn = '%s%=%{v:relnum?v:relnum:v:lnum} '
o.tabstop = 4
o.timeoutlen = 300
o.undofile = true
o.undolevels = 1000
o.updatetime = 250
o.winborder = 'single'
o.wrap = false

-- Cursor appearance and blinking
o.guicursor = table.concat({
  'n-v-c-sm:block-Cursor', -- Normal, Visual, Command, Showmatch: block cursor
  'i-ci-ve:ver25-Cursor', -- Insert, Command-insert, Visual-exclusive: vertical bar (25% width)
  'r-cr-o:hor20-Cursor', -- Replace, Command-replace, Operator-pending: horizontal bar (20% height)
  'a:blinkwait500-blinkoff500-blinkon500',
}, ',')

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

-- Folding (treesitter-based, configured per filetype)
o.foldlevel = 99
o.foldlevelstart = 99

-- Spelling
o.spelllang = 'en_us'
o.spellsuggest = 'best,20' -- Limits to 20 suggestions

-- Colorscheme (colors/claude-theme.lua is in rtp from stdpath('config'))
o.termguicolors = true
vim.cmd.colorscheme('claude-theme')

-- Experimental UI2: floating cmdline and messages
o.cmdheight = 0
require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = {
      [''] = 'msg',
      empty = 'cmd',
      bufwrite = 'msg',
      confirm = 'cmd',
      emsg = 'pager',
      echo = 'msg',
      echomsg = 'msg',
      echoerr = 'pager',
      completion = 'cmd',
      list_cmd = 'pager',
      lua_error = 'pager',
      lua_print = 'msg',
      progress = 'pager',
      rpc_error = 'pager',
      quickfix = 'msg',
      search_cmd = 'cmd',
      search_count = 'cmd',
      shell_cmd = 'pager',
      shell_err = 'pager',
      shell_out = 'pager',
      shell_ret = 'msg',
      undo = 'msg',
      verbose = 'pager',
      wildlist = 'cmd',
      wmsg = 'msg',
      typed_cmd = 'cmd',
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.3,
      timeout = 5000,
    },
    pager = {
      height = 0.5,
    },
  },
})

local opt = vim.opt
---@type table
local g = vim.g

opt.autoindent = true
opt.autoread = true
opt.breakindent = true
opt.clipboard = ''
opt.cmdheight = 0
opt.cmdwinheight = 10
opt.completeopt = 'menu,menuone,noselect'
opt.cursorline = true
opt.foldenable = false
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = 'expr'
opt.grepformat = '%f:%l:%c:%m'
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = 'split'
opt.incsearch = true
opt.jumpoptions = 'view'
opt.laststatus = 3
opt.linebreak = true
opt.maxmempattern = 5000
opt.mouse = 'nv'
opt.number = false
opt.pumblend = 0
opt.scrolloff = 8
opt.showcmd = true
opt.sidescrolloff = 8
opt.signcolumn = 'yes:1'
opt.smartcase = true
opt.smartindent = true
opt.smarttab = true
opt.smoothscroll = true
opt.splitbelow = true
opt.synmaxcol = 200
opt.tabline = ''
opt.updatetime = 250
opt.wildmenu = true
opt.wildmode = 'longest:full,full'
opt.wildoptions = 'pum'
opt.winblend = 0
opt.wrap = false
opt.backspace = { 'indent', 'eol', 'start' }
opt.path:append({ '**' })
opt.spelllang = { 'en', 'sv' }
opt.wildignore:append({
  '*.o',
  '*.obj',
  '*.dll',
  '*.exe',
  '*.pyc',
  '*.class',
  '*.swp',
  '*.swo',
  '*.DS_Store',
  '*/node_modules/*',
  '*/target/*',
  '*/build/*',
  '*/dist/*',
  '*/.git/*',
  '*/.svn/*',
  '*/.venv/*',
  '*/venv/*',
})

-- Use spaces for tabs and whatnot
opt.tabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true

-- Language providers
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_python_provider = 0
g.loaded_ruby_provider = 0

-- Setting up undo
opt.swapfile = false
opt.backup = false
local home = vim.env.HOME or vim.fn.expand('~')
local undodir = home .. '/.local/share/nvim/undo'
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end
opt.undodir = undodir
opt.undofile = true
opt.undolevels = 10000

-- Session management
opt.sessionoptions:remove('blank') -- Not saving empty buffers

opt.grepprg = vim.fn.executable('rg') == 1 and 'rg --vimgrep --smart-case --follow' or 'grep -n $* /dev/null'

-- Partial title rewriting
opt.titlestring = '%<%F - nvim'
opt.title = true

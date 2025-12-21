local opt = vim.opt
local o = vim.o
local g = vim.g

o.autoindent = true
o.autoread = true
o.breakindent = true
o.clipboard = ''
o.cmdheight = 0
o.cmdwinheight = 15
o.completeopt = 'menu,menuone,noselect'
o.cursorline = true
o.foldenable = true
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = 'expr'
o.viewoptions = 'cursor,folds,slash,unix'
o.grepformat = '%f:%l:%c:%m'
o.hlsearch = true
o.ignorecase = true
o.inccommand = 'split'
o.incsearch = true
o.jumpoptions = 'view'
o.laststatus = 3
o.linebreak = true
o.maxmempattern = 5000
o.mouse = 'nv'
o.number = false
o.pumblend = 0
o.scrolloff = 8
o.showcmd = false
o.sidescrolloff = 8
o.signcolumn = 'yes:1'
o.smartcase = true
o.smartindent = true
o.smarttab = true
o.smoothscroll = true
o.splitbelow = true
o.synmaxcol = 200
o.tabline = ''
o.updatetime = 250
o.wildmenu = true
o.wildmode = 'longest:full,full'
o.wildoptions = 'pum'
o.winblend = 0
o.wrap = false
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
o.tabstop = 4
o.shiftwidth = 4
o.shiftround = true
o.expandtab = true

-- Language providers
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_python_provider = 0
g.loaded_ruby_provider = 0

-- Setting up undo
o.swapfile = false
o.backup = false
local home = vim.env.HOME or vim.fn.expand('~')
local undodir = home .. '/.local/share/nvim/undo'
if vim.fn.isdirectory(undodir) == 0 then
  if vim.fn.mkdir(undodir, 'p') == 0 then
    vim.notify('Failed to create undo directory: ' .. undodir, vim.log.levels.WARN)
  end
end
o.undodir = undodir
o.undofile = true
o.undolevels = 1000

-- Session management
opt.sessionoptions:remove('blank') -- Not saving empty buffers

o.grepprg = vim.fn.executable('rg') == 1 and 'rg --vimgrep --smart-case --follow' or 'grep -n $* /dev/null'

-- Partial title rewriting
o.titlestring = '%<%F - nvim'
o.title = true

-- LSP floating windows with border
do
  local orig_open_floating_preview = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    return orig_open_floating_preview(contents, syntax, opts, ...)
  end
end

-- Experimental message and cmdline UI: no "Press ENTER" prompts.
require('vim._core.ui2').enable()

-- Indentation (filetype plugins and EditorConfig override these)
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

-- Interface
vim.o.cursorline = true
vim.o.fillchars = 'eob: ,fold: '
vim.o.laststatus = 2
vim.o.list = true
vim.o.listchars = 'tab:→ ,trail:•,nbsp:+,extends:›,precedes:‹'
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 10
vim.o.showmode = false
vim.o.signcolumn = 'auto'
-- The line number, replaced by a glyph for the line's most severe diagnostic.
local diagnostic_marks = { '✘', '▲', '●', '○' }
local diagnostic_groups = { 'Error', 'Warn', 'Info', 'Hint' }

function vim.statuscolumn_number()
  if vim.v.virtnum ~= 0 then
    return ''
  end
  local counts = vim.diagnostic.count(0, { lnum = vim.v.lnum - 1 })
  for level = 1, 4 do
    if counts[level] then
      return ('%%#Diagnostic%s#%s%%*'):format(diagnostic_groups[level], diagnostic_marks[level])
    end
  end
  if not (vim.wo.number or vim.wo.relativenumber) then
    return ''
  end
  return tostring(vim.wo.relativenumber and vim.v.relnum > 0 and vim.v.relnum or vim.v.lnum)
end

vim.o.statuscolumn = '%s%=%{%v:lua.vim.statuscolumn_number()%} '
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
-- gq wraps text with Vim's built-in formatter; conform formats code. Neovim
-- points an empty formatexpr at language servers with range formatting, but
-- ruff, emmylua_ls and jsonls leave comments unwrapped. A non-zero formatexpr
-- falls back to the built-in formatter. lsp.lua hands Markdown to rumdl.
vim.o.formatexpr = '1'
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

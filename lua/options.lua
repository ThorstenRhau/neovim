-- Message and command-line UI without "Press ENTER" prompts
require('vim._core.ui2').enable()

-- Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = -1

-- Interface
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = 'tab:→ ,trail:●,nbsp:+,extends:›,precedes:‹'
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 6
vim.o.showbreak = '↪ '
vim.o.showmode = false
vim.o.sidescrolloff = 6
vim.o.smoothscroll = true
vim.o.title = true
vim.o.titlestring = 'nvim %t%( %M%) (%{fnamemodify(getcwd(), ":t")})'
if vim.env.SSH_TTY then
  vim.o.titlestring = 'SSH ' .. vim.o.titlestring
end
vim.o.winborder = 'rounded'
vim.opt.fillchars:append({ diff = ' ', eob = ' ', foldinner = ' ', msgsep = '‾' })

-- Cursor shape per mode
vim.o.guicursor = table.concat({
  'n-v-c-sm:block-Cursor',
  'i-ci-ve:ver25-Cursor',
  'r-cr-o:hor20-Cursor',
  't:block-TermCursor',
  -- 'a:blinkwait500-blinkoff500-blinkon500',
}, ',')

-- Status column: the line number, or a letter for the line's worst diagnostic
-- local diagnostic_marks = { '✘', '▲', '●', '○' }
local diagnostic_marks = { 'E', 'W', 'I', 'H' }
local diagnostic_groups = { 'Error', 'Warn', 'Info', 'Hint' }
local worst_severity = {}

local group = vim.api.nvim_create_augroup('statuscolumn_diagnostics', { clear = true })

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = group,
  callback = function(event)
    local by_line = {}
    for _, d in ipairs(vim.diagnostic.get(event.buf)) do
      for lnum = d.lnum, d.end_lnum or d.lnum do
        if not by_line[lnum] or d.severity < by_line[lnum] then
          by_line[lnum] = d.severity
        end
      end
    end
    worst_severity[event.buf] = next(by_line) and by_line or nil
  end,
})

vim.api.nvim_create_autocmd('BufWipeout', {
  group = group,
  callback = function(event)
    worst_severity[event.buf] = nil
  end,
})

function vim.statuscolumn_number()
  if vim.v.virtnum ~= 0 then
    return ''
  end
  local by_line = worst_severity[vim.api.nvim_get_current_buf()]
  local level = by_line and by_line[vim.v.lnum - 1]
  if level then
    return ('%%#Diagnostic%s#%s%%*'):format(diagnostic_groups[level], diagnostic_marks[level])
  end
  if not (vim.wo.number or vim.wo.relativenumber) then
    return ''
  end
  return tostring(vim.wo.relativenumber and vim.v.relnum > 0 and vim.v.relnum or vim.v.lnum)
end

vim.o.statuscolumn = '%s%=%{%v:lua.vim.statuscolumn_number()%} '

-- Search
vim.o.ignorecase = true
vim.o.inccommand = 'split'
vim.o.smartcase = true

-- Windows
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true

-- Text layout and folding
vim.o.breakindent = true
vim.o.foldlevelstart = 99
vim.o.foldtext = ''
vim.o.formatexpr = '1' -- gq uses the built-in formatter instead of the language server
vim.o.linebreak = true
vim.o.wrap = false

-- Behavior
vim.o.confirm = true
vim.o.exrc = true
vim.o.jumpoptions = 'clean,view'
vim.o.spelllang = 'en_us'
vim.o.startofline = true
vim.o.synmaxcol = 200
vim.o.timeoutlen = 3000
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatecount = 0
vim.o.updatetime = 300
vim.o.virtualedit = 'block'
vim.opt.diffopt:append({ 'algorithm:histogram', 'hiddenoff' })
vim.opt.sessionoptions:remove({ 'blank', 'help', 'terminal' })
vim.opt.shada:append({ 'rgitsigns:', 'rhealth:', 'rman:', 'rfile:///var/folders/' })

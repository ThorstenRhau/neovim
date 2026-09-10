-- Icons (must load first, other plugins depend on it)
local icons = require('mini.icons')
icons.setup()
icons.mock_nvim_web_devicons()

-- Align text interactively
require('mini.align').setup()

-- Responsive 60 Hz scrolling capped at 12 animation steps
local animate = require('mini.animate')
local timing = animate.gen_timing.linear({ duration = 1000 / 60, unit = 'step' })
animate.setup({
  cursor = { enable = false },
  scroll = {
    enable = true,
    timing = timing,
    subscroll = animate.gen_subscroll.equal({ max_output_steps = 12 }),
  },
  resize = { enable = false },
  open = { enable = false },
  close = { enable = false },
})

-- Extended a/i textobjects (treesitter selection, built-in function call under F)
local ai = require('mini.ai')
ai.setup({
  mappings = {
    around_next = 'aN',
    inside_next = 'iN',
    around_last = 'aL',
    inside_last = 'iL',
  },
  custom_textobjects = {
    f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    a = ai.gen_spec.treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
    ['='] = ai.gen_spec.treesitter({ a = '@assignment.outer', i = '@assignment.inner' }),
    C = ai.gen_spec.treesitter({ a = '@comment.outer', i = { '@comment.inner', '@comment.outer' } }),
    r = ai.gen_spec.treesitter({ a = '@return.outer', i = '@return.inner' }),
    l = ai.gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
    B = ai.gen_spec.treesitter({ a = '@block.outer', i = '@block.inner' }),
    c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
    o = ai.gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
    F = ai.gen_spec.function_call(),
  },
})

local function gen_textobject_clues()
  local textobjects = {
    { key = 'w', desc = 'word' },
    { key = 'W', desc = 'WORD' },
    { key = 's', desc = 'sentence' },
    { key = 'p', desc = 'paragraph' },
    { key = '(', desc = 'parentheses (opening)' },
    { key = ')', desc = 'parentheses (closing)' },
    { key = '[', desc = 'square brackets (opening)' },
    { key = ']', desc = 'square brackets (closing)' },
    { key = '{', desc = 'braces (opening)' },
    { key = '}', desc = 'braces (closing)' },
    { key = '<', desc = 'angle brackets (opening)' },
    { key = '>', desc = 'angle brackets (closing)' },
    { key = 'b', desc = 'brackets alias' },
    { key = '"', desc = 'double quotes' },
    { key = "'", desc = 'single quotes' },
    { key = '`', desc = 'backtick quotes' },
    { key = 'q', desc = 'quotes alias' },
    { key = 't', desc = 'tag' },
    { key = '?', desc = 'prompted object' },
    { key = 'a', desc = 'parameter' },
    { key = 'f', desc = 'function definition' },
    { key = 'F', desc = 'function call' },
    { key = '=', desc = 'assignment' },
    { key = 'C', desc = 'comment' },
    { key = 'r', desc = 'return' },
    { key = 'l', desc = 'loop' },
    { key = 'B', desc = 'block' },
    { key = 'c', desc = 'class' },
    { key = 'o', desc = 'conditional' },
  }

  local clues = {}
  for _, textobject in ipairs(textobjects) do
    for _, prefix in ipairs({ 'a', 'i' }) do
      table.insert(clues, { mode = { 'x', 'o' }, keys = prefix .. textobject.key, desc = textobject.desc })
    end
  end

  return clues
end

-- Split/join arguments (gS to toggle, <leader>cj as alias)
local splitjoin = require('mini.splitjoin')
splitjoin.setup()
vim.keymap.set('n', '<leader>cj', function()
  splitjoin.toggle()
end, { desc = 'split/join' })

-- Surround actions (sa=add, sd=delete, sr=replace)
require('mini.surround').setup()

-- Auto-pairs
require('mini.pairs').setup()

-- Bracket navigation ([b/]b=buffer, [c/]c=comment, [d/]d=diagnostic, etc.)
require('mini.bracketed').setup({
  file = { suffix = '' },
  quickfix = { suffix = '' },
})

-- Remove buffers without changing the window layout
local bufremove = require('mini.bufremove')
bufremove.setup()
vim.keymap.set('n', '<leader>bd', function()
  bufremove.delete(0, false)
end, { desc = 'delete buffer' })
vim.keymap.set('n', '<leader>bD', function()
  bufremove.delete(0, true)
end, { desc = 'delete buffer (force)' })

-- Status column
local statuscolumn = require('mini.statuscolumn')
statuscolumn.setup({
  content = statuscolumn.gen_content.main({
    { format = '=lfs', sep = ' ' },
    { ltype = 'virt', lnum = '•' },
    { ltype = 'wrap', lnum = '↳' },
  }),
})

-- Statusline
local constants = require('config.constants')
local statusline = require('mini.statusline')

local diagnostic_signs = {
  ERROR = '%$DiagnosticError$' .. vim.trim(constants.diagnostic_symbols.error),
  WARN = '%$DiagnosticWarn$' .. vim.trim(constants.diagnostic_symbols.warn),
  INFO = '%$DiagnosticInfo$' .. vim.trim(constants.diagnostic_symbols.info),
  HINT = '%$DiagnosticHint$' .. vim.trim(constants.diagnostic_symbols.hint),
}

local function statusline_filename()
  if vim.bo.buftype == 'terminal' then
    return '%t'
  end

  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then
    return '%t%m%r'
  end

  local parent = vim.fn.fnamemodify(path, ':h:t'):gsub('%%', '%%%%')
  return parent .. '/%t%m%r'
end

statusline.setup({
  use_icons = true,
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local logo = ''
      local git = statusline.section_git({ icon = '', trunc_width = 40 })
      local diff = statusline.is_truncated(75) and '' or vim.b.gitsigns_status or ''
      local diagnostics = vim.trim(statusline.section_diagnostics({
        icon = '',
        trunc_width = 75,
        signs = diagnostic_signs,
      }))
      if diagnostics ~= '' then
        diagnostics = diagnostics .. '%$MiniStatuslineDevinfo$'
      end
      local lsp = statusline.section_lsp({ icon = 'lsp', trunc_width = 75 })
      local devinfo = table.concat(
        vim.tbl_filter(function(section)
          return section ~= ''
        end, { git, diff, diagnostics, lsp }),
        ' · '
      )
      local filename = statusline_filename()
      local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
      local search = statusline.section_searchcount({ trunc_width = 75 })

      -- Custom location section with lualine-style formatting
      local location = (function()
        if statusline.is_truncated(75) then
          return '%l│%2v'
        end
        return '%P %l│%2v'
      end)()

      return statusline.combine_groups({
        { hl = 'MiniIconsGreen', strings = { logo } },
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { devinfo } },
        '%<',
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=',
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location } },
      })
    end,
  },
})

-- Session management
local sessions = require('mini.sessions')
sessions.setup({
  autoread = false,
  autowrite = not constants.is_headless,
  directory = vim.fn.stdpath('state') .. '/sessions/',
})

-- Derive a session name from the current working directory
local function cwd_session()
  return (vim.fn.getcwd():gsub('/', '%%'))
end

-- Auto-create session on quit when none is active (persistence.nvim compat)
if not constants.is_headless then
  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = vim.api.nvim_create_augroup('mini_sessions_autosave', { clear = true }),
    callback = function()
      if vim.g.minisessions_disable then
        return
      end
      if vim.v.this_session == '' then
        sessions.write(cwd_session())
      end
    end,
  })
end

local map = vim.keymap.set
map('n', '<leader>S', function()
  local name = cwd_session()
  if sessions.detected[name] then
    sessions.read(name)
  else
    vim.notify('No session for this directory', vim.log.levels.INFO)
  end
end, { desc = 'restore session' })
map('n', '<leader>qs', function()
  local name = cwd_session()
  if sessions.detected[name] then
    sessions.read(name)
  else
    vim.notify('No session for this directory', vim.log.levels.INFO)
  end
end, { desc = 'restore session' })
map('n', '<leader>qS', function()
  sessions.select('read')
end, { desc = 'select session' })
map('n', '<leader>ql', function()
  sessions.read(sessions.get_latest())
end, { desc = 'restore last session' })
map('n', '<leader>qw', function()
  local name = vim.fn.input('Session name: ')
  if name ~= '' then
    sessions.write(name)
  end
end, { desc = 'write named session' })
map('n', '<leader>qx', function()
  sessions.select('delete')
end, { desc = 'delete session' })
map('n', '<leader>qd', function()
  vim.g.minisessions_disable = true
end, { desc = 'stop session tracking' })

-- Key clue popup
local miniclue = require('mini.clue')
miniclue.setup({
  window = {
    delay = 200,
    config = { width = 'auto' },
  },
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'i', keys = '<C-x>' },
    { mode = 'c', keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = { 'x', 'o' }, keys = 'a' },
    { mode = { 'x', 'o' }, keys = 'i' },
    { mode = { 'n', 'x' }, keys = 'z' },
    { mode = { 'n', 'x' }, keys = '[' },
    { mode = { 'n', 'x' }, keys = ']' },
    { mode = 'o', keys = '[' },
    { mode = 'o', keys = ']' },
  },
  clues = {
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers({ show_contents = true }),
    miniclue.gen_clues.windows({
      submode_navigate = true,
      submode_resize = true,
    }),
    miniclue.gen_clues.z(),
    gen_textobject_clues(),
    { mode = 'n', keys = ']b', postkeys = ']' },
    { mode = 'n', keys = '[b', postkeys = '[' },
    { mode = 'n', keys = ']d', postkeys = ']' },
    { mode = 'n', keys = '[d', postkeys = '[' },
    { mode = { 'n', 'x' }, keys = '<Leader>a', desc = '+ai' },
    { mode = 'n', keys = '<Leader>b', desc = '+buffer' },
    { mode = { 'n', 'x' }, keys = '<Leader>c', desc = '+code' },
    { mode = 'n', keys = '<Leader>f', desc = '+files' },
    { mode = 'n', keys = '<Leader>g', desc = '+git' },
    { mode = { 'n', 'x' }, keys = '<Leader>h', desc = '+hunk' },
    { mode = 'n', keys = '<Leader>q', desc = '+session' },
    { mode = 'n', keys = '<Leader>s', desc = '+search' },
    { mode = 'n', keys = '<Leader>t', desc = '+tools/toggles' },
    { mode = 'n', keys = '<Leader>w', desc = '+window' },
    { mode = 'n', keys = '<Leader>x', desc = '+quickfix' },
  },
})

-- Icons (must load first, other plugins depend on it)
local icons = require('mini.icons')
icons.setup()
icons.mock_nvim_web_devicons()

-- Align text interactively
require('mini.align').setup()

-- Extended a/i textobjects (treesitter selection, built-in function call under F)
local ai = require('mini.ai')
ai.setup({
  custom_textobjects = {
    f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    a = ai.gen_spec.treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
    c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
    F = ai.gen_spec.function_call(),
  },
})

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

-- Move selected text with meta+hjkl
require('mini.move').setup()

-- Statusline
local constants = require('config.constants')
local statusline = require('mini.statusline')
statusline.setup({
  use_icons = true,
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 40 })
      local diff = statusline.section_diff({ trunc_width = 75 })
      local diagnostics = statusline.section_diagnostics({
        trunc_width = 75,
        signs = {
          ERROR = constants.diagnostic_symbols.error,
          WARN = constants.diagnostic_symbols.warn,
          INFO = constants.diagnostic_symbols.info,
          HINT = constants.diagnostic_symbols.hint,
        },
      })
      local lsp = statusline.section_lsp({ trunc_width = 75 })
      local filename = statusline.section_filename({ trunc_width = 140 })
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
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
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
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = '[' },
    { mode = 'x', keys = ']' },
    { mode = 'o', keys = '[' },
    { mode = 'o', keys = ']' },
  },
  clues = {
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    { mode = 'n', keys = '<Leader>a', desc = '+claude' },
    { mode = 'x', keys = '<Leader>a', desc = '+claude' },
    { mode = 'n', keys = '<Leader>b', desc = '+buffer' },
    { mode = 'n', keys = '<Leader>c', desc = '+code' },
    { mode = 'x', keys = '<Leader>c', desc = '+code' },
    { mode = 'n', keys = '<Leader>f', desc = '+file/find' },
    { mode = 'x', keys = '<Leader>f', desc = '+file/find' },
    { mode = 'n', keys = '<Leader>g', desc = '+git' },
    { mode = 'n', keys = '<Leader>h', desc = '+hunk' },
    { mode = 'x', keys = '<Leader>h', desc = '+hunk' },
    { mode = 'n', keys = '<Leader>q', desc = '+project/session' },
    { mode = 'n', keys = '<Leader>s', desc = '+search' },
    { mode = 'n', keys = '<Leader>t', desc = '+toggle' },
    { mode = 'n', keys = '<Leader>w', desc = '+window' },
    { mode = 'n', keys = '<Leader>x', desc = '+quickfix' },
  },
})

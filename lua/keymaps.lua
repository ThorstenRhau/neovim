local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlights' })
map('n', '<leader>l', vim.pack.update, { desc = 'Update plugins' })

map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Down by display line' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Up by display line' })

local ts_select = require('nvim-treesitter-textobjects.select')
-- Select around a function.
map({ 'x', 'o' }, 'af', function()
  ts_select.select_textobject('@function.outer', 'textobjects')
end, { desc = 'Around function' })
-- Select inside a function.
map({ 'x', 'o' }, 'if', function()
  ts_select.select_textobject('@function.inner', 'textobjects')
end, { desc = 'Inside function' })
-- Select around a class.
map({ 'x', 'o' }, 'ac', function()
  ts_select.select_textobject('@class.outer', 'textobjects')
end, { desc = 'Around class' })
-- Select inside a class.
map({ 'x', 'o' }, 'ic', function()
  ts_select.select_textobject('@class.inner', 'textobjects')
end, { desc = 'Inside class' })
-- Select around a parameter.
map({ 'x', 'o' }, 'aa', function()
  ts_select.select_textobject('@parameter.outer', 'textobjects')
end, { desc = 'Around parameter' })
-- Select inside a parameter.
map({ 'x', 'o' }, 'ia', function()
  ts_select.select_textobject('@parameter.inner', 'textobjects')
end, { desc = 'Inside parameter' })

local ts_move = require('nvim-treesitter-textobjects.move')
-- Jump to the next function start.
map({ 'n', 'x', 'o' }, '<LocalLeader>fj', function()
  ts_move.goto_next_start('@function.outer', 'textobjects')
end, { desc = 'Next function start' })
-- Jump to the previous function start.
map({ 'n', 'x', 'o' }, '<LocalLeader>fk', function()
  ts_move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Previous function start' })
-- Jump to the next function end.
map({ 'n', 'x', 'o' }, '<LocalLeader>fJ', function()
  ts_move.goto_next_end('@function.outer', 'textobjects')
end, { desc = 'Next function end' })
-- Jump to the previous function end.
map({ 'n', 'x', 'o' }, '<LocalLeader>fK', function()
  ts_move.goto_previous_end('@function.outer', 'textobjects')
end, { desc = 'Previous function end' })
-- Jump to the next class start.
map({ 'n', 'x', 'o' }, '<LocalLeader>cj', function()
  ts_move.goto_next_start('@class.outer', 'textobjects')
end, { desc = 'Next class start' })
-- Jump to the previous class start.
map({ 'n', 'x', 'o' }, '<LocalLeader>ck', function()
  ts_move.goto_previous_start('@class.outer', 'textobjects')
end, { desc = 'Previous class start' })
-- Jump to the next class end.
map({ 'n', 'x', 'o' }, '<LocalLeader>cJ', function()
  ts_move.goto_next_end('@class.outer', 'textobjects')
end, { desc = 'Next class end' })
-- Jump to the previous class end.
map({ 'n', 'x', 'o' }, '<LocalLeader>cK', function()
  ts_move.goto_previous_end('@class.outer', 'textobjects')
end, { desc = 'Previous class end' })

map('n', '<leader> ', '<cmd>FzfLua files<cr>', { desc = 'Files' })
map('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Files' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })
map('n', '<leader>fo', '<cmd>FzfLua oldfiles<cr>', { desc = 'Recent files' })
map('n', '<leader>sg', '<cmd>FzfLua live_grep<cr>', { desc = 'Live grep' })
map('n', '<leader>sh', '<cmd>FzfLua helptags<cr>', { desc = 'Help' })
map('n', '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', { desc = 'Document diagnostics' })
map('n', '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', { desc = 'Workspace diagnostics' })
map('n', '<leader>cf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer' })
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Diagnostic float' })
map('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Neogit status' })
map('n', '<leader>gl', '<cmd>Neogit log<cr>', { desc = 'Neogit log' })
map('n', '<leader>o', '<cmd>silent !open %:p:S<cr>', { desc = 'Open file externally' })
map('n', '-', '<cmd>Oil<cr>', { desc = 'Open directory' })
map('n', '<leader>ts', function()
  vim.wo[0][0].spell = not vim.wo.spell
end, { desc = 'Toggle spelling' })
map('n', '<leader>tw', function()
  vim.wo[0][0].wrap = not vim.wo.wrap
end, { desc = 'Toggle line wrap' })

local cli = require('sidekick.cli')
map('n', '<leader>aa', function()
  cli.toggle({ name = 'codex', focus = true })
end, { desc = 'Toggle Codex' })
map('n', '<leader>af', function()
  cli.send({ name = 'codex', msg = '{file}' })
end, { desc = 'Send file to Codex' })
map('n', '<leader>at', function()
  cli.send({ name = 'codex', msg = '{this}' })
end, { desc = 'Send position to Codex' })
map('x', '<leader>at', function()
  cli.send({ name = 'codex', msg = '{selection}' })
end, { desc = 'Send selection to Codex' })
map('n', '<leader>ad', function()
  cli.send({ name = 'codex', msg = '{file}\n{diagnostics}' })
end, { desc = 'Send diagnostics to Codex' })

local clue = require('mini.clue')
clue.setup({
  triggers = {
    { mode = { 'n', 'x' }, keys = '<leader>' },
    { mode = { 'n', 'x', 'o' }, keys = '<LocalLeader>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = 'z' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'n', keys = '<C-w>' },
  },
  clues = {
    { mode = { 'n', 'x' }, keys = '<leader>a', desc = 'AI' },
    { mode = { 'n', 'x', 'o' }, keys = '<LocalLeader>c', desc = 'Classes' },
    { mode = { 'n', 'x', 'o' }, keys = '<LocalLeader>f', desc = 'Functions' },
    { mode = 'n', keys = '<leader>c', desc = 'Code' },
    { mode = 'n', keys = '<leader>f', desc = 'Files' },
    { mode = 'n', keys = '<leader>g', desc = 'Git' },
    { mode = 'n', keys = '<leader>s', desc = 'Search' },
    { mode = 'n', keys = '<leader>t', desc = 'Toggle' },
    clue.gen_clues.g(),
    clue.gen_clues.z(),
    clue.gen_clues.square_brackets(),
    clue.gen_clues.windows(),
  },
})

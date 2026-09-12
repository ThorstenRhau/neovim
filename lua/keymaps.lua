local map = vim.keymap.set

map('n', '<leader>l', function()
  vim.pack.update()
end, { desc = 'Update plugins' })

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
map('n', '<leader>gg', function()
  require('neogit').open()
end, { desc = 'Neogit status' })
map('n', '<leader>gl', function()
  require('neogit').open({ 'log' })
end, { desc = 'Neogit log' })
map('n', '<leader>o', '<cmd>silent !open %<cr>', { desc = 'Open file externally' })
map('n', '-', '<cmd>Oil<cr>', { desc = 'Open directory' })
map('n', '<leader>ts', function()
  vim.wo[0][0].spell = not vim.wo.spell
end, { desc = 'Toggle spelling' })

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
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = 'z' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'n', keys = '<C-w>' },
  },
  clues = {
    { mode = { 'n', 'x' }, keys = '<leader>a', desc = 'AI' },
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

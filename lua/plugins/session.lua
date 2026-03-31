require('persistence').setup({})

local map = vim.keymap.set

map('n', '<leader>S', function()
  require('persistence').load()
end, { desc = 'previous session' })
map('n', '<leader>qs', function()
  require('persistence').load()
end, { desc = 'previous session' })
map('n', '<leader>qS', function()
  require('persistence').select()
end, { desc = 'select session' })
map('n', '<leader>ql', function()
  require('persistence').load({ last = true })
end, { desc = 'restore last session' })
map('n', '<leader>qd', function()
  require('persistence').stop()
end, { desc = 'stop session tracking' })

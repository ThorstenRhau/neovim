local map = vim.keymap.set

map('n', '<leader>gg', '<cmd>Git<cr>', { desc = 'git status' })
map('n', '<leader>gP', '<cmd>Git push<cr>', { desc = 'git push' })
map('n', '<leader>gp', '<cmd>Git pull --rebase<cr>', { desc = 'git pull' })
map('n', '<leader>gf', '<cmd>Git fetch --all<cr>', { desc = 'git fetch' })
map('n', '<leader>gl', '<cmd>Git log --oneline<cr>', { desc = 'git log' })
map('n', '<leader>gL', '<cmd>Git log<cr>', { desc = 'git log (full)' })
map('n', '<leader>gA', '<cmd>Git blame<cr>', { desc = 'git blame (full)' })

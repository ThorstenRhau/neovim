local map = vim.keymap.set

-- Resize windows
map('n', '<S-Up>', '<cmd>resize +2<CR>', { desc = 'Increase Window Height', silent = true })
map('n', '<S-Down>', '<cmd>resize -2<CR>', { desc = 'Decrease Window Height', silent = true })
map('n', '<S-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Decrease Window Width', silent = true })
map('n', '<S-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Increase Window Width', silent = true })

-- Clear search highlights (Normal mode only)
map('n', '<esc>', '<cmd>noh<cr><esc>', { desc = 'Clear hlsearch', silent = true })

-- Disable yank/copy for 'x' and 'X' (backward yank)
map('n', 'x', '"_x', { silent = true })
map('n', 'X', '"_X', { silent = true })

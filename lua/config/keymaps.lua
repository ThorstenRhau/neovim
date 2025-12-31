local map = vim.keymap.set

---Create smart motion mapping for wrapped lines
---@param key string
---@param direction string
local function smart_motion(key, direction)
  map({ 'n', 'x' }, key, function()
    return vim.v.count == 0 and direction or (vim.v.count .. key)
  end, { desc = direction == 'gj' and 'Down' or 'Up', expr = true, silent = true })
end

-- Window navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window', silent = true, nowait = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window', silent = true, nowait = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window', silent = true, nowait = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window', silent = true, nowait = true })

-- Resize windows
map('n', '<S-Up>', '<cmd>resize +2<CR>', { desc = 'Increase Window Height', silent = true })
map('n', '<S-Down>', '<cmd>resize -2<CR>', { desc = 'Decrease Window Height', silent = true })
map('n', '<S-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Decrease Window Width', silent = true })
map('n', '<S-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Increase Window Width', silent = true })

-- Clear search highlights (Normal mode only)
map('n', '<esc>', '<cmd>noh<cr><esc>', { desc = 'Clear hlsearch', silent = true })

-- Optional: Buffer navigation
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer', silent = true })
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer', silent = true })

-- Disable yank/copy for 'x' and 'X' (backward yank)
map('n', 'x', '"_x', { silent = true })
map('n', 'X', '"_X', { silent = true })

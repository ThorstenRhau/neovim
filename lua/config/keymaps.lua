local map = vim.keymap.set

-- Better escape
map('i', 'jk', '<Esc>', { desc = 'Escape' })
map('i', 'jj', '<Esc>', { desc = 'Escape' })

-- Better movement
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Down' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Up' })

-- Move lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Buffers
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<leader>,', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })
map('n', '<leader>bD', '<cmd>bdelete!<cr>', { desc = 'Delete buffer (force)' })
map('n', '<leader>bo', '<cmd>%bdelete|edit#|bdelete#<cr>', { desc = 'Delete other buffers' })

-- Windows
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })
map('n', '<leader>ww', '<C-w>p', { desc = 'Other window' })
map('n', '<leader>wd', '<C-w>c', { desc = 'Delete window' })
map('n', '<leader>ws', '<C-w>s', { desc = 'Split window below' })
map('n', '<leader>wv', '<C-w>v', { desc = 'Split window right' })
map('n', '<leader>w=', '<C-w>=', { desc = 'Equalize windows' })

-- Resize windows
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

-- Better indenting
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Save
map({ 'n', 'i', 'x', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Better paste
map('x', 'p', '"_dP', { desc = 'Paste without yanking' })

-- Add blank lines
map('n', ']<space>', 'o<esc>k', { desc = 'Add blank line below' })
map('n', '[<space>', 'O<esc>j', { desc = 'Add blank line above' })

-- Quickfix
map('n', '<leader>xn', '<cmd>cnext<cr>', { desc = 'Next quickfix' })
map('n', '<leader>xp', '<cmd>cprev<cr>', { desc = 'Previous quickfix' })

-- Diagnostic navigation
map('n', ']d', function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = 'Next diagnostic' })
map('n', '[d', function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = 'Previous diagnostic' })
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })

-- Lazy
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- Toggle options
map('n', '<leader>tw', function()
  vim.o.wrap = not vim.o.wrap
end, { desc = 'Toggle wrap' })
map('n', '<leader>tn', function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = 'Toggle relative numbers' })
map('n', '<leader>ts', function()
  vim.o.spell = not vim.o.spell
end, { desc = 'Toggle spelling' })
map('n', '<leader>tc', function()
  vim.o.cursorline = not vim.o.cursorline
end, { desc = 'Toggle cursorline' })
map('n', '<leader>tl', function()
  local config = vim.diagnostic.config() or {}
  local new_value = not config.virtual_lines
  vim.diagnostic.config({ virtual_lines = new_value })
end, { desc = 'Toggle diagnostic lines' })

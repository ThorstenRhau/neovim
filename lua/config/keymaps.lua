local map = vim.keymap.set

-- Better escape
map('i', 'jk', '<Esc>', { desc = 'escape' })
map('i', 'jj', '<Esc>', { desc = 'escape' })

-- Better movement
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'down' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'up' })

-- Move lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'move line down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'move line up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'move line down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'move line up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'move selection down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'move selection up' })

-- Buffers
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'previous buffer' })
map('n', '<leader>,', '<cmd>bprevious<cr>', { desc = 'previous buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'next buffer' })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'delete buffer' })
map('n', '<leader>bD', '<cmd>bdelete!<cr>', { desc = 'delete buffer (force)' })
map('n', '<leader>bo', '<cmd>%bdelete|edit#|bdelete#<cr>', { desc = 'delete other buffers' })

-- Windows
map('n', '<C-h>', '<C-w>h', { desc = 'go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'go to right window' })
map('n', '<leader>ww', '<C-w>p', { desc = 'other window' })
map('n', '<leader>wd', '<C-w>c', { desc = 'delete window' })
map('n', '<leader>ws', '<C-w>s', { desc = 'split window below' })
map('n', '<leader>wv', '<C-w>v', { desc = 'split window right' })
map('n', '<leader>w=', '<C-w>=', { desc = 'equalize windows' })

-- Resize windows
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'increase window width' })

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'clear search highlight' })

-- Better indenting
map('v', '<', '<gv', { desc = 'indent left' })
map('v', '>', '>gv', { desc = 'indent right' })

-- Save
map({ 'n', 'i', 'x', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'save file' })

-- Better paste
map('x', 'p', '"_dP', { desc = 'paste without yanking' })

-- Add blank lines
map('n', ']<space>', 'o<esc>k', { desc = 'add blank line below' })
map('n', '[<space>', 'O<esc>j', { desc = 'add blank line above' })

-- Quickfix
map('n', '<leader>xn', '<cmd>cnext<cr>', { desc = 'next quickfix' })
map('n', '<leader>xp', '<cmd>cprev<cr>', { desc = 'previous quickfix' })

-- Code
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'line diagnostics' })
map('n', '<leader>cw', '<cmd>TrimWhitespace<cr>', { desc = 'trim whitespace' })

-- Lazy
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'lazy' })

-- Toggle options
local toggles = {
  { 'w', 'wrap', 'wrap' },
  { 'n', 'relativenumber', 'relative numbers' },
  { 's', 'spell', 'spelling' },
  { 'c', 'cursorline', 'cursorline' },
}
for _, t in ipairs(toggles) do
  map('n', '<leader>t' .. t[1], function()
    vim.o[t[2]] = not vim.o[t[2]]
  end, { desc = t[3] })
end
map('n', '<leader>tl', function()
  local config = vim.diagnostic.config() or {}
  local new_value = not config.virtual_lines
  vim.diagnostic.config({ virtual_lines = new_value })
end, { desc = 'diagnostic lines' })
map('n', '<leader>ta', function()
  if vim.b.completion == false then
    vim.b.completion = true
    vim.notify('Completion enabled', vim.log.levels.INFO)
  else
    vim.b.completion = false
    vim.notify('Completion disabled', vim.log.levels.INFO)
  end
end, { desc = 'auto-completion' })

local map = vim.keymap.set

-- Better escape
map('i', 'jk', '<Esc>', { desc = 'escape' })
map('i', 'jj', '<Esc>', { desc = 'escape' })

-- Better movement
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'down' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'up' })

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

-- Incremental selection
map({ 'n', 'x', 'o' }, '<A-o>', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require('vim.treesitter._select').select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = 'select parent node' })

map({ 'n', 'x', 'o' }, '<A-i>', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require('vim.treesitter._select').select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = 'select child node' })

-- Add blank lines
map('n', ']<space>', 'o<esc>k', { desc = 'add blank line below' })
map('n', '[<space>', 'O<esc>j', { desc = 'add blank line above' })

-- Quickfix
map('n', '<leader>xn', '<cmd>cnext<cr>', { desc = 'next quickfix' })
map('n', '<leader>xp', '<cmd>cprev<cr>', { desc = 'previous quickfix' })

-- Code
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'line diagnostics' })
map('n', '<leader>cw', '<cmd>TrimWhitespace<cr>', { desc = 'trim whitespace' })

-- Open file with system default
map('n', '<leader>cO', '<cmd>!open %<cr>', { desc = 'open file externally' })

-- Plugins
map('n', '<leader>l', function()
  vim.pack.update()
end, { desc = 'update plugins' })

-- Toggle options
local toggles = {
  { 'w', 'wrap', 'wrap' },
  { 'n', 'relativenumber', 'relative numbers' },
  { 's', 'spell', 'spelling' },
  { 'c', 'cursorline', 'cursorline' },
  { 'h', 'list', 'hidden chars' },
}
for _, t in ipairs(toggles) do
  map('n', '<leader>t' .. t[1], function()
    vim.o[t[2]] = not vim.o[t[2]]
  end, { desc = t[3] })
end
local saved_vlines
map('n', '<leader>tl', function()
  local current = vim.diagnostic.config().virtual_lines
  if current then
    saved_vlines = current
    vim.diagnostic.config({ virtual_lines = false })
  else
    vim.diagnostic.config({ virtual_lines = saved_vlines or { current_line = true } })
  end
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

map('n', '<leader>tC', function()
  local enabled = vim.g.document_color_enabled
  if enabled == nil then
    enabled = true
  end
  enabled = not enabled
  vim.g.document_color_enabled = enabled
  vim.lsp.document_color.enable(enabled, nil, { style = 'virtual' })
  vim.notify('Document colors ' .. (enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
end, { desc = 'document colors' })

map('n', '<leader>tL', function()
  local managed_servers = vim.g.managed_lsp_servers or {}
  local enabled = vim.g.disable_auto_lsp == true

  vim.g.disable_auto_lsp = not enabled
  vim.g.disable_auto_lint = not enabled

  if enabled then
    vim.diagnostic.enable(true)
    if #managed_servers > 0 then
      vim.lsp.enable(managed_servers, true)
    end

    local ok, lint = pcall(require, 'lint')
    if ok then
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == '' then
          vim.api.nvim_buf_call(bufnr, function()
            lint.try_lint()
          end)
        end
      end
    end

    vim.notify('Global LSP & linter enabled', vim.log.levels.INFO)
  else
    vim.diagnostic.enable(false)
    if #managed_servers > 0 then
      vim.lsp.enable(managed_servers, false)
    end
    vim.notify('Global LSP & linter disabled', vim.log.levels.INFO)
  end
end, { desc = 'global LSP & linter' })

-- Built-in difftool
map('n', '<leader>gD', function()
  vim.cmd.packadd('nvim.difftool')
  local current = vim.api.nvim_buf_get_name(0)
  local right = vim.fn.input('Diff against: ', '', 'file')
  if right ~= '' then
    require('difftool').open(current, right, { rename = { detect = true } })
  end
end, { desc = 'difftool' })

-- Built-in undotree
map('n', '<leader>tu', function()
  vim.cmd.packadd('nvim.undotree')
  require('undotree').open()
end, { desc = 'undotree' })

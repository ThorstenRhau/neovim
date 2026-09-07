local map = vim.keymap.set

-- Better escape
map('i', 'jk', '<Esc>', { desc = 'escape' })
map('i', 'jj', '<Esc>', { desc = 'escape' })

-- Better movement
map('n', 'j', [[(v:count > 1 ? 'm`' . v:count : v:count == 0 ? 'g' : '') . 'j']], { expr = true, desc = 'down' })
map('n', 'k', [[(v:count > 1 ? 'm`' . v:count : v:count == 0 ? 'g' : '') . 'k']], { expr = true, desc = 'up' })
map('x', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'down' })
map('x', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'up' })

-- Buffers
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'previous buffer' })
map('n', '<leader>,', '<cmd>bprevious<cr>', { desc = 'previous buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'next buffer' })
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
map('n', '<leader>wk', '<cmd>resize +2<cr>', { desc = 'increase window height' })
map('n', '<leader>wj', '<cmd>resize -2<cr>', { desc = 'decrease window height' })
map('n', '<leader>wh', '<cmd>vertical resize -2<cr>', { desc = 'decrease window width' })
map('n', '<leader>wl', '<cmd>vertical resize +2<cr>', { desc = 'increase window width' })

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'clear search highlight' })

-- Better indenting
map('v', '<', '<gv', { desc = 'indent left' })
map('v', '>', '>gv', { desc = 'indent right' })

-- Better paste
map('x', 'p', '"_dP', { desc = 'paste without yanking' })
map('n', 'gV', '`[v`]', { desc = 'select last changed or yanked text' })

-- Incremental selection
map({ 'n', 'x', 'o' }, '<A-o>', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    vim.treesitter.select('parent', vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = 'select parent node' })

map({ 'n', 'x', 'o' }, '<A-i>', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    vim.treesitter.select('child', vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = 'select child node' })

-- Quickfix
local severity_names = {
  [vim.diagnostic.severity.ERROR] = 'ERROR',
  [vim.diagnostic.severity.WARN] = 'WARN',
  [vim.diagnostic.severity.INFO] = 'INFO',
  [vim.diagnostic.severity.HINT] = 'HINT',
}

local function format_diagnostic_list_item(diagnostic)
  local severity = severity_names[diagnostic.severity] or 'ERROR'
  local source = diagnostic.source
  local code = diagnostic.code and tostring(diagnostic.code) or nil
  local label

  if source and code then
    label = string.format('%s/%s', source, code)
  else
    label = source or code
  end

  if label then
    return string.format('[%s] [%s] %s', severity, label, diagnostic.message)
  end

  return string.format('[%s] %s', severity, diagnostic.message)
end

map('n', '<leader>xd', function()
  vim.diagnostic.setloclist({
    open = true,
    title = 'Buffer Diagnostics',
    format = format_diagnostic_list_item,
  })
end, { desc = 'buffer diagnostics' })
map('n', '<leader>xD', function()
  vim.diagnostic.setqflist({
    open = true,
    title = 'Workspace Diagnostics',
    format = format_diagnostic_list_item,
  })
end, { desc = 'workspace diagnostics' })
map('n', '<leader>xn', '<cmd>cnext<cr>', { desc = 'next quickfix' })
map('n', '<leader>xp', '<cmd>cprev<cr>', { desc = 'previous quickfix' })
map('n', '[e', function()
  vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'previous error' })
map('n', ']e', function()
  vim.diagnostic.jump({ count = vim.v.count1, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'next error' })

-- Code
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'line diagnostics' })
map('n', '<leader>cw', '<cmd>TrimWhitespace<cr>', { desc = 'trim whitespace' })

-- Open file with system default
map('n', '<leader>o', function()
  local name = vim.api.nvim_buf_get_name(0)
  if name == '' then
    vim.notify('Buffer has no file', vim.log.levels.WARN)
    return
  end
  vim.ui.open(name)
end, { desc = 'open file externally' })

-- Plugins
map('n', '<leader>l', function()
  vim.pack.update()
end, { desc = 'update plugins' })

-- Session restart
map('n', '<leader>R', '<cmd>restart<cr>', { desc = 'restart Neovim' })

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
map('n', '<leader>tN', function()
  local enabled = not vim.o.number
  vim.o.number = enabled
  vim.o.relativenumber = enabled
end, { desc = 'line numbers' })
map('n', '<leader>ti', function()
  local filter = { bufnr = 0 }
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
end, { desc = 'inlay hints' })
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

-- Built-in difftool
map('n', '<leader>gD', function()
  vim.cmd.packadd('nvim.difftool')
  local current = vim.api.nvim_buf_get_name(0)
  local right = vim.fn.input('Diff against: ', '', 'file')
  if right ~= '' then
    require('difftool').open(current, right, { method = 'auto', ignore = {}, rename = { detect = true } })
  end
end, { desc = 'difftool' })

-- Built-in undotree
map('n', '<leader>tu', function()
  vim.cmd.packadd('nvim.undotree')
  require('undotree').open()
end, { desc = 'undotree' })

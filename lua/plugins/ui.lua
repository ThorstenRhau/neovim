local map = vim.keymap.set

-- Which-key
require('which-key').setup({
  preset = 'helix',
  delay = 200,
  spec = {
    { '<leader>a', group = 'claude' },
    { '<leader>b', group = 'buffer' },
    { '<leader>c', group = 'code' },
    { '<leader>f', group = 'file/find' },
    { '<leader>g', group = 'git' },
    { '<leader>h', group = 'hunk' },
    { '<leader>q', group = 'project/session' },
    { '<leader>s', group = 'search' },
    { '<leader>t', group = 'toggle' },
    { '<leader>w', group = 'window' },
    { '<leader>x', group = 'diagnostics' },
    { 'g', group = 'goto' },
    { '[', group = 'prev' },
    { ']', group = 'next' },
  },
  icons = {
    mappings = false,
  },
})

-- Trouble
require('trouble').setup({
  focus = true,
  auto_close = true,
})

map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'diagnostics' })
map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'buffer diagnostics' })
map('n', '<leader>xs', '<cmd>Trouble symbols toggle<cr>', { desc = 'symbols' })
map('n', '<leader>xl', '<cmd>Trouble lsp toggle<cr>', { desc = 'lsp references' })
map('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'location list' })
map('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'quickfix list' })

map('n', '[q', function()
  if require('trouble').is_open() then
    ---@diagnostic disable-next-line: missing-fields, missing-parameter
    require('trouble').prev({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cprev)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = 'previous trouble/quickfix item' })

map('n', ']q', function()
  if require('trouble').is_open() then
    ---@diagnostic disable-next-line: missing-fields, missing-parameter
    require('trouble').next({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cnext)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = 'next trouble/quickfix item' })

-- Neoscroll
require('neoscroll').setup({
  easing = 'sine',
})

local map = vim.keymap.set

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

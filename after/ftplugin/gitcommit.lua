vim.opt_local.colorcolumn = '72'
vim.opt_local.spell = true

-- Set it again once Neogit shows the buffer in its window
vim.api.nvim_create_autocmd('BufWinEnter', {
  buf = 0,
  once = true,
  callback = function()
    vim.opt_local.colorcolumn = '72'
  end,
})

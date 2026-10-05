vim.opt_local.colorcolumn = '72'
vim.opt_local.spell = true

vim.api.nvim_create_autocmd('BufWinEnter', {
  buf = 0,
  callback = function()
    vim.opt_local.colorcolumn = '72'
  end,
})

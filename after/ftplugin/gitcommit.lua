vim.opt_local.colorcolumn = '72'
vim.opt_local.spell = true
vim.opt_local.textwidth = 72

vim.api.nvim_create_autocmd('BufWinEnter', {
  buffer = 0,
  callback = function()
    vim.opt_local.colorcolumn = '72'
  end,
})

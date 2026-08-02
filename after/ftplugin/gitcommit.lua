vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = '50,73'
vim.api.nvim_create_autocmd('BufWinEnter', {
  buffer = 0,
  desc = 'Show commit message guides in newly opened windows',
  callback = function()
    vim.opt_local.colorcolumn = '50,73'
  end,
})
require('config.ftplugin').prose().indent(2).treesitter()

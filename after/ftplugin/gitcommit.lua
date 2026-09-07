vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = '50,73'
local guides = vim.api.nvim_create_autocmd('BufWinEnter', {
  buffer = 0,
  desc = 'Show commit message guides in newly opened windows',
  callback = function()
    vim.opt_local.colorcolumn = '50,73'
  end,
})
require('config.ftplugin').prose().indent(2).treesitter()

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|setlocal colorcolumn< wrap< spell< shiftwidth< softtabstop< foldmethod< foldexpr<'
  .. string.format('|lua vim.api.nvim_del_autocmd(%d)', guides)

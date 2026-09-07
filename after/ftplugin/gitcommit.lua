vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = '50,73'
local guides = vim.api.nvim_create_autocmd('BufWinEnter', {
  buffer = 0,
  desc = 'Show commit message guides in newly opened windows',
  callback = function()
    vim.opt_local.colorcolumn = '50,73'
  end,
})
vim.opt_local.wrap = true
vim.opt_local.spell = vim.bo.buftype == ''

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|setlocal textwidth< colorcolumn< wrap< spell<'
  .. string.format('|call v:lua.vim.api.nvim_del_autocmd(%d)', guides)

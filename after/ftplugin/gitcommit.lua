vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = '50,73'
vim.opt_local.wrap = true
if vim.bo.buftype == '' then
  vim.opt_local.spell = true
end
require('config.ftplugin').indent(2).treesitter()

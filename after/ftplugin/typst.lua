vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.conceallevel = 2
if vim.bo.buftype == '' then
  vim.opt_local.spell = true
  vim.opt_local.textwidth = 80
end
require('config.ftplugin').indent(2).treesitter()

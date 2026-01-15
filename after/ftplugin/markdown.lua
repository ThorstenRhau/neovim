vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.conceallevel = 2
-- Only enable spell for regular files, not scratch buffers (LSP hover, etc.)
if vim.bo.buftype == '' then
  vim.opt_local.spell = true
  vim.opt_local.textwidth = 80
end
require('config.ftplugin').treesitter()

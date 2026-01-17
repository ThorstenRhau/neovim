vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.conceallevel = 2
if vim.bo.buftype == '' then
  vim.opt_local.spell = true
  vim.opt_local.textwidth = 80
end
require('config.ftplugin').indent(2).treesitter()

-- Tinymist preview keymaps
vim.keymap.set('n', '<leader>tp', function()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = 'tinymist' })
  if clients[1] then
    clients[1]:exec_cmd({
      command = 'tinymist.startDefaultPreview',
      arguments = { vim.api.nvim_buf_get_name(0) },
    })
  end
end, { buffer = true, desc = 'typst preview' })

vim.keymap.set('n', '<leader>tq', function()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = 'tinymist' })
  if clients[1] then
    clients[1]:exec_cmd({
      command = 'tinymist.doKillPreview',
      arguments = { 'default_preview' },
    })
  end
end, { buffer = true, desc = 'stop typst preview' })

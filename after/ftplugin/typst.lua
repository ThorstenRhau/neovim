vim.opt_local.conceallevel = 2
require('config.ftplugin').prose().indent(2).treesitter()

-- Tinymist preview keymaps
local function tinymist_cmd(command, arguments)
  local client = vim.lsp.get_clients({ bufnr = 0, name = 'tinymist' })[1]
  if client then
    client:exec_cmd({ title = command, command = command, arguments = arguments })
  end
end

vim.keymap.set('n', '<leader>tp', function()
  tinymist_cmd('tinymist.startDefaultPreview', { vim.api.nvim_buf_get_name(0) })
end, { buffer = true, desc = 'typst preview' })

vim.keymap.set('n', '<leader>tq', function()
  tinymist_cmd('tinymist.doKillPreview', { 'default_preview' })
end, { buffer = true, desc = 'stop typst preview' })

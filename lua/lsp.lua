require('lazydev').setup()

vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })
vim.lsp.config('bashls', { settings = { bashIde = { shellcheckPath = '' } } })
vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = { typeCheckingMode = 'standard' },
    },
  },
})
vim.lsp.config('ruff', {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})
vim.lsp.config('jsonls', {
  settings = {
    json = { schemas = require('schemastore').json.schemas(), validate = { enable = true } },
  },
})
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = '' },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
})
vim.lsp.enable({ 'bashls', 'basedpyright', 'ruff', 'lua_ls', 'marksman', 'jsonls', 'yamlls', 'tombi' })

vim.diagnostic.config({
  signs = true,
  severity_sort = true,
  virtual_text = false,
  virtual_lines = { current_line = true },
  float = { source = true },
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
  callback = function(event)
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = event.buf, desc = desc })
    end
    map('gd', '<cmd>FzfLua lsp_definitions<cr>', 'Definitions')
    map('grr', '<cmd>FzfLua lsp_references<cr>', 'References')
    map('gO', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')
    map('<leader>fs', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', 'Live workspace symbols')
  end,
})

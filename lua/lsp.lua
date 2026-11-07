require('lazydev').setup()

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
      schemaStore = { enable = false },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
})

vim.lsp.enable({
  'bashls',
  'basedpyright',
  'ruff',
  'lua_ls',
  'marksman',
  'jsonls',
  'yamlls',
  'tombi',
})

local severity = vim.diagnostic.severity
vim.diagnostic.config({
  severity_sort = true,
  -- Color the line number instead of using a sign, so the single sign
  -- column stays free for Git markers.
  signs = {
    text = { [severity.ERROR] = '', [severity.WARN] = '', [severity.INFO] = '', [severity.HINT] = '' },
    numhl = {
      [severity.ERROR] = 'DiagnosticSignError',
      [severity.WARN] = 'DiagnosticSignWarn',
      [severity.INFO] = 'DiagnosticSignInfo',
      [severity.HINT] = 'DiagnosticSignHint',
    },
  },
  float = { source = true },
})

-- Show the cursor line's diagnostics in a float when the cursor rests.
-- Virtual lines start at the diagnostic's column and get clipped on long lines.
vim.api.nvim_create_autocmd('CursorHold', {
  group = vim.api.nvim_create_augroup('diagnostic_float', { clear = true }),
  callback = function()
    vim.diagnostic.open_float({ focus = false })
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
  callback = function(event)
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buf = event.buf, desc = desc })
    end
    map('gd', '<cmd>FzfLua lsp_definitions<cr>', 'Definitions')
    map('gri', '<cmd>FzfLua lsp_implementations<cr>', 'Implementations')
    map('grr', '<cmd>FzfLua lsp_references<cr>', 'References')
    map('grt', '<cmd>FzfLua lsp_typedefs<cr>', 'Type definitions')
    map('gO', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map('<leader>ss', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', 'Live workspace symbols')
  end,
})

-- Show server progress, such as indexing, as native progress messages.
vim.api.nvim_create_autocmd('LspProgress', {
  group = vim.api.nvim_create_augroup('lsp_progress', { clear = true }),
  callback = function(event)
    local value = event.data.params.value
    vim.api.nvim_echo({ { value.message or 'done' } }, false, {
      id = 'lsp.' .. event.data.params.token,
      kind = 'progress',
      source = 'vim.lsp',
      title = value.title,
      status = value.kind ~= 'end' and 'running' or 'success',
      percent = value.percentage,
    })
  end,
})

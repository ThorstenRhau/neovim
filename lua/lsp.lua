-- Server settings

vim.lsp.config('pyrefly', {
  settings = { python = { pyrefly = { typeCheckingMode = 'default' } } },
})

---@param d lsp.Diagnostic
local function not_line_length(d)
  return d.code ~= 'MD013'
end

-- rumdl reflows Markdown for gq. Hide its line-length diagnostics.
vim.lsp.config('rumdl', {
  init_options = { settings = { MD013 = { reflow = true, ['reflow-mode'] = 'normalize' } } },
  handlers = {
    ['textDocument/publishDiagnostics'] = function(err, result, ctx)
      result.diagnostics = vim.tbl_filter(not_line_length, result.diagnostics)
      vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
    end,
    ['textDocument/diagnostic'] = function(err, result, ctx)
      if result and result.items then
        result.items = vim.tbl_filter(not_line_length, result.items)
      end
      vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
    end,
  },
  on_attach = function(_, buf)
    vim.bo[buf].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end,
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

vim.lsp.config('sourcekit', {
  filetypes = { 'swift' },
})

vim.lsp.config('biome', {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
})

vim.lsp.config('rust_analyzer', {
  settings = { ['rust-analyzer'] = { check = { command = 'clippy' } } },
})

vim.lsp.enable({
  'bashls',
  'biome',
  'clangd',
  'emmylua_ls',
  'gopls',
  'jsonls',
  'pyrefly',
  'ruby_lsp',
  'ruff',
  'rumdl',
  'rust_analyzer',
  'sourcekit',
  'tombi',
  'tsc',
  'yamlls',
})

-- Diagnostics

vim.diagnostic.config({
  severity_sort = true,
  signs = false,
  float = { source = true },
})

vim.api.nvim_create_autocmd('CursorHold', {
  group = vim.api.nvim_create_augroup('diagnostic_float', { clear = true }),
  callback = function()
    vim.diagnostic.open_float({ focus = false })
  end,
})

-- Buffer-local mappings

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buf = buf, desc = desc })
    end

    map('gd', '<cmd>FzfLua lsp_definitions<cr>', 'Definitions')
    map('gri', '<cmd>FzfLua lsp_implementations<cr>', 'Implementations')
    map('grr', '<cmd>FzfLua lsp_references<cr>', 'References')
    map('grt', '<cmd>FzfLua lsp_typedefs<cr>', 'Type definitions')
    map('gO', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')
    map('<leader>ca', vim.lsp.buf.code_action, 'Action')
    map('<leader>co', '<cmd>FzfLua lsp_document_symbols<cr>', 'Outline')
    map('<leader>ss', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', 'Workspace symbols')
    map('<leader>th', function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
    end, 'Inlay hints')
  end,
})

-- Progress messages

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

-- Give emmylua_ls the Neovim runtime and every installed plugin. Disable
-- missing-fields: blink.cmp marks optional fields with a LuaLS-only idiom and
-- Neogit marks optional setup() fields as required.
vim.lsp.config('emmylua_ls', {
  settings = {
    emmylua = {
      runtime = { version = 'LuaJIT', requirePattern = { 'lua/?.lua', 'lua/?/init.lua' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
})

-- Without a project config, Pyrefly falls back to a preset that hides most
-- type errors. A pyrefly.toml or [tool.pyrefly] still takes precedence.
vim.lsp.config('pyrefly', {
  settings = { python = { pyrefly = { typeCheckingMode = 'default' } } },
})

---@param d lsp.Diagnostic
local function not_line_length(d)
  return d.code ~= 'MD013'
end

-- Let gq reflow Markdown paragraphs through rumdl's line-length rule instead
-- of the built-in formatter that options.lua sets. Disabling MD013 would also
-- disable the reflow, so drop only its diagnostics.
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

vim.lsp.enable({
  'bashls',
  'pyrefly',
  'ruff',
  'emmylua_ls',
  'rumdl',
  'jsonls',
  'yamlls',
  'tombi',
})

local severity = vim.diagnostic.severity
vim.diagnostic.config({
  severity_sort = true,
  -- Color the line number instead of using a sign, so the single sign
  -- column stays free for Git markers. The glyph comes from the statuscolumn
  -- in options.lua.
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
  -- The default status format uses the sign text, which is empty here.
  status = {
    -- vim.diagnostic.count() leaves out severities without diagnostics.
    ---@param counts table<vim.diagnostic.Severity, integer?>
    format = function(counts)
      local parts = {}
      for level, label in ipairs({ 'E', 'W', 'I', 'H' }) do
        if counts[level] then
          local hl = 'Diagnostic' .. ({ 'Error', 'Warn', 'Info', 'Hint' })[level]
          table.insert(parts, ('%%#%s#%s:%d%%*'):format(hl, label, counts[level]))
        end
      end
      return table.concat(parts, ' ')
    end,
  },
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
    map('<leader>co', '<cmd>FzfLua lsp_document_symbols<cr>', 'Code outline')
    map('<leader>ss', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', 'Workspace symbols')
    map('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
    end, 'Inlay hints')
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

-- Lazydev (Lua development)
require('lazydev').setup({
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
})

local constants = require('config.constants')
local server_names = {
  'bashls',
  'basedpyright',
  'cssls',
  'eslint',
  'html',
  'jsonls',
  'lua_ls',
  'marksman',
  'ruff',
  'tombi',
  'tinymist',
  'vtsls',
  'yamlls',
}

vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })

vim.lsp.config('bashls', {
  settings = { bashIde = { globPattern = '**/*@(.sh|.bash|.inc|.command)' } },
})
vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = { typeCheckingMode = 'standard' },
    },
  },
})

-- Keep Homebrew/PATH selection even when node_modules contains a server.
vim.lsp.config('cssls', { cmd = { 'vscode-css-language-server', '--stdio' } })
vim.lsp.config('html', { cmd = { 'vscode-html-language-server', '--stdio' } })
local eslint_before_init = vim.lsp.config.eslint.before_init
vim.lsp.config('eslint', {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  before_init = function(params, config)
    -- Upstream adds `yarn exec` for PnP; preserve PATH selection there too.
    local cmd = config.cmd
    eslint_before_init(params, config)
    config.cmd = cmd
  end,
  handlers = {
    ['eslint/noConfig'] = function()
      vim.notify('Unable to find ESLint configuration.', vim.log.levels.WARN)
      return {}
    end,
  },
  settings = { format = false, nodePath = vim.NIL, packageManager = 'npm' },
})
vim.lsp.config('jsonls', {
  cmd = { 'vscode-json-language-server', '--stdio' },
  settings = {
    json = { schemas = require('schemastore').json.schemas(), validate = { enable = true } },
  },
})
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      hover = { previewFields = 30 },
      runtime = { version = 'LuaJIT' },
      workspace = { checkThirdParty = false },
      diagnostics = { globals = { 'vim', 'MiniIcons', 'MiniStatusline' } },
    },
  },
})
vim.lsp.config('marksman', { filetypes = { 'markdown' } })
-- Retain the existing project marker coverage.
vim.lsp.config('tombi', { root_markers = { { '.tombi.toml', 'tombi.toml' }, '.git' } })
vim.lsp.config('tinymist', {
  root_markers = { 'typst.toml', '.git' },
  settings = { formatterMode = 'typstyle' },
})
local inlay_hints = {
  parameterNames = { enabled = 'all' },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
}
local vtsls_root_dir = vim.lsp.config.vtsls.root_dir
vim.lsp.config('vtsls', {
  root_dir = function(bufnr, on_dir)
    vtsls_root_dir(bufnr, function(root)
      -- Give both Deno config names equal priority when checking the selected root.
      local deno_root = vim.fs.root(bufnr, { { 'deno.json', 'deno.jsonc' } })
      if not deno_root or #deno_root < #root then
        on_dir(root)
      end
    end)
  end,
  settings = {
    typescript = { inlayHints = inlay_hints },
    javascript = { inlayHints = inlay_hints },
  },
})
vim.lsp.config('yamlls', {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
  settings = {
    yaml = {
      schemaStore = { enable = false, url = '' },
      schemas = require('schemastore').yaml.schemas(),
      validate = true,
    },
  },
})

if not vim.g.disable_auto_lsp then
  vim.lsp.enable(server_names)
end

-- LSP keymaps on attach
local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buf = event.buf, desc = desc })
    end

    map('n', 'gd', '<cmd>FzfLua lsp_definitions<cr>', 'go to definition')
    map('n', '<leader>cR', '<cmd>FzfLua lsp_references<cr>', 'references')
    map({ 'n', 'x' }, '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', 'code actions')
    map('n', '<leader>ss', '<cmd>FzfLua lsp_document_symbols<cr>', 'document symbols')

    map('n', '<leader>cr', vim.lsp.buf.rename, 'rename')
    map('n', '<leader>cS', vim.lsp.buf.signature_help, 'signature help')

    local client = vim.lsp.get_clients({ id = event.data.client_id })[1]

    -- Disable ruff hover (basedpyright provides richer type-aware hover)
    if client and client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end

    -- Document highlight on cursor hold
    if client and client:supports_method('textDocument/documentHighlight') then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buf = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buf = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
  callback = function(event)
    vim.lsp.util.buf_clear_references(event.buf)

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = event.buf })) do
      if client.id ~= event.data.client_id and client:supports_method('textDocument/documentHighlight') then
        return
      end
    end

    vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buf = event.buf })
  end,
})

-- Diagnostic configuration
local function centered_sign(symbol)
  return ' ' .. vim.trim(symbol)
end

vim.diagnostic.config({
  severity_sort = true,
  float = {
    border = constants.ui.border,
    source = true,
  },
  virtual_text = false,
  virtual_lines = {
    current_line = true,
    format = function(diagnostic)
      if diagnostic.source then
        return string.format('[%s] %s', diagnostic.source, diagnostic.message)
      end
      return diagnostic.message
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = centered_sign(constants.diagnostic_symbols.error),
      [vim.diagnostic.severity.WARN] = centered_sign(constants.diagnostic_symbols.warn),
      [vim.diagnostic.severity.INFO] = centered_sign(constants.diagnostic_symbols.info),
      [vim.diagnostic.severity.HINT] = centered_sign(constants.diagnostic_symbols.hint),
    },
  },
})

vim.keymap.set('n', '<leader>tL', function()
  local enabled = vim.g.disable_auto_lsp == true

  vim.g.disable_auto_lsp = not enabled
  vim.g.disable_auto_lint = not enabled

  if enabled then
    vim.diagnostic.enable(true)
    vim.lsp.enable(server_names, true)

    local ok, lint = pcall(require, 'lint')
    if ok then
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == '' then
          vim.api.nvim_buf_call(bufnr, function()
            lint.try_lint()
          end)
        end
      end
    end

    vim.notify('Global LSP & linter enabled', vim.log.levels.INFO)
  else
    vim.diagnostic.enable(false)
    vim.lsp.enable(server_names, false)
    vim.notify('Global LSP & linter disabled', vim.log.levels.INFO)
  end
end, { desc = 'global LSP & linter' })

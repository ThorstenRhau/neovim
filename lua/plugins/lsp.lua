-- Lazydev (Lua development)
require('lazydev').setup({
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
})

-- LSP configuration
local constants = require('config.constants')

local capabilities = require('blink.cmp').get_lsp_capabilities()

local function buffer_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return nil
  end
  return name
end

local function root_dir(markers, predicate)
  return function(bufnr, on_dir)
    local name = buffer_path(bufnr)
    if not name or (predicate and not predicate(name)) then
      return
    end

    local root = vim.fs.root(name, markers)
    if root then
      on_dir(root)
    end
  end
end

local function has_deno_config(path)
  return #vim.fs.find({ 'deno.json', 'deno.jsonc' }, { path = vim.fs.dirname(path), upward = true }) > 0
end

local js_workspace_markers = {
  { 'pnpm-workspace.yaml', 'lerna.json', 'turbo.json' },
  { 'yarn.lock', 'package-lock.json', 'npm-shrinkwrap.json', 'bun.lock', 'bun.lockb' },
  { 'tsconfig.json', 'jsconfig.json', 'package.json' },
  '.git',
}

local eslint_config_markers = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'eslint.config.js',
  'eslint.config.mjs',
  'eslint.config.cjs',
  'eslint.config.ts',
  'eslint.config.mts',
  'eslint.config.cts',
}

local function eslint_root_dir(bufnr, on_dir)
  local name = buffer_path(bufnr)
  if not name or has_deno_config(name) then
    return
  end

  local config = vim.fs.find(eslint_config_markers, { path = vim.fs.dirname(name), upward = true })[1]
  if not config then
    return
  end

  on_dir(vim.fs.root(config, js_workspace_markers) or vim.fs.dirname(config))
end

local function rust_root_dir(bufnr, on_dir)
  local name = buffer_path(bufnr)
  if not name then
    return
  end

  local cargo_toml = vim.fs.find('Cargo.toml', { path = vim.fs.dirname(name), upward = true })[1]
  if cargo_toml then
    local ok, result = pcall(function()
      return vim
        .system({ 'cargo', 'metadata', '--format-version=1', '--no-deps', '--manifest-path', cargo_toml }, {
          text = true,
          timeout = 1000,
        })
        :wait()
    end)
    if ok and result.code == 0 then
      local decoded_ok, metadata = pcall(vim.json.decode, result.stdout)
      if decoded_ok and metadata.workspace_root and vim.uv.fs_stat(metadata.workspace_root) then
        on_dir(metadata.workspace_root)
        return
      end
    end

    on_dir(vim.fs.dirname(cargo_toml))
    return
  end

  local root = vim.fs.root(name, { 'rust-project.json', '.git' })
  if root then
    on_dir(root)
  end
end

local function is_xcode_workspace(name)
  return name:match('%.xcodeproj$') ~= nil or name:match('%.xcworkspace$') ~= nil
end

local function sourcekit_root_dir(bufnr, on_dir)
  local name = buffer_path(bufnr)
  if not name then
    return
  end

  local root = vim.fs.root(name, {
    'buildServer.json',
    is_xcode_workspace,
    { 'Package.swift', 'compile_commands.json' },
    '.git',
  })
  if root then
    on_dir(root)
  end
end

-- Shared filetypes for JS/TS ecosystem
local js_ts_filetypes = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
}

-- Shared inlay hints settings for JS/TS
local js_ts_inlay_hints = {
  parameterNames = { enabled = 'all' },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
}

-- LSP server configurations
local servers = {
  bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' },
    root_markers = { '.git' },
    settings = {
      bashIde = {
        globPattern = '**/*@(.sh|.bash|.inc|.command)',
      },
    },
  },
  basedpyright = {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
      { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json' },
      '.git',
    },
    settings = {
      basedpyright = {
        disableOrganizeImports = true,
        analysis = {
          typeCheckingMode = 'standard',
        },
      },
    },
  },
  cssls = {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_markers = { 'package.json', '.git' },
    settings = {
      css = { validate = true },
      scss = { validate = true },
      less = { validate = true },
    },
  },
  eslint = {
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    filetypes = js_ts_filetypes,
    root_dir = eslint_root_dir,
    handlers = {
      ['eslint/openDoc'] = function(_, result)
        if result then
          vim.ui.open(result.url)
        end
        return {}
      end,
      ['eslint/probeFailed'] = function()
        vim.notify('ESLint probe failed.', vim.log.levels.WARN)
        return {}
      end,
      ['eslint/noLibrary'] = function()
        vim.notify('Unable to find ESLint library.', vim.log.levels.WARN)
        return {}
      end,
      ['eslint/noConfig'] = function()
        vim.notify('Unable to find ESLint configuration.', vim.log.levels.WARN)
        return {}
      end,
    },
    settings = {
      codeAction = {
        disableRuleComment = { enable = true, location = 'separateLine' },
        showDocumentation = { enable = true },
      },
      codeActionOnSave = { enable = false, mode = 'all' },
      experimental = {},
      format = false,
      nodePath = vim.NIL,
      onIgnoredFiles = 'off',
      packageManager = 'npm',
      problems = { shortenToSingleLine = false },
      quiet = false,
      rulesCustomizations = {},
      run = 'onType',
      validate = 'on',
    },
  },
  gopls = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { { 'go.work', 'go.mod' }, '.git' },
    settings = {
      gopls = {
        analyses = {
          nilness = true,
          shadow = true,
          unusedparams = true,
          unusedwrite = true,
        },
        semanticTokens = true,
      },
    },
  },
  html = {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    root_markers = { 'package.json', '.git' },
    init_options = {
      provideFormatter = true,
      embeddedLanguages = { css = true, javascript = true },
      configurationSection = { 'html', 'css', 'javascript' },
    },
  },
  jsonls = {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_markers = { '.git' },
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },
  lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
      { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
      '.git',
    },
    settings = {
      Lua = {
        hover = { previewFields = 30 },
        runtime = { version = 'LuaJIT' },
        workspace = { checkThirdParty = false },
        diagnostics = { globals = { 'vim', 'MiniIcons', 'MiniStatusline' } },
      },
    },
  },
  marksman = {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown' },
    root_markers = { '.marksman.toml', '.git' },
  },
  ruff = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  },
  rust_analyzer = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = rust_root_dir,
    workspace_required = true,
    settings = {
      ['rust-analyzer'] = {
        check = {
          command = 'check',
        },
      },
    },
  },
  sourcekit = {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift' },
    root_dir = sourcekit_root_dir,
  },
  tombi = {
    cmd = { 'tombi', 'lsp' },
    filetypes = { 'toml' },
    root_markers = { { '.tombi.toml', 'tombi.toml' }, '.git' },
  },
  tinymist = {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    root_markers = { 'typst.toml', '.git' },
    settings = {
      formatterMode = 'typstyle',
    },
  },
  vtsls = {
    cmd = { 'vtsls', '--stdio' },
    filetypes = js_ts_filetypes,
    root_dir = root_dir(js_workspace_markers, function(path)
      return not has_deno_config(path)
    end),
    init_options = { hostInfo = 'neovim' },
    settings = {
      typescript = { inlayHints = js_ts_inlay_hints },
      javascript = { inlayHints = js_ts_inlay_hints },
    },
  },
  yamlls = {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml' },
    root_markers = { '.git' },
    settings = {
      yaml = {
        -- disable built-in schemaStore to avoid double-loading with schemastore.nvim
        schemaStore = { enable = false, url = '' },
        schemas = require('schemastore').yaml.schemas(),
        validate = true,
      },
    },
  },
}

-- Shared capabilities for all servers
vim.lsp.config('*', {
  capabilities = capabilities,
})

-- Register all servers
local server_names = {}
for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  table.insert(server_names, name)
end

vim.g.managed_lsp_servers = server_names

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
    vim.lsp.buf.clear_references()

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

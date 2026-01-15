return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = {
      { '<leader>m', '<cmd>Mason<cr>', desc = 'mason' },
    },
    build = ':MasonUpdate',
    opts = {
      ui = {
        border = 'single',
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate', 'MasonToolsClean' },
    opts = {
      ensure_installed = {
        'basedpyright',
        'bash-language-server',
        'css-lsp',
        'eslint-lsp',
        'fish-lsp',
        'html-lsp',
        'json-lsp',
        'lua-language-server',
        'markdownlint',
        'marksman',
        'prettier',
        'ruff',
        'shellcheck',
        'shfmt',
        'stylua',
        'taplo',
        'tinymist',
        'vtsls',
        'yaml-language-server',
        'yamllint',
      },
      auto_update = false,
      run_on_start = false,
    },
  },
  {
    'b0o/schemastore.nvim',
    lazy = true,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',
      'b0o/schemastore.nvim',
    },
    config = function()
      local constants = require('config.constants')

      -- Get blink.cmp capabilities
      local has_blink, blink = pcall(require, 'blink.cmp')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- Shared filetypes for JS/TS ecosystem
      local js_ts_filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
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
          filetypes = { 'sh', 'bash' },
          root_markers = { '.git' },
        },
        basedpyright = {
          cmd = { 'basedpyright-langserver', '--stdio' },
          filetypes = { 'python' },
          root_markers = {
            'pyproject.toml',
            'setup.py',
            'setup.cfg',
            'requirements.txt',
            'Pipfile',
            'pyrightconfig.json',
            '.git',
          },
          settings = {
            basedpyright = { analysis = { typeCheckingMode = 'basic' } },
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
          root_markers = {
            '.eslintrc',
            '.eslintrc.js',
            '.eslintrc.cjs',
            '.eslintrc.yaml',
            '.eslintrc.yml',
            '.eslintrc.json',
            'eslint.config.js',
            'eslint.config.mjs',
            'eslint.config.cjs',
            'package.json',
          },
          settings = {
            codeAction = {
              disableRuleComment = { enable = true, location = 'separateLine' },
              showDocumentation = { enable = true },
            },
            codeActionOnSave = { enable = false, mode = 'all' },
            format = false,
            quiet = false,
            run = 'onType',
            validate = 'on',
          },
        },
        fish_lsp = {
          cmd = { 'fish-lsp', 'start' },
          filetypes = { 'fish' },
          root_markers = { '.git' },
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
            '.luarc.json',
            '.luarc.jsonc',
            '.luacheckrc',
            '.stylua.toml',
            'stylua.toml',
            'selene.toml',
            'selene.yml',
            '.git',
          },
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
              telemetry = { enable = false },
              diagnostics = { globals = { 'vim', 'MiniIcons', 'MiniStatusline' } },
            },
          },
        },
        marksman = {
          cmd = { 'marksman', 'server' },
          filetypes = { 'markdown', 'markdown.mdx' },
          root_markers = { '.marksman.toml', '.git' },
        },
        ruff = {
          cmd = { 'ruff', 'server' },
          filetypes = { 'python' },
          root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
        },
        taplo = {
          cmd = { 'taplo', 'lsp', 'stdio' },
          filetypes = { 'toml' },
          root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
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
          root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
          settings = {
            typescript = { inlayHints = js_ts_inlay_hints },
            javascript = { inlayHints = js_ts_inlay_hints },
          },
        },
        yamlls = {
          cmd = { 'yaml-language-server', '--stdio' },
          filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
          root_markers = { '.git' },
          settings = {
            yaml = {
              schemaStore = { enable = true },
              schemas = {
                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = 'docker-compose*.yml',
                ['kubernetes'] = '/*.k8s.yaml',
              },
              validate = true,
            },
          },
        },
      }

      -- Configure all servers with shared capabilities
      local server_names = {}
      for name, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config[name] = config
        table.insert(server_names, name)
      end

      vim.lsp.enable(server_names)

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
          end

          map('n', '<leader>cr', vim.lsp.buf.rename, 'rename')
          map('n', '<leader>cS', vim.lsp.buf.signature_help, 'signature help')
          map('i', '<C-k>', vim.lsp.buf.signature_help, 'signature help')

          -- Document highlight on cursor hold
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight') then
            local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = event2.buf })
              end,
            })
          end
        end,
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        severity_sort = true,
        float = {
          border = 'single',
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
            [vim.diagnostic.severity.ERROR] = constants.diagnostic_symbols.error,
            [vim.diagnostic.severity.WARN] = constants.diagnostic_symbols.warn,
            [vim.diagnostic.severity.INFO] = constants.diagnostic_symbols.info,
            [vim.diagnostic.severity.HINT] = constants.diagnostic_symbols.hint,
          },
        },
      })
    end,
  },
}

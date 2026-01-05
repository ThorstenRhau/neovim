return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    opts = {
      ui = {
        border = 'rounded',
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate', 'MasonToolsClean' },
    event = 'VeryLazy',
    opts = {
      ensure_installed = {
        -- LSP servers
        'lua-language-server',
        'basedpyright',
        'ruff',
        'yaml-language-server',
        'json-lsp',
        'bash-language-server',
        'marksman',
        'taplo',

        -- Formatters
        'stylua',
        'prettier',
        'shfmt',

        -- Linters
        'yamllint',
        'shellcheck',
        'markdownlint',
      },
      auto_update = false,
      run_on_start = true,
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
      -- Get blink.cmp capabilities
      local has_blink, blink = pcall(require, 'blink.cmp')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- Lua (Neovim development)
      vim.lsp.config.lua_ls = {
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
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      }

      -- Python: basedpyright for types
      vim.lsp.config.basedpyright = {
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
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = 'basic',
            },
          },
        },
      }

      -- Python: ruff for lint/format
      vim.lsp.config.ruff = {
        cmd = { 'ruff', 'server' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
        capabilities = capabilities,
      }

      -- YAML with schema support
      vim.lsp.config.yamlls = {
        cmd = { 'yaml-language-server', '--stdio' },
        filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
        root_markers = { '.git' },
        capabilities = capabilities,
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
      }

      -- JSON with schema support
      vim.lsp.config.jsonls = {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { '.git' },
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }

      -- Bash
      vim.lsp.config.bashls = {
        cmd = { 'bash-language-server', 'start' },
        filetypes = { 'sh', 'bash' },
        root_markers = { '.git' },
        capabilities = capabilities,
      }

      -- Markdown
      vim.lsp.config.marksman = {
        cmd = { 'marksman', 'server' },
        filetypes = { 'markdown', 'markdown.mdx' },
        root_markers = { '.marksman.toml', '.git' },
        capabilities = capabilities,
      }

      -- TOML
      vim.lsp.config.taplo = {
        cmd = { 'taplo', 'lsp', 'stdio' },
        filetypes = { 'toml' },
        root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
        capabilities = capabilities,
      }

      -- Enable all configured servers
      vim.lsp.enable({
        'lua_ls',
        'basedpyright',
        'ruff',
        'yamlls',
        'jsonls',
        'bashls',
        'marksman',
        'taplo',
      })

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
          end

          map('n', 'K', vim.lsp.buf.hover, 'Hover')
          map('n', '<leader>cr', vim.lsp.buf.rename, 'Rename')
          map('n', '<leader>cS', vim.lsp.buf.signature_help, 'Signature help')
          map('i', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')

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
          border = 'rounded',
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
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.INFO] = '󰋽',
            [vim.diagnostic.severity.HINT] = '󰌵',
          },
        },
      })
    end,
  },
}

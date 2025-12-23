---@module "lazy"
---@type LazySpec
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'b0o/schemastore.nvim',
    'saghen/blink.cmp',
  },
  ft = {
    'fish',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'python',
    'sh',
    'toml',
    'typescript',
    'xml',
    'yaml',
  },
  config = function()
    local schemastore = require('schemastore')

    -- Base capabilities from blink.cmp
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Global defaults for all LSP servers (Neovim 0.11+ API)
    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    -- Server-specific configs using vim.lsp.config() (replaces handlers)
    vim.lsp.config('jsonls', {
      settings = {
        json = {
          schemas = schemastore.json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config('yamlls', {
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = '',
          },
          schemas = schemastore.yaml.schemas(),
          validate = true,
          format = { enable = true },
        },
      },
    })

    -- LspAttach autocmd for buffer-local keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }
        local keymaps = {
          { 'n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action' },
          { 'n', '<leader>cr', vim.lsp.buf.rename, 'Rename Symbol' },
        }
        for _, map in ipairs(keymaps) do
          vim.keymap.set(map[1], map[2], map[3], vim.tbl_extend('force', opts, { desc = map[4] }))
        end

        -- Disable inlay hints by default (toggle with <leader>uh via snacks)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/inlayHint') then
          vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })
        end
      end,
    })

    -- Diagnostic configuration
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚',
          [vim.diagnostic.severity.WARN] = '󰀪',
          [vim.diagnostic.severity.INFO] = '󰋽',
          [vim.diagnostic.severity.HINT] = '󰌵',
        },
      },
      underline = {
        severity = vim.diagnostic.severity.WARN,
      },
      virtual_text = false,
      virtual_lines = {
        current_line = true,
        format = function(diagnostic)
          return string.format('[%s] %s', diagnostic.source, diagnostic.message)
        end,
      },
      float = false,
      update_in_insert = false,
      severity_sort = true,
    })
  end,
}

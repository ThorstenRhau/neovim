---@module "lazy"
---@type LazySpec
return {
  'stevearc/conform.nvim',
  ft = {
    'css',
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
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format({ async = true })
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  opts = {
    default_format_opts = {
      lsp_fallback = true,
    },
    formatters_by_ft = {
      css = { 'prettier' },
      html = { 'prettier' },
      javascript = { 'prettier' },
      json = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier' },
      python = { 'ruff_format' },
      sh = { 'shfmt' },
      toml = { 'taplo' },
      typescript = { 'prettier' },
      xml = { 'xmlformatter' },
      yaml = { 'yamlfmt' },
    },
    -- format_on_save = {
    --     lsp_fallback = true,
    --     timeout_ms = 5000,
    -- },
    format_on_save = false,
    notify_on_error = true,

  },
}

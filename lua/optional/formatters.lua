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
        vim.notify('Formatting ... ', vim.log.levels.INFO, { id = 'conform_format', timeout = false })
        require('conform').format({ async = true }, function(err)
          if err then
            vim.notify('Format failed: ' .. err, vim.log.levels.ERROR, { id = 'conform_format' })
          else
            vim.notify('Formatting done', vim.log.levels.INFO, { id = 'conform_format', timeout = 1500 })
          end
        end)
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
  },
  cmd = { 'ConformInfo' },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  opts = {
    default_format_opts = {
      lsp_format = 'fallback',
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
    format_on_save = false,
    notify_on_error = false,
  },
}

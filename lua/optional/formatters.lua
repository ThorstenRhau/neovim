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
        local ok, fidget = pcall(require, 'fidget')
        if not ok then
          return
        end
        fidget.notify('Formatting...', vim.log.levels.INFO, { group = 'format' })
        require('conform').format({ async = true }, function(err)
          if err then
            fidget.notify('Format failed: ' .. err, vim.log.levels.ERROR, { group = 'format' })
          else
            fidget.notify('Formatted', vim.log.levels.INFO, { group = 'format', ttl = 2 })
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
    notify_on_error = true,
  },
}

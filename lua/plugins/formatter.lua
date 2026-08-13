local map = vim.keymap.set

require('conform').setup({
  formatters_by_ft = {
    bash = { 'shfmt' },
    css = { 'biome' },
    go = { 'goimports', 'gofumpt' },
    html = { 'biome' },
    javascript = { 'biome' },
    javascriptreact = { 'biome' },
    json = { 'biome' },
    jsonc = { 'biome' },
    less = { 'prettier' },
    lua = { 'stylua' },
    markdown = { 'prettier' },
    python = { 'ruff_format' },
    rust = { 'rustfmt' },
    scss = { 'prettier' },
    sh = { 'shfmt' },
    toml = { 'taplo' },
    typescript = { 'biome' },
    typescriptreact = { 'biome' },
    yaml = { 'prettier' },
  },
  formatters = {
    biome = {
      append_args = { '--html-formatter-enabled=true' },
    },
    shfmt = {
      prepend_args = { '-i', '2', '-ci' },
    },
  },
})

map('n', '<leader>cf', function()
  require('conform').format({ async = true, lsp_format = 'fallback', quiet = true }, function(err)
    if err then
      local no_formatter = err == 'No formatters available for buffer'
      local message = no_formatter and 'No formatter available for this filetype' or err
      local level = no_formatter and vim.log.levels.WARN or vim.log.levels.ERROR
      vim.notify(message, level)
      return
    end

    vim.notify('File formatted', vim.log.levels.INFO)
  end)
end, { desc = 'format buffer' })

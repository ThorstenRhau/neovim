local map = vim.keymap.set

require('conform').setup({
  formatters_by_ft = {
    bash = { 'shfmt' },
    css = { 'biome' },
    html = { 'biome' },
    javascript = { 'biome' },
    javascriptreact = { 'biome' },
    json = { 'biome' },
    jsonc = { 'biome' },
    less = { 'prettier' },
    lua = { 'stylua' },
    markdown = { 'prettier' },
    python = { 'ruff_format' },
    scss = { 'prettier' },
    sh = { 'shfmt' },
    toml = { 'tombi' },
    typescript = { 'biome' },
    typescriptreact = { 'biome' },
    yaml = { 'prettier' },
  },
  formatters = {
    biome = {
      append_args = { '--html-formatter-enabled=true' },
    },
    stylua = {
      range_args = function(self, ctx)
        -- Include the complete final statement at the selection's byte boundary.
        ctx = vim.deepcopy(ctx)
        ctx.range['end'][2] = ctx.range['end'][2] + 1
        return require('conform.formatters.stylua').range_args(self, ctx)
      end,
    },
  },
})

local function format()
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
end

map('n', '<leader>cf', function()
  format()
end, { desc = 'format buffer' })

map('v', '<leader>cf', function()
  format()
end, { desc = 'format selection' })

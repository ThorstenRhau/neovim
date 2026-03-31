local map = vim.keymap.set

-- Conform
require('conform').setup({
  formatters_by_ft = {
    bash = { 'shfmt' },
    css = { 'prettier' },
    fish = { 'fish_indent' },
    html = { 'prettier' },
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    less = { 'prettier' },
    lua = { 'stylua' },
    markdown = { 'prettier' },
    python = { 'ruff_format' },
    scss = { 'prettier' },
    sh = { 'shfmt' },
    toml = { 'taplo' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    yaml = { 'prettier' },
  },
  formatters = {
    shfmt = {
      prepend_args = { '-i', '2', '-ci' },
    },
  },
})

map('n', '<leader>cf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' }, function(err)
    if not err then
      vim.notify('File formatted', vim.log.levels.INFO)
    else
      vim.notify('No formatter available for this filetype', vim.log.levels.WARN)
    end
  end)
end, { desc = 'format buffer' })

-- Nvim-lint
local lint = require('lint')

lint.linters_by_ft = {
  bash = { 'shellcheck' },
  lua = { 'selene' },
  markdown = { 'markdownlint' },
  yaml = { 'yamllint' },
}

-- Disable line-length rule
lint.linters.markdownlint.args = {
  '--disable',
  'MD013',
  '--',
}

-- Custom yamllint config
lint.linters.yamllint.args = {
  '-d',
  '{extends: default, rules: {line-length: {max: 120}}}',
  '-f',
  'parsable',
  '-',
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'BufEnter' }, {
  group = lint_augroup,
  callback = function()
    -- Don't lint if buffer is not a file
    if vim.bo.buftype ~= '' then
      return
    end

    if vim.g.disable_auto_lint then
      return
    end

    lint.try_lint()
  end,
})

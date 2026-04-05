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
    if vim.bo.buftype ~= '' then
      return
    end

    if vim.g.disable_auto_lint then
      return
    end

    lint.try_lint()
  end,
})

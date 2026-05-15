local lint = require('lint')

lint.linters_by_ft = {
  bash = { 'shellcheck' },
  go = { 'staticcheck' },
  lua = { 'selene' },
  markdown = { 'markdownlint' },
  yaml = { 'yamllint' },
}

local staticcheck = lint.linters.staticcheck
lint.linters.staticcheck = function()
  local linter = vim.deepcopy(staticcheck)
  linter.cwd = vim.fs.root(0, { 'go.work', 'go.mod', '.git' }) or vim.fn.getcwd()
  linter.append_fname = false
  linter.args = {
    '-f',
    'json',
    function()
      local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:h')
      local package = vim.fn.fnamemodify(dir, ':.')
      if package == '.' then
        return '.'
      end
      return './' .. package
    end,
  }
  return linter
end

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

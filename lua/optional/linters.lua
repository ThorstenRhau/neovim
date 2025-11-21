---@module "lazy"
---@type LazySpec
return {
  'mfussenegger/nvim-lint',
  ft = {
    'javascript',
    'json',
    'lua',
    'make',
    'python',
    'sh',
    'typescript',
    'yaml',
  },
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      json = { 'jsonlint' },
      lua = { 'selene' },
      make = { 'checkmake' },
      python = { 'ruff' },
      sh = { 'shellcheck' },
      typescript = { 'eslint_d' },
      yaml = { 'yamllint' },
    }

    local custom_config = vim.fn.getcwd() .. '/.nvim-lint.lua'
    if vim.fn.filereadable(custom_config) == 1 then
      dofile(custom_config)
    end

    local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost' }, {
      group = lint_augroup,
      callback = function(event)
        local bufnr = event.buf
        if vim.bo[bufnr].buftype ~= '' then
          return
        end
        local filetype = vim.bo[bufnr].filetype
        local ft_linters = lint.linters_by_ft[filetype]
        if not ft_linters or next(ft_linters) == nil then
          return
        end
        lint.try_lint(nil, { bufnr = bufnr })
      end,
    })

    vim.keymap.set('n', '<leader>cl', function()
      lint.try_lint(nil, { bufnr = vim.api.nvim_get_current_buf() })
    end, { desc = 'Trigger linting for current file' })
  end,
}

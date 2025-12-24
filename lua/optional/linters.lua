---@module "lazy"
---@type LazySpec
return {
  'mfussenegger/nvim-lint',
  ft = {
    'javascript',
    'json',
    'lua',
    'make',
    'markdown',
    'python',
    'typescript',
    'yaml',
  },
  keys = {
    {
      '<leader>cl',
      function()
        local lint = require('lint')
        local ft = vim.bo.filetype
        local linters = lint.linters_by_ft[ft]

        if linters and #linters > 0 then
          vim.notify('Linting with: ' .. table.concat(linters, ', '), vim.log.levels.INFO)
        end
        lint.try_lint()
      end,
      desc = 'Lint current file',
    },
  },
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      json = { 'jsonlint' },
      lua = { 'selene' },
      make = { 'checkmake' },
      markdown = { 'markdownlint' },
      python = { 'ruff' },
      typescript = { 'eslint_d' },
      yaml = { 'yamllint' },
    }

    local custom_config = vim.fn.getcwd() .. '/.nvim-lint.lua'
    if vim.fn.filereadable(custom_config) == 1 then
      local ok, err = pcall(dofile, custom_config)
      if not ok then
        vim.notify('Failed to load .nvim-lint.lua: ' .. tostring(err), vim.log.levels.WARN)
      end
    end

    vim.api.nvim_create_autocmd('BufWritePost', {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}

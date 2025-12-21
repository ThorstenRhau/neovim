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
    'sh',
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
        lint.try_lint(nil, { bufnr = vim.api.nvim_get_current_buf() })
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
      -- sh = { 'shellcheck' }, -- Duplicate: bashls (LSP) already runs shellcheck
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

    local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost' }, {
      group = lint_augroup,
      callback = function(event)
        local bufnr = event.buf
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
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
  end,
}

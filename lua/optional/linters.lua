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

    -- SECURITY: Trusted project allowlist for custom lint configs
    local trusted_projects = {
      -- Add your trusted paths here:
      -- vim.fn.expand('~/code/'),
      -- vim.fn.expand('~/work/trusted-project'),
    }

    local function is_trusted_project(dir)
      for _, trusted in ipairs(trusted_projects) do
        if vim.startswith(dir, vim.fn.expand(trusted)) then
          return true
        end
      end
      return false
    end

    local cwd = vim.fn.getcwd()
    local custom_config = cwd .. '/.nvim-lint.lua'

    if vim.fn.filereadable(custom_config) == 1 then
      if is_trusted_project(cwd) then
        local ok, err = pcall(dofile, custom_config)
        if not ok then
          vim.notify('Failed to load .nvim-lint.lua: ' .. tostring(err), vim.log.levels.WARN)
        end
      else
        vim.notify('Blocked untrusted .nvim-lint.lua in: ' .. cwd, vim.log.levels.WARN)
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

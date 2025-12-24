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

    local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

    -- Per-buffer debounce timers to prevent spawning too many linter processes
    local debounce_timers = {}
    local debounce_ms = 500

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

        -- Cancel pending lint for this buffer and schedule a new one
        if debounce_timers[bufnr] then
          debounce_timers[bufnr]:stop()
        end
        debounce_timers[bufnr] = vim.defer_fn(function()
          debounce_timers[bufnr] = nil
          if vim.api.nvim_buf_is_valid(bufnr) then
            lint.try_lint(nil, { bufnr = bufnr })
          end
        end, debounce_ms)
      end,
    })

    -- Clean up timers when buffers are deleted
    vim.api.nvim_create_autocmd('BufDelete', {
      group = lint_augroup,
      callback = function(event)
        local timer = debounce_timers[event.buf]
        if timer then
          timer:stop()
          debounce_timers[event.buf] = nil
        end
      end,
    })
  end,
}

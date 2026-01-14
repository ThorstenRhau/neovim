return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' }, function(err)
            if not err then
              vim.notify('File formatted', vim.log.levels.INFO)
            else
              -- Fallback to Vim's native = formatting
              local pos = vim.api.nvim_win_get_cursor(0)
              vim.cmd('silent! normal! gg=G')
              vim.api.nvim_win_set_cursor(0, pos)
              vim.notify('Formatted with native Vim =', vim.log.levels.INFO)
            end
          end)
        end,
        desc = 'format buffer',
      },
    },
    opts = {
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
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')

      lint.linters_by_ft = {
        bash = { 'shellcheck' },
        lua = { 'selene' },
        markdown = { 'markdownlint' },
        yaml = { 'yamllint' },
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
    end,
  },
}

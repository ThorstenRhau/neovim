return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format({ async = true, lsp_fallback = true })
        end,
        desc = 'Format buffer',
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
        yaml = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        markdown = { 'prettier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        fish = { 'fish_indent' },
        toml = { 'taplo' },
        terraform = { 'terraform_fmt' },
        tf = { 'terraform_fmt' },
        ['terraform-vars'] = { 'terraform_fmt' },
        xml = { 'xmlformat' },
        ['_'] = { 'trim_whitespace' },
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
        yaml = { 'yamllint' },
        dockerfile = { 'hadolint' },
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
        markdown = { 'markdownlint' },
        terraform = { 'tflint' },
        tf = { 'tflint' },
        ansible = { 'ansible_lint' },
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
          local ctx = { filename = vim.api.nvim_buf_get_name(0) }
          ctx.dirname = vim.fn.fnamemodify(ctx.filename, ':h')

          -- Don't lint if buffer is not a file
          if vim.bo.buftype ~= '' then
            return
          end

          lint.try_lint()
        end,
      })
    end,
  },
}

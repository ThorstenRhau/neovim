return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
      delay = 200,
      spec = {
        { '<leader>a', group = 'claude' },
        { '<leader>b', group = 'buffer' },
        { '<leader>c', group = 'code' },
        { '<leader>f', group = 'file/find' },
        { '<leader>g', group = 'git' },
        { '<leader>h', group = 'hunk' },
        { '<leader>o', group = 'opencode' },
        { '<leader>q', group = 'project/session' },
        { '<leader>s', group = 'search' },
        { '<leader>t', group = 'toggle' },
        { '<leader>w', group = 'window' },
        { '<leader>x', group = 'diagnostics' },
        { 'g', group = 'goto' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
      },
      icons = {
        mappings = false,
      },
    },
  },
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {
      focus = true,
      auto_close = true,
    },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'diagnostics' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'buffer diagnostics' },
      { '<leader>xs', '<cmd>Trouble symbols toggle<cr>', desc = 'symbols' },
      { '<leader>xl', '<cmd>Trouble lsp toggle<cr>', desc = 'lsp references' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'location list' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'quickfix list' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            ---@diagnostic disable-next-line: missing-fields, missing-parameter
            require('trouble').prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'previous trouble/quickfix item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            ---@diagnostic disable-next-line: missing-fields, missing-parameter
            require('trouble').next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'next trouble/quickfix item',
      },
    },
  },
  {
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>tS', '<cmd>SmearCursorToggle<cr>', desc = 'cursor smear' },
    },
    opts = {
      smear_insert_mode = false,
      legacy_computing_symbols_support = true,
    },
  },
  {
    'karb94/neoscroll.nvim',
    event = 'VeryLazy',
    opts = {
      easing = 'sine',
    },
  },
}

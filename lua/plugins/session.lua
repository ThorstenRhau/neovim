return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    keys = {
      {
        '<leader>S',
        function()
          require('persistence').load()
        end,
        desc = 'previous session',
      },
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = 'previous session',
      },
      {
        '<leader>qS',
        function()
          require('persistence').select()
        end,
        desc = 'select session',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load({ last = true })
        end,
        desc = 'restore last session',
      },
      {
        '<leader>qd',
        function()
          require('persistence').stop()
        end,
        desc = 'stop session tracking',
      },
    },
    opts = {},
  },
}

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
        desc = 'Restore session',
      },
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = 'Restore session',
      },
      {
        '<leader>qS',
        function()
          require('persistence').select()
        end,
        desc = 'Select session',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load({ last = true })
        end,
        desc = 'Restore last session',
      },
      {
        '<leader>qd',
        function()
          require('persistence').stop()
        end,
        desc = 'Stop session tracking',
      },
    },
    opts = {},
  },
}

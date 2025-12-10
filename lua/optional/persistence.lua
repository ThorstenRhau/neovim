---@module "lazy"
---@type LazySpec
return {
  'folke/persistence.nvim',
  -- Only load session management when first needed
  event = 'BufReadPost',
  opts = {
    dir = vim.fn.stdpath('state') .. '/sessions/',
    options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
    autosave = true,
    autosave_events = { 'BufWritePost', 'VimLeavePre' },
  },
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'Restore Session',
    },
    {
      '<leader>ql',
      function()
        require('persistence').load({ last = true })
      end,
      desc = 'Restore Last Session',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = "Don't Save Current Session",
    },
  },
}

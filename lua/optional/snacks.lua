---@module "lazy"
---@type LazySpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,

  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    animate = { enabled = false },
    bigfile = {
      size = 1 * 1024 * 1024,
      notify = true,
    },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    git = { enabled = false },
    gitbrowse = { enabled = false },
    indent = { enabled = false },
    input = { enabled = true },
    image = { enabled = false },
    notifier = {
      enabled = false, -- Disabled: using noice.nvim instead
    },
    picker = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scratch = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    terminal = { enabled = true },
    dim = { enabled = true },
    toggle = { enabled = true },
    words = {
      modes = { 'n' },
    },
  },

  keys = {
    -- stylua: ignore start
    { "<leader>z", function() require("snacks").zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z", function() require("snacks").zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>bd", function() require("snacks").bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() require("snacks").rename.rename_file() end, desc = "Rename File" },
    { "<leader>t",      function() require("snacks").terminal() end, desc = "Toggle Terminal" },
    -- stylua: ignore end
  },

  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      once = true,
      callback = function()
        local Snacks = require('snacks')

        Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
        Snacks.toggle.diagnostics():map('<leader>ud')
        Snacks.toggle.line_number():map('<leader>ul')
        Snacks.toggle
          .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map('<leader>uc')
        Snacks.toggle.treesitter():map('<leader>uT')
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
        Snacks.toggle.inlay_hints():map('<leader>uh')
        Snacks.toggle.dim():map('<leader>uD')
      end,
    })
  end,
}

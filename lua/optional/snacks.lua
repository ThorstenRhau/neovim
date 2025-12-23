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
      enabled = true,
      size = 1 * 1024 * 1024,
      notify = true,
    },
    dashboard = { enabled = false },
    dim = { enabled = false },
    explorer = { enabled = false },
    gh = { enabled = false },
    gitbrowse = { enabled = false },
    image = { enabled = false },
    indent = { enabled = false },
    input = { enabled = true },
    layout = { enabled = false },
    lazygit = { enabled = false },
    notifier = { enabled = false },
    picker = { enabled = false },
    profiler = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scratch = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    terminal = { enabled = false },
    toggle = { enabled = true },
    win = { enabled = false },
    words = { enabled = false },
    zen = { enabled = false },
  },

  keys = {},

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
      end,
    })
  end,
}

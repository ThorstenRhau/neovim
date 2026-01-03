---@module "lazy"
---@type LazySpec
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>ug',
      function()
        local ibl = require('ibl')
        local config = require('ibl.config').get_config(0)
        ibl.setup_buffer(0, { enabled = not config.enabled })
      end,
      desc = 'Toggle Indent Guides',
    },
  },
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    debounce = 100,
    scope = {
      enabled = true,
      show_start = true,
      show_end = true,
    },
    indent = {
      char = '│',
    },
    exclude = {
      filetypes = {
        'help',
        'lazy',
        'mason',
        'neo-tree',
        'oil',
        'snacks_dashboard',
        'snacks_notif',
        'snacks_win',
        'toggleterm',
        'Trouble',
        'trouble',
      },
      buftypes = {
        'terminal',
        'nofile',
        'prompt',
      },
    },
  },
}

---@module "lazy"
---@type LazySpec
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    {
      'rcarriga/nvim-notify',
      opts = {
        stages = 'static',
        timeout = 3000,
        render = 'compact',
        fps = 60,
        top_down = false,
      },
    },
  },

  ---@module "noice"
  ---@type NoiceConfig
  opts = {
    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
    },
    lsp = {
      hover = { enabled = false },
      signature = { enabled = false },
      progress = {
        enabled = true,
        view = 'notify',
      },
    },
    messages = {
      enabled = true,
      view = 'notify',
      view_error = 'notify',
      view_warn = 'notify',
      view_history = 'messages',
      view_search = 'virtualtext',
    },
    notify = {
      enabled = true,
      view = 'notify',
    },
    popupmenu = { enabled = true, kind_icons = {} },
    presets = {
      long_message_to_split = true,
    },
    views = {
      notify = {
        replace = true,
        merge = true,
      },
      cmdline_popup = {
        position = {
          row = '75%',
          col = '50%',
        },
      },
    },
  },

  keys = {
    { '<leader>n', '<cmd>Noice all<cr>', desc = 'Notification History' },
    { '<leader>E', '<cmd>Noice errors<cr>', desc = 'Errors' },
    { '<leader>un', '<cmd>Noice dismiss<cr>', desc = 'Dismiss All Notifications' },
  },
}

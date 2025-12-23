---@module "lazy"
---@type LazySpec
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },

  ---@module "noice"
  ---@type NoiceConfig
  opts = {
    cmdline = {
      enabled = true,
      view = 'cmdline', -- Classic bottom cmdline
    },
    messages = {
      enabled = true,
      view = 'mini', -- Compact notifications
    },
    popupmenu = {
      enabled = true,
      backend = 'nui',
    },
    lsp = {
      -- Disable hover/signature to avoid overlap with native K
      hover = { enabled = false },
      signature = { enabled = false },
      progress = {
        enabled = true,
        view = 'mini',
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
    },
    presets = {
      bottom_search = true, -- Classic bottom search
      long_message_to_split = true, -- Long messages go to split
    },
    views = {
      mini = {
        timeout = 5000,
        position = {
          row = -2,
          col = '100%',
        },
        win_options = {
          wrap = true,
        },
      },
    },
  },

  keys = {
    { '<leader>n', '<cmd>Noice all<cr>', desc = 'Notification History' },
    { '<leader>un', '<cmd>Noice dismiss<cr>', desc = 'Dismiss All Notifications' },
  },
}

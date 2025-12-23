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
      view = 'cmdline_popup',
    },
    messages = {
      enabled = true,
      view = 'mini',
      view_error = 'mini',
      view_warn = 'mini',
      view_history = 'messages',
      view_search = 'virtualtext',
      opts = {},
    },
    notify = {
      enabled = true,
      view = 'mini',
    },
    popupmenu = {
      enabled = true,
      backend = 'nui',
    },
    lsp = {
      hover = { enabled = false },
      signature = { enabled = false },
      progress = {
        enabled = true,
        format = 'lsp_progress',
        format_done = 'lsp_progress_done',
        view = 'mini',
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
    },
    presets = {
      long_message_to_split = true,
    },
    views = {
      mini = {
        timeout = 5000,
        position = {
          row = 0,
          col = '100%',
        },
        win_options = {
          wrap = true,
        },
      },
    },
  },

  keys = {
    { '<leader>n', '<cmd>Noice fzf<cr>', desc = 'Notification History' },
    { '<leader>un', '<cmd>Noice dismiss<cr>', desc = 'Dismiss All Notifications' },
  },
}

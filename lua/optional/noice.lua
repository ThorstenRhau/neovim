---@module "lazy"
---@type LazySpec
return {
  'folke/noice.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  lazy = false,
  priority = 1000,

  ---@module 'noice'
  ---@type NoiceConfig
  opts = {
    presets = {
      bottom_search = true,
      command_palette = false,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    cmdline = {
      view = 'cmdline_popup',
    },
    views = {
      cmdline_popup = {
        position = {
          row = '20%',
          col = '50%',
        },
      },
    },
    lsp = {
      progress = {
        enabled = true,
        format = 'lsp_progress',
        format_done = 'lsp_progress_done',
        throttle = 1000 / 30, -- frequency to update lsp progress message
        view = 'mini',
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
      hover = {
        enabled = true,
      },
      signature = {
        enabled = false,
      },
    },
    notify = {
      enabled = true,
      view = 'notify',
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'written',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          find = 'blink.cmp',
        },
        opts = { skip = true },
      },
    },
  },
}

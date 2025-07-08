---@module "lazy"
---@type LazySpec
return {
  'folke/noice.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  event = 'VeryLazy',
  opts = {
    presets = {
      bottom_search = true,
      command_palette = false,
      long_message_to_split = true,
      inc_rename = true,
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
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      hover = {
        enabled = true,
      },
      signature = {
        enabled = true,
      },
    },
    notify = {
      enabled = true,
      view = 'notify',
    },
  },
}

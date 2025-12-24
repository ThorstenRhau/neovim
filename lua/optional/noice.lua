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
        stages = 'fade',
        timeout = 3000,
        render = 'wrapped-compact',
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
        format = 'lsp_progress',
        format_done = 'lsp_progress_done',
        view = 'mini',
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
    },
  },

  keys = {
    { '<leader>n', '<cmd>Noice all<cr>', desc = 'Notification History' },
    { '<leader>un', '<cmd>NotificationsClear<cr>', desc = 'Dismiss All Notifications' },
  },
}

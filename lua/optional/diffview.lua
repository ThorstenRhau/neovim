---@module "lazy"
---@type LazySpec
return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'DiffView Open' },
    { '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', desc = 'DiffView File History' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'DiffView Close' },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = {
        winbar_info = true,
      },
      file_history = {
        winbar_info = true,
      },
    },
    hooks = {
      diff_buf_read = function()
        vim.opt_local.wrap = false
      end,
    },
  },
}

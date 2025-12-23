---@module "lazy"
---@type LazySpec
return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'DiffView Open' },
    { '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', mode = { 'n', 'v' }, desc = 'DiffView File History' },
    { '<leader>gL', '<cmd>DiffviewFileHistory<cr>', desc = 'DiffView Project History' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'DiffView Close' },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = {
        winbar_info = true,
      },
      merge_tool = {
        winbar_info = true,
      },
      file_history = {
        winbar_info = true,
      },
    },
    hooks = {
      diff_buf_read = function(bufnr)
        vim.opt_local.wrap = false
        vim.opt_local.list = false
      end,
    },
  },
}

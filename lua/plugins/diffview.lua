local actions = require('diffview.actions')

require('diffview').setup({
  enhanced_diff_hl = true,
  view = {
    default = { winbar_info = true },
    merge_tool = { layout = 'diff3_mixed' },
    file_history = { winbar_info = true },
  },
  hooks = {
    diff_buf_read = function(_)
      vim.opt_local.wrap = false
      vim.opt_local.list = false
      vim.opt_local.colorcolumn = ''
    end,
  },
  keymaps = {
    view = {
      { 'n', 'q', actions.close, { desc = 'close diffview' } },
    },
    file_panel = {
      { 'n', 'q', actions.close, { desc = 'close diffview' } },
    },
    file_history_panel = {
      { 'n', 'q', actions.close, { desc = 'close diffview' } },
    },
  },
})

local map = vim.keymap.set

require('diffview').setup({
  enhanced_diff_hl = true,
  use_icons = true,
  default_args = {
    DiffviewOpen = { '--untracked-files=no' },
  },
  view = {
    merge_tool = {
      layout = 'diff3_mixed',
    },
  },
})

map('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'diffview' })
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'file history' })
map('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'branch history' })
map('n', '<leader>gq', '<cmd>DiffviewClose<cr>', { desc = 'diffview close' })

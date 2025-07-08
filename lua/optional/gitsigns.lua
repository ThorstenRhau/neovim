---@module "lazy"
---@type LazySpec
return {
  'lewis6991/gitsigns.nvim',
  -- Delay git integration until files are opened
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = { 'Gitsigns' },
  keys = {
    { '<leader>gB', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'Toggle current line blame' },
    { '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', desc = 'Preview hunk' },
    { '<leader>gh', '<cmd>Gitsigns toggle_linehl<cr>', desc = 'Toggle line highlight' },
  },
  opts = {
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    signs_staged = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      follow_files = true,
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'right_align',
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
  },
}

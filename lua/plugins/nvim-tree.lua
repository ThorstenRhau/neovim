local map = vim.keymap.set

require('nvim-tree').setup({
  hijack_directories = {
    enable = false,
  },
  update_focused_file = {
    enable = true,
  },
  view = {
    side = 'right',
    width = 25,
  },
  renderer = {
    group_empty = true,
    highlight_git = 'name',
    highlight_opened_files = 'name',
    highlight_diagnostics = 'name',
    highlight_modified = 'name',
    indent_markers = {
      enable = false,
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  modified = {
    enable = true,
  },
  filters = {
    custom = { '^.git$' },
  },
})

map('n', '<leader>tr', '<cmd>NvimTreeToggle<cr>', { desc = 'file tree' })

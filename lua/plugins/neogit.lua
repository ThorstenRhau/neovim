local map = vim.keymap.set

require('neogit').setup({
  disable_insert_on_commit = true,
  graph_style = 'kitty',
  process_spinner = true,
  integrations = {
    diffview = true,
    fzf_lua = true,
  },
  signs = {
    hunk = { '', '' },
    item = { '▸', '▾' },
    section = { '▸', '▾' },
  },
})

map('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'neogit' })

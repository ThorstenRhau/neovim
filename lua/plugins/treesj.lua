local map = vim.keymap.set

require('treesj').setup({
  use_default_keymaps = false,
  max_join_length = 120,
})

map('n', '<leader>cj', require('treesj').toggle, { desc = 'split/join' })
map('n', '<leader>cJ', function()
  require('treesj').toggle({ split = { recursive = true } })
end, { desc = 'split/join (recursive)' })

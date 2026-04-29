local neogit = require('neogit')
local map = vim.keymap.set

neogit.setup({
  graph_style = 'kitty',
  integrations = {
    fzf_lua = true,
    diffview = false,
  },
  kind = 'tab',
  signs = {
    hunk = { '', '' },
    item = { '', '' },
    section = { '', '' },
  },
  highlight = {
    italic = true,
    bold = true,
    underline = true,
  },
  commit_editor = {
    kind = 'tab',
    show_staged_diff = true,
    staged_diff_split_kind = 'auto',
    spell_check = true,
  },
  disable_insert_on_commit = true,
  commit_view = {
    kind = 'vsplit',
    verify_commit = true,
  },
  popup = {
    kind = 'split',
  },
  sections = {
    recent = { folded = false, hidden = false },
  },
})

map('n', '<leader>gg', function()
  neogit.open()
end, { desc = 'neogit status' })
map('n', '<leader>gP', function()
  neogit.open({ 'push' })
end, { desc = 'git push' })
map('n', '<leader>gp', function()
  neogit.open({ 'pull' })
end, { desc = 'git pull' })
map('n', '<leader>gf', function()
  neogit.open({ 'fetch' })
end, { desc = 'git fetch' })
map('n', '<leader>gl', function()
  neogit.open({ 'log' })
end, { desc = 'git log' })

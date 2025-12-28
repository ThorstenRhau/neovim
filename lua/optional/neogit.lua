---@module "lazy"
---@type LazySpec
return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
  },
  cmd = { 'Neogit', 'NeogitResetState' },
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit' },
    { '<leader>gC', '<cmd>Neogit commit<cr>', desc = 'Neogit Commit' },
  },

  ---@module 'neogit'
  ---@type NeogitConfig
  opts = {
    disable_insert_on_commit = true,
    graph_style = 'kitty',
    process_spinner = false,
    integrations = {
      diffview = true,
    },
  },
}

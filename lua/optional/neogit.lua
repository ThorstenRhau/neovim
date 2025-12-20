---@module "lazy"
---@type LazySpec
return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'NeoGit' },
  },

  ---@module 'neogit'
  ---@type NeogitConfig
  opts = {
    disable_insert_on_commit = true,
    graph_style = 'kitty',
    process_spinner = false,
  },
}

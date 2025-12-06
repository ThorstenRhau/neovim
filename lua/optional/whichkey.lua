---@module "lazy"
---@type LazySpec
return {
  'folke/which-key.nvim',
  dependencies = { 'echasnovski/mini.icons' },
  opts = {
    preset = 'modern',
    delay = 300,
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
    '<leader>',
  },
  config = function(_, opts)
    require('which-key').setup(opts)
    require('config.whichkey')
  end,
}

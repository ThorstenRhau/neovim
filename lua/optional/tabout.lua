---@module "lazy"
---@type LazySpec
return {
  {
    'abecodes/tabout.nvim',
    event = 'InsertEnter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      tabkey = '<Tab>',
      backwards_tabkey = '<S-Tab>',
      act_as_tab = true,
      act_as_shift_tab = false,
      default_tab = '<C-t>',
      default_shift_tab = '<C-d>',
      enable_backwards = true,
      completion = false,
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = '`', close = '`' },
        { open = '(', close = ')' },
        { open = '[', close = ']' },
        { open = '{', close = '}' },
      },
      ignore_beginning = true,
      exclude = {},
    },
    config = function(_, opts)
      require('tabout').setup(opts)
    end,
  },
}

---@module "lazy"
---@type LazySpec
return {
  'andymass/vim-matchup',
  event = 'VeryLazy',
  init = function()
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_deferred_show_delay = 300
    vim.g.matchup_matchparen_deferred_hide_delay = 500
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
  end,
  keys = {
    {
      '<C-k>',
      '<cmd>MatchupWhereAmI?<cr>',
      desc = 'Show match context',
    },
  },
}

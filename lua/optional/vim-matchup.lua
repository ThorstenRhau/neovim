---@module "lazy"
---@type LazySpec
return {
  'andymass/vim-matchup',
  event = { 'BufReadPost', 'BufNewFile' },
  init = function()
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_deferred_show_delay = 100
    vim.g.matchup_matchparen_deferred_hide_delay = 100
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

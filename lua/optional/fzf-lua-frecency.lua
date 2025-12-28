---@module "lazy"
---@type LazySpec
return {
  'elanmed/fzf-lua-frecency.nvim',
  opts = {
    cwd_only = false,
    db_dir = vim.fn.stdpath('data') .. '/fzf-lua-frecency',
    display_score = false,
    stat_file = true,
  },
  keys = {
    {
      '<leader>fe',
      function()
        require('fzf-lua-frecency').frecency({ all_files = true })
      end,
      desc = 'Frecent Files',
    },
    {
      '<leader>fX',
      function()
        require('fzf-lua-frecency').clear_db({
          db_dir = vim.fn.stdpath('data') .. '/fzf-lua-frecency',
        })
      end,
      desc = 'Clear Frecency DB',
    },
  },
}

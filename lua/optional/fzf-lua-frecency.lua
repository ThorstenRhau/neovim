---@module "lazy"
---@type LazySpec
return {
  'elanmed/fzf-lua-frecency.nvim',
  opts = {
    cwd_only = false,
    db_dir = vim.fn.stdpath('data') .. '/fzf-lua-frecency',
    display_score = true,
    stat_file = true,
  },
  keys = {
    {
      '<leader><leader>',
      '<cmd>FzfLua combine pickers=buffers;files<cr>',
      desc = 'Buffers & Files',
    },
    {
      '<leader>fe',
      '<cmd>FzfLua global<cr>',
      desc = 'FzfLua Global',
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

---@module "lazy"
---@type LazySpec
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = 'ToggleTerm',
  keys = {
    { '<leader>t', '<cmd>ToggleTerm<cr>', desc = 'Terminal' },
  },
  opts = {},
}

---@module "lazy"
---@type LazySpec
return {
  'sphamba/smear-cursor.nvim',
  event = 'VeryLazy',
  keys = {
    { '<leader>us', '<cmd>SmearCursorToggle<cr>', desc = 'Smear Cursor Toggle' },
  },
  opts = {
    legacy_computing_symbols_support = true,
  },
}

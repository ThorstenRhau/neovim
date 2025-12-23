---@module "lazy"
---@type LazySpec
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'echasnovski/mini.icons' },
  },
  opts = {},
}

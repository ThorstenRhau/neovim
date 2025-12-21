---@module "lazy"
---@type LazySpec
return {
  'OXY2DEV/markview.nvim',
  event = 'VeryLazy',
  ft = { 'markdown', 'typst' },
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter' },
    { 'echasnovski/mini.icons' },
  },
  opts = {
    preview = {
      filetypes = { 'markdown', 'typst' },
      ignore_buftypes = {},
      icon_provider = 'mini',
    },
  },
}

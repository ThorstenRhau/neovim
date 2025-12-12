---@module "lazy"
---@type LazySpec
return {
  'OXY2DEV/markview.nvim',
  ft = 'markdown',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter' },
    { 'echasnovski/mini.icons' },
  },
  opts = {
    preview = {
      filetypes = { 'markdown', 'codecompanion' },
      ignore_buftypes = {},
      icon_provider = nil,
    },
  },
}

---@module "lazy"
---@type LazySpec
return {
  'OXY2DEV/markview.nvim',
  ft = 'markdown',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter', ft = 'markdown' },
    { 'echasnovski/mini.icons', lazy = true },
  },
  opts = {
    preview = {
      filetypes = { 'markdown', 'codecompanion' },
      ignore_buftypes = {},
      icon_provider = nil, -- use global mini.icons setting
    },
  },
}

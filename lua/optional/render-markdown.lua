---@module "lazy"
---@type LazySpec
return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = 'markdown',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    {
      '<leader>um',
      function()
        require('render-markdown').toggle()
      end,
      desc = 'Toggle Markdown Rendering',
    },
  },
  opts = {
    enabled = false,
    latex = { enabled = false },
  },
}

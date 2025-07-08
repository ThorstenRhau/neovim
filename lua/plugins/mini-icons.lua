---@module "lazy"
---@type LazySpec
return {
  'echasnovski/mini.icons',
  event = 'VeryLazy',
  version = false,
  opts = {},
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', optional = true, enabled = false },
  },
  init = function()
    package.preload['nvim-web-devicons'] = function()
      require('mini.icons').mock_nvim_web_devicons()
      return package.loaded['nvim-web-devicons']
    end
  end,
}

---@module "lazy"
---@type LazySpec
return {
  'echasnovski/mini.icons',
  lazy = false,
  version = false,
  opts = {},
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', optional = true, enabled = false },
  },
  init = function()
    package.preload['nvim-web-devicons'] = function()
      local ok, icons = pcall(require, 'mini.icons')
      if ok then
        icons.mock_nvim_web_devicons()
      end
      return package.loaded['nvim-web-devicons']
    end
  end,
}

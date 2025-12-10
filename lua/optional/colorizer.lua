---@module "lazy"
---@type LazySpec
return {
  'NvChad/nvim-colorizer.lua',
  cmd = { 'ColorizerToggle' },
  opts = {
    user_default_options = {
      always_update = false,
    },
  },
}

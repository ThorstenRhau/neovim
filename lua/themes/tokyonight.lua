-- Function to determine the preferred theme based on vim.o.background
local function getPreferredStyle()
  return vim.o.background == 'light' and 'day' or 'night'
end

local preferred_style = getPreferredStyle()

---@module "lazy"
---@type LazySpec
return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1100,
  ---@module 'tokyonight'
  ---@type tokyonight.Config
  opts = {
    style = preferred_style,
    transparent = true,
    styles = {
      comments = { italic = true },
      keywords = { bold = true },
      functions = {},
      variables = {},
      types = { bold = true },
      sidebars = 'transparent',
      floats = 'transparent',
    },
    day_brightness = 0.3,
    dim_inactive = true,
    lualine_bold = true,
    cache = true,
    plugins = {
      auto = true,
    },
  },
}

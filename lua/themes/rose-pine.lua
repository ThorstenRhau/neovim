-- Function to determine the preferred theme based on vim.o.background
local function getPreferredStyle()
  return vim.o.background == 'light' and 'dawn' or 'main'
end

local preferred_style = getPreferredStyle()

---@module "lazy"
---@type LazySpec
return {
  'rose-pine/neovim',
  name = 'rose-pine',
  lazy = false,
  priority = 1100,
  opts = {
    variant = preferred_style,
    dim_inactive_windows = true,
    enable = {
      terminal = true,
      legacy_highlights = false,
      migrations = false,
    },
    styles = {
      bold = true,
      italic = true,
      transparency = false,
    },
  },
}

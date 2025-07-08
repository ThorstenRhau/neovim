-- Function to determine the preferred theme based on macOS light/dark mode
local function getPreferredStyle()
  if vim.fn.executable('defaults') == 0 then
    -- Fallback to "Dark" style if `defaults` is not available
    return 'night' -- Dark style
  end

  local result = vim.fn.system('defaults read -g AppleInterfaceStyle')

  -- Trim any trailing whitespace or newline characters
  result = result:match('^%s*(.-)%s*$')

  if result == 'Dark' then
    return 'main' -- Dark style, alternatives are: storm, moon, and night
  else
    return 'dawn' -- Light style
  end
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

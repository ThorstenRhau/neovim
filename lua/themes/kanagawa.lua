-- Function to determine the preferred theme based on vim.o.background
local function getPreferredStyle()
  return vim.o.background == 'light' and 'lotus' or 'wave'
end

local preferred_style = getPreferredStyle()

---@module "lazy"
---@type LazySpec
return {
  'rebelot/kanagawa.nvim',
  priority = 1100,
  lazy = false,
  opts = {
    theme = preferred_style,
    compile = true, -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false, -- do not set background color
    dimInactive = true, -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
  },
}

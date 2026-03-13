local M = {}

function M.load()
  vim.cmd('hi clear')
  vim.o.termguicolors = true
  vim.g.colors_name = 'claude-theme'

  -- Clear cached modules so palette/groups pick up the new background
  for key in pairs(package.loaded) do
    if key:match('^claude%-theme%.') then
      package.loaded[key] = nil
    end
  end

  local palette = require('claude-theme.palette')
  local p = palette(vim.o.background)

  local groups = vim.tbl_extend(
    'force',
    require('claude-theme.groups.base')(p),
    require('claude-theme.groups.treesitter')(p),
    require('claude-theme.groups.lsp')(p),
    require('claude-theme.groups.plugins')(p)
  )

  for group, hl in pairs(groups) do
    vim.api.nvim_set_hl(0, group, hl)
  end

  -- Terminal ANSI colors (0..15)
  local is_dark = vim.o.background == 'dark'
  vim.g.terminal_color_0 = is_dark and p.bg1 or p.fg0
  vim.g.terminal_color_1 = p.red
  vim.g.terminal_color_2 = p.green
  vim.g.terminal_color_3 = p.yellow
  vim.g.terminal_color_4 = p.blue
  vim.g.terminal_color_5 = p.purple
  vim.g.terminal_color_6 = p.cyan
  vim.g.terminal_color_7 = is_dark and p.fg1 or p.bg1
  vim.g.terminal_color_8 = is_dark and p.fg3 or p.fg2
  vim.g.terminal_color_9 = p.accent
  vim.g.terminal_color_10 = p.green
  vim.g.terminal_color_11 = p.accent2
  vim.g.terminal_color_12 = p.blue
  vim.g.terminal_color_13 = p.purple
  vim.g.terminal_color_14 = p.cyan
  vim.g.terminal_color_15 = is_dark and p.fg0 or p.bg3
end

return M

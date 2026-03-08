local M = {}

function M.load()
  vim.cmd('hi clear')
  vim.o.termguicolors = true
  vim.g.colors_name = 'claude'

  -- Clear cached modules so palette/groups pick up the new background
  for key in pairs(package.loaded) do
    if key:match('^claude%.') then
      package.loaded[key] = nil
    end
  end

  local palette = require('claude.palette')
  local p = palette(vim.o.background)

  local groups = vim.tbl_extend(
    'force',
    require('claude.groups.base')(p),
    require('claude.groups.treesitter')(p),
    require('claude.groups.lsp')(p),
    require('claude.groups.plugins')(p)
  )

  for group, hl in pairs(groups) do
    vim.api.nvim_set_hl(0, group, hl)
  end
end

return M

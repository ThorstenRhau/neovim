---@module "lazy"
---@type LazySpec

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
  end
end

local function min_width(width)
  return function()
    return vim.fn.winwidth(0) > width
  end
end

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  init = function()
    vim.opt.showmode = false
  end,
  opts = {
    sections = {
      lualine_a = { { 'mode', icon = ' ' }, { 'searchcount', icon = ' ' }, { 'selectioncount', icon = '󰒉 ' } },
      lualine_b = {
        { 'branch', cond = min_width(80) },
        { 'diff', source = diff_source, cond = min_width(100) },
      },
      lualine_c = {
        'diagnostics',
        {
          'filename',
          file_status = true,
          newfile_status = true,
          path = 4,
        },
      },
      lualine_x = {
        { 'lsp_status', cond = min_width(105) },
        { 'filetype', cond = min_width(80) },
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { 'filename', path = 4 } },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {
      'lazy',
      'mason',
      'oil',
      'trouble',
      'fzf',
      'nvim-dap-ui',
      'quickfix',
      'toggleterm',
    },
  },
}

---@module "lazy"
---@type LazySpec
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'echasnovski/mini.icons' },
  opts = {
    sections = {
      lualine_a = { { 'mode', icon = ' ' } },
      lualine_b = { 'branch', 'diff' },
      lualine_c = {
        {
          function()
            local reg = vim.fn.reg_recording()
            if reg ~= '' then
              return '@' .. reg
            end
            return ''
          end,
        },
        'diagnostics',
        'filename',
      },
      lualine_x = {
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    extensions = { 'lazy', 'mason', 'oil', 'trouble', 'fzf', 'nvim-dap-ui', 'quickfix' },
  },
}

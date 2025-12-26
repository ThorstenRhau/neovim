---@module "lazy"
---@type LazySpec
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'echasnovski/mini.icons' },
  opts = {
    sections = {
      lualine_a = { { 'mode', icon = ' ' }, { 'searchcount', icon = ' ' } },
      lualine_b = {
        'branch',
        {
          'diff',
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
            end
          end,
        },
      },
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
        'lsp_status',
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    extensions = { 'lazy', 'mason', 'oil', 'trouble', 'fzf', 'nvim-dap-ui', 'quickfix' },
  },
}

return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '-', '<cmd>Oil --float<cr>', desc = 'Open parent directory' },
    { '<leader>e', '<cmd>Oil --float<cr>', desc = 'File explorer' },
  },
  opts = {
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    keymaps = {
      ['gd'] = {
        desc = 'Toggle file detail view',
        callback = function()
          local oil = require('oil')
          local config = require('oil.config')
          if #config.columns == 1 then
            oil.set_columns({ 'icon', 'permissions', 'size', 'mtime' })
          else
            oil.set_columns({ 'icon' })
          end
        end,
      },
    },
    view_options = {
      is_always_hidden = function(name, _)
        return name == '..' or name == '.git'
      end,
    },
    float = {
      max_width = 100,
      max_height = 30,
    },
  },
}

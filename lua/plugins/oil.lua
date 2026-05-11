local map = vim.keymap.set

require('oil').setup({
  win_options = {
    statuscolumn = '',
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  watch_for_changes = true,
  keymaps = {
    ['gd'] = {
      desc = 'toggle file detail view',
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
    win_options = {
      statuscolumn = '',
      number = false,
      relativenumber = false,
    },
  },
})

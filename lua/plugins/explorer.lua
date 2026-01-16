return {
  {
    'stevearc/oil.nvim',
    keys = {
      { '-', '<cmd>Oil --float<cr>', desc = 'open parent directory' },
      { '<leader>e', '<cmd>Oil --float<cr>', desc = 'file explorer' },
    },
    opts = {
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
    },
  },
  {
    'nvim-tree/nvim-tree.lua',
    keys = {
      { '<leader>tr', '<cmd>NvimTreeToggle<cr>', desc = 'file tree' },
    },
    opts = {
      hijack_directories = {
        enable = false,
      },
      update_focused_file = {
        enable = true,
      },
      view = {
        side = 'right',
        width = 25,
      },
      renderer = {
        group_empty = true,
        highlight_git = 'name',
        highlight_opened_files = 'name',
        highlight_diagnostics = 'name',
        highlight_modified = 'name',
        indent_markers = {
          enable = false,
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      modified = {
        enable = true,
      },
      filters = {
        custom = { '^.git$' },
      },
    },
  },
}

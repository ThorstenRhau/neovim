return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    { '<leader>e', '<cmd>Oil<cr>', desc = 'File explorer' },
  },
  opts = {
    default_file_explorer = true,
    columns = {
      'icon',
    },
    buf_options = {
      buflisted = false,
      bufhidden = 'hide',
    },
    win_options = {
      wrap = false,
      signcolumn = 'no',
      cursorcolumn = false,
      foldcolumn = '0',
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = 'nvic',
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = false,
    },
    constrain_cursor = 'editable',
    watch_for_changes = true,
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['<C-l>'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
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
    use_default_keymaps = false,
    view_options = {
      show_hidden = false,
      is_hidden_file = function(name, _)
        return vim.startswith(name, '.')
      end,
      is_always_hidden = function(name, _)
        return name == '..' or name == '.git'
      end,
      natural_order = 'fast',
      case_insensitive = false,
      sort = {
        { 'type', 'asc' },
        { 'name', 'asc' },
      },
    },
    float = {
      padding = 2,
      max_width = 100,
      max_height = 30,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
    },
  },
}

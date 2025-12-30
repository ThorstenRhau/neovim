---@module "lazy"
---@type LazySpec
return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'Oil',
  init = function()
    if vim.fn.argc() == 1 then
      local argv = vim.fn.argv(0) --[[@as string]]
      local stat = vim.uv.fs_stat(argv)
      if stat and stat.type == 'directory' then
        require('lazy').load({ plugins = { 'oil.nvim' } })
      end
    end
  end,

  ---@module 'oil'
  ---@type oil.Config
  ---@diagnostic disable: missing-fields
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = false,
    constrain_cursor = 'editable',
    columns = { 'icon' },
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        return name == '..' or name == '.git'
      end,
    },
    win_options = {
      wrap = true,
      signcolumn = 'no',
      cursorcolumn = false,
    },
    watch_for_changes = true,
    use_default_keymaps = true,
  },
}

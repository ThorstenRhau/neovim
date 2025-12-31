---@module "lazy"
---@type LazySpec
return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'DiffView Open' },
    { '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', mode = { 'n', 'v' }, desc = 'DiffView File History' },
    { '<leader>gL', '<cmd>DiffviewFileHistory<cr>', desc = 'DiffView Project History' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'DiffView Close' },
    { '<leader>gt', '<cmd>DiffviewToggleFiles<cr>', desc = 'DiffView Toggle File Panel' },
    { '<leader>gf', '<cmd>DiffviewFocusFiles<cr>', desc = 'DiffView Focus Files' },
  },
  ---@module "diffview"
  ---@type DiffViewOptions
  opts = {
    enhanced_diff_hl = true,
    use_icons = true,
    default_args = {
      DiffviewOpen = { '--imply-local', '--untracked-files=no' },
    },
    view = {
      default = {
        layout = 'diff2_horizontal',
        winbar_info = true,
      },
      merge_tool = {
        layout = 'diff3_horizontal',
        winbar_info = true,
      },
      file_history = {
        winbar_info = true,
      },
    },
    file_panel = {
      listing_style = 'tree',
      win_config = {
        position = 'left',
        width = 30,
      },
    },
    hooks = {
      diff_buf_read = function(bufnr)
        vim.opt_local.wrap = false
        vim.opt_local.list = false
        vim.opt_local.spell = false
        vim.diagnostic.enable(false, { bufnr = bufnr })
      end,
      view_opened = function(view)
        -- Hide file panel for all views except merge_tool
        if view.class:name() ~= 'MergeTool' then
          vim.cmd('DiffviewToggleFiles')
        end
      end,
    },
  },
}

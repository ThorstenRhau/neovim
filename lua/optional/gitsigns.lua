---@module "lazy"
---@type LazySpec
return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = { 'Gitsigns' },

  ---@module 'gitsigns'
  ---@type Gitsigns.Config
  ---@diagnostic disable: missing-fields
  opts = {
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    signs_staged = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'right_align',
      delay = 1500,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    update_debounce = 250,
    preview_config = {
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.next_hunk()
        end
      end, 'Next Hunk')

      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.prev_hunk()
        end
      end, 'Prev Hunk')

      -- Actions
      map('n', '<leader>ghs', gs.stage_hunk, 'Stage Hunk')
      map('n', '<leader>ghr', gs.reset_hunk, 'Reset Hunk')
      map('v', '<leader>ghs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, 'Stage Hunk')
      map('v', '<leader>ghr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, 'Reset Hunk')
      map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
      map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
      map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
      map('n', '<leader>ghp', gs.preview_hunk, 'Preview Hunk')
      map('n', '<leader>ghb', function()
        gs.blame_line({ full = true })
      end, 'Blame Line')
      map('n', '<leader>ghB', gs.toggle_current_line_blame, 'Toggle Line Blame')
      map('n', '<leader>ghd', gs.diffthis, 'Diff This')
      map('n', '<leader>ghD', function()
        gs.diffthis('~')
      end, 'Diff This ~')
      map('n', '<leader>ghl', gs.toggle_linehl, 'Toggle Line Highlight')

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
    end,
  },
}

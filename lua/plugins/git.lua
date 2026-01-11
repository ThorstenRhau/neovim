return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      { '<leader>hs', '<cmd>Gitsigns stage_hunk<cr>', desc = 'stage hunk' },
      { '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>', desc = 'reset hunk' },
      { '<leader>hS', '<cmd>Gitsigns stage_buffer<cr>', desc = 'stage buffer' },
      { '<leader>hu', '<cmd>Gitsigns reset_buffer_index<cr>', desc = 'unstage buffer' },
      { '<leader>hR', '<cmd>Gitsigns reset_buffer<cr>', desc = 'reset buffer' },
      { '<leader>hp', '<cmd>Gitsigns preview_hunk_inline<cr>', desc = 'preview hunk' },
      { '<leader>hb', '<cmd>Gitsigns blame_line full=true<cr>', desc = 'blame line' },
      { '<leader>hB', '<cmd>Gitsigns blame<cr>', desc = 'blame buffer' },
      { '<leader>hd', '<cmd>Gitsigns diffthis<cr>', desc = 'diff this' },
      { '<leader>hD', '<cmd>Gitsigns diffthis ~<cr>', desc = 'diff this ~' },
      { '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'line blame' },
      { '<leader>hl', '<cmd>Gitsigns toggle_linehl<cr>', desc = 'toggle line highlight' },
    },
    opts = {
      attach_to_untracked = false,
      on_attach = function(bufnr)
        local gs = require('gitsigns')

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            ---@diagnostic disable-next-line: param-type-mismatch, missing-fields
            gs.nav_hunk('next', { target = 'all' })
          end
        end, 'next hunk')

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            ---@diagnostic disable-next-line: param-type-mismatch, missing-fields
            gs.nav_hunk('prev', { target = 'all' })
          end
        end, 'prev hunk')

        -- Visual mode actions (need buffer context)
        map('v', '<leader>hs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'stage hunk')
        map('v', '<leader>hr', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'reset hunk')

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'select hunk')
      end,
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'ibhagwan/fzf-lua',
    },
    cmd = { 'Neogit', 'NeogitCommit', 'NeogitResetState', 'NeogitLogCurrent' },
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'neogit' },
    },
    opts = {
      disable_insert_on_commit = true,
      graph_style = 'kitty',
      process_spinner = true,
      integrations = {
        diffview = true,
        fzf_lua = true,
      },
      signs = {
        hunk = { '', '' },
        item = { '▸', '▾' },
        section = { '▸', '▾' },
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'diffview' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'file history' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'branch history' },
      { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'diffview close' },
    },
    opts = {
      enhanced_diff_hl = true,
      use_icons = true,
      default_args = {
        DiffviewOpen = { '--untracked-files=no' },
      },
      view = {
        merge_tool = {
          layout = 'diff3_mixed',
        },
      },
    },
  },
}

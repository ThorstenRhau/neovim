local map = vim.keymap.set

require('gitsigns').setup({
  attach_to_untracked = false,
  on_attach = function(bufnr)
    local gs = require('gitsigns')

    local function bmap(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    bmap('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        ---@diagnostic disable-next-line: param-type-mismatch, missing-fields
        gs.nav_hunk('next', { target = 'all' })
      end
    end, 'next hunk')

    bmap('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        ---@diagnostic disable-next-line: param-type-mismatch, missing-fields
        gs.nav_hunk('prev', { target = 'all' })
      end
    end, 'prev hunk')

    -- Visual mode actions (need buffer context)
    bmap('v', '<leader>hs', function()
      gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'stage hunk')
    bmap('v', '<leader>hr', function()
      gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'reset hunk')

    -- Text object
    bmap({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'select hunk')
  end,
})

map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<cr>', { desc = 'stage hunk' })
map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>', { desc = 'reset hunk' })
map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<cr>', { desc = 'stage buffer' })
map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<cr>', { desc = 'unstage hunk' })
map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<cr>', { desc = 'reset buffer' })
map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk_inline<cr>', { desc = 'preview hunk' })
map('n', '<leader>hb', '<cmd>Gitsigns blame_line full=true<cr>', { desc = 'blame line' })
map('n', '<leader>hB', '<cmd>Gitsigns blame<cr>', { desc = 'blame buffer' })
map('n', '<leader>hd', '<cmd>Gitsigns diffthis<cr>', { desc = 'diff this' })
map('n', '<leader>hD', '<cmd>Gitsigns diffthis ~<cr>', { desc = 'diff this ~' })
map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<cr>', { desc = 'line blame' })
map('n', '<leader>hl', '<cmd>Gitsigns toggle_linehl<cr>', { desc = 'toggle line highlight' })

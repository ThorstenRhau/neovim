local map = vim.keymap.set

local function close_revision_diffs()
  local revision_wins = {}

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_name(buf):match('^gitsigns://') then
      table.insert(revision_wins, win)
    end
  end

  for _, win in ipairs(revision_wins) do
    vim.api.nvim_win_close(win, false)
  end

  return #revision_wins > 0
end

local function toggle_diffthis(base)
  if vim.wo.diff and close_revision_diffs() then
    return
  end

  require('gitsigns').diffthis(base)
end

require('gitsigns').setup({
  attach_to_untracked = false,
  signs = {
    add = { text = ' ┃' },
    change = { text = ' ┃' },
    delete = { text = ' ▁' },
    topdelete = { text = ' ▔' },
    changedelete = { text = ' ~' },
    untracked = { text = ' ┆' },
  },
  signs_staged = {
    add = { text = ' ┃' },
    change = { text = ' ┃' },
    delete = { text = ' ▁' },
    topdelete = { text = ' ▔' },
    changedelete = { text = ' ~' },
  },
  on_attach = function(bufnr)
    local gs = require('gitsigns')

    local function bmap(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buf = bufnr, desc = desc })
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

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('gitsigns_revision_exit', { clear = true }),
  callback = function(event)
    if not vim.api.nvim_buf_get_name(event.buf):match('^gitsigns://') then
      return
    end

    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buf = event.buf, desc = 'close revision diff' })
  end,
})

map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<cr>', { desc = 'stage hunk' })
map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>', { desc = 'reset hunk' })
map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<cr>', { desc = 'stage buffer' })
map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<cr>', { desc = 'reset buffer' })
map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk_inline<cr>', { desc = 'preview hunk' })
map('n', '<leader>hb', '<cmd>Gitsigns blame_line full=true<cr>', { desc = 'blame line' })
map('n', '<leader>hB', '<cmd>Gitsigns blame<cr>', { desc = 'blame buffer' })
map('n', '<leader>gd', toggle_diffthis, { desc = 'toggle diff this' })
map('n', '<leader>hD', function()
  toggle_diffthis('~')
end, { desc = 'toggle diff this ~' })
map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<cr>', { desc = 'line blame' })
map('n', '<leader>hl', '<cmd>Gitsigns toggle_linehl<cr>', { desc = 'toggle line highlight' })

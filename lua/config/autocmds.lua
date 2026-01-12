local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Return to last edit position
autocmd('BufReadPost', {
  group = augroup('restore_cursor', { clear = true }),
  callback = function(event)
    local exclude_ft = { 'gitcommit', 'gitrebase', 'help' }
    if vim.tbl_contains(exclude_ft, vim.bo[event.buf].filetype) then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-resize splits on window resize
autocmd('VimResized', {
  group = augroup('resize_splits', { clear = true }),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Close certain filetypes with q
-- Note: 'man' is excluded because Neovim has built-in q handling for man pages
autocmd('FileType', {
  group = augroup('close_with_q', { clear = true }),
  pattern = {
    'checkhealth',
    'git',
    'gitsigns-blame',
    'help',
    'lspinfo',
    'notify',
    'qf',
    'startuptime',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', function()
      local ok = pcall(vim.cmd.bdelete, { bang = true })
      if not ok then
        vim.cmd.quit()
      end
    end, { buffer = event.buf, silent = true, desc = 'Close buffer' })
  end,
})

-- Auto create parent directories when saving
autocmd('BufWritePre', {
  group = augroup('auto_create_dir', { clear = true }),
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Check if file changed outside of vim
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime', { clear = true }),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Trim whitespace command
vim.api.nvim_create_user_command('TrimWhitespace', function()
  local save_cursor = vim.fn.getpos('.')
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos('.', save_cursor)
end, { desc = 'trim trailing whitespace' })

-- Disable statuscolumn for specific filetypes/buftypes
autocmd('BufWinEnter', {
  group = augroup('statuscolumn_exclusions', { clear = true }),
  callback = function()
    local dominated_filetypes = {
      'help',
      'lazy',
      'mason',
      'NvimTree',
      'oil',
      'trouble',
    }
    if vim.tbl_contains(dominated_filetypes, vim.bo.filetype) then
      vim.wo.statuscolumn = ''
      vim.wo.signcolumn = 'no'
    end
  end,
})

autocmd('OptionSet', {
  group = augroup('statuscolumn_exclusions', { clear = false }),
  pattern = 'buftype',
  callback = function()
    local buftype = vim.bo.buftype
    if buftype == 'nofile' or buftype == 'terminal' then
      vim.wo.statuscolumn = ''
      vim.wo.signcolumn = 'no'
    end
  end,
})

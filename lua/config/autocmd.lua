-- Utility function to create auto groups
local function augroup(name)
  return vim.api.nvim_create_augroup('my_' .. name, { clear = true })
end

-- Function to close or quit Neovim
local function close_or_quit()
  local win_count = #vim.api.nvim_list_wins()
  local listed_bufs = vim.fn.getbufinfo({ buflisted = 1 })

  if win_count == 1 and #listed_bufs <= 1 then
    vim.cmd('qall!')
  elseif win_count == 1 then
    vim.notify('Cannot close the last window without quitting Neovim.', vim.log.levels.WARN)
  else
    pcall(vim.cmd.close)
  end
end

-- Remove 'c', 'r', 'o' from format options for all filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('formatoptions'),
  pattern = '*',
  desc = 'Remove auto-comment formatoptions',
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- Markdown-specific settings
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('markdown'),
  pattern = 'markdown',
  desc = 'Set markdown textwidth/wrap/spell',
  callback = function()
    vim.bo.textwidth = 80
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Git commit message settings
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('gitcommit'),
  pattern = 'gitcommit',
  desc = 'Set gitcommit formatting',
  callback = function()
    vim.bo.textwidth = 72
    vim.wo.colorcolumn = '50,73'
    vim.schedule(function()
      vim.wo.spell = true
      vim.wo.wrap = true
    end)
  end,
})

-- Close with 'q' in special buffers
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('q_close'),
  pattern = {
    'checkhealth',
    'git',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'snacks_dashboard',
    'spectre_panel',
    'startuptime',
  },
  desc = "Map 'q' to close for helper filetypes",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', close_or_quit, {
      buffer = event.buf,
      silent = true,
      noremap = true,
      desc = 'Close window',
    })
  end,
})

-- Resize splits on window resize
-- Debounce to prevent lag during rapid resizing
local resize_timer = nil
vim.api.nvim_create_autocmd('VimResized', {
  group = augroup('resize'),
  desc = 'Auto resize splits',
  callback = function()
    if resize_timer then
      resize_timer:stop()
    end
    resize_timer = vim.defer_fn(function()
      vim.cmd('tabdo wincmd =')
      resize_timer = nil
    end, 100)
  end,
})

-- Reload file if changed externally
-- Debounce checktime on BufEnter to avoid excessive filesystem checks
local last_checktime = 0
local checktime_cooldown = 1000 -- milliseconds

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave', 'BufEnter' }, {
  group = augroup('checktime'),
  desc = 'Check for file changes',
  callback = function(args)
    if vim.tbl_contains({ 'FocusGained', 'TermClose', 'TermLeave' }, args.event) then
      vim.cmd.checktime()
      last_checktime = vim.uv.now()
    else
      -- Debounce BufEnter checktime to avoid excessive calls
      local now = vim.uv.now()
      if vim.bo[args.buf].buftype == '' and (now - last_checktime) > checktime_cooldown then
        vim.cmd.checktime('%')
        last_checktime = now
      end
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  desc = 'Highlight yanked text',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore last cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('restore_cursor'),
  desc = 'Jump to last known position',
  callback = function(args)
    if vim.bo[args.buf].buftype ~= '' then
      return
    end
    if vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.bo[args.buf].filetype) then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line = mark[1]
    local col = mark[2]

    if line <= 0 then
      return
    end

    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if line > line_count then
      line = line_count
    end
    if line == 0 then
      return
    end

    local line_text = vim.api.nvim_buf_get_lines(args.buf, line - 1, line, true)[1] or ''
    local target_col = math.max(math.min(col, #line_text), 0)

    if vim.api.nvim_get_current_buf() ~= args.buf then
      return
    end

    pcall(vim.api.nvim_win_set_cursor, 0, { line, target_col })
  end,
})

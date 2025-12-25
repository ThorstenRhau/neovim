-- Create an autocommand group with automatic clearing
---@param name string
---@return integer
local function augroup(name)
  return vim.api.nvim_create_augroup('my_' .. name, { clear = true })
end

---Close the current window or quit Neovim if it's the last window
---@return nil
local function close_or_quit()
  -- Filter out floating windows from window count
  local wins = vim.tbl_filter(function(win)
    return vim.api.nvim_win_get_config(win).relative == ''
  end, vim.api.nvim_list_wins())
  local win_count = #wins
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
  desc = 'Set markdown wrap/spell',
  callback = function()
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
    vim.wo.spell = true
    vim.wo.wrap = true
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
    'startuptime',
  },
  desc = "Map 'q' to close for helper filetypes",
  callback = function(event)
    if not vim.api.nvim_buf_is_valid(event.buf) then
      return
    end
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', close_or_quit, {
      buffer = event.buf,
      silent = true,
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
      resize_timer:close()
    end
    resize_timer = vim.defer_fn(function()
      vim.cmd('tabdo wincmd =')
      resize_timer = nil
    end, 100)
  end,
})

-- Reload file if changed externally
-- Debounce checktime on BufEnter/CursorHold to avoid excessive filesystem checks
local last_checktime = 0
local checktime_cooldown = 500 -- milliseconds
local immediate_events = { FocusGained = true, TermClose = true, TermLeave = true }

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave', 'BufEnter', 'CursorHold' }, {
  group = augroup('checktime'),
  desc = 'Check for file changes',
  callback = function(args)
    if vim.fn.getcmdwintype() ~= '' then
      return
    end

    if immediate_events[args.event] then
      vim.cmd.checktime()
      last_checktime = vim.uv.now()
      return
    end

    -- Debounced events: BufEnter, CursorHold
    if not vim.api.nvim_buf_is_valid(args.buf) or vim.bo[args.buf].buftype ~= '' then
      return
    end

    local now = vim.uv.now()
    if (now - last_checktime) > checktime_cooldown then
      vim.cmd.checktime('%')
      last_checktime = now
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

-- Restore last known cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('restore_cursor'),
  desc = 'Jump to last known position',
  callback = function(args)
    local buf = args.buf
    local bt = vim.bo[buf].buftype
    local ft = vim.bo[buf].filetype

    -- Skip special buffers and git commit/rebase messages
    if bt ~= '' or ft == 'gitcommit' or ft == 'gitrebase' then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line = mark[1]

    -- Mark not set or invalid
    if line <= 0 then
      return
    end

    -- Clamp line to buffer bounds
    local line_count = vim.api.nvim_buf_line_count(buf)
    line = math.min(line, line_count)

    -- Clamp column to line length
    local line_text = vim.api.nvim_buf_get_lines(buf, line - 1, line, true)[1] or ''
    local col = math.min(mark[2], #line_text)

    -- Only restore if this buffer is current (might not be with splits/tabs)
    if vim.api.nvim_get_current_buf() == buf then
      pcall(vim.api.nvim_win_set_cursor, 0, { line, col })
    end
  end,
})

-- Disable persistent undo for sensitive files
vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup('no_undo_sensitive'),
  pattern = { '/tmp/*', '*.env', '*/.env.*', '/private/tmp/*' },
  desc = 'Disable undofile for sensitive paths',
  callback = function()
    vim.bo.undofile = false
  end,
})

-- Clean old undo files (older than 14 days) with delayed startup
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup('undo_cleanup'),
  desc = 'Clean old undo files after delay',
  callback = function()
    vim.defer_fn(function()
      local undodir = vim.fn.expand(vim.o.undodir)

      -- Safety: only proceed if undodir looks like a valid undo directory
      if not undodir:match('undo') then
        return
      end
      if vim.fn.isdirectory(undodir) == 0 then
        return
      end

      local max_age_days = 14
      local max_age_seconds = max_age_days * 24 * 60 * 60
      local now = os.time()
      local deleted = 0

      local handle = vim.uv.fs_scandir(undodir)
      if not handle then
        return
      end

      while true do
        local name, type = vim.uv.fs_scandir_next(handle)
        if not name then
          break
        end

        -- Safety: only delete files that look like undo files (path-encoded with %)
        if type == 'file' and name:match('%%') then
          local filepath = vim.fs.joinpath(undodir, name)
          local stat = vim.uv.fs_stat(filepath)
          if stat and (now - stat.mtime.sec) > max_age_seconds then
            if vim.uv.fs_unlink(filepath) then
              deleted = deleted + 1
            end
          end
        end
      end

      if deleted > 0 then
        vim.notify(string.format('Cleaned %d old undo file(s)', deleted), vim.log.levels.INFO)
      end
    end, 5000) -- 5 second delay after startup
  end,
})

-- Persistent folds
local persistent_folds_group = augroup('persistent_folds')

vim.api.nvim_create_autocmd('BufWinLeave', {
  group = persistent_folds_group,
  pattern = '*',
  desc = 'Save view on leave',
  callback = function()
    if vim.bo.buftype == '' and vim.fn.expand('%') ~= '' then
      vim.cmd('silent! mkview')
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = persistent_folds_group,
  pattern = '*',
  desc = 'Load view on enter',
  callback = function()
    if vim.bo.buftype == '' and vim.fn.expand('%') ~= '' then
      vim.cmd('silent! loadview')
    end
  end,
})

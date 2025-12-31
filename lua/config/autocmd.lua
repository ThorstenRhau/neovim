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

  -- If last window and only one (or zero) listed buffers
  if win_count == 1 and #listed_bufs <= 1 then
    -- Check for unsaved changes before quitting
    local modified = vim.fn.getbufinfo({ bufmodified = 1 })
    if #modified > 0 then
      vim.notify('Unsaved changes in buffer(s). Use :qa! to force quit.', vim.log.levels.ERROR)
      return
    end
    vim.cmd('qa') -- Quit all (non-forcing, safer than qall!)
  elseif win_count == 1 then
    -- Last window but multiple buffers - close buffer, show another
    vim.cmd('bdelete')
  else
    -- Multiple windows - just close this one
    pcall(vim.cmd.close)
  end
end

-- Markdown-specific settings
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('markdown'),
  pattern = 'markdown',
  desc = 'Set markdown wrap/spell/folding',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.foldenable = true
    vim.opt_local.foldlevel = 99
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
local last_debounced_checktime = 0
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
      return
    end

    -- Debounced events: BufEnter, CursorHold
    if not vim.api.nvim_buf_is_valid(args.buf) or vim.bo[args.buf].buftype ~= '' then
      return
    end

    local now = vim.uv.now()
    if (now - last_debounced_checktime) > checktime_cooldown then
      vim.cmd.checktime()
      last_debounced_checktime = now
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
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = augroup('no_undo_sensitive'),
  desc = 'Disable undofile for sensitive paths',
  callback = function(event)
    local path = vim.api.nvim_buf_get_name(event.buf)
    if path == '' then
      return
    end

    local function disable_undo()
      vim.bo[event.buf].undofile = false
    end

    -- Temp directories
    local tmpdir = (vim.env.TMPDIR or '/tmp'):gsub('/$', '')
    local temp_dirs = {
      '/tmp/',
      '/private/tmp/',
      tmpdir .. '/',
      '/var/tmp/',
      '/dev/shm/',
    }

    for _, dir in ipairs(temp_dirs) do
      if vim.startswith(path, dir) then
        return disable_undo()
      end
    end

    -- Environment files
    local basename = vim.fn.fnamemodify(path, ':t')
    if basename == '.env' or basename:match('^%.env%.') or basename:match('%.env$') then
      return disable_undo()
    end

    -- SSH and GPG directories
    if path:match('/%.ssh/') or path:match('/%.gnupg/') then
      return disable_undo()
    end

    -- SSH keys (id_rsa, id_ed25519, id_ecdsa, id_dsa, and .pub variants)
    if basename:match('^id_[a-z0-9]+') then
      return disable_undo()
    end

    -- Certificate and key files
    local sensitive_extensions = {
      '.pem',
      '.key',
      '.p12',
      '.pfx',
      '.crt',
      '.cer',
      '.gpg',
      '.keystore',
      '.jks',
    }
    for _, ext in ipairs(sensitive_extensions) do
      if vim.endswith(path:lower(), ext) then
        return disable_undo()
      end
    end

    -- Shell history (dotfiles ending in _history)
    if basename:match('^%..+_history$') then
      return disable_undo()
    end

    -- Generic sensitive patterns
    local sensitive_patterns = { 'secret', 'password', 'credential', 'auth_token' }
    local lower_path = path:lower()
    for _, pattern in ipairs(sensitive_patterns) do
      if lower_path:match(pattern) then
        return disable_undo()
      end
    end
  end,
})

-- Clean old undo files (older than 14 days) with delayed startup
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup('undo_cleanup'),
  desc = 'Clean old undo files after delay',
  callback = function()
    vim.defer_fn(function()
      if vim.o.undodir == '' then
        return
      end

      local max_age_days = 14
      local max_age_seconds = max_age_days * 24 * 60 * 60
      local now = os.time()
      local total_deleted = 0

      for _, dir in ipairs(vim.split(vim.o.undodir, ',', { trimempty = true })) do
        local undodir = vim.fn.expand(dir)

        -- Safety: only proceed if path contains 'undo' and exists
        if undodir:match('undo') and vim.fn.isdirectory(undodir) == 1 then
          local handle = vim.uv.fs_scandir(undodir)
          if handle then
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
                  local ok, err = vim.uv.fs_unlink(filepath)
                  if not ok then
                    vim.notify('Failed to delete ' .. name .. ': ' .. err, vim.log.levels.WARN)
                  else
                    total_deleted = total_deleted + 1
                  end
                end
              end
            end
          end
        end
      end

      if total_deleted > 0 then
        vim.notify(string.format('Cleaned %d old undo file(s)', total_deleted), vim.log.levels.DEBUG)
      end
    end, 5000)
  end,
})

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local constants = require('config.constants')

-- Auto-reload buffers changed externally
autocmd({ 'FocusGained', 'BufEnter' }, {
  group = augroup('auto_reload', { clear = true }),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd.checktime()
    end
  end,
})

-- Highlight on yank
autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = 'Search' })
  end,
})

-- Return to last edit position
autocmd('BufReadPost', {
  group = augroup('restore_cursor', { clear = true }),
  callback = function(event)
    if vim.list_contains(constants.filetypes.restore_cursor_exclude, vim.bo[event.buf].filetype) then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close certain filetypes with q
-- Note: 'man' is excluded because Neovim has built-in q handling for man pages
autocmd('FileType', {
  group = augroup('close_with_q', { clear = true }),
  pattern = constants.filetypes.close_with_q,
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

-- Trim whitespace command
vim.api.nvim_create_user_command('TrimWhitespace', function()
  local save_cursor = vim.fn.getpos('.')
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos('.', save_cursor)
end, { desc = 'trim trailing whitespace' })

local function clear_chrome()
  vim.wo.statuscolumn = ''
  vim.wo.signcolumn = 'no'
  vim.wo.number = false
  vim.wo.relativenumber = false
end

autocmd('FileType', {
  group = augroup('statuscolumn_exclusions', { clear = true }),
  pattern = constants.filetypes.no_chrome,
  callback = clear_chrome,
})

autocmd('BufWinEnter', {
  group = augroup('statuscolumn_exclusions', { clear = false }),
  callback = function(event)
    if vim.bo[event.buf].buftype == 'nofile' then
      clear_chrome()
    end
  end,
})

-- Terminal buffers: clear chrome and disable listchars (broken with ANSI colors).
-- TermOpen is used because buftype is not yet 'terminal' at BufWinEnter.
autocmd('TermOpen', {
  group = augroup('terminal_setup', { clear = true }),
  callback = function()
    clear_chrome()
    vim.wo.list = false
  end,
})

-- Enable document colors with virtual text style by default
vim.lsp.document_color.enable(true, nil, { style = 'virtual' })

-- LSP progress via nvim_echo progress messages
autocmd('LspProgress', {
  group = augroup('lsp_progress', { clear = true }),
  desc = 'Display LSP progress in echo area',
  callback = function(ev)
    local value = ev.data.params.value
    local msg = value.message or (value.kind == 'end' and 'done' or '')
    vim.api.nvim_echo({ { msg } }, false, {
      id = 'lsp.' .. ev.data.client_id .. '.' .. ev.data.params.token,
      kind = 'progress',
      source = 'vim.lsp',
      title = value.title,
      status = value.kind ~= 'end' and 'running' or 'success',
      percent = value.percentage,
    })
  end,
})

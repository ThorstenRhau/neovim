local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Auto-reload buffers changed externally (e.g. by Claude Code)
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
local exclude_ft = { gitcommit = true, gitrebase = true, help = true }
autocmd('BufReadPost', {
  group = augroup('restore_cursor', { clear = true }),
  callback = function(event)
    if exclude_ft[vim.bo[event.buf].filetype] then
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
  pattern = {
    'checkhealth',
    'fugitive',
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

-- Trim whitespace command
vim.api.nvim_create_user_command('TrimWhitespace', function()
  local save_cursor = vim.fn.getpos('.')
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos('.', save_cursor)
end, { desc = 'trim trailing whitespace' })

-- Disable statuscolumn for specific filetypes/buftypes
local no_chrome_filetypes = {
  checkhealth = true,
  help = true,
  NvimTree = true,
  oil = true,
}

local function clear_chrome()
  vim.wo.statuscolumn = ''
  vim.wo.signcolumn = 'no'
  vim.wo.number = false
  vim.wo.relativenumber = false
end

autocmd('FileType', {
  group = augroup('statuscolumn_exclusions', { clear = true }),
  pattern = vim.tbl_keys(no_chrome_filetypes),
  callback = clear_chrome,
})

autocmd('BufWinEnter', {
  group = augroup('statuscolumn_exclusions', { clear = false }),
  callback = function(event)
    local bt = vim.bo[event.buf].buftype
    if bt == 'nofile' or bt == 'terminal' then
      clear_chrome()
    end
  end,
})

-- listchars render broken in terminal buffers with ANSI colors
autocmd('TermOpen', {
  group = augroup('terminal_list', { clear = true }),
  callback = function()
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

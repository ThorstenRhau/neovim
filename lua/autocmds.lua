local group = vim.api.nvim_create_augroup('editor', { clear = true })

-- Highlight yanked text briefly.
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Restore the cursor to its last position in regular buffers.
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  callback = function(event)
    local filetype = vim.bo[event.buf].filetype
    if filetype == '' then
      filetype = vim.filetype.match({ buf = event.buf }) or ''
    end
    if vim.bo[event.buf].buftype ~= '' or vim.list_contains({ 'gitcommit', 'gitrebase', 'help' }, filetype) then
      return
    end
    local line = vim.api.nvim_buf_get_mark(event.buf, '"')[1]
    if line > 0 and line <= vim.api.nvim_buf_line_count(event.buf) then
      vim.cmd.normal({ args = { 'g`"' }, bang = true })
    end
  end,
})

-- Enable Tree-sitter and expression folding for supported filetypes.
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = {
    'diff',
    'editorconfig',
    'gitattributes',
    'gitcommit',
    'gitconfig',
    'gitignore',
    'gitrebase',
    'json',
    'jsonc',
    'lua',
    'make',
    'markdown',
    'python',
    'query',
    'ruby',
    'sh',
    'toml',
    'vim',
    'yaml',
  },
  callback = function(event)
    vim.treesitter.start(event.buf)
    for _, win in ipairs(vim.fn.win_findbuf(event.buf)) do
      vim.wo[win][0].foldmethod = 'expr'
      vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
    vim.b[event.buf].undo_ftplugin = (vim.b[event.buf].undo_ftplugin or '')
      .. '\ncall v:lua.vim.treesitter.stop()'
      .. '|call map(win_findbuf(bufnr()), {_, win -> win_execute(win, "setlocal foldmethod< foldexpr<")})'
  end,
})

-- Hide trailing-space markers while typing.
vim.api.nvim_create_autocmd('InsertEnter', {
  group = group,
  callback = function()
    vim.opt_local.listchars:remove('trail')
  end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = group,
  callback = function()
    vim.cmd.setlocal('listchars<')
  end,
})

-- Run configured linters when opening, leaving insert mode, and writing.
vim.api.nvim_create_autocmd({ 'BufReadPost', 'InsertLeave', 'BufWritePost' }, {
  group = group,
  callback = function()
    require('lint').try_lint(nil, { cwd = vim.fs.root(0, { 'selene.toml', '.git' }) })
  end,
})

-- Manual restore previous session
local session = vim.fn.stdpath('state') .. '/last-session.vim'
vim.keymap.set('n', '<leader>S', function()
  vim.cmd('source ' .. vim.fn.fnameescape(session))
end, { desc = 'Restore last session' })

-- Save the interactive session before exiting Neovim. Only when started
-- without file arguments, so `git commit` and quick edits keep the session.
local started_without_files = vim.fn.argc(-1) == 0
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = function()
    if not started_without_files or #vim.api.nvim_list_uis() == 0 then
      return
    end
    vim.cmd('mksession! ' .. vim.fn.fnameescape(session))
  end,
})

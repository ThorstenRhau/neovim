local group = vim.api.nvim_create_augroup('editor', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  callback = function(event)
    if
      vim.bo[event.buf].buftype ~= ''
      or vim.list_contains({ 'gitcommit', 'gitrebase', 'help' }, vim.bo[event.buf].filetype)
    then
      return
    end
    local line = vim.api.nvim_buf_get_mark(event.buf, '"')[1]
    if line > 0 and line <= vim.api.nvim_buf_line_count(event.buf) then
      vim.cmd.normal({ args = { 'g`"' }, bang = true })
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = {
    'bash',
    'sh',
    'diff',
    'gitdiff',
    'editorconfig',
    'gitconfig',
    'gitrebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'json',
    'jsonc',
    'lua',
    'make',
    'markdown',
    'python',
    'query',
    'toml',
    'vim',
    'help',
    'yaml',
    'yaml.docker-compose',
    'yaml.gitlab',
    'yaml.helm-values',
  },
  callback = function(event)
    vim.treesitter.start(event.buf)
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.b[event.buf].undo_ftplugin = (vim.b[event.buf].undo_ftplugin or '')
      .. '|call v:lua.vim.treesitter.stop()'
      .. '|call map(win_findbuf(bufnr()), {_, win -> win_execute(win, "setlocal foldmethod< foldexpr<")})'
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  callback = function()
    require('lint').try_lint()
  end,
})

local session = vim.fn.stdpath('state') .. '/last-session.vim'
vim.keymap.set('n', '<leader>S', function()
  vim.cmd('source ' .. vim.fn.fnameescape(session))
end, { desc = 'Restore session' })

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = function()
    if #vim.api.nvim_list_uis() == 0 then
      return
    end
    vim.fn.mkdir(vim.fn.stdpath('state'), 'p')
    vim.cmd('mksession! ' .. vim.fn.fnameescape(session))
  end,
})

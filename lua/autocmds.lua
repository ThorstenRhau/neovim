local group = vim.api.nvim_create_augroup('editor', { clear = true })

-- Flash yanked text once
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Restore the last cursor position
local skip_restore = { 'gitcommit', 'gitrebase', 'help' }

vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  callback = function(event)
    local buf = event.buf
    local filetype = vim.bo[buf].filetype
    if filetype == '' then
      filetype = vim.filetype.match({ buf = buf }) or ''
    end
    if vim.bo[buf].buftype ~= '' or vim.list_contains(skip_restore, filetype) then
      return
    end
    local line = vim.api.nvim_buf_get_mark(buf, '"')[1]
    if line > 0 and line <= vim.api.nvim_buf_line_count(buf) then
      vim.cmd.normal({ args = { 'g`"' }, bang = true })
    end
  end,
})

-- Tree-sitter highlighting and folding
local undo_treesitter = table.concat({
  'call v:lua.vim.treesitter.stop()',
  'call map(win_findbuf(bufnr()), {_, win -> win_execute(win, "setlocal foldmethod< foldexpr<")})',
}, '|')

vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = {
    'c',
    'diff',
    'editorconfig',
    'gitattributes',
    'gitcommit',
    'gitconfig',
    'gitignore',
    'gitrebase',
    'go',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'lua',
    'make',
    'markdown',
    'python',
    'query',
    'ruby',
    'rust',
    'sh',
    'swift',
    'toml',
    'typescript',
    'typescriptreact',
    'vim',
    'yaml',
  },
  callback = function(event)
    local buf = event.buf
    vim.treesitter.start(buf)
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
      vim.wo[win][0].foldmethod = 'expr'
      vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
    vim.b[buf].undo_ftplugin = (vim.b[buf].undo_ftplugin or '') .. '\n' .. undo_treesitter
  end,
})

-- Hide trailing whitespace markers in insert mode
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

-- Lint when leaving insert mode and on write
vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost' }, {
  group = group,
  callback = function()
    local lint = require('lint')
    local opts = { cwd = vim.fs.root(0, { 'selene.toml', '.git' }) }
    lint.try_lint(nil, opts)
    if vim.api.nvim_buf_get_name(0):match('/%.github/workflows/[^/]+%.ya?ml$') then
      lint.try_lint('actionlint', opts)
    end
  end,
})

-- Restore last session
local session = vim.fn.stdpath('state') .. '/last-session.vim'
local started_without_files = vim.fn.argc(-1) == 0

vim.keymap.set('n', '<leader>S', function()
  vim.cmd('source ' .. vim.fn.fnameescape(session))
end, { desc = 'Restore last session' })

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = function()
    if started_without_files and #vim.api.nvim_list_uis() > 0 then
      vim.cmd('mksession! ' .. vim.fn.fnameescape(session))
    end
  end,
})

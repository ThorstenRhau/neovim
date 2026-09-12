-- Disable line numbers and status column for man pages
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.statuscolumn = ''

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|call map(win_findbuf(bufnr()), {_, win -> win_execute(win, "setlocal number< relativenumber< statuscolumn<")})'

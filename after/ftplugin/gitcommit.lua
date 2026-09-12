vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|call map(win_findbuf(bufnr()), {_, win -> win_execute(win, "setlocal wrap< spell<")})'

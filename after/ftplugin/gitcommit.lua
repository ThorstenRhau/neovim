for _, win in ipairs(vim.fn.win_findbuf(vim.api.nvim_get_current_buf())) do
  vim.wo[win][0].wrap = true
  vim.wo[win][0].spell = true
end
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|call map(win_findbuf(bufnr()), {_, win -> win_execute(win, "setlocal wrap< spell<")})'

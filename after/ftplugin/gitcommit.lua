vim.opt_local.colorcolumn = '72'
vim.opt_local.spell = true

-- Neogit sets the filetype before it shows the commit buffer in its window, so
-- the line above lands on another window. Set it again once the buffer is
-- shown. `once` keeps reloads of this ftplugin from stacking autocmds.
vim.api.nvim_create_autocmd('BufWinEnter', {
  buf = 0,
  once = true,
  callback = function()
    vim.opt_local.colorcolumn = '72'
  end,
})

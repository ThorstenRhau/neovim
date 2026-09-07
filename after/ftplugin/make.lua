vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal expandtab< tabstop< shiftwidth< softtabstop<'

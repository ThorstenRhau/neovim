vim.opt_local.wrap = true

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal wrap<'

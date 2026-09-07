vim.opt_local.conceallevel = 2
vim.opt_local.wrap = true
vim.opt_local.spell = vim.bo.buftype == ''

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal conceallevel< wrap< spell<'

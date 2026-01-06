vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

vim.treesitter.start()

vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.wo[0][0].foldmethod = 'expr'
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'

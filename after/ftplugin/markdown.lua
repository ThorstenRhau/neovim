vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.conceallevel = 2

-- Only enable spell for regular files, not scratch buffers (LSP hover, etc.)
if vim.bo.buftype == '' then
  vim.opt_local.spell = true
end

vim.wo[0][0].foldmethod = 'expr'
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'

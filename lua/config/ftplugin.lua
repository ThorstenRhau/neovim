local M = {}

function M.indent(size)
  vim.opt_local.tabstop = size
  vim.opt_local.shiftwidth = size
  vim.opt_local.softtabstop = size
  return M
end

function M.treesitter()
  vim.treesitter.start()
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  vim.wo[0][0].foldmethod = 'expr'
  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  return M
end

return M

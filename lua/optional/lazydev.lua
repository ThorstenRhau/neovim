---@module "lazy"
---@type LazySpec
return {
  'folke/lazydev.nvim',
  ft = 'lua',
  ---@module 'lazydev'
  ---@type lazydev.Config
  opts = {
    library = {
      { path = vim.fn.stdpath('config') },
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
    integrations = {
      lspconfig = true,
      cmp = false,
      coq = false,
    },
  },
}

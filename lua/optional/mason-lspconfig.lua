---@module "lazy"
---@type LazySpec
return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
  },
  opts = {
    ensure_installed = {},
    automatic_enable = true,
  },
}

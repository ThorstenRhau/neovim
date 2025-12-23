---@module "lazy"
---@type LazySpec
return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
  },
  ---@module "mason-lspconfig"
  ---@type MasonLspconfigSettings
  opts = {
    ensure_installed = {},
    automatic_enable = true,
  },
}

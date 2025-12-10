---@module "lazy"
---@type LazySpec
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    ---@module 'lazydev'
    ---@type lazydev.Config
    opts = {
      library = {
        { path = '~/.config/nvim/' },
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
      integrations = {
        lspconfig = true,
        cmp = false,
        coq = false,
      },
    },
  },
}

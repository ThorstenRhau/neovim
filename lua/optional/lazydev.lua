---@module "lazy"
---@type LazySpec
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '~/.config/nvim/' },
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}

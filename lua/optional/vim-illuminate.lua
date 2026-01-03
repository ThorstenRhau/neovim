---@module "lazy"
---@type LazySpec
return {
  'RRethy/vim-illuminate',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('illuminate').configure({
      providers = {
        'lsp',
        'treesitter',
        'regex',
      },
      delay = 500,
      filetypes_denylist = {
        'Trouble',
        'checkhealth',
        'help',
        'lazy',
        'mason',
        'oil',
        'trouble',
      },
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
      under_cursor = false,
      modes_allowlist = { 'n' },
    })
  end,
}

-- https://github.com/miikanissi/modus-themes.nvim/
---@module "lazy"
---@type LazySpec
return {
  'miikanissi/modus-themes.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('modus-themes').setup({
      style = 'auto',
      variant = 'tinted',
      transparent = false,
    })
    vim.cmd.colorscheme('modus')
  end,
}

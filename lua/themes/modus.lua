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
      variant = 'default', -- default, tinted, deuteranopia
      transparent = false,
      on_colors = function(colors)
        -- Override light variant background to light grey instead of pure white
        if colors.bg_main == '#ffffff' then
          colors.bg_main = '#f5f5f5'
        end
      end,
    })
    vim.cmd.colorscheme('modus')
  end,
}

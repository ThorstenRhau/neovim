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
          colors.bg_main = '#f0f0f0'
        end
        -- Override dark variant background to slightly lighter black
        if colors.bg_main == '#000000' then
          colors.bg_main = '#141414'
        end
      end,
      on_highlights = function(highlights, colors)
        -- Make indent lines subtle but visible
        highlights.IblIndent = { fg = colors.bg_active, nocombine = true }
        highlights.IblScope = { fg = colors.cyan_faint, nocombine = true }
      end,
    })
    vim.cmd.colorscheme('modus')
  end,
}

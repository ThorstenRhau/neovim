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
      line_nr_column_background = true,
      on_colors = function(colors)
        -- Override light (operandi) variant background
        -- to light grey instead of pure white
        if colors.bg_main == '#ffffff' then
          colors.bg_main = '#f5f5f5'
        end
        -- Override dark (vivendi) variant background
        -- to slightly lighter black
        if colors.bg_main == '#000000' then
          colors.bg_main = '#141414'
        end
      end,
      on_highlights = function(highlights, colors)
        -- Make indent lines subtle but visible
        highlights.IblIndent = { fg = colors.bg_active, nocombine = true }
        highlights.IblScope = { fg = colors.cyan_faint, nocombine = true }

        if colors.bg_main == '#f5f5f5' then
          -- Light mode color tweaks
          highlights.LineNrAbove = { fg = colors.fg_dim, bg = '#efefef' }
          highlights.LineNr = { fg = colors.fg_main, bg = '#efefef' }
          highlights.LineNrBelow = { fg = colors.fg_dim, bg = '#efefef' }
          highlights.SignColumn = { bg = '#efefef' }
        elseif colors.bg_main == '#141414' then
          -- Dark mode color tweaks
          highlights.LineNrAbove = { fg = colors.fg_dim, bg = '#242424' }
          highlights.LineNr = { fg = colors.fg_main, bg = '#242424' }
          highlights.LineNrBelow = { fg = colors.fg_dim, bg = '#242424' }
          highlights.SignColumn = { bg = '#242424' }
        end
      end,
    })
    vim.cmd.colorscheme('modus')
  end,
}

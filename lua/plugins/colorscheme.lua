-- https://github.com/rebelot/kanagawa.nvim

---@module "lazy"
---@type LazySpec
return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  ---@module "kanagawa"
  ---@type KanagawaConfig
  opts = {
    compile = true,
    background = {
      dark = 'wave',
      light = 'lotus',
    },
    overrides = function(colors)
      return {
        IblIndent = { fg = colors.theme.ui.bg_p2 },
        IblScope = { fg = colors.theme.ui.special },
      }
    end,
    colors = {
      palette = {
        -- Dark backgrounds (wave) — warm charcoal inspired by claude.ai
        sumiInk0 = '#191918', -- darkest (floats, statuslines)
        sumiInk1 = '#1d1d1d', -- bg_dim, bg_m2
        sumiInk2 = '#212120', -- bg_m1
        sumiInk3 = '#262624', -- main background
        sumiInk4 = '#2f2f2d', -- bg_p1, gutter
        sumiInk5 = '#383835', -- bg_p2, cursorline
        sumiInk6 = '#4f4f4d', -- nontext, whitespace

        -- Diff backgrounds (wave) — warm tints replacing cool blue originals
        winterGreen = '#292f26', -- diff add bg
        winterRed = '#362728', -- diff delete bg
        winterBlue = '#2b2b29', -- diff change/context bg
        winterYellow = '#444039', -- diff text bg

        -- Light backgrounds (lotus) — warm cream inspired by claude.ai
        lotusWhite0 = '#edece8', -- darkest light bg (floats)
        lotusWhite1 = '#f1f0ec', -- bg_dim, bg_m2
        lotusWhite2 = '#f5f4f1', -- bg_m1
        lotusWhite3 = '#faf9f5', -- main background
        lotusWhite4 = '#f0efeb', -- bg_p1, gutter
        lotusWhite5 = '#eae9e5', -- bg_p2, cursorline
      },
    },
  },
  config = function(_, opts)
    require('kanagawa').setup(opts)
    vim.cmd.colorscheme('kanagawa')

    -- Re-enable automatic background detection after initial colorscheme load
    local function parsecolor(c)
      -- Parse a color value (0-65535 range or hex)
      if c:match('^%x+$') then
        local val = tonumber(c, 16)
        if #c == 4 then
          return val / 65535
        elseif #c == 2 then
          return val / 255
        end
      end
      return nil
    end

    vim.api.nvim_create_autocmd('TermResponse', {
      group = vim.api.nvim_create_augroup('kanagawa_background_sync', { clear = true }),
      nested = true,
      desc = 'Update background based on terminal emulator response',
      callback = function(args)
        local resp = args.data.sequence
        local r, g, b = resp:match('^\027%]11;rgb:(%x+)/(%x+)/(%x+)')
        if r and g and b then
          local rr, gg, bb = parsecolor(r), parsecolor(g), parsecolor(b)
          if rr and gg and bb then
            local luminance = (0.299 * rr) + (0.587 * gg) + (0.114 * bb)
            local new_bg = luminance < 0.5 and 'dark' or 'light'
            if vim.o.background ~= new_bg then
              vim.o.background = new_bg
              vim.cmd.colorscheme('kanagawa')
            end
          end
        end
      end,
    })
  end,
}

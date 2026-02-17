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
    colors = {
      palette = {
        -- Dark backgrounds (wave) — warm charcoal inspired by claude.ai
        sumiInk0 = '#1e1d1b', -- darkest (floats, statuslines)
        sumiInk1 = '#222120', -- bg_dim, bg_m2
        sumiInk2 = '#262523', -- bg_m1
        sumiInk3 = '#2b2a27', -- main background
        sumiInk4 = '#343330', -- bg_p1, gutter
        sumiInk5 = '#3d3c38', -- bg_p2, cursorline
        sumiInk6 = '#545350', -- nontext, whitespace

        -- Diff backgrounds (wave) — warm tints replacing cool blue originals
        winterGreen = '#2e3329', -- diff add bg
        winterRed = '#3b2b2b', -- diff delete bg
        winterBlue = '#302f2c', -- diff change/context bg
        winterYellow = '#49443c', -- diff text bg

        -- Light backgrounds (lotus) — warm cream inspired by claude.ai
        lotusWhite0 = '#e8e2d6', -- darkest light bg (floats)
        lotusWhite1 = '#ece6da', -- bg_dim, bg_m2
        lotusWhite2 = '#f0eadf', -- bg_m1
        lotusWhite3 = '#f5efe3', -- main background
        lotusWhite4 = '#ebe5d9', -- bg_p1, gutter
        lotusWhite5 = '#e5dfd3', -- bg_p2, cursorline
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

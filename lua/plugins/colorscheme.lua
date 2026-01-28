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

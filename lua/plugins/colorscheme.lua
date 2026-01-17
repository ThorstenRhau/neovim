-- https://github.com/neanias/everforest-nvim

---@module "lazy"
---@type LazySpec
return {
  'neanias/everforest-nvim',
  name = 'everforest',
  lazy = false,
  priority = 1000,
  ---@module "everforest"
  ---@type Everforest.Config
  ---@diagnostic disable: missing-fields
  opts = {
    background = 'medium',
    transparent_background_level = 0,
    italics = true,
    disable_italic_comments = false,
    inlay_hints_background = 'dimmed',
    on_highlights = function(hl, palette)
      hl['@string.special.symbol.ruby'] = { link = '@field' }
      hl['DiagnosticUnderlineWarn'] = { undercurl = true, sp = palette.yellow }
    end,
  },
  config = function(_, opts)
    require('everforest').setup(opts)
    vim.cmd.colorscheme('everforest')

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
      group = vim.api.nvim_create_augroup('everforest_background_sync', { clear = true }),
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
              vim.cmd.colorscheme('everforest')
            end
          end
        end
      end,
    })
  end,
}

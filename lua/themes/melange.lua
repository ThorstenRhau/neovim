---@module "lazy"
---@type LazySpec
return {
  'savq/melange-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme('melange')

    -- Apply highlights when nvim-notify loads (it loads on VeryLazy)
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      callback = function(event)
        if event.data == 'nvim-notify' then
          -- Define highlight function
          local function apply_notify_highlights()
            local ok, palette = pcall(require, 'melange.palettes.' .. vim.o.background)
            if not ok then
              return
            end

            -- nvim-notify highlights
            vim.api.nvim_set_hl(0, 'NotifyINFOBody', { bg = palette.a.float, fg = palette.a.fg })
            vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { fg = palette.b.cyan })
            vim.api.nvim_set_hl(0, 'NotifyINFOTitle', { fg = palette.b.cyan, bold = true })
            vim.api.nvim_set_hl(0, 'NotifyINFOIcon', { fg = palette.b.cyan })

            vim.api.nvim_set_hl(0, 'NotifyWARNBody', { bg = palette.a.float, fg = palette.a.fg })
            vim.api.nvim_set_hl(0, 'NotifyWARNBorder', { fg = palette.b.yellow })
            vim.api.nvim_set_hl(0, 'NotifyWARNTitle', { fg = palette.b.yellow, bold = true })
            vim.api.nvim_set_hl(0, 'NotifyWARNIcon', { fg = palette.b.yellow })

            vim.api.nvim_set_hl(0, 'NotifyERRORBody', { bg = palette.a.float, fg = palette.a.fg })
            vim.api.nvim_set_hl(0, 'NotifyERRORBorder', { fg = palette.b.red })
            vim.api.nvim_set_hl(0, 'NotifyERRORTitle', { fg = palette.b.red, bold = true })
            vim.api.nvim_set_hl(0, 'NotifyERRORIcon', { fg = palette.b.red })

            vim.api.nvim_set_hl(0, 'NotifyDEBUGBody', { bg = palette.a.float, fg = palette.a.fg })
            vim.api.nvim_set_hl(0, 'NotifyDEBUGBorder', { fg = palette.c.magenta })
            vim.api.nvim_set_hl(0, 'NotifyDEBUGTitle', { fg = palette.c.magenta, bold = true })
            vim.api.nvim_set_hl(0, 'NotifyDEBUGIcon', { fg = palette.c.magenta })

            vim.api.nvim_set_hl(0, 'NotifyTRACEBody', { bg = palette.a.float, fg = palette.a.fg })
            vim.api.nvim_set_hl(0, 'NotifyTRACEBorder', { fg = palette.c.blue })
            vim.api.nvim_set_hl(0, 'NotifyTRACETitle', { fg = palette.c.blue, bold = true })
            vim.api.nvim_set_hl(0, 'NotifyTRACEIcon', { fg = palette.c.blue })

            vim.api.nvim_set_hl(0, 'NotifyBackground', { bg = palette.a.float })
          end

          -- Apply immediately
          apply_notify_highlights()

          -- Re-apply on colorscheme change (after nvim-notify resets defaults)
          vim.api.nvim_create_autocmd('ColorScheme', {
            pattern = 'melange',
            callback = apply_notify_highlights,
          })
        end
      end,
    })
  end,
}

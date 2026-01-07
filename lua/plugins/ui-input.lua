---@module "lazy"
---@type LazySpec
return {
  'MunifTanjim/nui.nvim',
  event = 'VeryLazy',
  config = function()
    local Input = require('nui.input')

    local input_ui

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(opts, on_confirm)
      assert(type(on_confirm) == 'function', 'missing on_confirm function')

      if input_ui then
        vim.notify('busy: another input is pending!', vim.log.levels.ERROR)
        return
      end

      opts = opts or {}

      local prompt_text = opts.prompt or 'Input'
      if prompt_text:sub(-1) == ':' then
        prompt_text = prompt_text:sub(1, -2)
      end
      prompt_text = '[' .. prompt_text .. ']'

      local default_value = tostring(opts.default or '')

      local function on_done(value)
        if not input_ui then
          return
        end
        local ui = input_ui
        input_ui = nil
        ui:unmount()
        on_confirm(value)
      end

      input_ui = Input({
        relative = 'cursor',
        position = { row = 1, col = 0 },
        size = { width = math.max(40, #default_value + 5) },
        border = {
          style = 'none',
          text = { top = prompt_text, top_align = 'left' },
        },
        win_options = {
          winhighlight = 'NormalFloat:Normal,FloatBorder:FloatBorder',
        },
      }, {
        prompt = '> ',
        default_value = default_value,
        on_close = function()
          on_done(nil)
        end,
        on_submit = function(value)
          on_done(value)
        end,
      })

      input_ui:map('n', '<Esc>', function()
        on_done(nil)
      end, { noremap = true, nowait = true })

      input_ui:map('n', 'q', function()
        on_done(nil)
      end, { noremap = true, nowait = true })

      input_ui:map('i', '<C-c>', function()
        on_done(nil)
      end, { noremap = true, nowait = true })

      input_ui:mount()
      vim.schedule(function()
        vim.cmd('startinsert!')
      end)
    end
  end,
}

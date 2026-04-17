local constants = require('config.constants')
local fzf = require('fzf-lua')

---@module "fzf-lua"
---@type fzf-lua.Config|{}
---@diagnostic disable: missing-fields
local opts = {
  'fzf-native',
  winopts = {
    height = 0.90,
    width = 0.90,
    row = 0.5,
    col = 0.5,
    border = constants.ui.border,
    backdrop = 60,
    treesitter = { enabled = true },
    preview = {
      border = constants.ui.border,
      flip_columns = 120,
      horizontal = 'right:55%',
      layout = 'flex',
      scrollbar = 'float',
      title_pos = 'center',
      vertical = 'down:65%',
      winopts = { number = false },
    },
  },
  oldfiles = {
    include_current_session = true,
  },
  defaults = {
    formatter = 'path.filename_first',
    file_icons = 'mini',
  },
  previewers = {
    builtin = {
      syntax_limit_b = 1024 * 100, -- 100KB
    },
  },
  -- Native previewers for special content (faster)
  manpages = { previewer = 'man_native' },
  helptags = { previewer = 'help_native' },
  keymap = {
    builtin = {
      true,
      ['<Esc>'] = 'hide',
      ['<C-d>'] = 'preview-page-down',
      ['<C-u>'] = 'preview-page-up',
    },
    fzf = {
      true,
      ['ctrl-q'] = 'select-all+accept',
    },
  },
  files = {
    follow = true,
    cwd_prompt = false,
    cwd_header = false,
    fzf_opts = {
      ['--tiebreak'] = 'pathname,chunk,begin',
    },
  },
  grep = {
    hidden = true,
  },
  command_history = {
    fzf_opts = { ['--scheme'] = 'history' },
  },
  search_history = {
    fzf_opts = { ['--scheme'] = 'history' },
  },
  git = {
    status = {
      winopts = {
        preview = {
          layout = 'vertical',
          vertical = 'up:60%', -- Diff on top, file list middle, input at bottom
        },
      },
    },
  },

  lsp = {
    code_actions = { previewer = 'codeaction_native' },
    symbols = {
      symbol_icons = {
        File = '󰈙 ',
        Module = '󰏗 ',
        Namespace = '󰅩 ',
        Package = '󰏗 ',
        Class = '󰠱 ',
        Method = '󰊕 ',
        Property = '󰜢 ',
        Field = '󰜢 ',
        Constructor = '󰒓 ',
        Enum = '󰜂 ',
        Interface = '󰜄 ',
        Function = '󰊕 ',
        Variable = '󰀫 ',
        Constant = '󰏿 ',
        String = '󰀬 ',
        Number = '󰎠 ',
        Boolean = '󰨙 ',
        Array = '󰅪 ',
        Object = '󰅩 ',
        Key = '󰌋 ',
        Null = '󰟢 ',
        EnumMember = '󰜃 ',
        Struct = '󰙅 ',
        Event = '󰜁 ',
        Operator = '󰆕 ',
        TypeParameter = '󰊄 ',
      },
    },
  },
}

fzf.setup(opts)

---@diagnostic enable: missing-fields

-- Register as vim.ui.select handler with auto-sizing
fzf.register_ui_select(function(_, items)
  local min_h, max_h = 0.15, 0.70
  local h = (#items + 4) / vim.o.lines
  h = math.max(min_h, math.min(max_h, h))
  return { winopts = { height = h, width = 0.50, row = 0.40 } }
end)

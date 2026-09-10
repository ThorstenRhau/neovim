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
  ui_select = function(_, items)
    local min_h, max_h = 0.15, 0.70
    local h = (#items + 4) / vim.o.lines
    h = math.max(min_h, math.min(max_h, h))
    return { winopts = { height = h, width = 0.50, row = 0.40 } }
  end,
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

local map = vim.keymap.set

local fzf_cmds = {
  { 'n', '<leader><space>', 'FzfLua files', 'files' },
  { 'n', '<leader>fb', 'FzfLua buffers', 'buffers' },
  { 'n', '<leader>ff', 'FzfLua files', 'find files' },
  { 'n', '<leader>fo', 'FzfLua oldfiles', 'recent files' },
  { 'n', '<leader>gs', 'FzfLua git_status', 'git status' },
  { 'n', '<leader>sD', 'FzfLua diagnostics_workspace', 'workspace diagnostics' },
  { 'n', '<leader>sd', 'FzfLua diagnostics_document', 'document diagnostics' },
  { 'n', '<leader>sg', 'FzfLua live_grep', 'grep' },
  { 'n', '<leader>sh', 'FzfLua helptags', 'help pages' },
  { 'n', '<leader>sp', 'FzfLua builtin', 'builtin pickers' },
}

for _, m in ipairs(fzf_cmds) do
  map(m[1], m[2], '<cmd>' .. m[3] .. '<cr>', { desc = m[4] })
end

---@diagnostic enable: missing-fields

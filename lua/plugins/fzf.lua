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
  { 'n', '<leader>:', 'FzfLua command_history', 'command history' },
  { 'n', '<leader><space>', 'FzfLua files', 'files' },
  { { 'n', 'v' }, '<leader>ca', 'FzfLua lsp_code_actions', 'code actions' },
  { 'n', '<leader>ci', 'FzfLua lsp_incoming_calls', 'incoming calls' },
  { 'n', '<leader>co', 'FzfLua lsp_outgoing_calls', 'outgoing calls' },
  { 'n', '<leader>cs', 'FzfLua lsp_finder', 'lsp finder' },
  { 'n', '<leader>fL', 'FzfLua lines', 'lines (all buffers)' },
  { 'n', '<leader>fS', 'FzfLua spellcheck', 'spellcheck document' },
  { 'n', '<leader>fT', 'FzfLua treesitter', 'treesitter symbols' },
  { 'n', '<leader>fW', 'FzfLua grep_cWORD', 'grep WORD' },
  { 'n', '<leader>fa', 'FzfLua args', 'args list' },
  { 'n', '<leader>fb', 'FzfLua buffers', 'buffers' },
  { 'n', '<leader>ff', 'FzfLua files', 'files' },
  { 'n', '<leader>fg', 'FzfLua git_files', 'git files' },
  { 'n', '<leader>fl', 'FzfLua blines', 'buffer lines' },
  { 'n', '<leader>fo', 'FzfLua oldfiles', 'recent files' },
  { 'n', '<leader>fr', 'FzfLua resume', 'resume last search' },
  { 'n', '<leader>fs', 'FzfLua spell_suggest', 'spelling suggestion' },
  { 'n', '<leader>ft', 'FzfLua tabs', 'tabs' },
  { 'v', '<leader>fv', 'FzfLua grep_visual', 'grep selection' },
  { 'n', '<leader>fw', 'FzfLua grep_cword', 'grep word' },
  { 'n', '<leader>gB', 'FzfLua git_blame', 'git blame' },
  { 'n', '<leader>gh', 'FzfLua git_bcommits', 'file history' },
  { 'n', '<leader>gS', 'FzfLua git_stash', 'git stash' },
  { 'n', '<leader>gb', 'FzfLua git_branches', 'git branches' },
  { 'n', '<leader>gc', 'FzfLua git_commits', 'git commits' },
  { 'n', '<leader>gs', 'FzfLua git_status', 'git status' },
  { 'n', '<leader>gt', 'FzfLua git_tags', 'git tags' },
  { 'n', '<leader>s/', 'FzfLua search_history', 'search history' },
  { 'n', '<leader>sC', 'FzfLua command_history', 'command history' },
  { 'n', '<leader>sD', 'FzfLua diagnostics_workspace', 'workspace diagnostics' },
  { 'n', '<leader>sH', 'FzfLua highlights', 'highlights' },
  { 'n', '<leader>sL', 'FzfLua loclist_stack', 'location stack' },
  { 'n', '<leader>sM', 'FzfLua man_pages', 'man pages' },
  { 'n', '<leader>sQ', 'FzfLua quickfix_stack', 'quickfix stack' },
  { 'n', '<leader>sS', 'FzfLua lsp_workspace_symbols', 'workspace symbols' },
  { 'n', '<leader>sU', 'FzfLua grep_loclist', 'grep loclist' },
  { 'n', '<leader>sa', 'FzfLua autocmds', 'autocommands' },
  { 'n', '<leader>sb', 'FzfLua lgrep_curbuf', 'grep buffer' },
  { 'n', '<leader>sc', 'FzfLua commands', 'commands' },
  { 'n', '<leader>sd', 'FzfLua diagnostics_document', 'document diagnostics' },
  { 'n', '<leader>s"', 'FzfLua registers', 'registers' },
  { 'n', '<leader>sf', 'FzfLua filetypes', 'filetypes' },
  { 'n', '<leader>sg', 'FzfLua live_grep', 'grep' },
  { 'n', '<leader>sh', 'FzfLua help_tags', 'help tags' },
  { 'n', '<leader>si', 'FzfLua lsp_live_workspace_symbols', 'live workspace symbols' },
  { 'n', '<leader>sj', 'FzfLua jumps', 'jumps' },
  { 'n', '<leader>sk', 'FzfLua keymaps', 'keymaps' },
  { 'n', '<leader>sl', 'FzfLua loclist', 'location list' },
  { 'n', '<leader>sm', 'FzfLua marks', 'marks' },
  { 'n', '<leader>sn', 'FzfLua changes', 'changes' },
  { 'n', '<leader>sT', 'FzfLua colorschemes', 'themes' },
  { 'n', '<leader>sp', 'FzfLua builtin', 'builtin pickers' },
  { 'n', '<leader>sq', 'FzfLua quickfix', 'quickfix list' },
  { 'n', '<leader>sr', 'FzfLua resume', 'resume last search' },
  { 'n', '<leader>ss', 'FzfLua lsp_document_symbols', 'document symbols' },
  { 'n', '<leader>st', 'FzfLua tagstack', 'tag stack' },
  { 'n', '<leader>su', 'FzfLua grep_quickfix', 'grep quickfix' },
  { 'n', '<leader>u', 'FzfLua undotree', 'undo-tree' },
  { 'n', 'gD', 'FzfLua lsp_declarations', 'go to declaration' },
  { 'n', 'gI', 'FzfLua lsp_implementations', 'implementations' },
  { 'n', 'gd', 'FzfLua lsp_definitions', 'go to definition' },
  { 'n', 'gr', 'FzfLua lsp_references', 'references' },
  { 'n', 'gy', 'FzfLua lsp_typedefs', 'type definition' },
}

for _, m in ipairs(fzf_cmds) do
  map(m[1], m[2], '<cmd>' .. m[3] .. '<cr>', { desc = m[4] })
end

map('n', '<leader>fm', function()
  local messages = vim.fn.execute('messages')
  fzf.fzf_exec(vim.split(messages, '\n'), {
    prompt = 'Messages❯ ',
    fzf_opts = {
      ['--no-multi'] = '',
      ['--layout'] = 'reverse-list',
    },
  })
end, { desc = 'messages' })

map('n', '<leader>sG', function()
  fzf.live_grep({ no_ignore = true })
end, { desc = 'grep (no ignore)' })

---@diagnostic enable: missing-fields

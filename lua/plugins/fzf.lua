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
    border = 'single',
    backdrop = 60,
    treesitter = { enabled = true },
    preview = {
      border = 'single',
      layout = 'flex',
      flip_columns = 120,
      horizontal = 'right:55%',
      vertical = 'down:65%',
      scrollbar = 'float',
      title_pos = 'center',
      delay = 20,
      winopts = { number = false },
    },
  },
  defaults = {
    formatter = 'path.filename_first',
    file_icons = 'mini',
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

-- Keymaps
local map = vim.keymap.set

map('n', '<leader>:', '<cmd>FzfLua command_history<cr>', { desc = 'command history' })
map('n', '<leader><space>', '<cmd>FzfLua files<cr>', { desc = 'files' })
map({ 'n', 'v' }, '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'code actions' })
map('n', '<leader>ci', '<cmd>FzfLua lsp_incoming_calls<cr>', { desc = 'incoming calls' })
map('n', '<leader>co', '<cmd>FzfLua lsp_outgoing_calls<cr>', { desc = 'outgoing calls' })
map('n', '<leader>cs', '<cmd>FzfLua lsp_finder<cr>', { desc = 'lsp finder' })
map('n', '<leader>fL', '<cmd>FzfLua lines<cr>', { desc = 'lines (all buffers)' })
map('n', '<leader>fS', '<cmd>FzfLua spellcheck<cr>', { desc = 'spellcheck document' })
map('n', '<leader>fT', '<cmd>FzfLua treesitter<cr>', { desc = 'treesitter symbols' })
map('n', '<leader>fW', '<cmd>FzfLua grep_cWORD<cr>', { desc = 'grep WORD' })
map('n', '<leader>fa', '<cmd>FzfLua args<cr>', { desc = 'args list' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'buffers' })
map('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'files' })
map('n', '<leader>fg', '<cmd>FzfLua git_files<cr>', { desc = 'git files' })
map('n', '<leader>fl', '<cmd>FzfLua blines<cr>', { desc = 'buffer lines' })
map('n', '<leader>fm', function()
  local messages = vim.fn.execute('messages')
  local lines = vim.split(messages, '\n')
  fzf.fzf_exec(lines, {
    prompt = 'Messages❯ ',
    fzf_opts = {
      ['--no-multi'] = '',
      ['--layout'] = 'reverse-list',
    },
  })
end, { desc = 'messages' })
map('n', '<leader>fo', '<cmd>FzfLua oldfiles<cr>', { desc = 'recent files' })
map('n', '<leader>fr', '<cmd>FzfLua resume<cr>', { desc = 'resume last search' })
map('n', '<leader>fs', '<cmd>FzfLua spell_suggest<cr>', { desc = 'spelling suggestion' })
map('n', '<leader>ft', '<cmd>FzfLua tabs<cr>', { desc = 'tabs' })
map('v', '<leader>fv', '<cmd>FzfLua grep_visual<cr>', { desc = 'grep selection' })
map('n', '<leader>fw', '<cmd>FzfLua grep_cword<cr>', { desc = 'grep word' })
map('n', '<leader>gB', '<cmd>FzfLua git_blame<cr>', { desc = 'git blame' })
map('n', '<leader>gC', '<cmd>FzfLua git_bcommits<cr>', { desc = 'git buffer commits' })
map('n', '<leader>gS', '<cmd>FzfLua git_stash<cr>', { desc = 'git stash' })
map('n', '<leader>gb', '<cmd>FzfLua git_branches<cr>', { desc = 'git branches' })
map('n', '<leader>gc', '<cmd>FzfLua git_commits<cr>', { desc = 'git commits' })
map('n', '<leader>gs', '<cmd>FzfLua git_status<cr>', { desc = 'git status' })
map('n', '<leader>gt', '<cmd>FzfLua git_tags<cr>', { desc = 'git tags' })
map('n', '<leader>s/', '<cmd>FzfLua search_history<cr>', { desc = 'search history' })
map('n', '<leader>sC', '<cmd>FzfLua command_history<cr>', { desc = 'command history' })
map('n', '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', { desc = 'workspace diagnostics' })
map('n', '<leader>sH', '<cmd>FzfLua highlights<cr>', { desc = 'highlights' })
map('n', '<leader>sL', '<cmd>FzfLua loclist_stack<cr>', { desc = 'location stack' })
map('n', '<leader>sM', '<cmd>FzfLua man_pages<cr>', { desc = 'man pages' })
map('n', '<leader>sQ', '<cmd>FzfLua quickfix_stack<cr>', { desc = 'quickfix stack' })
map('n', '<leader>sS', '<cmd>FzfLua lsp_workspace_symbols<cr>', { desc = 'workspace symbols' })
map('n', '<leader>sU', '<cmd>FzfLua grep_loclist<cr>', { desc = 'grep loclist' })
map('n', '<leader>sa', '<cmd>FzfLua autocmds<cr>', { desc = 'autocommands' })
map('n', '<leader>sb', '<cmd>FzfLua lgrep_curbuf<cr>', { desc = 'grep buffer' })
map('n', '<leader>sc', '<cmd>FzfLua commands<cr>', { desc = 'commands' })
map('n', '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', { desc = 'document diagnostics' })
map('n', '<leader>s"', '<cmd>FzfLua registers<cr>', { desc = 'registers' })
map('n', '<leader>sf', '<cmd>FzfLua filetypes<cr>', { desc = 'filetypes' })
map('n', '<leader>sG', function()
  fzf.live_grep({ no_ignore = true })
end, { desc = 'grep (no ignore)' })
map('n', '<leader>sg', '<cmd>FzfLua live_grep<cr>', { desc = 'grep' })
map('n', '<leader>sh', '<cmd>FzfLua help_tags<cr>', { desc = 'help tags' })
map('n', '<leader>si', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', { desc = 'live workspace symbols' })
map('n', '<leader>sj', '<cmd>FzfLua jumps<cr>', { desc = 'jumps' })
map('n', '<leader>sk', '<cmd>FzfLua keymaps<cr>', { desc = 'keymaps' })
map('n', '<leader>sl', '<cmd>FzfLua loclist<cr>', { desc = 'location list' })
map('n', '<leader>sm', '<cmd>FzfLua marks<cr>', { desc = 'marks' })
map('n', '<leader>sn', '<cmd>FzfLua changes<cr>', { desc = 'changes' })
map('n', '<leader>sT', '<cmd>FzfLua colorschemes<cr>', { desc = 'themes' })
map('n', '<leader>sp', '<cmd>FzfLua builtin<cr>', { desc = 'builtin pickers' })
map('n', '<leader>sq', '<cmd>FzfLua quickfix<cr>', { desc = 'quickfix list' })
map('n', '<leader>sr', '<cmd>FzfLua resume<cr>', { desc = 'resume last search' })
map('n', '<leader>ss', '<cmd>FzfLua lsp_document_symbols<cr>', { desc = 'document symbols' })
map('n', '<leader>st', '<cmd>FzfLua tagstack<cr>', { desc = 'tag stack' })
map('n', '<leader>su', '<cmd>FzfLua grep_quickfix<cr>', { desc = 'grep quickfix' })
map('n', '<leader>u', '<cmd>FzfLua undotree<cr>', { desc = 'undo-tree' })
map('n', 'gD', '<cmd>FzfLua lsp_declarations<cr>', { desc = 'go to declaration' })
map('n', 'gI', '<cmd>FzfLua lsp_implementations<cr>', { desc = 'implementations' })
map('n', 'gd', '<cmd>FzfLua lsp_definitions<cr>', { desc = 'go to definition' })
map('n', 'gr', '<cmd>FzfLua lsp_references<cr>', { desc = 'references' })
map('n', 'gy', '<cmd>FzfLua lsp_typedefs<cr>', { desc = 'type definition' })

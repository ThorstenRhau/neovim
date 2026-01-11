---@diagnostic disable: missing-fields
return {
  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  cmd = 'FzfLua',
  keys = {
    { '<leader>:', '<cmd>FzfLua command_history<cr>', desc = 'command history' },
    { '<leader><space>', '<cmd>FzfLua files<cr>', desc = 'files' },
    { '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', mode = { 'n', 'v' }, desc = 'code actions' },
    { '<leader>ci', '<cmd>FzfLua lsp_incoming_calls<cr>', desc = 'incoming calls' },
    { '<leader>co', '<cmd>FzfLua lsp_outgoing_calls<cr>', desc = 'outgoing calls' },
    { '<leader>cs', '<cmd>FzfLua lsp_finder<cr>', desc = 'lsp finder' },
    { '<leader>fL', '<cmd>FzfLua lines<cr>', desc = 'lines (all buffers)' },
    { '<leader>fS', '<cmd>FzfLua spellcheck<cr>', desc = 'spellcheck document' },
    { '<leader>fT', '<cmd>FzfLua treesitter<cr>', desc = 'treesitter symbols' },
    { '<leader>fW', '<cmd>FzfLua grep_cWORD<cr>', desc = 'grep word' },
    { '<leader>fa', '<cmd>FzfLua args<cr>', desc = 'args list' },
    { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = 'buffers' },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'files' },
    { '<leader>fg', '<cmd>FzfLua git_files<cr>', desc = 'git files' },
    { '<leader>fl', '<cmd>FzfLua blines<cr>', desc = 'buffer lines' },
    {
      '<leader>fm',
      function()
        local messages = vim.fn.execute('messages')
        local lines = vim.split(messages, '\n')
        require('fzf-lua').fzf_exec(lines, {
          prompt = 'Messages❯ ',
          fzf_opts = {
            ['--no-multi'] = '',
            ['--layout'] = 'reverse-list',
          },
        })
      end,
      desc = 'messages',
    },
    { '<leader>fo', '<cmd>FzfLua oldfiles<cr>', desc = 'recent files' },
    { '<leader>fr', '<cmd>FzfLua resume<cr>', desc = 'resume last search' },
    { '<leader>fs', '<cmd>FzfLua spell_suggest<cr>', desc = 'spelling suggestion' },
    { '<leader>ft', '<cmd>FzfLua tabs<cr>', desc = 'tabs' },
    { '<leader>fv', '<cmd>FzfLua grep_visual<cr>', mode = 'v', desc = 'grep selection' },
    { '<leader>fw', '<cmd>FzfLua grep_cword<cr>', desc = 'grep word' },
    { '<leader>gB', '<cmd>FzfLua git_blame<cr>', desc = 'git blame' },
    { '<leader>gC', '<cmd>FzfLua git_bcommits<cr>', desc = 'git buffer commits' },
    { '<leader>gS', '<cmd>FzfLua git_stash<cr>', desc = 'git stash' },
    { '<leader>gb', '<cmd>FzfLua git_branches<cr>', desc = 'git branches' },
    { '<leader>gc', '<cmd>FzfLua git_commits<cr>', desc = 'git commits' },
    { '<leader>gs', '<cmd>FzfLua git_status<cr>', desc = 'git status' },
    { '<leader>gt', '<cmd>FzfLua git_tags<cr>', desc = 'git tags' },
    { '<leader>s/', '<cmd>FzfLua search_history<cr>', desc = 'search history' },
    { '<leader>sC', '<cmd>FzfLua command_history<cr>', desc = 'command history' },
    { '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'workspace diagnostics' },
    { '<leader>sH', '<cmd>FzfLua highlights<cr>', desc = 'highlights' },
    { '<leader>sL', '<cmd>FzfLua loclist_stack<cr>', desc = 'location stack' },
    { '<leader>sM', '<cmd>FzfLua man_pages<cr>', desc = 'man pages' },
    { '<leader>sQ', '<cmd>FzfLua quickfix_stack<cr>', desc = 'quickfix stack' },
    { '<leader>sS', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = 'workspace symbols' },
    { '<leader>sU', '<cmd>FzfLua grep_loclist<cr>', desc = 'grep loclist' },
    { '<leader>sa', '<cmd>FzfLua autocmds<cr>', desc = 'autocommands' },
    { '<leader>sb', '<cmd>FzfLua lgrep_curbuf<cr>', desc = 'grep buffer' },
    { '<leader>sc', '<cmd>FzfLua commands<cr>', desc = 'commands' },
    { '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'document diagnostics' },
    { '<leader>se', '<cmd>FzfLua registers<cr>', desc = 'registers' },
    { '<leader>sf', '<cmd>FzfLua filetypes<cr>', desc = 'filetypes' },
    { '<leader>sg', '<cmd>FzfLua live_grep<cr>', desc = 'grep' },
    { '<leader>sh', '<cmd>FzfLua help_tags<cr>', desc = 'help tags' },
    { '<leader>si', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', desc = 'live workspace symbols' },
    { '<leader>sj', '<cmd>FzfLua jumps<cr>', desc = 'jumps' },
    { '<leader>sk', '<cmd>FzfLua keymaps<cr>', desc = 'keymaps' },
    { '<leader>sl', '<cmd>FzfLua loclist<cr>', desc = 'location list' },
    { '<leader>sm', '<cmd>FzfLua marks<cr>', desc = 'marks' },
    { '<leader>sn', '<cmd>FzfLua changes<cr>', desc = 'changes' },
    { '<leader>so', '<cmd>FzfLua colorschemes<cr>', desc = 'colorschemes' },
    { '<leader>sp', '<cmd>FzfLua builtin<cr>', desc = 'builtin pickers' },
    { '<leader>sq', '<cmd>FzfLua quickfix<cr>', desc = 'quickfix list' },
    { '<leader>sr', '<cmd>FzfLua resume<cr>', desc = 'resume last search' },
    { '<leader>ss', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'document symbols' },
    { '<leader>st', '<cmd>FzfLua tagstack<cr>', desc = 'tag stack' },
    { '<leader>su', '<cmd>FzfLua grep_quickfix<cr>', desc = 'grep quickfix' },
    { '<leader>u', '<cmd>FzfLua undotree<cr>', desc = 'undo-tree' },
    { 'gD', '<cmd>FzfLua lsp_declarations<cr>', desc = 'go to declaration' },
    { 'gI', '<cmd>FzfLua lsp_implementations<cr>', desc = 'implementations' },
    { 'gd', '<cmd>FzfLua lsp_definitions<cr>', desc = 'go to definition' },
    { 'gr', '<cmd>FzfLua lsp_references<cr>', desc = 'references' },
    { 'gy', '<cmd>FzfLua lsp_typedefs<cr>', desc = 'type definition' },
  },
  ---@module "fzf-lua"
  ---@type fzf-lua.config
  opts = {
    'default-title', -- Titles for picker windows
    fzf_opts = {
      ['--scheme'] = 'path',
    },
    ---@type fzf-lua.config.Winopts
    winopts = {
      height = 0.90,
      width = 0.90,
      row = 0.5,
      col = 0.5,
      border = 'single',
      backdrop = false,
      preview = {
        border = 'single',
        default = 'bat',
        layout = 'flex',
        flip_columns = 120,
        horizontal = 'right:65%',
        vertical = 'down:65%',
        delay = 50,
      },
    },
    ---@type fzf-lua.config.Previewers
    previewers = {
      builtin = {
        treesitter = { context = false },
      },
    },
    ---@type fzf-lua.config.Defaults
    defaults = {
      formatter = 'path.filename_first',
    },
    -- Native previewers for special content (faster)
    manpages = { previewer = 'man_native' },
    helptags = { previewer = 'help_native' },
    tags = { previewer = 'bat' },
    btags = { previewer = 'bat' },
    keymap = {
      builtin = {
        ['<Esc>'] = 'hide',
        ['<C-d>'] = 'preview-page-down',
        ['<C-u>'] = 'preview-page-up',
      },
      fzf = {
        ['ctrl-q'] = 'select-all+accept',
        ['ctrl-d'] = 'preview-page-down',
        ['ctrl-u'] = 'preview-page-up',
      },
    },
    files = {
      fd_opts = '--color=never --type f --hidden --follow --exclude .git',
      cwd_prompt = false,
      fzf_opts = {
        ['--tiebreak'] = 'pathname,chunk,begin',
      },
    },
    grep = {
      rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096',
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
    ---@type fzf-lua.config.Lsp
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
  },
  config = function(_, opts)
    local fzf = require('fzf-lua')
    fzf.setup(opts)
    -- Register as vim.ui.select handler with auto-sizing
    fzf.register_ui_select(function(_, items)
      local min_h, max_h = 0.15, 0.70
      local h = (#items + 4) / vim.o.lines
      h = math.max(min_h, math.min(max_h, h))
      return { winopts = { height = h, width = 0.50, row = 0.40 } }
    end)
  end,
}

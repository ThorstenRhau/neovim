return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'elanmed/fzf-lua-frecency.nvim' },
  event = 'VeryLazy',
  cmd = 'FzfLua',
  keys = {
    {
      '<leader>ff',
      function()
        require('fzf-lua-frecency').frecency({ cwd_only = true })
      end,
      desc = 'Find files (frecency)',
    },
    {
      '<leader><space>',
      function()
        require('fzf-lua-frecency').frecency({ cwd_only = true })
      end,
      desc = 'Find files (frecency)',
    },
    {
      '<leader>fF',
      function()
        require('fzf-lua-frecency').frecency()
      end,
      desc = 'Frecent files (all)',
    },
    {
      '<leader>fX',
      function()
        require('fzf-lua-frecency').clear_db()
        vim.notify('Frecency database cleared', vim.log.levels.INFO)
      end,
      desc = 'Clear frecency database',
    },
    { '<leader>/', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
    { '<leader>u', '<cmd>FzfLua undotree<cr>', desc = 'Undo' },
    { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = 'Buffers' },
    { '<leader>fo', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent files' },
    { '<leader>fg', '<cmd>FzfLua git_files<cr>', desc = 'Git files' },
    { '<leader>fw', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep word' },
    { '<leader>fW', '<cmd>FzfLua grep_cWORD<cr>', desc = 'Grep WORD' },
    { '<leader>fv', '<cmd>FzfLua grep_visual<cr>', mode = 'v', desc = 'Grep selection' },
    { '<leader>fr', '<cmd>FzfLua resume<cr>', desc = 'Resume last search' },

    -- LSP
    { 'gd', '<cmd>FzfLua lsp_definitions<cr>', desc = 'Go to definition' },
    { 'gr', '<cmd>FzfLua lsp_references<cr>', desc = 'References' },
    { 'gI', '<cmd>FzfLua lsp_implementations<cr>', desc = 'Implementations' },
    { 'gy', '<cmd>FzfLua lsp_typedefs<cr>', desc = 'Type definition' },
    { '<leader>ss', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'Document symbols' },
    { '<leader>sS', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = 'Workspace symbols' },
    { '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Document diagnostics' },
    { '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Workspace diagnostics' },
    { 'gD', '<cmd>FzfLua lsp_declarations<cr>', desc = 'Go to declaration' },
    { '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', mode = { 'n', 'v' }, desc = 'Code actions' },
    { '<leader>ci', '<cmd>FzfLua lsp_incoming_calls<cr>', desc = 'Incoming calls' },
    { '<leader>co', '<cmd>FzfLua lsp_outgoing_calls<cr>', desc = 'Outgoing calls' },
    { '<leader>cs', '<cmd>FzfLua lsp_finder<cr>', desc = 'LSP finder' },

    -- Git
    { '<leader>gb', '<cmd>FzfLua git_branches<cr>', desc = 'Git branches' },
    { '<leader>gc', '<cmd>FzfLua git_commits<cr>', desc = 'Git commits' },
    { '<leader>gC', '<cmd>FzfLua git_bcommits<cr>', desc = 'Git buffer commits' },
    { '<leader>gs', '<cmd>FzfLua git_status<cr>', desc = 'Git status' },

    -- Search
    { '<leader>sg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
    { '<leader>sh', '<cmd>FzfLua help_tags<cr>', desc = 'Help tags' },
    { '<leader>sk', '<cmd>FzfLua keymaps<cr>', desc = 'Keymaps' },
    { '<leader>sm', '<cmd>FzfLua marks<cr>', desc = 'Marks' },
    { '<leader>sj', '<cmd>FzfLua jumps<cr>', desc = 'Jumps' },
    { '<leader>sc', '<cmd>FzfLua commands<cr>', desc = 'Commands' },
    { '<leader>sC', '<cmd>FzfLua command_history<cr>', desc = 'Command history' },
    { '<leader>:', '<cmd>FzfLua command_history<cr>', desc = 'Command history' },
    { '<leader>sr', '<cmd>FzfLua resume<cr>', desc = 'Resume last search' },
  },
  opts = {
    -- Combining profiles for layout and performance options.
    { 'telescope', 'fzf-native' },
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
    },
    grep = {
      rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096',
    },
    git = {
      status = {
        winopts = {
          preview = {
            layout = 'vertical',
            vertical = 'up:60%',
          },
        },
      },
    },
    lsp = {
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
    -- Setup frecency (registers extension, creates autocommand for tracking)
    require('fzf-lua-frecency').setup({
      display_score = true,
      stat_file = true,
    })
  end,
}

return {
  {
    'abecodes/tabout.nvim',
    event = 'InsertEnter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      tabkey = '<Tab>',
      backwards_tabkey = '<S-Tab>',
      act_as_tab = true,
      act_as_shift_tab = false,
      enable_backwards = true,
      completion = true,
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = '`', close = '`' },
        { open = '(', close = ')' },
        { open = '[', close = ']' },
        { open = '{', close = '}' },
        { open = '<', close = '>' },
      },
      ignore_beginning = true,
      exclude = {},
    },
  },
  {
    'andymass/vim-matchup',
    event = 'BufReadPre',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_treesitter_stopline = 500
      vim.g.matchup_treesitter_include_match_words = false
      vim.g.matchup_treesitter_enable_quotes = true
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
      },
      exclude = {
        filetypes = {
          'help',
          'lazy',
          'mason',
          'neo-tree',
          'notify',
          'oil',
          'trouble',
        },
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown' },
    keys = {
      {
        '<leader>tm',
        function()
          require('render-markdown').toggle()
        end,
        desc = 'markdown render',
      },
    },
    opts = {
      pipe_table = { preset = 'round' },
      latex = { enabled = false },
    },
  },
  {
    'brianhuster/live-preview.nvim',
    dependencies = { 'ibhagwan/fzf-lua' },
    opts = {},
    keys = {
      { '<leader>tM', '<cmd>LivePreview start<cr>', desc = 'markdown in browser' },
      { '<leader>tQ', '<cmd>LivePreview close<cr>', desc = 'stop markdown preview' },
    },
  },
  {
    'uga-rosa/ccc.nvim',
    cmd = { 'CccPick', 'CccConvert', 'CccHighlighterToggle' },
    keys = {
      { '<leader>tC', '<cmd>CccHighlighterToggle<cr>', desc = 'color highlight' },
      { '<leader>cp', '<cmd>CccPick<cr>', desc = 'color picker' },
      { '<leader>cc', '<cmd>CccConvert<cr>', desc = 'convert color format' },
    },
    opts = {
      highlighter = {
        auto_enable = false,
        lsp = true,
      },
      highlight_mode = 'background',
      virtual_symbol = '●',
      virtual_pos = 'inline',
      recognize = {
        input = true,
        output = true,
      },
    },
  },
}

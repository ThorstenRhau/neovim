return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = '$',
        before_key = 'h',
        after_key = 'l',
        cursor_pos_before = true,
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        manual_position = true,
        highlight = 'Search',
        highlight_grey = 'Comment',
      },
    },
  },
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
    event = 'VeryLazy',
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
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
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown' },
    keys = {
      {
        '<leader>tm',
        function()
          require('render-markdown').toggle()
        end,
        desc = 'Toggle markdown render',
      },
    },
    opts = {
      pipe_table = { preset = 'round' },
      latex = { enabled = false },
    },
  },
  -- Color picker and highlighter
  {
    'uga-rosa/ccc.nvim',
    cmd = { 'CccPick', 'CccConvert', 'CccHighlighterToggle' },
    keys = {
      { '<leader>tC', '<cmd>CccHighlighterToggle<cr>', desc = 'Toggle color highlight' },
      { '<leader>cp', '<cmd>CccPick<cr>', desc = 'Color picker' },
      { '<leader>cc', '<cmd>CccConvert<cr>', desc = 'Convert color format' },
    },
    opts = {
      highlighter = {
        auto_enable = false,
        lsp = true,
      },
      highlight_mode = 'background',
      virtual_symbol = '●',
      virtual_pos = 'inline-left',
      recognize = {
        input = true,
        output = true,
      },
    },
  },
}

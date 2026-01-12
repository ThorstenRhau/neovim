return {
  -- Icons using modern material design
  {

    'nvim-mini/mini.icons',
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('mini.icons').setup()
      _G.MiniIcons.mock_nvim_web_devicons()
    end,
  },

  -- Align text interactively
  {
    'nvim-mini/mini.align',
    version = false,
    keys = {
      { 'ga', mode = { 'n', 'x' }, desc = 'align' },
      { 'gA', mode = { 'n', 'x' }, desc = 'align with preview' },
    },
    opts = {},
  },

  -- Split and join arguments
  {
    'nvim-mini/mini.splitjoin',
    version = false,
    keys = {
      { 'gS', mode = { 'n', 'x' }, desc = 'toggle split/join' },
      {
        '<leader>cj',
        function()
          require('mini.splitjoin').toggle()
        end,
        mode = { 'n', 'x' },
        desc = 'toggle split/join',
      },
    },
    opts = {},
  },

  -- Statusline
  {
    'nvim-mini/mini.statusline',
    version = false,
    event = 'VeryLazy',
    opts = {
      use_icons = true,
      content = {},
    },
  },
}

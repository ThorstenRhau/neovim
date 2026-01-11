return {
  -- Icons using modern material design
  {

    'echasnovski/mini.icons',
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
    'echasnovski/mini.align',
    version = false,
    keys = {
      { 'ga', mode = { 'n', 'x' }, desc = 'align' },
      { 'gA', mode = { 'n', 'x' }, desc = 'align with preview' },
    },
    opts = {},
  },

  -- Split and join arguments
  {
    'echasnovski/mini.splitjoin',
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
}

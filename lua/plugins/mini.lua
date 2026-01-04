return {
  -- Align text interactively
  {
    'echasnovski/mini.align',
    version = false,
    keys = {
      { 'ga', mode = { 'n', 'x' }, desc = 'Align' },
      { 'gA', mode = { 'n', 'x' }, desc = 'Align with preview' },
    },
    opts = {},
  },

  -- Split and join arguments
  {
    'echasnovski/mini.splitjoin',
    version = false,
    keys = {
      { 'gS', mode = { 'n', 'x' }, desc = 'Toggle split/join' },
      {
        '<leader>cj',
        function()
          require('mini.splitjoin').toggle()
        end,
        mode = { 'n', 'x' },
        desc = 'Toggle split/join',
      },
    },
    opts = {},
  },

  -- Jump within visible lines
  {
    'echasnovski/mini.jump2d',
    version = false,
    keys = {
      {
        '<leader>j',
        function()
          require('mini.jump2d').start()
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Jump 2D',
      },
    },
    opts = {
      mappings = { start_jumping = '' },
    },
  },

  -- Animate common Neovim actions
  {
    'echasnovski/mini.animate',
    version = false,
    event = 'VeryLazy',
    opts = {},
    config = function(_, opts)
      require('mini.animate').setup(opts)
      vim.keymap.set('n', '<leader>ta', function()
        vim.g.minianimate_disable = not vim.g.minianimate_disable
        if vim.g.minianimate_disable then
          vim.notify('Animations disabled', vim.log.levels.INFO)
        else
          vim.notify('Animations enabled', vim.log.levels.INFO)
        end
      end, { desc = 'Toggle animations' })
    end,
  },
}

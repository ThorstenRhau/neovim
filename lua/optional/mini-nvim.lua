---@module "lazy"
---@type LazySpec
return {
  {
    'echasnovski/mini.ai',
    version = false,
    event = 'VeryLazy',
    opts = {},
  },
  {
    'echasnovski/mini.align',
    version = false,
    keys = {
      { 'ga', mode = { 'n', 'v' }, desc = 'Align text' },
      { 'gA', mode = { 'n', 'v' }, desc = 'Align text interactive' },
    },
    opts = {},
  },
  {
    'echasnovski/mini.bracketed',
    version = false,
    event = 'VeryLazy',
    opts = {},
  },
  {
    'echasnovski/mini.comment',
    version = false,
    keys = {
      { 'gc', mode = { 'n', 'v' }, desc = 'Comment' },
      { 'gcc', mode = { 'n' }, desc = 'Comment line' },
    },
    opts = {},
  },
  {
    'echasnovski/mini.operators',
    version = false,
    keys = {
      { 'g=', mode = { 'n', 'v' }, desc = 'Evaluate' },
      { 'gx', mode = { 'n', 'v' }, desc = 'Exchange' },
      { 'gm', mode = { 'n', 'v' }, desc = 'Multiply' },
      { 'gr', mode = { 'n', 'v' }, desc = 'Replace' },
    },
    opts = {},
  },
  {
    'echasnovski/mini.pairs',
    version = false,
    event = 'InsertEnter',
    opts = {},
  },
  {
    'echasnovski/mini.splitjoin',
    version = false,
    keys = {
      {
        '<leader>cj',
        function()
          require('mini.splitjoin').toggle()
        end,
        desc = 'Split/Join text',
        mode = { 'n', 'v' },
      },
    },
    opts = {},
  },
  {
    'echasnovski/mini.surround',
    version = false,
    keys = {
      { 's', mode = { 'n', 'v' }, desc = 'Surround' },
    },
    opts = {},
  },
  {
    'echasnovski/mini.jump2d',
    version = false,
    keys = {
      {
        '<C-CR>',
        function()
          require('mini.jump2d').start()
        end,
        desc = 'MiniJump2d: start jumping',
        mode = { 'n' },
      },
    },
    opts = {
      mappings = { start_jumping = '' }, -- disable default <CR>
    },
  },
}

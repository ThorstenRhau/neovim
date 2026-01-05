return {
  'NickvanDyke/opencode.nvim',
  keys = {
    -- Toggle opencode terminal
    {
      '<leader>oo',
      function()
        require('opencode').toggle()
      end,
      desc = 'Toggle opencode',
    },
    {
      '<C-.>',
      function()
        require('opencode').toggle()
      end,
      mode = { 'n', 't' },
      desc = 'Toggle opencode',
    },

    -- Ask/prompt
    {
      '<leader>oa',
      function()
        require('opencode').ask()
      end,
      mode = { 'n', 'x' },
      desc = 'Ask opencode',
    },
    {
      '<leader>oA',
      function()
        require('opencode').ask('@this: ', { submit = true })
      end,
      mode = { 'n', 'x' },
      desc = 'Ask opencode about this',
    },

    -- Select from prompts/commands
    {
      '<leader>os',
      function()
        require('opencode').select()
      end,
      mode = { 'n', 'x' },
      desc = 'Select opencode action',
    },

    -- Operator for ranges
    {
      'go',
      function()
        return require('opencode').operator('@this ')
      end,
      expr = true,
      desc = 'Add range to opencode',
    },
    {
      'goo',
      function()
        return require('opencode').operator('@this ') .. '_'
      end,
      expr = true,
      desc = 'Add line to opencode',
    },

    -- Session controls
    {
      '<leader>on',
      function()
        require('opencode').command('session.new')
      end,
      desc = 'New session',
    },
    {
      '<leader>oi',
      function()
        require('opencode').command('session.interrupt')
      end,
      desc = 'Interrupt session',
    },
    {
      '<leader>ou',
      function()
        require('opencode').command('session.undo')
      end,
      desc = 'Undo',
    },
    {
      '<leader>or',
      function()
        require('opencode').command('session.redo')
      end,
      desc = 'Redo',
    },
  },
  config = function()
    -- Required for opts.events.reload
    vim.o.autoread = true

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      provider = {
        enabled = 'terminal',
        terminal = {
          split = 'right',
          width = math.floor(vim.o.columns * 0.4),
        },
      },
    }

    -- Terminal keymaps for opencode buffer
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = 'term://*opencode*',
      callback = function()
        local opts = { buffer = 0 }
        -- Exit terminal mode
        vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n><Cmd>wincmd h<CR>]], opts)
        -- Window navigation from terminal mode
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end,
    })
  end,
}

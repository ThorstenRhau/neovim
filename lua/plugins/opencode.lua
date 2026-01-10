return {
  'NickvanDyke/opencode.nvim',

  init = function()
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = 'term://*opencode*',
      callback = function()
        vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n><Cmd>wincmd h<CR>]], { buffer = 0 })
      end,
    })
  end,

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
        require('opencode').ask('', { submit = true })
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

    -- Focus opencode window
    {
      '<leader>of',
      function()
        -- Find and focus the opencode terminal window
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if buf_name:match('opencode') then
            vim.api.nvim_set_current_win(win)
            vim.cmd('startinsert')
            return
          end
        end
        -- If opencode window not found, toggle it open and enter insert mode
        require('opencode').toggle()
        vim.schedule(function()
          vim.cmd('startinsert')
        end)
      end,
      desc = 'Focus opencode',
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
  end,
}

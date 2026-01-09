return {
  'coder/claudecode.nvim',

  keys = {
    { '<leader>aa', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add buffer to Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude session' },
    { '<leader>aR', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude session' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>at', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Add tree file to Claude', ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles' } },
    { '<leader>aS', '<cmd>ClaudeCodeStatus<cr>', desc = 'Claude status' },
    { '<leader>ay', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept Claude diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny Claude diff' },
  },

  opts = {
    terminal = {
      split_side = 'right',
      split_width_percentage = 0.40,
      provider = 'native',
      auto_close = false,
    },
  },

  config = function(_, opts)
    require('claudecode').setup(opts)

    -- Terminal keymaps for claude buffer
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = 'term://*claude*',
      callback = function()
        local keymap_opts = { buffer = 0 }
        -- Exit terminal mode
        vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n><Cmd>wincmd h<CR><Cmd>stopinsert<CR>]], keymap_opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], keymap_opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], keymap_opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], keymap_opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], keymap_opts)
      end,
    })
  end,
}

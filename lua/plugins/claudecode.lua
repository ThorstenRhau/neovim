return {
  'coder/claudecode.nvim',

  init = function()
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = 'term://*claude*',
      callback = function()
        vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n><Cmd>wincmd h<CR>]], { buffer = 0 })
      end,
    })
  end,

  keys = {
    { '<leader>aa', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', mode = { 'n', 'v' }, desc = 'Focus Claude' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add buffer to Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude session' },
    { '<leader>aR', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude session' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    {
      '<leader>at',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add tree file to Claude',
      ft = { 'NvimTree', 'oil' },
    },
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
}

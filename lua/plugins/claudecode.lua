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
    { '<leader>aa', '<cmd>ClaudeCode<cr>', desc = 'toggle claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', mode = { 'n', 'v' }, desc = 'focus claude' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'send to claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'add buffer to claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'resume claude session' },
    { '<leader>aR', '<cmd>ClaudeCode --continue<cr>', desc = 'continue claude session' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'select claude model' },
    {
      '<leader>at',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'add tree file to claude',
      ft = { 'NvimTree', 'oil' },
    },
    { '<leader>aS', '<cmd>ClaudeCodeStatus<cr>', desc = 'claude status' },
    { '<leader>ay', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'accept claude diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'deny claude diff' },
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

---@module "lazy"
---@type LazySpec
return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  cmd = {
    'ClaudeCode',
    'ClaudeCodeFocus',
    'ClaudeCodeSelectModel',
    'ClaudeCodeSend',
    'ClaudeCodeAdd',
    'ClaudeCodeDiffAccept',
    'ClaudeCodeDiffDeny',
  },

  ---@type table
  opts = {
    port_range = { min = 10000, max = 65535 },
    auto_start = true,
    log_level = 'info',
    terminal_cmd = nil, -- Set to "~/.claude/local/claude" for local installation
    track_selection = true,
    terminal = {
      split_side = 'right',
      split_width_percentage = 0.30,
      provider = 'auto', -- Use snacks, native, external, or none
    },
  },

  keys = {
    -- stylua: ignore start
    { '<leader>aa', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Model' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = { 'n', 'v' }, desc = 'Send to Claude' },
    { '<leader>aA', function()
      local file = vim.fn.expand('%:p')
      vim.cmd('ClaudeCodeAdd ' .. file)
    end, desc = 'Add Current File to Context' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept Diff' },
    { '<leader>aD', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Reject Diff' },
    -- stylua: ignore end
  },
}

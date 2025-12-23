---@module "lazy"
---@type LazySpec
return {
  'coder/claudecode.nvim',
  cmd = {
    'ClaudeCode',
    'ClaudeCodeFocus',
    'ClaudeCodeSelectModel',
    'ClaudeCodeSend',
    'ClaudeCodeAdd',
    'ClaudeCodeDiffAccept',
    'ClaudeCodeDiffDeny',
  },

  opts = {
    -- Server configuration
    port_range = { min = 10000, max = 65535 },
    auto_start = true,
    log_level = 'info',
    terminal_cmd = nil, -- Set to "~/.claude/local/claude" for local installation

    -- Selection tracking
    track_selection = true,
    visual_demotion_delay_ms = 50,

    -- Terminal configuration
    terminal = {
      split_side = 'right',
      split_width_percentage = 0.35,
      provider = 'native',
      auto_close = true,
    },

    -- Diff integration
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
      open_in_current_tab = true,
      keep_terminal_focus = false,
    },
  },

  keys = {
    -- stylua: ignore start
    { '<leader>a', nil, desc = 'AI/Claude' },
    -- Terminal escape
    { '<Esc><Esc>', '<C-\\><C-n><C-w>h', mode = 't', desc = 'Exit terminal mode' },
    -- Core commands
    { '<leader>aa', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', mode = { 'n', 'x' }, desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume conversation' },
    { '<leader>ac', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue conversation' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select model' },
    -- Context management
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add buffer to context' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send selection' },
    -- Diff management
    { '<leader>ay', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>an', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    -- stylua: ignore end
  },
}

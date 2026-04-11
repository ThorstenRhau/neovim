local constants = require('config.constants')

-- Terminal escape for Claude Code terminals
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('claudecode_terminal', { clear = true }),
  pattern = 'term://*claude*',
  callback = function()
    vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n><Cmd>wincmd h<CR>]], { buffer = 0, desc = 'exit terminal mode' })
  end,
})

require('claudecode').setup({
  auto_start = not constants.is_headless,
  terminal = {
    split_side = 'right',
    split_width_percentage = 0.40,
    provider = 'native',
    show_native_term_exit_tip = true,
    auto_close = false,
  },
  diff_opts = {
    layout = 'vertical',
    open_in_new_tab = true,
    keep_terminal_focus = false,
    hide_terminal_in_new_tab = true,
    on_new_file_reject = 'keep_empty',
  },
})

local map = vim.keymap.set

map('n', '<leader>aa', '<cmd>ClaudeCode<cr>', { desc = 'toggle claude' })
map({ 'n', 'v' }, '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'focus claude' })
map('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'send to claude' })
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'add buffer to claude' })
map('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>', { desc = 'resume claude session' })
map('n', '<leader>aR', '<cmd>ClaudeCode --continue<cr>', { desc = 'continue claude session' })
map('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', { desc = 'select claude model' })
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('claudecode_tree_keymaps', { clear = true }),
  pattern = constants.filetypes.tree_views,
  callback = function(ev)
    vim.keymap.set(
      'n',
      '<leader>at',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      { buffer = ev.buf, desc = 'add tree file to claude' }
    )
  end,
})
map('n', '<leader>aS', '<cmd>ClaudeCodeStatus<cr>', { desc = 'claude status' })
map('n', '<leader>ay', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'accept claude diff' })
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'deny claude diff' })

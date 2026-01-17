return {
  dir = vim.fn.stdpath('config'),
  name = 'terminal',
  lazy = false,
  config = function()
    -- Built-in terminal toggle
    -- Simple horizontal terminal at the bottom of the window

    local term_buf = nil
    local term_win = nil

    local function get_height()
      return math.floor(vim.o.lines * 0.3)
    end

    local function open_terminal()
      -- Create a horizontal split at the bottom
      vim.cmd('botright split')
      vim.cmd('resize ' .. get_height())

      if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        -- Reuse existing terminal buffer
        vim.api.nvim_win_set_buf(0, term_buf)
      else
        -- Create new terminal
        vim.cmd('terminal')
        term_buf = vim.api.nvim_get_current_buf()
      end

      term_win = vim.api.nvim_get_current_win()
      vim.cmd('startinsert')
    end

    local function close_terminal()
      if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_close(term_win, true)
      end
      term_win = nil
    end

    local function toggle_terminal()
      if term_win and vim.api.nvim_win_is_valid(term_win) then
        close_terminal()
      else
        open_terminal()
      end
    end

    -- Terminal keymaps (applied to all terminals except fzf-lua)
    vim.api.nvim_create_autocmd('TermOpen', {
      group = vim.api.nvim_create_augroup('terminal_keymaps', { clear = true }),
      callback = function()
        -- Skip fzf-lua buffers (they handle their own keymaps)
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match('fzf') or bufname:match('claude') or bufname:match('opencode') then
          return
        end

        vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]], { buffer = 0, desc = 'exit terminal mode' })
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { buffer = 0, desc = 'go to left window' })
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { buffer = 0, desc = 'go to lower window' })
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { buffer = 0, desc = 'go to upper window' })
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { buffer = 0, desc = 'go to right window' })
      end,
    })

    vim.keymap.set('n', '<leader>tt', toggle_terminal, { desc = 'terminal' })
  end,
}

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

    local function is_terminal_alive(buf)
      if not buf or not vim.api.nvim_buf_is_valid(buf) then
        return false
      end
      local chan = vim.bo[buf].channel
      return chan and chan > 0 and vim.fn.jobwait({ chan }, 0)[1] == -1
    end

    local function open_terminal()
      if is_terminal_alive(term_buf) then
        -- Reuse existing terminal buffer directly
        vim.cmd('botright sbuffer ' .. term_buf)
      else
        -- Clean up dead buffer if it exists
        if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
          vim.api.nvim_buf_delete(term_buf, { force = true })
        end
        vim.cmd('botright split | terminal')
        term_buf = vim.api.nvim_get_current_buf()
      end

      vim.cmd('resize ' .. get_height())
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
        if bufname:match('fzf') or bufname:match('claude') then
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

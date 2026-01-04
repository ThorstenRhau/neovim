return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<C-\\>', '<cmd>ToggleTerm<cr>', desc = 'Toggle terminal' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Float terminal' },
    { '<leader>th', '<cmd>ToggleTerm direction=horizontal size=15<cr>', desc = 'Horizontal terminal' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical size=80<cr>', desc = 'Vertical terminal' },
  },
  opts = {
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = true,
    float_opts = {
      border = 'rounded',
      winblend = 0,
    },
    winbar = {
      enabled = false,
    },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    -- Terminal keymaps
    local function set_terminal_keymaps()
      local map = vim.keymap.set
      local term_opts = { buffer = 0 }
      map('t', '<esc><esc>', [[<C-\><C-n>]], term_opts)
      map('t', '<C-h>', [[<Cmd>wincmd h<CR>]], term_opts)
      map('t', '<C-j>', [[<Cmd>wincmd j<CR>]], term_opts)
      map('t', '<C-k>', [[<Cmd>wincmd k<CR>]], term_opts)
      map('t', '<C-l>', [[<Cmd>wincmd l<CR>]], term_opts)
    end

    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = 'term://*toggleterm#*',
      callback = function()
        set_terminal_keymaps()
      end,
    })

    -- Lazygit terminal
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = 'lazygit',
      dir = 'git_dir',
      direction = 'float',
      float_opts = {
        border = 'rounded',
      },
      on_open = function(_)
        vim.cmd('startinsert!')
      end,
    })

    vim.keymap.set('n', '<leader>gl', function()
      lazygit:toggle()
    end, { desc = 'Lazygit' })
  end,
}

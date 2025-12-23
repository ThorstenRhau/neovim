---@module "lazy"
---@type LazySpec
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = { 'ToggleTerm', 'TermExec' },
  keys = {
    { '<leader>t', '<cmd>ToggleTerm direction=horizontal<cr>', desc = 'Terminal' },
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
    direction = 'float',
    float_opts = {
      border = 'rounded',
      width = function()
        return math.floor(vim.o.columns * 0.85)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.8)
      end,
    },
    shade_terminals = true,
    shading_factor = 2,
    persist_size = true,
    persist_mode = true,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    -- Better terminal navigation
    vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = 'Move to left window' })
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = 'Move to lower window' })
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = 'Move to upper window' })
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = 'Move to right window' })
  end,
}

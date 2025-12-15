---@module "lazy"
---@type LazySpec
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  event = 'VeryLazy',
  init = function()
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require('nvim-treesitter-textobjects').setup({
      select = {
        lookahead = true,
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    })

    local select = require('nvim-treesitter-textobjects.select')
    local move = require('nvim-treesitter-textobjects.move')
    local swap = require('nvim-treesitter-textobjects.swap')

    -- Select textobjects
    vim.keymap.set({ 'x', 'o' }, 'af', function()
      select.select_textobject('@function.outer', 'textobjects')
    end, { desc = 'Select around function' })

    vim.keymap.set({ 'x', 'o' }, 'if', function()
      select.select_textobject('@function.inner', 'textobjects')
    end, { desc = 'Select inner function' })

    vim.keymap.set({ 'x', 'o' }, 'ac', function()
      select.select_textobject('@class.outer', 'textobjects')
    end, { desc = 'Select around class' })

    vim.keymap.set({ 'x', 'o' }, 'ic', function()
      select.select_textobject('@class.inner', 'textobjects')
    end, { desc = 'Select inner class' })

    vim.keymap.set({ 'x', 'o' }, 'aa', function()
      select.select_textobject('@parameter.outer', 'textobjects')
    end, { desc = 'Select around parameter' })

    vim.keymap.set({ 'x', 'o' }, 'ia', function()
      select.select_textobject('@parameter.inner', 'textobjects')
    end, { desc = 'Select inner parameter' })

    -- Move to next/previous function
    vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
      move.goto_next_start('@function.outer', 'textobjects')
    end, { desc = 'Next function start' })

    vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
      move.goto_previous_start('@function.outer', 'textobjects')
    end, { desc = 'Previous function start' })

    vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
      move.goto_next_end('@function.outer', 'textobjects')
    end, { desc = 'Next function end' })

    vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
      move.goto_previous_end('@function.outer', 'textobjects')
    end, { desc = 'Previous function end' })

    -- Move to next/previous class
    vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
      move.goto_next_start('@class.outer', 'textobjects')
    end, { desc = 'Next class start' })

    vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
      move.goto_previous_start('@class.outer', 'textobjects')
    end, { desc = 'Previous class start' })

    vim.keymap.set({ 'n', 'x', 'o' }, ']C', function()
      move.goto_next_end('@class.outer', 'textobjects')
    end, { desc = 'Next class end' })

    vim.keymap.set({ 'n', 'x', 'o' }, '[C', function()
      move.goto_previous_end('@class.outer', 'textobjects')
    end, { desc = 'Previous class end' })

    -- Move to next/previous parameter
    vim.keymap.set({ 'n', 'x', 'o' }, ']a', function()
      move.goto_next_start('@parameter.outer', 'textobjects')
    end, { desc = 'Next parameter' })

    vim.keymap.set({ 'n', 'x', 'o' }, '[a', function()
      move.goto_previous_start('@parameter.outer', 'textobjects')
    end, { desc = 'Previous parameter' })

    -- Swap parameters
    vim.keymap.set('n', '<leader>a', function()
      swap.swap_next('@parameter.inner')
    end, { desc = 'Swap with next parameter' })

    vim.keymap.set('n', '<leader>A', function()
      swap.swap_previous('@parameter.inner')
    end, { desc = 'Swap with previous parameter' })
  end,
}

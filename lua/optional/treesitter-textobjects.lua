---@module "lazy"
---@type LazySpec
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  config = function()
    -- Setup textobjects modules
    require('nvim-treesitter-textobjects').setup({
      select = {
        lookahead = true,
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    })

    -- Text object selection keymaps
    local vks = vim.keymap.set
    local select = require('nvim-treesitter-textobjects.select')
    vks({ 'x', 'o' }, 'af', function()
      select.select_textobject('@function.outer', 'textobjects')
    end, { desc = 'Around function' })
    vks({ 'x', 'o' }, 'if', function()
      select.select_textobject('@function.inner', 'textobjects')
    end, { desc = 'Inside function' })
    vks({ 'x', 'o' }, 'ac', function()
      select.select_textobject('@class.outer', 'textobjects')
    end, { desc = 'Around class' })
    vks({ 'x', 'o' }, 'ic', function()
      select.select_textobject('@class.inner', 'textobjects')
    end, { desc = 'Inside class' })
    vks({ 'x', 'o' }, 'aa', function()
      select.select_textobject('@parameter.outer', 'textobjects')
    end, { desc = 'Around argument' })
    vks({ 'x', 'o' }, 'ia', function()
      select.select_textobject('@parameter.inner', 'textobjects')
    end, { desc = 'Inside argument' })
    vks({ 'x', 'o' }, 'ai', function()
      select.select_textobject('@conditional.outer', 'textobjects')
    end, { desc = 'Around conditional' })
    vks({ 'x', 'o' }, 'ii', function()
      select.select_textobject('@conditional.inner', 'textobjects')
    end, { desc = 'Inside conditional' })
    vks({ 'x', 'o' }, 'al', function()
      select.select_textobject('@loop.outer', 'textobjects')
    end, { desc = 'Around loop' })
    vks({ 'x', 'o' }, 'il', function()
      select.select_textobject('@loop.inner', 'textobjects')
    end, { desc = 'Inside loop' })

    -- Movement keymaps using repeatable_move
    local ts_repeat = require('nvim-treesitter-textobjects.repeatable_move')
    local move = require('nvim-treesitter-textobjects.move')

    -- Make movements repeatable with ; and ,
    vks({ 'n', 'x', 'o' }, ';', ts_repeat.repeat_last_move_next)
    vks({ 'n', 'x', 'o' }, ',', ts_repeat.repeat_last_move_previous)

    -- Make f, F, t, T repeatable
    vks({ 'n', 'x', 'o' }, 'f', ts_repeat.builtin_f_expr, { expr = true })
    vks({ 'n', 'x', 'o' }, 'F', ts_repeat.builtin_F_expr, { expr = true })
    vks({ 'n', 'x', 'o' }, 't', ts_repeat.builtin_t_expr, { expr = true })
    vks({ 'n', 'x', 'o' }, 'T', ts_repeat.builtin_T_expr, { expr = true })

    -- Function navigation with ]]/[[
    vks({ 'n', 'x', 'o' }, ']]', function()
      move.goto_next_start('@function.outer', 'textobjects')
    end, { desc = 'Next function start' })
    vks({ 'n', 'x', 'o' }, '[[', function()
      move.goto_previous_start('@function.outer', 'textobjects')
    end, { desc = 'Prev function start' })
    vks({ 'n', 'x', 'o' }, '][', function()
      move.goto_next_end('@function.outer', 'textobjects')
    end, { desc = 'Next function end' })
    vks({ 'n', 'x', 'o' }, '[]', function()
      move.goto_previous_end('@function.outer', 'textobjects')
    end, { desc = 'Prev function end' })

    -- Class navigation with ]C/[C (lowercase c is used by mini.bracketed for comments)
    vks({ 'n', 'x', 'o' }, ']C', function()
      move.goto_next_start('@class.outer', 'textobjects')
    end, { desc = 'Next class start' })
    vks({ 'n', 'x', 'o' }, '[C', function()
      move.goto_previous_start('@class.outer', 'textobjects')
    end, { desc = 'Prev class start' })

    -- Swap keymaps with <leader>cs prefix
    local swap = require('nvim-treesitter-textobjects.swap')
    vks('n', '<leader>csp', function()
      swap.swap_next('@parameter.inner')
    end, { desc = 'Swap param next' })
    vks('n', '<leader>csP', function()
      swap.swap_previous('@parameter.inner')
    end, { desc = 'Swap param prev' })
    vks('n', '<leader>csf', function()
      swap.swap_next('@function.outer')
    end, { desc = 'Swap function next' })
    vks('n', '<leader>csF', function()
      swap.swap_previous('@function.outer')
    end, { desc = 'Swap function prev' })
  end,
}

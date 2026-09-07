-- Treesitter
require('nvim-treesitter').setup({
  install_dir = vim.fn.stdpath('data') .. '/site',
})

-- jsonc uses the json parser
vim.treesitter.language.register('json', { 'jsonc' })

-- zsh uses the bash parser
vim.treesitter.language.register('bash', { 'zsh' })

-- Use native filetype indentation; Treesitter only supplies highlighting and folds.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= '' or vim.bo[ev.buf].filetype == '' then
      return
    end
    if not pcall(vim.treesitter.start, ev.buf) then
      return
    end
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.b[ev.buf].undo_ftplugin = (vim.b[ev.buf].undo_ftplugin or '')
      .. '|call v:lua.vim.treesitter.stop()'
      .. '|setlocal foldmethod< foldexpr<'
  end,
})

-- Textobjects (selection handled by mini.ai, movement by treesitter-textobjects)
require('nvim-treesitter-textobjects').setup({
  move = {
    set_jumps = true,
  },
})

local map = vim.keymap.set

-- Movement
map({ 'n', 'x', 'o' }, ']f', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
end, { desc = 'next function start' })
map({ 'n', 'x', 'o' }, '[f', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'previous function start' })
map({ 'n', 'x', 'o' }, ']F', function()
  require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
end, { desc = 'next function end' })
map({ 'n', 'x', 'o' }, '[F', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
end, { desc = 'previous function end' })
map({ 'n', 'x', 'o' }, ']k', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
end, { desc = 'next class start' })
map({ 'n', 'x', 'o' }, '[k', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
end, { desc = 'previous class start' })
map({ 'n', 'x', 'o' }, ']K', function()
  require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
end, { desc = 'next class end' })
map({ 'n', 'x', 'o' }, '[K', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
end, { desc = 'previous class end' })

-- Context
require('treesitter-context').setup({
  line_numbers = true,
  max_lines = 3,
  min_window_height = 20,
})

map('n', 'gC', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { desc = 'go to context' })

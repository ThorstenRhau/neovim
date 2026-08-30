-- Treesitter
require('nvim-treesitter').setup({
  install_dir = vim.fn.stdpath('data') .. '/site',
})

-- jsonc uses the json parser
vim.treesitter.language.register('json', { 'jsonc' })

-- zsh uses the bash parser
vim.treesitter.language.register('bash', { 'zsh' })

local parsers = {
  'bash',
  'css',
  'diff',
  'editorconfig',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'go',
  'gomod',
  'gosum',
  'gotmpl',
  'gowork',
  'hcl',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'latex',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'rust',
  'scss',
  'swift',
  'toml',
  'tsx',
  'typescript',
  'typst',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
  'yang',
}

local function start_treesitter_for_loaded_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == '' and vim.bo[bufnr].filetype ~= '' then
      vim.api.nvim_buf_call(bufnr, function()
        require('config.ftplugin').treesitter()
      end)
    end
  end
end

-- Install parsers after startup, then retry activation for buffers that opened before their parser was available.
vim.schedule(function()
  require('nvim-treesitter').install(parsers):await(function()
    vim.schedule(start_treesitter_for_loaded_buffers)
  end)
end)

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

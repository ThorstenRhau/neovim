---@module "lazy"
---@type LazySpec
return {
  'marcinjahn/gemini-cli.nvim',
  dependencies = { 'folke/snacks.nvim' },
  cmd = { 'Gemini' },
  keys = {
    { '<leader>a/', '<cmd>Gemini toggle<cr>', desc = 'Toggle Gemini CLI' },
    { '<leader>aa', '<cmd>Gemini ask<cr>', desc = 'Ask Gemini', mode = { 'n', 'v' } },
    { '<leader>af', '<cmd>Gemini add_file<cr>', desc = 'Gemini Add File' },
  },
  opts = {},
}

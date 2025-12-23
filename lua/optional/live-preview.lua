---@module "lazy"
---@type LazySpec
return {
  'brianhuster/live-preview.nvim',
  ft = { 'markdown', 'html', 'asciidoc', 'svg' },
  dependencies = {
    'ibhagwan/fzf-lua',
  },
  ---@module 'live-preview'
  ---@type LivePreviewConfig
  opts = {
    picker = 'fzf-lua',
  },
  keys = {
    { '<leader>uMs', '<cmd>LivePreview start<cr>', desc = 'Start Live Preview' },
    { '<leader>uMc', '<cmd>LivePreview close<cr>', desc = 'Close Live Preview' },
    { '<leader>uMp', '<cmd>LivePreview pick<cr>', desc = 'Pick File to Preview' },
  },
}

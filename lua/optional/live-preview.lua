---@module "lazy"
---@type LazySpec
return {
  'brianhuster/live-preview.nvim',
  ft = { 'markdown', 'html' },
  dependencies = {
    'ibhagwan/fzf-lua',
  },
  ---@module 'live-preview'
  ---@type LivePreviewConfig
  opts = {
    picker = 'fzf-lua',
  },
  keys = {
    { '<leader>ums', '<cmd>LivePreview start<cr>', desc = 'Start Live Preview' },
    { '<leader>umc', '<cmd>LivePreview close<cr>', desc = 'Close Live Preview' },
    { '<leader>ump', '<cmd>LivePreview pick<cr>', desc = 'Pick File to Preview' },
  },
}

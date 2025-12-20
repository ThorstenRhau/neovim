---@module "lazy"
---@type LazySpec
return {
  'j-hui/fidget.nvim',
  event = 'VeryLazy',
  opts = {
    notification = {
      override_vim_notify = true,
      window = {
        winblend = 0,
      },
      configs = {
        format = { name = 'Format', icon = '󰉶', ttl = 3 },
        lint = { name = 'Lint', icon = '', ttl = 3 },
      },
    },
  },
  keys = {
    { '<leader>un', '<cmd>Fidget clear<cr>', desc = 'Dismiss All Notifications' },
    { '<leader>n', '<cmd>Fidget history<cr>', desc = 'Notification History' },
  },
}

---@module "lazy"
---@type LazySpec
return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  cmd = {
    'CodeCompanion',
    'CodeCompanionActions',
    'CodeCompanionChat',
    'CodeCompanionCmd',
  },
  keys = {
    { '<leader>ci', '<cmd>CodeCompanion<cr>', desc = 'CodeCompanion Inline Assistant' },
    { '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'CodeCompanion Chat Buffer' },
    { '<leader>cx', '<cmd>CodeCompanionCmd<cr>', desc = 'CodeCompanion CMD Generator' },
    { '<leader>cX', '<cmd>CodeCompanionActions<cr>', desc = 'CodeCompanion Actions Palette' },
  },
  opts = {

    adapters = {
      http = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            env = { api_key = vim.env.OPENAI_API_KEY },
            opts = {
              stream = true,
              -- verbosity = 'low',
              -- reasoning_effort = 'low', -- Allowed options are: high, medium, low, none
            },
            schema = {
              model = {
                default = 'gpt-5-nano',
              },
              params = {
                temperature = 0.2,
                max_output_tokens = 8192,
              },
            },
          })
        end,
      },
    },

    strategies = {
      chat = { adapter = 'openai' },
      inline = { adapter = 'openai' },
      cmd = { adapter = 'openai' },
    },
  },
}

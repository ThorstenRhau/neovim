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
      openai = function()
        return require('codecompanion.adapters').extend('openai', {
          env = { api_key = vim.env.OPENAI_API_KEY },
          parameters = {
            model = 'gpt-4.1-mini',
            temperature = 0.1,
            stream = true,
            max_tokens = 8192,
            top_p = 1,
            presence_penalty = 0,
            frequency_penalty = 0,
          },
        })
      end,
    },
    strategies = {
      chat = { adapter = 'openai' },
      inline = { adapter = 'openai' },
      cmd = { adapter = 'openai' },
    },
  },
}

-- Toggle virtual text for diagnostics
local function toggle_virtual_text()
  local current_value = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current_value })
  vim.notify('Virtual text ' .. (current_value and 'disabled' or 'enabled'))
end

-- Toggle virtual lines for diagnostics
local function toggle_virtual_lines()
  local current_value = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = not current_value })
  vim.notify('Virtual lines ' .. (current_value and 'disabled' or 'enabled'))
end

-- List active linters for the current filetype
local function ListActiveLinters()
  local ok, lint = pcall(require, 'lint')
  if not ok then
    vim.notify('nvim-lint is not available.', vim.log.levels.WARN)
    return
  end

  local linters = lint.linters_by_ft[vim.bo.filetype]
  if linters then
    vim.notify("Active linters for '" .. vim.bo.filetype .. "': " .. table.concat(linters, ', '))
  else
    vim.notify("No active linters for filetype '" .. vim.bo.filetype .. "'.", vim.log.levels.INFO)
  end
end

---@module "lazy"
---@type LazySpec
return {
  'folke/which-key.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    preset = 'modern',
    delay = 1000,
    spec = {
      -- Root menu
      { '<leader>,', '<cmd>b#<CR>', desc = 'Switch buffer', icon = { icon = '󰯍 ', color = 'yellow' } },
      { '<leader>l', '<cmd>Lazy<cr>', desc = 'Lazy - plugin manager' },
      { '<leader>m', '<cmd>Mason<cr>', desc = 'Mason - package manager', icon = '󰏖 ' },
      { '<leader>o', '<cmd>Oil --float<cr>', desc = 'Oil - file explorer', icon = { icon = '󰏇 ', color = 'grey' } },
      {
        '<leader>S',
        function()
          local ok, persistence = pcall(require, 'persistence')
          if ok then
            persistence.load({ last = true })
          end
        end,
        desc = 'Restore Last Session',
      },

      -- Code tools
      { '<leader>c', group = 'Code' },
      { '<leader>cA', '<cmd>LspInfo<CR>', desc = 'LSP Info' },
      { '<leader>cF', '<cmd>ConformInfo<CR>', desc = 'Formatters' },
      { '<leader>cL', ListActiveLinters, desc = 'Linters' },

      -- Claude Code
      { '<leader>a', group = 'Claude', icon = { icon = '󱙺 ', color = 'purple' } },

      -- Fuzzy finding / search
      { '<leader>f', group = 'Find', icon = { icon = '󰍉 ', color = 'azure' } },
      { '<leader>s', group = 'Search', icon = { icon = '󰍉 ', color = 'azure' } },

      -- Git tools
      { '<leader>g', group = 'Git' },
      { '<leader>gh', group = 'Git Hunk (Gitsigns)' },

      -- UI toggles and enhancements
      { '<leader>u', group = 'Interface', icon = { icon = '󰕮 ', color = 'azure' } },
      { '<leader>uC', '<cmd>ColorizerToggle<CR>', desc = 'Toggle colorizer' },
      { '<leader>uH', '<cmd>set list!<CR>', desc = 'Toggle hidden characters' },
      { '<leader>uk', '<cmd>set cursorline!<CR>', desc = 'Toggle cursor line' },
      { '<leader>uM', group = 'Live Preview (browser)' },
      { '<leader>up', '<cmd>PickColor<CR>', desc = 'Color picker' },
      { '<leader>uV', toggle_virtual_text, desc = 'Toggle virtual text' },
      { '<leader>uv', toggle_virtual_lines, desc = 'Toggle virtual lines' },

      -- Window management
      { '<leader>b', group = 'Buffer', icon = { icon = ' ', color = 'blue' } },
      { '<leader>bc', '<cmd>close<cr>', desc = 'Close window' },
      { '<leader>bh', '<cmd>split<cr>', desc = 'Split horizontally' },
      { '<leader>bo', '<cmd>only<cr>', desc = 'Keep only current window' },
      { '<leader>bv', '<cmd>vsplit<cr>', desc = 'Split vertically' },
      { '<leader>bX', '<cmd>bufdo bd<cr>', desc = 'Close all buffers' },

      -- Trouble group (placeholder if used elsewhere)
      { '<leader>q', group = 'Session', icon = { icon = ' ', color = 'blue' } },

      -- Trouble group (placeholder if used elsewhere)
      { '<leader>x', group = 'Trouble', icon = { icon = '󰨰 ', color = 'orange' } },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}

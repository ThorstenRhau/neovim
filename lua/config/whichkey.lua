-- Toggle virtual text for diagnostics
local function toggle_virtual_text()
  local current_value = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current_value })
  print('Virtual text ' .. (current_value and 'disabled' or 'enabled'))
end

-- Toggle virtual lines for diagnostics
local function toggle_virtual_lines()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end

-- List active linters for the current filetype
local function ListActiveLinters()
  local ok, lint = pcall(require, 'lint')
  if not ok then
    print('nvim-lint is not available.')
    return
  end

  local linters = lint.linters_by_ft[vim.bo.filetype]
  if linters then
    print("Active linters for filetype '" .. vim.bo.filetype .. "':")
    for _, linter in ipairs(linters) do
      print(linter)
    end
  else
    print("No active linters for filetype '" .. vim.bo.filetype .. "'.")
  end
end

-- Register mappings with which-key
local wk = require('which-key')

wk.add({
  -- Root menu
  { '<leader>,', '<cmd>b#<CR>', desc = 'Switch buffer', icon = { icon = '󰯍 ', color = 'yellow' } },
  { '<leader>l', '<cmd>Lazy<cr>', desc = 'Lazy - plugin manager' },
  { '<leader>m', '<cmd>Mason<cr>', desc = 'Mason - package manager', icon = '󰏖 ' },
  { '<leader>o', '<cmd>Oil --float<cr>', desc = 'Oil - file explorer', icon = { icon = '󰏇 ', color = 'grey' } },
  {
    '<leader>S',
    function()
      require('persistence').load({ last = true })
    end,
    desc = 'Restore Last Session',
  },
  { '<leader>T', '<cmd>Trouble<cr>', desc = 'Trouble', icon = { icon = ' ', color = 'red' } },

  -- Buffer management
  { '<leader>b', group = 'Buffer', icon = { icon = ' ', color = 'blue' } },
  { '<leader>bb', '<cmd>b#<CR>', desc = 'Switch buffer', icon = { icon = '󰯍 ', color = 'yellow' } },
  {
    '<leader>bd',
    function()
      local ok, snacks = pcall(require, 'snacks')
      if ok then
        snacks.bufdelete()
      end
    end,
    desc = 'Delete buffer',
  },
  {
    '<leader>bO',
    function()
      local ok, snacks = pcall(require, 'snacks')
      if ok then
        snacks.bufdelete.other()
      end
    end,
    desc = 'Delete all other buffers',
  },
  {
    '<leader>bX',
    function()
      local ok, snacks = pcall(require, 'snacks')
      if ok then
        snacks.bufdelete.all()
      end
    end,
    desc = 'Delete all buffers',
  },

  -- Code tools
  { '<leader>c', group = 'Code' },
  { '<leader>cA', '<cmd>LspInfo<CR>', desc = 'LSP Info' },
  { '<leader>cF', '<cmd>ConformInfo<CR>', desc = 'Formatters' },
  { '<leader>cL', ListActiveLinters, desc = 'Linters' },

  -- Fuzzy finding / search
  { '<leader>f', group = 'Find', icon = { icon = '󰍉 ', color = 'azure' } },
  { '<leader>s', group = 'Search', icon = { icon = '󰍉 ', color = 'azure' } },

  -- Git tools
  { '<leader>g', group = 'Git' },
  { '<leader>gg', '<cmd>Neogit<cr>', desc = 'NeoGit' },
  { '<leader>gh', group = 'Git Hunk (Gitsigns)' },

  -- GPT or AI tools
  { '<C-g>', group = 'GPT', desc = 'GPT tools' },

  -- UI toggles and enhancements
  { '<leader>u', group = 'Interface', icon = { icon = ' ', color = 'azure' } },
  { '<leader>uC', '<cmd>ColorizerToggle<CR>', desc = 'Toggle colorizer' },
  { '<leader>uH', '<cmd>set list!<CR>', desc = 'Toggle hidden characters' },
  { '<leader>ui', '<cmd>IlluminateToggle<cr>', desc = 'Toggle illumination' },
  { '<leader>uk', '<cmd>set cursorline!<CR>', desc = 'Toggle cursor line' },
  { '<leader>um', '<cmd>Markview toggle<cr>', desc = 'Toggle markdown preview' },
  { '<leader>up', '<cmd>PickColor<CR>', desc = 'Color picker' },
  { '<leader>ut', '<cmd>TodoLocList<cr>', desc = 'Todo list' },
  { '<leader>uV', toggle_virtual_text, desc = 'Toggle virtual text' },
  { '<leader>uv', toggle_virtual_lines, desc = 'Toggle virtual lines' },

  -- Window management
  { '<leader>w', group = 'Window' },
  { '<leader>wc', '<cmd>close<cr>', desc = 'Close window' },
  { '<leader>wh', '<cmd>split<cr>', desc = 'Split horizontally' },
  { '<leader>wo', '<cmd>only<cr>', desc = 'Keep only current window' },
  { '<leader>wv', '<cmd>vsplit<cr>', desc = 'Split vertically' },

  -- Trouble group (placeholder if used elsewhere)
  { '<leader>x', group = 'Trouble', icon = { icon = '󰨰 ', color = 'orange' } },
})

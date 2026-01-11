local constants = require('config.constants')

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
  end
end

return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
      delay = 200,
      spec = {
        { '<leader>a', group = 'claude' },
        { '<leader>b', group = 'buffer' },
        { '<leader>c', group = 'code' },
        { '<leader>f', group = 'file/find' },
        { '<leader>g', group = 'git' },
        { '<leader>h', group = 'hunk' },
        { '<leader>o', group = 'opencode' },
        { '<leader>q', group = 'project/session' },
        { '<leader>s', group = 'search' },
        { '<leader>t', group = 'toggle' },
        { '<leader>w', group = 'window' },
        { '<leader>x', group = 'diagnostics' },
        { 'g', group = 'goto' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
      },
      icons = {
        mappings = false,
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    opts = {
      options = {
        theme = 'auto',
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { 'lazy', 'mason', 'oil' },
        },
      },
      sections = {
        lualine_a = { 'mode', 'searchcount', 'selectioncount' },
        lualine_b = {
          { 'branch', icon = '' },
          { 'diff', source = diff_source },
        },
        lualine_c = {
          {
            'filename',
            path = 1,
            symbols = {
              modified = '●',
              readonly = '',
              unnamed = '[No Name]',
            },
          },
          {
            'diagnostics',
            symbols = constants.diagnostic_symbols,
          },
        },
        lualine_x = {
          'lsp_status',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        'lazy',
        'mason',
        'oil',
        'trouble',
        'fzf',
        'nvim-dap-ui',
        'quickfix',
      },
    },
  },
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {
      focus = true,
      auto_close = true,
    },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'diagnostics' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'buffer diagnostics' },
      { '<leader>xs', '<cmd>Trouble symbols toggle<cr>', desc = 'symbols' },
      { '<leader>xl', '<cmd>Trouble lsp toggle<cr>', desc = 'lsp references' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'location list' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'quickfix list' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            ---@diagnostic disable-next-line: missing-fields, missing-parameter
            require('trouble').prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'previous trouble/quickfix item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            ---@diagnostic disable-next-line: missing-fields, missing-parameter
            require('trouble').next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'next trouble/quickfix item',
      },
    },
  },
  {
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>ts', '<cmd>SmearCursorToggle<cr>', desc = 'cursor smear' },
    },
    opts = {
      smear_insert_mode = false,
      legacy_computing_symbols_support = true,
    },
  },
  {
    'karb94/neoscroll.nvim',
    event = 'VeryLazy',
    opts = {
      easing = 'sine',
    },
  },
}

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
      delay = 300,
      spec = {
        { '<leader>f', group = 'file/find' },
        { '<leader>s', group = 'search' },
        { '<leader>g', group = 'git' },
        { '<leader>c', group = 'code' },
        { '<leader>h', group = 'hunk' },
        { '<leader>t', group = 'toggle' },
        { '<leader>tS', group = 'spell lang' },
        { '<leader>o', group = 'opencode' },
        { '<leader>q', group = 'project/session' },
        { '<leader>x', group = 'diagnostics' },
        { '<leader>b', group = 'buffer' },
        { '<leader>w', group = 'window' },
        { 'g', group = 'goto' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
      },
      icons = {
        breadcrumb = '»',
        separator = '➜',
        group = '+',
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
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
          { 'branch', icon = '' },
          { 'diff', source = diff_source },
        },
        lualine_c = {
          {
            'filename',
            path = 1,
            symbols = {
              modified = '●',
              readonly = '',
              unnamed = '[No Name]',
            },
          },
          {
            'diagnostics',
            symbols = {
              error = '󰅚',
              warn = '󰀪',
              info = '󰋽',
              hint = '󰌵',
            },
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
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      focus = true,
    },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer diagnostics' },
      { '<leader>xs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols' },
      { '<leader>xl', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP references' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix list' },
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
        desc = 'Previous trouble/quickfix item',
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
        desc = 'Next trouble/quickfix item',
      },
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

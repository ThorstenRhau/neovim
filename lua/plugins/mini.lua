-- https://github.com/nvim-mini/mini.nvim
return {
  -- Icons using modern material design
  {

    'nvim-mini/mini.icons',
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('mini.icons').setup()
      _G.MiniIcons.mock_nvim_web_devicons()
    end,
  },

  -- Align text interactively
  {
    'nvim-mini/mini.align',
    version = false,
    keys = {
      { 'ga', mode = { 'n', 'x' }, desc = 'align' },
      { 'gA', mode = { 'n', 'x' }, desc = 'align with preview' },
    },
    opts = {},
  },

  -- Split and join arguments
  {
    'nvim-mini/mini.splitjoin',
    version = false,
    keys = {
      { 'gS', mode = { 'n', 'x' }, desc = 'toggle split/join' },
      {
        '<leader>cj',
        function()
          require('mini.splitjoin').toggle()
        end,
        mode = { 'n', 'x' },
        desc = 'split/join',
      },
    },
    opts = {},
  },

  -- Extended a/i textobjects
  {
    'nvim-mini/mini.ai',
    version = false,
    event = 'BufReadPost',
    opts = {},
  },

  -- Surround actions (sa=add, sd=delete, sr=replace)
  {
    'nvim-mini/mini.surround',
    version = false,
    event = 'BufReadPost',
    opts = {},
  },

  -- Auto-pairs
  {
    'nvim-mini/mini.pairs',
    version = false,
    event = 'InsertEnter',
    opts = {},
  },

  -- Bracket navigation ([b/]b=buffer, [c/]c=comment, [d/]d=diagnostic, etc.)
  {
    'nvim-mini/mini.bracketed',
    version = false,
    event = 'BufReadPost',
    opts = {},
  },

  -- Move selected text with meta+hjkl
  {
    'nvim-mini/mini.move',
    version = false,
    event = 'BufReadPost',
    opts = {},
  },

  -- Statusline
  {
    'nvim-mini/mini.statusline',
    version = false,
    event = 'UIEnter',
    opts = {
      use_icons = true,
      content = {
        active = function()
          local constants = require('config.constants')
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diff = MiniStatusline.section_diff({ trunc_width = 75 })
          local diagnostics = MiniStatusline.section_diagnostics({
            trunc_width = 75,
            signs = {
              ERROR = constants.diagnostic_symbols.error,
              WARN = constants.diagnostic_symbols.warn,
              INFO = constants.diagnostic_symbols.info,
              HINT = constants.diagnostic_symbols.hint,
            },
          })
          local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

          -- Custom location section with lualine-style formatting
          local location = (function()
            if MiniStatusline.is_truncated(75) then
              return '%l│%2v'
            end
            return '%P %l│%2v'
          end)()

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
            '%<',
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=',
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          })
        end,
      },
    },
  },
}

---@module "lazy"
---@type LazySpec
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1100,

    ---@module 'catppuccin'
    ---@type CatppuccinOptions
    opts = {
      compile = {
        enabled = true,
        path = vim.fn.stdpath('cache') .. '/catppuccin',
      },
      background = {
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.10,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        booleans = { 'bold' },
        comments = { 'italic' },
        conditionals = { 'bold' },
        constants = {},
        functions = { 'bold' },
        keywords = { 'bold' },
        loops = { 'bold' },
        numbers = {},
        operators = {},
        properties = {},
        strings = {},
        types = { 'bold' },
        variables = {},
      },
      integrations = {
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          underlines = {
            errors = { 'undercurl' },
            hints = { 'underdotted' },
            warnings = { 'underline' },
            information = { 'underdashed' },
          },
          inlay_hints = {
            background = true,
          },
        },
        blink_cmp = { enabled = true, style = 'bordered' },
        dap = true,
        dap_ui = true,
        diffview = true,
        gitsigns = true,
        indent_blankline = {
          enabled = true,
          scope_color = 'lavender',
          colored_indent_levels = false,
        },
        lsp_trouble = true,
        markdown = true,
        markview = true,
        mason = true,
        mini = true,
        neogit = true,
        oil = true,
        semantic_tokens = true,
        snacks = true,
        noice = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}

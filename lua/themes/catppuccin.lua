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
      color_overrides = {
        mocha = {
          -- Base colors
          base = '#292522',
          mantle = '#34302C',
          crust = '#211E1C',
          -- Surface colors
          surface0 = '#403A36',
          surface1 = '#5A524C',
          surface2 = '#867462',
          -- Overlay colors
          overlay0 = '#9A8A7A',
          overlay1 = '#AE9D8C',
          overlay2 = '#C1A78E',
          -- Text colors
          subtext0 = '#D4C4B4',
          subtext1 = '#E0D2C5',
          text = '#ECE1D7',
          -- Accent colors
          rosewater = '#EBC9B4',
          flamingo = '#B380B0',
          pink = '#CF9BC2',
          mauve = '#A3A9CE',
          red = '#D47766',
          maroon = '#BD8183',
          peach = '#E49B5D',
          yellow = '#EBC06D',
          green = '#85B695',
          teal = '#78997A',
          sky = '#89B3B6',
          sapphire = '#7B9695',
          blue = '#7F91B2',
          lavender = '#A3A9CE',
        },
        latte = {
          -- Base colors
          base = '#F1F1F1',
          mantle = '#E9E1DB',
          crust = '#D9D3CE',
          -- Surface colors
          surface0 = '#CEC7C1',
          surface1 = '#C0B5AC',
          surface2 = '#A98A78',
          -- Overlay colors
          overlay0 = '#9A7B68',
          overlay1 = '#8B6C5A',
          overlay2 = '#7D6658',
          -- Text colors
          subtext0 = '#6A5548',
          subtext1 = '#5F4C40',
          text = '#54433A',
          -- Accent colors
          rosewater = '#D4A088',
          flamingo = '#BE79BB',
          pink = '#904180',
          mauve = '#465AA4',
          red = '#BF0021',
          maroon = '#C77B8B',
          peach = '#BC5C00',
          yellow = '#A06D00',
          green = '#3A684A',
          teal = '#6E9B72',
          sky = '#3D6568',
          sapphire = '#739797',
          blue = '#7892BD',
          lavender = '#465AA4',
        },
      },
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
        fzf = true,
        gitsigns = true,
        illuminate = {
          enabled = true,
          lsp = true,
        },
        indent_blankline = {
          enabled = true,
          scope_color = 'text',
          colored_indent_levels = false,
        },
        lsp_trouble = true,
        mason = true,
        mini = true,
        neogit = true,
        noice = true,
        notify = true,
        oil = true,
        render_markdown = true,
        semantic_tokens = true,
        snacks = true,
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

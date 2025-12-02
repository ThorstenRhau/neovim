-- Determine preferred theme style from vim.o.background
local function get_preferred_style()
  return vim.o.background == 'light' and 'latte' or 'mocha'
end

local preferred_style = get_preferred_style()

---@type LazySpec
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1100,
    opts = {
      flavour = preferred_style, -- latte, frappe, macchiato, mocha
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
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = { 'italic' },
        constants = { 'bold' },
        functions = { 'bold' },
        keywords = { 'italic' },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = { 'bold' },
        operators = {},
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
        blink_cmp = true,
        dap = true,
        dap_ui = true,
        diffview = true,
        gitsigns = true,
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = true,
        neogit = true,
        noice = true,
        notify = true,
        oil = true,
        semantic_tokens = true,
        snacks = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
}

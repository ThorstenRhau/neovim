-- Determine preferred theme style from macOS appearance
local function get_preferred_style()
  if vim.fn.executable('defaults') == 0 then
    return 'mocha' -- Default to dark
  end

  local result = vim.fn.system('defaults read -g AppleInterfaceStyle'):match('^%s*(.-)%s*$')
  return result == 'Dark' and 'mocha' or 'latte'
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
        conditionals = {},
        loops = {},
        constants = { 'bold' },
        functions = { 'bold', 'italic' },
        keywords = { 'italic' },
        strings = {},
        variables = { 'bold' },
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
        illuminate = {
          enabled = true,
          lsp = false,
        },
        cmp = true,
        diffview = true,
        fzf = true,
        gitsigns = true,
        lsp_trouble = true,
        mason = true,
        neogit = true,
        noice = true,
        notify = true,
        pounce = true,
        semantic_tokens = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
}

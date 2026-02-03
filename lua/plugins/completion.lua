return {
  'saghen/blink.cmp',
  version = '1.*',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  opts = {
    fuzzy = {
      implementation = 'prefer_rust',
    },
    keymap = { preset = 'super-tab' },
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = {
        menu = { auto_show = true },
        ghost_text = { enabled = true },
      },
    },
    sources = {
      default = { 'lsp', 'snippets', 'path', 'buffer' },
      per_filetype = {
        lua = { inherit_defaults = true, 'lazydev' },
      },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100, -- show at top of suggestions
        },
      },
    },
    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = 'single',
        },
      },
      menu = {
        scrollbar = true,
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'kind' },
          },
        },
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        border = 'single',
      },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
  },
}

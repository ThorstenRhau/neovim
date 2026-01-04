return {
  'saghen/blink.cmp',
  version = '1.*',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  opts = {
    keymap = { preset = 'super-tab' },
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = {
        menu = { auto_show = true },
        ghost_text = { enabled = true },
      },
    },
    sources = {
      default = { 'lazydev', 'lsp', 'snippets', 'path', 'buffer' },
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
          border = 'rounded',
        },
      },
      menu = {
        border = 'rounded',
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
        border = 'rounded',
      },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
  },
}

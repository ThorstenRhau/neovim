return {
  'saghen/blink.cmp',
  version = '1.*',
  event = 'InsertEnter',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  opts = {
    keymap = {
      preset = 'none',
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          elseif cmp.is_visible() then
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
    },
    sources = {
      default = { 'lsp', 'snippets', 'path', 'buffer' },
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

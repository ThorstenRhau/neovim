---@module "lazy"
---@type LazySpec
return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '*',
  event = { 'InsertEnter', 'CmdlineEnter' },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'normal',
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        update_delay_ms = 50,
        treesitter_highlighting = true,
        window = { border = 'rounded' },
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      menu = {
        border = 'rounded',
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind' },
          },
          treesitter = { 'lsp' },
        },
      },
    },

    -- My super-TAB configuration
    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = {
        function(cmp)
          return cmp.select_next()
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = {
        function(cmp)
          return cmp.select_prev()
        end,
        'snippet_backward',
        'fallback',
      },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-up>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-down>'] = { 'scroll_documentation_down', 'fallback' },
    },

    -- Experimental signature help support
    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },

    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          -- Make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
        lsp = {
          min_keyword_length = 2, -- Number of characters to trigger provider
          score_offset = 0, -- Boost/penalize the score of the items
        },
        path = {
          min_keyword_length = 0,
        },
        snippets = {
          min_keyword_length = 2,
        },
        buffer = {
          min_keyword_length = 4,
          max_items = 5,
        },
      },
    },
  },
}

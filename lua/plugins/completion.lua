local constants = require('config.constants')

local function is_colon_cmdline()
  return vim.fn.getcmdtype() == ':' or vim.fn.getcmdwintype() == ':'
end

require('blink.cmp').setup({
  fuzzy = {
    implementation = 'prefer_rust',
  },
  keymap = { preset = 'super-tab' },
  cmdline = {
    keymap = {
      preset = 'cmdline',
      ['<Tab>'] = {
        function(cmp)
          if not is_colon_cmdline() then
            return
          end
          if cmp.is_menu_visible() then
            return cmp.accept()
          end
          return cmp.show()
        end,
        'fallback',
      },
      ['<S-Tab>'] = {
        function(cmp)
          if is_colon_cmdline() then
            return cmp.show_and_insert_or_accept_single({ initial_selected_item_idx = -1 })
          end
        end,
        function(cmp)
          if is_colon_cmdline() then
            return cmp.select_prev()
          end
        end,
        'fallback',
      },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
    },
    sources = function()
      if is_colon_cmdline() then
        return { 'buffer', 'cmdline' }
      end
      return {}
    end,
    completion = {
      menu = { auto_show = is_colon_cmdline },
      ghost_text = { enabled = is_colon_cmdline },
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
        border = constants.ui.border,
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
        preselect = function()
          return not require('blink.cmp').snippet_active({ direction = 1 })
        end,
        auto_insert = false,
      },
    },
  },
  signature = {
    enabled = true,
    window = {
      border = constants.ui.border,
    },
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
})

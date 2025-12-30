---@module "lazy"
---@type LazySpec
return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  event = { 'InsertEnter', 'CmdlineEnter' },

  keys = {
    {
      '<leader>ua',
      function()
        vim.b.completion = vim.b.completion == false
        vim.notify('Autocompletion ' .. (vim.b.completion and 'enabled' or 'disabled'))
      end,
      desc = 'Toggle blink-cmp',
    },
  },

  config = function(_, opts)
    require('blink.cmp').setup(opts)
    vim.api.nvim_set_hl(0, 'BlinkCmpLabelDeprecated', { strikethrough = true })
  end,

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'super-tab' },
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = {
        menu = { auto_show = true },
        ghost_text = { enabled = true },
      },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      ghost_text = { enabled = true },
      keyword = { range = 'full' },
      list = { selection = { preselect = true, auto_insert = false } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        treesitter_highlighting = true,
        window = { border = 'rounded' },
      },
      menu = {
        border = 'rounded',
        -- Determining if the completion menu expands upwards or downwards
        ---@diagnostic disable-next-line: assign-type-mismatch
        direction_priority = function()
          local ctx = require('blink.cmp').get_context()
          local item = require('blink.cmp').get_selected_item()
          if ctx == nil or item == nil then
            return { 's', 'n' }
          end
          local item_text = (item.textEdit and item.textEdit.newText) or item.insertText or item.label or ''
          local is_multi_line = item_text:find('\n') ~= nil
          if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
            vim.g.blink_cmp_upwards_ctx_id = ctx.id
            return { 'n', 's' }
          end
          return { 's', 'n' }
        end,
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind' },
            { 'source_name' },
          },
          treesitter = { 'lsp' },
        },
      },
    },

    fuzzy = {
      implementation = 'prefer_rust',
      frecency = { enabled = true },
      use_proximity = true,
      sorts = { 'exact', 'score', 'sort_text', 'label' },
    },

    signature = {
      enabled = true,
      window = { border = 'rounded', show_documentation = false },
    },

    sources = {
      default = function()
        local success, node = pcall(vim.treesitter.get_node)

        -- In comments: buffer only
        if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
          return { 'buffer' }
        end

        return { 'lsp', 'path', 'snippets', 'buffer' }
      end,
      per_filetype = {
        lua = { inherit_defaults = true, 'lazydev' },
      },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 1000,
        },
        lsp = {
          min_keyword_length = 1,
        },
        path = {
          min_keyword_length = 0,
        },
        snippets = {
          min_keyword_length = 2,
          should_show_items = function(ctx)
            return not ctx.trigger or ctx.trigger.initial_kind ~= 'trigger_character'
          end,
        },
        buffer = {
          min_keyword_length = 4,
          max_items = 5,
          opts = {
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == ''
              end, vim.api.nvim_list_bufs())
            end,
          },
        },
      },
    },
  },
}

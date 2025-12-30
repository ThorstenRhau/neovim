---@module "lazy"
---@type LazySpec
return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets', 'onsails/lspkind.nvim' },
  version = '1.*',
  event = { 'InsertEnter', 'CmdlineEnter' },

  keys = {
    {
      '<leader>ua',
      function()
        -- Toggle: enabled (nil/true) -> disabled (false), disabled (false) -> enabled (true)
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
        auto_show = false,
        auto_show_delay_ms = 500,
        treesitter_highlighting = true,
        window = { border = 'rounded' },
      },
      menu = {
        border = 'rounded',
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind' },
            { 'source_name' },
          },
          treesitter = { 'lsp' },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if ctx.source_name == 'Path' then
                  local ok, devicons = pcall(require, 'nvim-web-devicons')
                  if ok then
                    local ext = vim.fn.fnamemodify(ctx.label, ':e')
                    local dev_icon = devicons.get_icon(ctx.label, ext)
                    if dev_icon then
                      icon = dev_icon
                    end
                  end
                else
                  local ok, lspkind = pcall(require, 'lspkind')
                  if ok then
                    icon = lspkind.symbolic(ctx.kind, { mode = 'symbol' }) or icon
                  end
                end
                return icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if ctx.source_name == 'Path' then
                  local ok, devicons = pcall(require, 'nvim-web-devicons')
                  if ok then
                    local ext = vim.fn.fnamemodify(ctx.label, ':e')
                    local _, dev_hl = devicons.get_icon(ctx.label, ext)
                    if dev_hl then
                      hl = dev_hl
                    end
                  end
                end
                return hl
              end,
            },
          },
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

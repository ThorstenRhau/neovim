---@module "lazy"
---@type LazySpec
return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'disrupted/blink-cmp-conventional-commits',
    'Kaiser-Yang/blink-cmp-git',
  },
  version = '1.*',
  event = { 'InsertEnter', 'CmdlineEnter' },
  opts_extend = { 'sources.default' },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      nerd_font_variant = 'normal',
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      ghost_text = { enabled = true },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = 'rounded' },
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

    keymap = {
      preset = 'super-tab',
    },

    fuzzy = {
      implementation = 'prefer_rust',
      prebuilt_binaries = {
        download = true,
      },
    },

    signature = {
      enabled = true,
      window = { border = 'rounded', show_documentation = false },
    },

    sources = {
      default = { 'lazydev', 'conventional_commits', 'git', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          -- Make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 1000,
        },
        conventional_commits = {
          name = 'Conventional Commits',
          module = 'blink-cmp-conventional-commits',
          enabled = function()
            return vim.bo.filetype == 'gitcommit'
          end,
        },
        git = {
          name = 'Git',
          module = 'blink-cmp-git',
          enabled = function()
            return vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.bo.filetype)
          end,
          opts = {},
        },
        lsp = {
          min_keyword_length = 1,
          score_offset = 0,
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
          opts = {
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == ''
              end, vim.api.nvim_list_bufs())
            end,
          },
        },
      },
    },
  },
}

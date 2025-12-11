---@module "lazy"
---@type LazySpec
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    keys = {
      { '<c-space>', desc = 'Increment Selection' },
      { '<bs>', desc = 'Decrement Selection', mode = 'x' },
    },
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max = 256 * 1024
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > max
        end,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['a,'] = '@parameter.outer',
            ['i,'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
            ['],'] = '@parameter.inner',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
            ['[,'] = '@parameter.inner',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['>,'] = '@parameter.inner',
          },
          swap_previous = {
            ['<,'] = '@parameter.inner',
          },
        },
      },
      ensure_installed = {
        'bash',
        'comment',
        'diff',
        'git_config',
        'git_rebase',
        'gitcommit',
        'gitignore',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'regex',
        'vim',
        'vimdoc',
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufNewFile' },
  },
}

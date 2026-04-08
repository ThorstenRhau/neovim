require('ibl').setup({
  indent = {
    char = '│',
  },
  ---@type ibl.config.scope
  scope = {
    enabled = true,
    show_end = true,
    show_exact_scope = false,
    show_start = true,
    include = {
      node_type = {
        lua = {
          'table_constructor',
          'return_statement',
        },
        bash = {
          'if_statement',
          'for_statement',
          'while_statement',
          'case_statement',
          'compound_statement',
        },
        python = {
          'if_statement',
          'for_statement',
          'while_statement',
          'with_statement',
          'try_statement',
        },
      },
    },
  },
  exclude = {
    filetypes = {
      '',
      'DiffviewFileHistory',
      'DiffviewFiles',
      'NvimTree',
      'checkhealth',
      'fugitive',
      'git',
      'gitcommit',
      'gitsigns-blame',
      'help',
      'lspinfo',
      'man',
      'notify',
      'oil',
      'qf',
    },
  },
})

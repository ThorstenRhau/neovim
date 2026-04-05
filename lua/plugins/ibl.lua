require('ibl').setup({
  indent = {
    char = '│',
    tab_char = '│',
  },
  scope = {
    enabled = true,
    show_start = true,
    show_end = true,
    include = {
      node_type = {
        bash = { 'if_statement', 'for_statement', 'while_statement', 'case_statement', 'compound_statement' },
        css = { 'rule_set', 'media_statement', 'block' },
        hcl = { 'block', 'object' },
        javascript = { 'object', 'array' },
        lua = { 'table_constructor' },
        python = { 'if_statement', 'for_statement', 'while_statement', 'with_statement', 'try_statement' },
        tsx = { 'object', 'array' },
        typescript = { 'object', 'array' },
        xml = { 'element' },
      },
    },
  },
  exclude = {
    filetypes = {
      'mason',
      'NvimTree',
      'notify',
      'oil',
      'trouble',
    },
  },
})

require('blink.indent').setup({
  dedent_scoped_filetypes = { include_defaults = true },
  blocked = {
    buftypes = { include_defaults = true },
    filetypes = {
      include_defaults = true,
      '',
      'NeogitStatus',
      'NvimTree',
      'checkhealth',
      'git',
      'gitcommit',
      'gitsigns-blame',
      'go',
      'help',
      'lspinfo',
      'make',
      'man',
      'notify',
      'oil',
      'qf',
    },
  },
  mappings = {
    object_scope = '',
    object_scope_with_border = '',
    goto_top = '',
    goto_bottom = '',
  },
  static = {
    char = '│',
    highlights = { 'IblIndent' },
  },
  scope = {
    char = '│',
    highlights = { 'IblScope' },
  },
})

vim.cmd.packadd('blink.indent')

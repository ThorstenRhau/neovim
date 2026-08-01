require('blink.indent').setup({
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
    highlights = { 'BlinkIndent' },
  },
  scope = {
    char = '│',
    highlights = { 'BlinkIndentScope' },
    underline = {
      enabled = true,
      highlights = { 'BlinkIndentUnderline' },
    },
  },
})

vim.cmd.packadd('blink.indent')

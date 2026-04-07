require('hlchunk').setup({
  chunk = {
    enable = true,
    notify = false,
    delay = 0,
    textobject = 'ih',
    exclude_filetypes = {
      NvimTree = true,
      notify = true,
      oil = true,
    },
  },
  indent = {
    enable = true,
    notify = false,
    use_treesitter = true,
    exclude_filetypes = {
      NvimTree = true,
      notify = true,
      oil = true,
    },
  },
  line_num = { enable = false },
  blank = { enable = false },
})

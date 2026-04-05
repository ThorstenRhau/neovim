require('hlchunk').setup({
  chunk = {
    enable = true,
    notify = false,
    delay = 0,
    textobject = 'ic',
    exclude_filetypes = {
      mason = true,
      NvimTree = true,
      notify = true,
      oil = true,
      trouble = true,
    },
  },
  indent = {
    enable = true,
    notify = false,
    use_treesitter = true,
    exclude_filetypes = {
      mason = true,
      NvimTree = true,
      notify = true,
      oil = true,
      trouble = true,
    },
  },
  line_num = { enable = false },
  blank = { enable = false },
})

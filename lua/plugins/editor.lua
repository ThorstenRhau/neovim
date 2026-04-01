local map = vim.keymap.set

-- Tabout
require('tabout').setup({
  tabkey = '<Tab>',
  backwards_tabkey = '<S-Tab>',
  act_as_tab = true,
  act_as_shift_tab = false,
  enable_backwards = true,
  completion = true,
  tabouts = {
    { open = "'", close = "'" },
    { open = '"', close = '"' },
    { open = '`', close = '`' },
    { open = '(', close = ')' },
    { open = '[', close = ']' },
    { open = '{', close = '}' },
    { open = '<', close = '>' },
  },
  ignore_beginning = true,
  exclude = {},
})

-- Split/join code blocks via tree-sitter
require('treesj').setup({
  use_default_keymaps = false,
  max_join_length = 120,
})

map('n', '<leader>cj', require('treesj').toggle, { desc = 'split/join' })
map('n', '<leader>cJ', function()
  require('treesj').toggle({ split = { recursive = true } })
end, { desc = 'split/join (recursive)' })

-- Indent blankline
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

-- Render markdown, typst, latex, html in-buffer
require('markview').setup({
  preview = {
    icon_provider = 'mini',
    hybrid_modes = { 'n' },
    edit_range = { 1, 1 },
  },
})

map('n', '<leader>tm', '<cmd>Markview toggle<cr>', { desc = 'markdown render' })

-- Markdown.nvim
require('markdown').setup({}) ---@diagnostic disable-line: missing-fields

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('markdown_nvim_keymaps', { clear = true }),
  pattern = 'markdown',
  callback = function(ev)
    local b = ev.buf
    map('n', '<leader>cl', '<cmd>MDListItemBelow<cr>', { buffer = b, desc = 'list item below' })
    map('n', '<leader>cL', '<cmd>MDListItemAbove<cr>', { buffer = b, desc = 'list item above' })
    map('n', '<leader>cN', '<cmd>MDResetListNumbering<cr>', { buffer = b, desc = 'reset list numbering' })
    map('n', '<leader>ct', '<cmd>MDInsertToc<cr>', { buffer = b, desc = 'insert TOC' })
    map('n', '<leader>cT', '<cmd>MDToc<cr>', { buffer = b, desc = 'show TOC' })
    map('n', '<leader>cx', '<cmd>MDTaskToggle<cr>', { buffer = b, desc = 'toggle task' })
  end,
})

-- Live preview
require('livepreview.config').set({})

map('n', '<leader>tM', '<cmd>LivePreview start<cr>', { desc = 'markdown in browser' })
map('n', '<leader>tQ', '<cmd>LivePreview close<cr>', { desc = 'stop markdown preview' })

-- Built-in difftool
map('n', '<leader>gD', function()
  vim.cmd.packadd('nvim.difftool')
  local current = vim.api.nvim_buf_get_name(0)
  local right = vim.fn.input('Diff against: ', '', 'file')
  if right ~= '' then
    require('difftool').open(current, right, { rename = { detect = true } })
  end
end, { desc = 'difftool' })

-- Built-in undotree
map('n', '<leader>tu', function()
  vim.cmd.packadd('nvim.undotree')
  require('undotree').open()
end, { desc = 'undotree' })

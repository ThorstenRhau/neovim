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
      'neo-tree',
      'notify',
      'oil',
      'trouble',
    },
  },
})

-- Render markdown
require('render-markdown').setup({
  pipe_table = { preset = 'round' },
  latex = { enabled = false },
  code = {
    sign = false,
    width = 'block',
    right_pad = 1,
  },
  heading = {
    sign = false,
  },
  checkbox = {
    custom = {
      todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
    },
  },
})

map('n', '<leader>tm', function()
  require('render-markdown').toggle()
end, { desc = 'markdown render' })

-- Markdown.nvim
require('markdown').setup({}) ---@diagnostic disable-line: missing-fields

vim.api.nvim_create_autocmd('FileType', {
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

-- Color picker
require('ccc').setup({
  highlighter = {
    auto_enable = false,
    lsp = true,
  },
  highlight_mode = 'background',
  virtual_symbol = '●',
  virtual_pos = 'inline-right',
  recognize = {
    input = true,
    output = true,
  },
})

map('n', '<leader>tC', '<cmd>CccHighlighterToggle<cr>', { desc = 'color highlight' })
map('n', '<leader>cp', '<cmd>CccPick<cr>', { desc = 'color picker' })
map('n', '<leader>cc', '<cmd>CccConvert<cr>', { desc = 'convert color format' })

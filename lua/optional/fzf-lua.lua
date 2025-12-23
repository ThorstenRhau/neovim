---@module "lazy"
---@type LazySpec
return {
  'ibhagwan/fzf-lua',
  dependencies = { 'echasnovski/mini.icons' },
  event = 'VeryLazy',
  cmd = 'FzfLua',
  opts = {
    winopts = {
      border = 'rounded',
      fullscreen = true,
    },
    file_icons = 'mini',
    undotree = {
      previewer = 'undotree_native',
    },
  },
  keys = {
    -- General
    { '<leader>/', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
    { '<leader>:', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },
    { '<leader>U', '<cmd>FzfLua undotree<cr>', desc = 'Undo Tree' },
    { '<leader><space>', '<cmd>FzfLua files<cr>', desc = 'Find Files' },
    -- Find
    { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = 'Buffers' },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find Files' },
    { '<leader>fg', '<cmd>FzfLua git_files<cr>', desc = 'Find Git Files' },
    { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent' },
    { '<leader>fs', '<cmd>FzfLua spell_suggest<cr>', desc = 'Spelling suggestions' },
    -- Git
    { '<leader>gP', '<cmd>FzfLua git_commits<cr>', desc = 'Git Log Picker' },
    { '<leader>gs', '<cmd>FzfLua git_status<cr>', desc = 'Git Status' },
    -- Grep
    { '<leader>sb', '<cmd>FzfLua blines<cr>', desc = 'Buffer Lines' },
    { '<leader>sB', '<cmd>FzfLua grep_curbuf<cr>', desc = 'Grep Open Buffers' },
    { '<leader>sg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
    { '<leader>sw', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep word under cursor', mode = 'n' },
    { '<leader>sw', '<cmd>FzfLua grep_visual<cr>', desc = 'Grep visual selection', mode = 'x' },
    -- Search
    { '<leader>s"', '<cmd>FzfLua registers<cr>', desc = 'Registers' },
    { '<leader>sa', '<cmd>FzfLua autocmds<cr>', desc = 'Autocmds' },
    { '<leader>sc', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },
    { '<leader>sC', '<cmd>FzfLua commands<cr>', desc = 'Commands' },
    { '<leader>sd', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Diagnostics' },
    { '<leader>sh', '<cmd>FzfLua help_tags<cr>', desc = 'Help Pages' },
    { '<leader>sH', '<cmd>FzfLua highlights<cr>', desc = 'Highlights' },
    { '<leader>sj', '<cmd>FzfLua jumps<cr>', desc = 'Jumps' },
    { '<leader>sk', '<cmd>FzfLua keymaps<cr>', desc = 'Keymaps' },
    { '<leader>sl', '<cmd>FzfLua loclist<cr>', desc = 'Location List' },
    { '<leader>sM', '<cmd>FzfLua man_pages<cr>', desc = 'Man Pages' },
    { '<leader>sm', '<cmd>FzfLua marks<cr>', desc = 'Marks' },
    { '<leader>sR', '<cmd>FzfLua resume<cr>', desc = 'Resume' },
    { '<leader>sq', '<cmd>FzfLua quickfix<cr>', desc = 'Quickfix List' },
    { '<leader>uX', '<cmd>FzfLua colorschemes<cr>', desc = 'Colorschemes' },
    -- LSP
    { 'gd', '<cmd>FzfLua lsp_definitions<cr>', desc = 'Goto Definition' },
    { 'gr', '<cmd>FzfLua lsp_references<cr>', nowait = true, desc = 'References' },
    { 'gI', '<cmd>FzfLua lsp_implementations<cr>', desc = 'Goto Implementation' },
    { 'gy', '<cmd>FzfLua lsp_typedefs<cr>', desc = 'Goto T[y]pe Definition' },
    { '<leader>ss', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'LSP Symbols' },
  },
}

---@module "lazy"
---@type LazySpec
return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    'fzf-native', -- https://github.com/ibhagwan/fzf-lua/tree/main/lua/fzf-lua/profiles
    defaults = { git_icons = false },
    oldfiles = { cwd_only = true },
    undotree = { previewer = 'undotree_native' },
    ui_select = {},
    files = { hidden = true },
    grep = { hidden = true, rg_glob = true },
    keymap = {
      fzf = {
        ['ctrl-d'] = 'preview-page-down',
        ['ctrl-u'] = 'preview-page-up',
        ['ctrl-p'] = 'toggle-preview',
      },
    },
    winopts = {
      preview = {
        hidden = 'hidden', -- or 'nohidden' to show by default
      },
    },
  },
  config = function(_, opts)
    require('fzf-lua').setup(opts)
    require('fzf-lua').register_ui_select()
  end,
  keys = {
    -- General
    { '<leader><leader>', '<cmd>FzfLua combine pickers=buffers,oldfiles,files<cr>', desc = 'Super Find!' },
    { '<leader>/', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
    { '<leader>:', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },
    { '<leader>U', '<cmd>FzfLua undotree<cr>', desc = 'Undo Tree' },
    -- Find
    { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = 'Buffers' },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find Files' },
    { '<leader>fg', '<cmd>FzfLua git_files<cr>', desc = 'Find Git Files' },
    { '<leader>fo', '<cmd>FzfLua oldfiles<cr>', desc = 'Old files' },
    { '<leader>fs', '<cmd>FzfLua spell_suggest<cr>', desc = 'Spelling suggestions' },
    -- Git
    { '<leader>gs', '<cmd>FzfLua git_status<cr>', desc = 'Git Status' },
    { '<leader>gc', '<cmd>FzfLua git_commits<cr>', desc = 'Git Commits' },
    { '<leader>gf', '<cmd>FzfLua git_bcommits<cr>', desc = 'File Commits' },
    { '<leader>gb', '<cmd>FzfLua git_branches<cr>', desc = 'Git Branches' },
    { '<leader>gB', '<cmd>FzfLua git_blame<cr>', desc = 'Git Blame' },
    { '<leader>gt', '<cmd>FzfLua git_tags<cr>', desc = 'Git Tags' },
    { '<leader>gS', '<cmd>FzfLua git_stash<cr>', desc = 'Git Stash' },
    -- Grep
    { '<leader>sb', '<cmd>FzfLua blines<cr>', desc = 'Buffer Lines' },
    { '<leader>sB', '<cmd>FzfLua grep_curbuf<cr>', desc = 'Grep Current Buffer' },
    { '<leader>sg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
    { '<leader>sw', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep word under cursor', mode = 'n' },
    { '<leader>sw', '<cmd>FzfLua grep_visual<cr>', desc = 'Grep visual selection', mode = 'x' },
    { '<leader>sW', '<cmd>FzfLua grep_cWORD<cr>', desc = 'Grep WORD under cursor' },
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
  },
}

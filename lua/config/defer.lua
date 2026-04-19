-- Deferred plugin loading: plugins are on runtimepath (plugin/ files sourced)
-- but setup() and keymaps are deferred to first use.

local map = vim.keymap.set

local function lazy_cmd(mod, cmd)
  return function()
    require(mod)
    vim.cmd(cmd)
  end
end

-- vim.ui.select proxy: loads fzf config on first ui.select call
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(...)
  require('plugins.fzf')
  return vim.ui.select(...)
end

-- Fzf-lua ----------------------------------------------------------------
local fzf_cmds = {
  { 'n', '<leader>:', 'FzfLua command_history', 'command history' },
  { 'n', '<leader><space>', 'FzfLua files', 'files' },
  { { 'n', 'v' }, '<leader>ca', 'FzfLua lsp_code_actions', 'code actions' },
  { 'n', '<leader>ci', 'FzfLua lsp_incoming_calls', 'incoming calls' },
  { 'n', '<leader>co', 'FzfLua lsp_outgoing_calls', 'outgoing calls' },
  { 'n', '<leader>cs', 'FzfLua lsp_finder', 'lsp finder' },
  { 'n', '<leader>fL', 'FzfLua lines', 'lines (all buffers)' },
  { 'n', '<leader>fS', 'FzfLua spellcheck', 'spellcheck document' },
  { 'n', '<leader>fT', 'FzfLua treesitter', 'treesitter symbols' },
  { 'n', '<leader>fW', 'FzfLua grep_cWORD', 'grep WORD' },
  { 'n', '<leader>fa', 'FzfLua args', 'args list' },
  { 'n', '<leader>fb', 'FzfLua buffers', 'buffers' },
  { 'n', '<leader>ff', 'FzfLua files', 'files' },
  { 'n', '<leader>fg', 'FzfLua git_files', 'git files' },
  { 'n', '<leader>fl', 'FzfLua blines', 'buffer lines' },
  { 'n', '<leader>fo', 'FzfLua oldfiles', 'recent files' },
  { 'n', '<leader>fr', 'FzfLua resume', 'resume last search' },
  { 'n', '<leader>fs', 'FzfLua spell_suggest', 'spelling suggestion' },
  { 'n', '<leader>ft', 'FzfLua tabs', 'tabs' },
  { 'v', '<leader>fv', 'FzfLua grep_visual', 'grep selection' },
  { 'n', '<leader>fw', 'FzfLua grep_cword', 'grep word' },
  { 'n', '<leader>gB', 'FzfLua git_blame', 'git blame' },
  { 'n', '<leader>gh', 'FzfLua git_bcommits', 'file history' },
  { 'n', '<leader>gS', 'FzfLua git_stash', 'git stash' },
  { 'n', '<leader>gb', 'FzfLua git_branches', 'git branches' },
  { 'n', '<leader>gc', 'FzfLua git_commits', 'git commits' },
  { 'n', '<leader>gs', 'FzfLua git_status', 'git status' },
  { 'n', '<leader>gt', 'FzfLua git_tags', 'git tags' },
  { 'n', '<leader>s/', 'FzfLua search_history', 'search history' },
  { 'n', '<leader>sC', 'FzfLua command_history', 'command history' },
  { 'n', '<leader>sD', 'FzfLua diagnostics_workspace', 'workspace diagnostics' },
  { 'n', '<leader>sH', 'FzfLua highlights', 'highlights' },
  { 'n', '<leader>sL', 'FzfLua loclist_stack', 'location stack' },
  { 'n', '<leader>sM', 'FzfLua man_pages', 'man pages' },
  { 'n', '<leader>sQ', 'FzfLua quickfix_stack', 'quickfix stack' },
  { 'n', '<leader>sS', 'FzfLua lsp_workspace_symbols', 'workspace symbols' },
  { 'n', '<leader>sU', 'FzfLua grep_loclist', 'grep loclist' },
  { 'n', '<leader>sa', 'FzfLua autocmds', 'autocommands' },
  { 'n', '<leader>sb', 'FzfLua lgrep_curbuf', 'grep buffer' },
  { 'n', '<leader>sc', 'FzfLua commands', 'commands' },
  { 'n', '<leader>sd', 'FzfLua diagnostics_document', 'document diagnostics' },
  { 'n', '<leader>s"', 'FzfLua registers', 'registers' },
  { 'n', '<leader>sf', 'FzfLua filetypes', 'filetypes' },
  { 'n', '<leader>sg', 'FzfLua live_grep', 'grep' },
  { 'n', '<leader>sh', 'FzfLua help_tags', 'help tags' },
  { 'n', '<leader>si', 'FzfLua lsp_live_workspace_symbols', 'live workspace symbols' },
  { 'n', '<leader>sj', 'FzfLua jumps', 'jumps' },
  { 'n', '<leader>sk', 'FzfLua keymaps', 'keymaps' },
  { 'n', '<leader>sl', 'FzfLua loclist', 'location list' },
  { 'n', '<leader>sm', 'FzfLua marks', 'marks' },
  { 'n', '<leader>sn', 'FzfLua changes', 'changes' },
  { 'n', '<leader>sT', 'FzfLua colorschemes', 'themes' },
  { 'n', '<leader>sp', 'FzfLua builtin', 'builtin pickers' },
  { 'n', '<leader>sq', 'FzfLua quickfix', 'quickfix list' },
  { 'n', '<leader>sr', 'FzfLua resume', 'resume last search' },
  { 'n', '<leader>ss', 'FzfLua lsp_document_symbols', 'document symbols' },
  { 'n', '<leader>st', 'FzfLua tagstack', 'tag stack' },
  { 'n', '<leader>su', 'FzfLua grep_quickfix', 'grep quickfix' },
  { 'n', '<leader>u', 'FzfLua undotree', 'undo-tree' },
  { 'n', 'gD', 'FzfLua lsp_declarations', 'go to declaration' },
  { 'n', 'gI', 'FzfLua lsp_implementations', 'implementations' },
  { 'n', 'gd', 'FzfLua lsp_definitions', 'go to definition' },
  { 'n', 'gr', 'FzfLua lsp_references', 'references' },
  { 'n', 'gy', 'FzfLua lsp_typedefs', 'type definition' },
}

for _, m in ipairs(fzf_cmds) do
  map(m[1], m[2], lazy_cmd('plugins.fzf', m[3]), { desc = m[4] })
end

-- fzf keymaps with function callbacks
map('n', '<leader>fm', function()
  require('plugins.fzf')
  local fzf = require('fzf-lua')
  local messages = vim.fn.execute('messages')
  local lines = vim.split(messages, '\n')
  fzf.fzf_exec(lines, {
    prompt = 'Messages❯ ',
    fzf_opts = {
      ['--no-multi'] = '',
      ['--layout'] = 'reverse-list',
    },
  })
end, { desc = 'messages' })

map('n', '<leader>sG', function()
  require('plugins.fzf')
  require('fzf-lua').live_grep({ no_ignore = true })
end, { desc = 'grep (no ignore)' })

-- Neogit ----------------------------------------------------------------
local function neogit(args)
  return function()
    require('plugins.neogit')
    require('neogit').open(args)
  end
end

map('n', '<leader>gg', neogit(), { desc = 'neogit status' })
map('n', '<leader>gP', neogit({ 'push' }), { desc = 'git push' })
map('n', '<leader>gp', neogit({ 'pull' }), { desc = 'git pull' })
map('n', '<leader>gf', neogit({ 'fetch' }), { desc = 'git fetch' })
map('n', '<leader>gl', neogit({ 'log' }), { desc = 'git log' })

-- Git diff
map('n', '<leader>gd', '<cmd>Gitsigns diffthis<cr>', { desc = 'diff this' })

-- Nvim-tree --------------------------------------------------------------
map('n', '<leader>tr', lazy_cmd('plugins.nvim-tree', 'NvimTreeToggle'), { desc = 'file tree' })

-- Oil --------------------------------------------------------------------
map('n', '-', lazy_cmd('plugins.oil', 'Oil --float'), { desc = 'open parent directory' })
map('n', '<leader>e', lazy_cmd('plugins.oil', 'Oil --float'), { desc = 'file explorer' })

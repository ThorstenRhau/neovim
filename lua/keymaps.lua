local map = vim.keymap.set

-- General

map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })
map('n', '<leader>l', vim.pack.update, { desc = 'Update plugins' })
map({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map('n', '<leader>,', '<C-^>', { desc = 'Previous buffer' })

-- Emacs-style line editing

map('i', '<C-a>', '<Cmd>normal! ^<CR>', { desc = 'First non-blank character' })
map('i', '<C-e>', '<End>', { desc = 'End of line' })
map('c', '<C-a>', '<Home>', { desc = 'Start of line' })
-- remap keeps the undo step that the default <C-w> mapping starts
map({ 'i', 'c' }, '<M-BS>', '<C-w>', { remap = true, desc = 'Delete word before cursor' })

-- Movement and scrolling

map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Down by display line' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Up by display line' })

local function third()
  return math.max(1, math.floor(vim.api.nvim_win_get_height(0) / 3))
end

map({ 'n', 'x' }, '<C-d>', function()
  return third() .. '<C-d>zz'
end, { expr = true, desc = 'Scroll down a third' })

map({ 'n', 'x' }, '<C-u>', function()
  return third() .. '<C-u>zz'
end, { expr = true, desc = 'Scroll up a third' })

-- Tree-sitter text objects

local ts_select = require('nvim-treesitter-textobjects.select')

local function textobject(lhs, query, desc)
  map({ 'x', 'o' }, lhs, function()
    ts_select.select_textobject(query, 'textobjects')
  end, { desc = desc })
end

textobject('af', '@function.outer', 'Around function')
textobject('if', '@function.inner', 'Inside function')
textobject('ac', '@class.outer', 'Around class')
textobject('ic', '@class.inner', 'Inside class')
textobject('aa', '@parameter.outer', 'Around parameter')
textobject('ia', '@parameter.inner', 'Inside parameter')

local ts_move = require('nvim-treesitter-textobjects.move')

local function move(lhs, fn, query, desc)
  map({ 'n', 'x', 'o' }, lhs, function()
    ts_move[fn](query, 'textobjects')
  end, { desc = desc })
end

move('<LocalLeader>fj', 'goto_next_start', '@function.outer', 'Next function start')
move('<LocalLeader>fk', 'goto_previous_start', '@function.outer', 'Previous function start')
move('<LocalLeader>fJ', 'goto_next_end', '@function.outer', 'Next function end')
move('<LocalLeader>fK', 'goto_previous_end', '@function.outer', 'Previous function end')
move('<LocalLeader>cj', 'goto_next_start', '@class.outer', 'Next class start')
move('<LocalLeader>ck', 'goto_previous_start', '@class.outer', 'Previous class start')
move('<LocalLeader>cJ', 'goto_next_end', '@class.outer', 'Next class end')
move('<LocalLeader>cK', 'goto_previous_end', '@class.outer', 'Previous class end')

-- Files and search

map('n', '<leader> ', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
map('n', '<leader>/', '<cmd>FzfLua blines<cr>', { desc = 'Search buffer' })
map('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Find' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })
map('n', '<leader>fo', '<cmd>FzfLua oldfiles<cr>', { desc = 'Recent' })
map('n', '<leader>sf', '<cmd>FzfLua builtin<cr>', { desc = 'FzfLua builtin commands' })
map('n', '<leader>sg', '<cmd>FzfLua live_grep<cr>', { desc = 'Grep text' })
map('n', '<leader>sr', '<cmd>FzfLua resume<cr>', { desc = 'Resume' })
map('n', '<leader>sh', '<cmd>FzfLua helptags<cr>', { desc = 'Help pages' })
map('n', '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', { desc = 'Document diagnostics' })
map('n', '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', { desc = 'Workspace diagnostics' })
map('n', 'z=', '<cmd>FzfLua spell_suggest<cr>', { desc = 'Spelling suggestions' })
map('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

map('n', '<leader>sw', function()
  local fzf = require('fzf-lua')
  local rg_opts = fzf.config.globals.grep.rg_opts --[[@as string]]
  fzf.grep_cword({ rg_opts = rg_opts:gsub('%-%-smart%-case', '--ignore-case') })
end, { desc = 'Word under cursor (ignore case)' })

map('n', '<leader>o', function()
  vim.ui.open(vim.api.nvim_buf_get_name(0))
end, { desc = 'Open in default app' })

-- Code

map('n', '<leader>cf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer' })

map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Diagnostic' })

-- Git

map('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Status' })
map('n', '<leader>gl', '<cmd>Neogit log<cr>', { desc = 'Log' })

map('n', '<leader>gR', function()
  vim.cmd.tabnew()
  local buf = vim.api.nvim_get_current_buf()
  vim.fn.jobstart({ 'tuicr' }, {
    term = true,
    -- shortcut: files open at the top. Jumping to the line needs a :drop wrapper over RPC.
    env = { EDITOR = 'env nvim --server ' .. vim.v.servername .. ' --remote-tab' },
    on_exit = function(_, code)
      if code == 0 and vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
  })
  vim.cmd.startinsert()
end, { desc = 'Review with tuicr' })

-- Toggles

map('n', '<leader>ts', '<cmd>setlocal spell!<cr>', { desc = 'Spell check' })
map('n', '<leader>tw', '<cmd>setlocal wrap!<cr>', { desc = 'Line wrap' })

map('n', '<leader>tl', function()
  local on = not vim.wo.number
  vim.opt_local.number = on
  vim.opt_local.relativenumber = on
end, { desc = 'Line numbers' })

map('n', '<leader>tc', function()
  vim.b.completion_auto = vim.b.completion_auto == false
  vim.notify('Auto completion ' .. (vim.b.completion_auto and 'on' or 'off'))
end, { desc = 'Auto completion' })

map('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Diagnostics' })

-- Key hints

local clue = require('mini.clue')

clue.setup({
  window = {
    config = function(buf_id)
      local width = 0
      for _, line in ipairs(vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
      end
      return { width = math.min(width + 1, 40) }
    end,
  },
  triggers = {
    { mode = { 'n', 'x' }, keys = '<leader>' },
    { mode = { 'n', 'x', 'o' }, keys = '<LocalLeader>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = 'z' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'n', keys = '<C-w>' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'i', keys = '<C-x>' },
  },
  clues = {
    { mode = { 'n', 'x', 'o' }, keys = '<LocalLeader>c', desc = '+Classes' },
    { mode = { 'n', 'x', 'o' }, keys = '<LocalLeader>f', desc = '+Functions' },
    { mode = 'n', keys = '<leader>c', desc = '+Code' },
    { mode = 'n', keys = '<leader>f', desc = '+Files' },
    { mode = { 'n', 'x' }, keys = '<leader>g', desc = '+Git' },
    { mode = 'n', keys = '<leader>s', desc = '+Search' },
    { mode = 'n', keys = '<leader>t', desc = '+Toggle' },
    { mode = 'n', keys = 'gr', desc = '+LSP' },
    clue.gen_clues.g(),
    clue.gen_clues.z(),
    clue.gen_clues.square_brackets(),
    clue.gen_clues.windows({ submode_resize = true }),
    clue.gen_clues.marks(),
    clue.gen_clues.registers(),
    clue.gen_clues.builtin_completion(),
  },
})

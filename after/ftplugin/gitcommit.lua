vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = '50,73'
require('config.ftplugin').prose().indent(2).treesitter()

-- Stacked diff split: commit message on top, staged changes on bottom

local commit_buf = vim.api.nvim_get_current_buf()
local commit_win = vim.api.nvim_get_current_win()
local bufname = vim.api.nvim_buf_get_name(commit_buf)

if not bufname:match('COMMIT_EDITMSG$') then
  return
end

-- Close other windows in current tab (full-screen commit editor)
for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
  if win ~= commit_win and vim.api.nvim_win_is_valid(win) then
    pcall(vim.api.nvim_win_close, win, true)
  end
end

-- Get staged diff from the repo containing this commit
local repo_dir = vim.fn.systemlist({ 'git', 'rev-parse', '--show-toplevel' })[1]
local diff_output = vim.fn.systemlist({ 'git', '-C', repo_dir, 'diff', '--cached' })

if vim.v.shell_error ~= 0 or #diff_output == 0 then
  return
end

-- Create read-only scratch buffer with diff content
local diff_buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, diff_output)
vim.bo[diff_buf].buftype = 'nofile'
vim.bo[diff_buf].bufhidden = 'wipe'
vim.bo[diff_buf].swapfile = false
vim.bo[diff_buf].modifiable = false
vim.bo[diff_buf].filetype = 'diff'

-- Open diff split on the bottom
vim.cmd('botright split')
local diff_win = vim.api.nvim_get_current_win()
vim.api.nvim_win_set_buf(diff_win, diff_buf)

-- Configure diff window
vim.wo[diff_win].number = false
vim.wo[diff_win].relativenumber = false
vim.wo[diff_win].signcolumn = 'no'
vim.wo[diff_win].statuscolumn = ''
vim.wo[diff_win].winfixheight = true
vim.wo[diff_win].wrap = false
vim.wo[diff_win].list = false
vim.wo[diff_win].cursorline = false
vim.wo[diff_win].foldlevel = 99

-- Resize: give commit message ~10 lines at the top, diff gets the rest
vim.api.nvim_win_set_height(commit_win, 10)

-- Return focus to commit message
vim.api.nvim_set_current_win(commit_win)

-- Auto-close diff when commit buffer leaves the window
local augroup = vim.api.nvim_create_augroup('gitcommit_diff_split', { clear = true })

vim.api.nvim_create_autocmd('BufWinLeave', {
  group = augroup,
  buffer = commit_buf,
  once = true,
  callback = function()
    if vim.api.nvim_buf_is_valid(diff_buf) then
      vim.api.nvim_buf_delete(diff_buf, { force = true })
    end
    pcall(vim.api.nvim_del_augroup_by_id, augroup)
  end,
})

vim.api.nvim_create_autocmd('BufWipeout', {
  group = augroup,
  buffer = diff_buf,
  once = true,
  callback = function()
    pcall(vim.api.nvim_del_augroup_by_id, augroup)
  end,
})

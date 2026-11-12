-- Statusline built from native 'statusline' items. Neovim calls render() for
-- each window it redraws. Colors come from the colorscheme: StatusLine and
-- StatusLineNC, with %$Group$ adding a group's foreground on top.
-- Optional parts render only when they have something to say, and the
-- secondary ones also need a wide enough screen.
local M = {}

-- Nerd Font lock, shown after the name of a readonly or unmodifiable buffer.
local lock = vim.fn.nr2char(0xF023)

-- Foreground for the mode letter. Normal mode keeps the StatusLine color.
local mode_groups = {
  I = 'DiagnosticOk',
  V = 'Statement',
  S = 'Statement',
  R = 'DiagnosticError',
  C = 'DiagnosticWarn',
  T = 'DiagnosticInfo',
}

local function colored(group, text)
  return ('%%$%s$%s%%*'):format(group, text)
end

-- One letter per mode. Blockwise visual and select are control characters.
-- Without an argument, mode() returns only the first character of the mode.
local function mode()
  local m = vim.fn.mode()
  local letter = m == '\22' and 'V' or m == '\19' and 'S' or m:upper()
  local group = mode_groups[letter]
  return group and colored(group, letter) or letter
end

-- Path relative to the working directory, cut from the left when it is too long.
local function filename()
  local name = '%<%f'
  if vim.bo.modified then
    name = name .. ' ●'
  end
  if vim.bo.readonly or not vim.bo.modifiable then
    name = name .. ' ' .. lock
  end
  return name
end

-- Branch and line counts from gitsigns. Buffers gitsigns is not attached to
-- show the branch of the working directory.
local function git(parts)
  local head = vim.b.gitsigns_head or vim.g.gitsigns_head
  if head and head ~= '' then
    -- Branch names may contain '%', which the statusline would parse.
    parts[#parts + 1] = (head:gsub('%%', '%%%%'))
  end
  local status = vim.b.gitsigns_status_dict
  if not status then
    return
  end
  if (status.added or 0) > 0 then
    parts[#parts + 1] = colored('GitSignsAdd', '+' .. status.added)
  end
  if (status.changed or 0) > 0 then
    parts[#parts + 1] = colored('GitSignsChange', '~' .. status.changed)
  end
  if (status.removed or 0) > 0 then
    parts[#parts + 1] = colored('GitSignsDelete', '-' .. status.removed)
  end
end

local function recording()
  local reg = vim.fn.reg_recording()
  return reg ~= '' and colored('DiagnosticError', '@' .. reg) or ''
end

-- Position among the matches of the last search, while they are highlighted.
local function searchcount()
  if vim.v.hlsearch == 0 then
    return ''
  end
  -- An invalid pattern such as `\(` stays the last search and raises here. An
  -- error in the statusline makes Neovim reset the option.
  local ok, count = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
  if not ok or not count.total then
    return ''
  end
  -- Past maxcount, current and total are maxcount + 1.
  local function capped(n)
    return n > count.maxcount and '>' .. count.maxcount or tostring(n)
  end
  return ('[%s/%s]'):format(capped(count.current), capped(count.total))
end

-- Size of the visual selection: lines, characters on one line, or rows x columns.
local function selectioncount()
  local m = vim.fn.mode()
  if m ~= 'v' and m ~= 'V' and m ~= '\22' then
    return ''
  end
  local lines = math.abs(vim.fn.line('v') - vim.fn.line('.')) + 1
  if m == '\22' then
    -- Columns are screen columns, so wide and multibyte characters count right.
    local cols = math.abs(vim.fn.virtcol('v') - vim.fn.virtcol('.')) + 1
    return lines .. 'x' .. cols
  end
  if m == 'V' or lines > 1 then
    return tostring(lines)
  end
  -- col() counts bytes, which overcounts multibyte characters.
  return tostring(vim.fn.wordcount().visual_chars)
end

-- Names of the attached language servers, marked while a server works.
local function lsp()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    names[#names + 1] = next(client.progress.pending) and client.name .. ' ◐' or client.name
  end
  return table.concat(names, ' ')
end

-- Only show encoding and format when they differ from utf-8 and unix.
local function encoding()
  local fenc, ff = vim.bo.fileencoding, vim.bo.fileformat
  if (fenc == '' or fenc == 'utf-8') and ff == 'unix' then
    return ''
  end
  return ('%s[%s]'):format(fenc, ff)
end

local function add(parts, text)
  if text ~= '' then
    parts[#parts + 1] = text
  end
end

function M.render()
  -- 'statusline' expressions run with the drawn window as the current one.
  if tonumber(vim.g.actual_curwin) ~= vim.api.nvim_get_current_win() then
    return ' ' .. filename() .. ' '
  end

  local columns = vim.o.columns
  local left = { mode(), filename() }
  if columns >= 80 then
    git(left)
  end
  add(left, vim.diagnostic.status())

  local right = {}
  add(right, recording())
  add(right, searchcount())
  add(right, selectioncount())
  if columns >= 100 then
    add(right, lsp())
  end
  add(right, encoding())
  if columns >= 60 then
    add(right, vim.bo.filetype)
  end
  if columns >= 40 then
    add(right, '%l:%v')
  end

  return ' ' .. table.concat(left, '  ') .. '%=' .. table.concat(right, '  ') .. ' '
end

vim.o.statusline = "%{%v:lua.require'statusline'.render()%}"

-- Neovim redraws the statusline on cursor moves, mode changes and diagnostic
-- changes. These events change what it shows without any of those. LspDetach
-- and RecordingLeave fire before the client or the recording is gone, so the
-- redraw waits until after them.
local group = vim.api.nvim_create_augroup('statusline', { clear = true })
vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach', 'RecordingEnter', 'RecordingLeave' }, {
  group = group,
  callback = function()
    vim.schedule(function()
      vim.cmd.redrawstatus()
    end)
  end,
})
vim.api.nvim_create_autocmd('LspProgress', {
  group = group,
  pattern = { 'begin', 'end' },
  command = 'redrawstatus',
})
vim.api.nvim_create_autocmd('User', {
  group = group,
  pattern = 'GitSignsUpdate',
  command = 'redrawstatus',
})

return M

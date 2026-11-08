-- Global statusline from built-ins, gitsigns, conform, nvim-lint, and mini.icons.
local M = {}

local modes = {
  n = 'NORMAL',
  v = 'VISUAL',
  V = 'V-LINE',
  ['\22'] = 'V-BLOCK',
  s = 'SELECT',
  S = 'S-LINE',
  ['\19'] = 'S-BLOCK',
  i = 'INSERT',
  R = 'REPLACE',
  c = 'COMMAND',
  r = 'PROMPT',
  ['!'] = 'SHELL',
  t = 'TERMINAL',
}

-- Escape '%' in text that comes from buffers or plugins.
local function escape(text)
  return (text:gsub('%%', '%%%%'))
end

local function file()
  local ft = vim.bo.filetype
  local icon = ''
  if ft ~= '' then
    local glyph, hl = require('mini.icons').get('filetype', ft)
    icon = ('%%#%s#%s%%* '):format(hl, glyph)
  end
  -- The %( %) group drops the space when no flag is set.
  return icon .. '%<%f%( %h%w%m%r%)'
end

local function git()
  local status = vim.b.gitsigns_status_dict
  if not status then
    return ''
  end
  local parts = {}
  if status.head ~= '' then
    table.insert(parts, escape(status.head))
  end
  for _, item in ipairs({
    { count = status.added, sign = '+', hl = 'GitSignsAdd' },
    { count = status.changed, sign = '!', hl = 'GitSignsChange' },
    { count = status.removed, sign = '-', hl = 'GitSignsDelete' },
  }) do
    if (item.count or 0) > 0 then
      table.insert(parts, ('%%#%s#%s%d%%*'):format(item.hl, item.sign, item.count))
    end
  end
  return table.concat(parts, ' ')
end

local function recording()
  local reg = vim.fn.reg_recording()
  return reg ~= '' and '@' .. reg or ''
end

local function names(list)
  local joined = vim
    .iter(list)
    :map(function(item)
      return item.name
    end)
    :join(',')
  return escape(joined)
end

local function encoding()
  local fenc, ff = vim.bo.fileencoding, vim.bo.fileformat
  if (fenc == '' or fenc == 'utf-8') and ff == 'unix' then
    return ''
  end
  return ('%s[%s]'):format(fenc, ff)
end

local function search()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local count = vim.fn.searchcount({ maxcount = 999, timeout = 20 })
  if (count.total or 0) == 0 then
    return ''
  end
  local total = count.incomplete == 2 and '>' .. count.maxcount or count.total
  return ('[%s/%s]'):format(count.current, total)
end

-- Join the non-empty items of a section.
local function section(items)
  return vim
    .iter(items)
    :filter(function(item)
      return item ~= ''
    end)
    :join('  ')
end

function M.render()
  local mode = vim.api.nvim_get_mode().mode
  return table.concat({
    section({ ' ' .. (modes[mode:sub(1, 1)] or mode), file(), git() }),
    '%=',
    section({ vim.ui.progress_status(), table.concat(require('lint').get_running(0), ','), recording() }),
    '%=',
    section({
      vim.diagnostic.status(),
      names(vim.lsp.get_clients({ bufnr = 0 })),
      names(require('conform').list_formatters(0)),
      vim.bo.filetype,
      encoding(),
      search(),
      '%l:%c %P ',
    }),
  })
end

-- Redraw for state changes that do not redraw the statusline on their own.
-- Scheduled because the state settles after these events.
local group = vim.api.nvim_create_augroup('statusline', { clear = true })
local redraw = vim.schedule_wrap(function()
  vim.cmd.redrawstatus()
end)
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave', 'LspAttach', 'LspDetach', 'Progress' }, {
  group = group,
  callback = redraw,
})
vim.api.nvim_create_autocmd('User', { group = group, pattern = 'GitSignsUpdate', callback = redraw })

return M

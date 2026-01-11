-- Built-in statusline configuration
local constants = require('config.constants')

local M = {}

-- Expose globally for statusline expression
_G.Statusline = M

-- Mode name mapping
local mode_map = {
  ['n'] = 'NORMAL',
  ['no'] = 'O-PENDING',
  ['nov'] = 'O-PENDING',
  ['noV'] = 'O-PENDING',
  ['no\22'] = 'O-PENDING',
  ['niI'] = 'NORMAL',
  ['niR'] = 'NORMAL',
  ['niV'] = 'NORMAL',
  ['nt'] = 'NORMAL',
  ['ntT'] = 'NORMAL',
  ['v'] = 'VISUAL',
  ['vs'] = 'VISUAL',
  ['V'] = 'V-LINE',
  ['Vs'] = 'V-LINE',
  ['\22'] = 'V-BLOCK',
  ['\22s'] = 'V-BLOCK',
  ['s'] = 'SELECT',
  ['S'] = 'S-LINE',
  ['\19'] = 'S-BLOCK',
  ['i'] = 'INSERT',
  ['ic'] = 'INSERT',
  ['ix'] = 'INSERT',
  ['R'] = 'REPLACE',
  ['Rc'] = 'REPLACE',
  ['Rx'] = 'REPLACE',
  ['Rv'] = 'V-REPLACE',
  ['Rvc'] = 'V-REPLACE',
  ['Rvx'] = 'V-REPLACE',
  ['c'] = 'COMMAND',
  ['cv'] = 'EX',
  ['ce'] = 'EX',
  ['r'] = 'REPLACE',
  ['rm'] = 'MORE',
  ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL',
  ['t'] = 'TERMINAL',
}

-- Mode highlight mapping
local mode_hl_map = {
  n = 'StatusLineMode',
  i = 'StatusLineModeInsert',
  v = 'StatusLineModeVisual',
  V = 'StatusLineModeVisual',
  ['\22'] = 'StatusLineModeVisual',
  c = 'StatusLineModeCommand',
  R = 'StatusLineModeReplace',
  t = 'StatusLineMode',
}

-- Disabled filetypes
local disabled_filetypes = {
  lazy = true,
  mason = true,
  oil = true,
}

-- Mode component with dynamic highlighting
function M.mode()
  local mode = vim.api.nvim_get_mode().mode
  local mode_char = mode:sub(1, 1)
  local hl = mode_hl_map[mode_char] or 'StatusLineMode'
  local mode_text = mode_map[mode] or mode:upper()
  return '%#' .. hl .. '# ' .. mode_text .. ' %#StatusLine#'
end

-- Search count component
function M.searchcount()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
  if not ok or result.total == 0 then
    return ''
  end
  if result.incomplete == 1 then
    return ' [?/?]'
  end
  return string.format(' [%d/%d]', result.current, result.total)
end

-- Selection count component
function M.selectioncount()
  local mode = vim.fn.mode()
  if not mode:find('[vV\22]') then
    return ''
  end
  local starts = vim.fn.line('v')
  local ends = vim.fn.line('.')
  local lines = math.abs(ends - starts) + 1
  local chars = vim.fn.wordcount().visual_chars or 0
  return string.format(' %d:%d', lines, chars)
end

-- Git branch component
function M.branch()
  local branch = vim.b.gitsigns_head
  if not branch or branch == '' then
    return ''
  end
  return '%#StatusLineGitBranch# ' .. branch .. '%#StatusLine#'
end

-- Git diff component
function M.diff()
  local status = vim.b.gitsigns_status_dict
  if not status then
    return ''
  end

  local parts = {}
  if status.added and status.added > 0 then
    table.insert(parts, '%#StatusLineDiffAdd#+' .. status.added .. '%#StatusLine#')
  end
  if status.changed and status.changed > 0 then
    table.insert(parts, '%#StatusLineDiffChange#~' .. status.changed .. '%#StatusLine#')
  end
  if status.removed and status.removed > 0 then
    table.insert(parts, '%#StatusLineDiffDelete#-' .. status.removed .. '%#StatusLine#')
  end

  if #parts == 0 then
    return ''
  end
  return ' ' .. table.concat(parts, ' ')
end

-- Filename component
function M.filename()
  local name = vim.fn.expand('%:~:.')
  if name == '' then
    name = '[No Name]'
  end

  local symbols = ''
  if vim.bo.modified then
    symbols = symbols .. ' ●'
  end
  if vim.bo.readonly or not vim.bo.modifiable then
    symbols = symbols .. ' '
  end

  return name .. symbols
end

-- Diagnostics component
function M.diagnostics()
  local counts = vim.diagnostic.count(0)
  if vim.tbl_isempty(counts) then
    return ''
  end

  local symbols = constants.diagnostic_symbols
  local parts = {}

  local error_count = counts[vim.diagnostic.severity.ERROR] or 0
  local warn_count = counts[vim.diagnostic.severity.WARN] or 0
  local info_count = counts[vim.diagnostic.severity.INFO] or 0
  local hint_count = counts[vim.diagnostic.severity.HINT] or 0

  if error_count > 0 then
    table.insert(parts, '%#DiagnosticError#' .. symbols.error .. ' ' .. error_count .. '%#StatusLine#')
  end
  if warn_count > 0 then
    table.insert(parts, '%#DiagnosticWarn#' .. symbols.warn .. ' ' .. warn_count .. '%#StatusLine#')
  end
  if info_count > 0 then
    table.insert(parts, '%#DiagnosticInfo#' .. symbols.info .. ' ' .. info_count .. '%#StatusLine#')
  end
  if hint_count > 0 then
    table.insert(parts, '%#DiagnosticHint#' .. symbols.hint .. ' ' .. hint_count .. '%#StatusLine#')
  end

  if #parts == 0 then
    return ''
  end
  return ' ' .. table.concat(parts, ' ')
end

-- LSP status component
function M.lsp_status()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ''
  end

  -- Get first attached client (skip null-ls if present)
  for _, client in ipairs(clients) do
    if client.name ~= 'null-ls' then
      return client.name
    end
  end

  return ''
end

-- Filetype component
function M.filetype()
  local ft = vim.bo.filetype
  if ft == '' then
    return ''
  end
  return ft
end

-- Progress component
function M.progress()
  local cur = vim.fn.line('.')
  local total = vim.fn.line('$')
  if cur == 1 then
    return 'Top'
  elseif cur == total then
    return 'Bot'
  else
    return string.format('%2d%%%%', math.floor(cur / total * 100))
  end
end

-- Location component
function M.location()
  return '%l:%c'
end

-- Oil path helper (for oil.nvim filetypes)
function M.oil_path()
  local ok, oil = pcall(require, 'oil')
  if ok then
    local dir = oil.get_current_dir()
    if dir then
      return vim.fn.fnamemodify(dir, ':~')
    end
  end
  return ''
end

-- Build active statusline
function M.build_active()
  local left = table.concat({
    '%{%v:lua.Statusline.mode()%}',
    '%{%v:lua.Statusline.searchcount()%}',
    '%{%v:lua.Statusline.selectioncount()%}',
    '%{%v:lua.Statusline.branch()%}',
    '%{%v:lua.Statusline.diff()%}',
    ' ',
    '%<',
    '%{%v:lua.Statusline.filename()%}',
    '%{%v:lua.Statusline.diagnostics()%}',
  }, '')

  local center = '%='

  local right = table.concat({
    '%{%v:lua.Statusline.lsp_status()%}',
    ' ',
    '%{%v:lua.Statusline.filetype()%}',
    ' ',
    '%{%v:lua.Statusline.progress()%}',
    ' ',
    '%{%v:lua.Statusline.location()%}',
    ' ',
  }, '')

  return left .. center .. right
end

-- Build inactive statusline
function M.build_inactive()
  return ' %{%v:lua.Statusline.filename()%} %= %l:%c '
end

-- Build special statusline for disabled filetypes
function M.build_special()
  local ft = vim.bo.filetype
  if ft == 'lazy' then
    return ' Lazy %='
  elseif ft == 'mason' then
    return ' Mason %='
  elseif ft == 'oil' then
    return ' Oil: %{%v:lua.Statusline.oil_path()%} %='
  elseif ft == 'trouble' then
    return ' Trouble %='
  elseif ft == 'fzf' then
    return ' FZF %='
  elseif ft == 'qf' then
    local is_loc = vim.fn.getloclist(0, { filewinid = 0 }).filewinid ~= 0
    local title = is_loc and 'Location List' or 'Quickfix'
    return ' ' .. title .. ' %='
  elseif ft:match('^dap') then
    return ' Debug %='
  end
  return ''
end

-- Check if filetype is disabled
function M.is_disabled()
  return disabled_filetypes[vim.bo.filetype] or false
end

-- Setup autocmds
function M.setup_autocmds()
  local group = vim.api.nvim_create_augroup('statusline', { clear = true })

  -- Update on window/buffer changes for active/inactive styling
  vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = group,
    callback = function()
      if M.is_disabled() then
        vim.wo.statusline = M.build_special()
      else
        vim.wo.statusline = M.build_active()
      end
    end,
    desc = 'activate statusline',
  })

  vim.api.nvim_create_autocmd({ 'WinLeave' }, {
    group = group,
    callback = function()
      if not M.is_disabled() then
        vim.wo.statusline = M.build_inactive()
      end
    end,
    desc = 'deactivate statusline',
  })

  -- Redraw on events that change statusline content
  vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
    group = group,
    callback = function()
      vim.cmd('redrawstatus')
    end,
    desc = 'update statusline on lsp attach/detach',
  })

  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = group,
    callback = function()
      vim.cmd('redrawstatus')
    end,
    desc = 'update statusline on diagnostic change',
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = group,
    callback = function()
      vim.cmd('redrawstatus')
    end,
    desc = 'update statusline on mode change',
  })

  -- Handle filetype changes for special filetypes
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = { 'lazy', 'mason', 'oil', 'trouble', 'fzf', 'dap-repl', 'dapui_*', 'qf' },
    callback = function()
      vim.wo.statusline = M.build_special()
    end,
    desc = 'set special statusline for plugin windows',
  })
end

-- Setup function
function M.setup()
  -- Set global statusline
  vim.o.laststatus = 3

  -- Build initial statusline
  vim.o.statusline = M.build_active()

  -- Setup autocmds
  M.setup_autocmds()
end

return M

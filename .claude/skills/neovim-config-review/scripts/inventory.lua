-- Read-only inventory of the live configuration for the neovim-config-review skill.
-- Run from the repository root:
--   nvim --headless -V1 -i NONE -n -S <path to this file>
-- -V1 makes Neovim record the file and line that set each option and keymap.

local config = vim.fn.resolve(vim.fn.stdpath('config'))
local runtime = vim.fn.resolve(vim.env.VIMRUNTIME)
local modes = { 'n', 'x', 's', 'o', 'i', 'c', 't' }
local lines = {}

local function add(text, ...)
  table.insert(lines, select('#', ...) > 0 and text:format(...) or text)
end

local function section(title)
  add('')
  add('## ' .. title)
end

local function short(path)
  path = vim.fn.resolve(path)
  if vim.startswith(path, config .. '/') then
    return path:sub(#config + 2)
  end
  return vim.fn.fnamemodify(path, ':~')
end

-- Neovim's own settings come from $VIMRUNTIME or from embedded modules such as
-- vim/_core/defaults, which Neovim names as if they were files in the current directory.
local function from_neovim(file)
  return vim.startswith(file, runtime) or vim.fn.filereadable(file) == 0
end

local function script_names()
  local names = {}
  for _, script in ipairs(vim.fn.getscriptinfo()) do
    names[script.sid] = vim.fn.resolve(script.name)
  end
  return names
end

local function function_location(fn)
  local info = debug.getinfo(fn, 'S')
  return short(info.source:sub(2)) .. ':' .. info.linedefined
end

local function neovim()
  section('Neovim')
  add('version: %s', tostring(vim.version()))
  add('$VIMRUNTIME: %s', runtime)
  add('config: %s', config)
  add('startup v:errmsg: %s', vim.v.errmsg == '' and '(none)' or vim.v.errmsg)
  local messages = vim.api.nvim_exec2('messages', { output = true }).output
  add('messages: %s', messages == '' and '(none)' or '\n' .. messages)
end

local function options()
  section('Options last set by the configuration or plugins ("= default" when the value equals the default)')
  local names = script_names()
  for name, info in vim.spairs(vim.api.nvim_get_all_options_info()) do
    local set = vim.api.nvim_get_option_info2(name, {})
    local file = names[set.last_set_sid]
    if file and not from_neovim(file) then
      local value = vim.api.nvim_get_option_value(name, {})
      add(
        '%s=%s%s  %s:%d',
        name,
        vim.inspect(value),
        value == info.default and ' = default' or '',
        short(file),
        set.last_set_linenr
      )
    end
  end
end

local function packages()
  section('Packages: vim.pack.get() against nvim-pack-lock.json')
  local lockfile = config .. '/nvim-pack-lock.json'
  local lock = vim.json.decode(table.concat(vim.fn.readfile(lockfile), '\n')).plugins
  local installed = {}
  for _, pack in ipairs(vim.pack.get()) do
    local name = pack.spec.name
    installed[name] = true
    local notes = {}
    if not pack.active then
      table.insert(notes, 'INSTALLED BUT NOT ADDED THIS SESSION')
    end
    if not lock[name] then
      table.insert(notes, 'NOT IN LOCKFILE')
    elseif lock[name].rev ~= pack.rev then
      table.insert(notes, 'LOCKFILE REV ' .. lock[name].rev:sub(1, 8))
    end
    add(
      '%s rev=%s version=%s path=%s %s',
      name,
      pack.rev:sub(1, 8),
      pack.spec.version and tostring(pack.spec.version) or 'default branch',
      short(pack.path),
      table.concat(notes, ', ')
    )
  end
  for name in vim.spairs(lock) do
    if not installed[name] then
      add('%s IN LOCKFILE BUT NOT INSTALLED', name)
    end
  end
end

local function lsp()
  section('LSP configs enabled with vim.lsp.enable()')
  local configs = vim.lsp.get_configs({ enabled = true })
  table.sort(configs, function(a, b)
    return a.name < b.name
  end)
  for _, client in ipairs(configs) do
    local cmd = client.cmd
    local command
    if type(cmd) == 'table' then
      command = ('%s executable=%d'):format(cmd[1], vim.fn.executable(cmd[1]))
    else
      command = 'function at ' .. function_location(cmd)
    end
    add('%s cmd=%s filetypes=%s', client.name, command, table.concat(client.filetypes or {}, ','))
  end
end

local function formatters()
  section('conform.nvim formatters_by_ft')
  local conform = require('conform')
  for filetype, names in vim.spairs(conform.formatters_by_ft) do
    for _, name in ipairs(names) do
      local info = conform.get_formatter_info(name, 0)
      add('%s %s available=%s %s', filetype, name, tostring(info.available), info.available_msg or '')
    end
  end
end

local function linters()
  section('nvim-lint linters_by_ft')
  local lint = require('lint')
  for filetype, names in vim.spairs(lint.linters_by_ft) do
    for _, name in ipairs(names) do
      local linter = lint.linters[name]
      if type(linter) == 'function' then
        linter = linter()
      end
      local cmd = type(linter.cmd) == 'function' and linter.cmd() or linter.cmd
      add('%s %s cmd=%s executable=%d', filetype, name, cmd, vim.fn.executable(cmd))
    end
  end
end

local function treesitter()
  section('FileType autocmds defined in the configuration, with the Tree-sitter parser for each pattern')
  for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = 'FileType' })) do
    if type(autocmd.callback) == 'function' then
      local location = function_location(autocmd.callback)
      if not location:match('^[~/]') then
        local lang = vim.treesitter.language.get_lang(autocmd.pattern) or autocmd.pattern
        local loads = pcall(vim.treesitter.language.add, lang)
        add('%s lang=%s parser=%s  %s', autocmd.pattern, lang, loads and 'loads' or 'MISSING', location)
      end
    end
  end
  section("Parsers on 'runtimepath' (first one found wins)")
  for _, path in ipairs(vim.api.nvim_get_runtime_file('parser/*', true)) do
    add('%s  %s', vim.fn.fnamemodify(path, ':t:r'), short(vim.fn.fnamemodify(path, ':h')))
  end
end

local function keymap_lines(get)
  local names = script_names()
  for _, mode in ipairs(modes) do
    for _, map in ipairs(get(mode)) do
      local file = names[map.sid]
      if not (file and from_neovim(file)) then
        add(
          '%s %s  desc=%s  rhs=%s  %s',
          mode,
          vim.fn.keytrans(map.lhsraw),
          map.desc or 'NONE',
          map.rhs or 'Lua function',
          file and short(file) .. ':' .. map.lnum or 'unknown source'
        )
      end
    end
  end
end

local function keymaps()
  section("Global keymaps outside Neovim's defaults (see :h default-mappings)")
  keymap_lines(vim.api.nvim_get_keymap)

  vim.cmd.edit(vim.fn.fnameescape(config .. '/init.lua'))
  local attached = vim.wait(10000, function()
    return #vim.lsp.get_clients({ bufnr = 0 }) > 0 and vim.b.gitsigns_status_dict ~= nil
  end, 100)
  local clients = vim.tbl_map(function(client)
    return client.name
  end, vim.lsp.get_clients({ bufnr = 0 }))
  section(
    ('Buffer-local keymaps in init.lua (LSP clients: %s; gitsigns attached: %s%s)'):format(
      #clients > 0 and table.concat(clients, ',') or 'none',
      tostring(vim.b.gitsigns_status_dict ~= nil),
      attached and '' or '; timed out after 10 s, list may be partial'
    )
  )
  keymap_lines(function(mode)
    return vim.api.nvim_buf_get_keymap(0, mode)
  end)
end

local function health()
  section(':checkhealth warnings and errors')
  vim.cmd('checkhealth')
  local name, part, context = '', '', 0
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    if line:match('^=+$') then
      name = ''
    elseif name == '' and line:match('^%S.*:') then
      name = line:match('^(%S+):')
    elseif line:match(' ~$') then
      part = line:sub(1, -3)
    elseif line:match('^%- .*WARNING') or line:match('^%- .*ERROR') then
      add('%s / %s: %s', name, part, line:gsub('^%- %S+ ', ''))
      context = 2
    elseif context > 0 and line:match('^  %S') then
      add('    %s', vim.trim(line))
      context = context - 1
    else
      context = 0
    end
  end
end

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = vim.schedule_wrap(function()
    for _, step in ipairs({ neovim, options, packages, lsp, formatters, linters, treesitter, keymaps, health }) do
      local ok, err = xpcall(step, debug.traceback)
      if not ok then
        add('SECTION FAILED: %s', err)
      end
    end
    io.write(table.concat(lines, '\n'), '\n')
    vim.cmd('qa!')
  end),
})

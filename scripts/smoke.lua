local M = {}

if arg and arg[1] == 'preflight' then
  local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.env.NVIM_SMOKE_SOURCE .. '/nvim-pack-lock.json'), '\n'))
  for name, spec in pairs(lock.plugins) do
    local path = vim.env.NVIM_SMOKE_DATA .. '/site/pack/core/opt/' .. name
    local result = vim.system({ 'git', '-C', path, 'rev-parse', 'HEAD' }, { text = true }):wait()
    assert(
      result.code == 0 and vim.trim(result.stdout) == spec.rev,
      name .. ': missing or mismatched installation; install the locked revision in normal Neovim before make smoke'
    )
    assert(
      vim.system({ 'git', '-C', path, 'diff', '--quiet', 'HEAD' }):wait().code == 0,
      name .. ': modified plugin files; resolve local edits before make smoke'
    )
  end
  print('smoke: dependency preflight passed')
  return M
end

function M.guard()
  local native_brackets = {}
  for _, key in ipairs({ '[b', ']b', '[B', ']B', '[d', ']d', '[D', ']D' }) do
    local mapping = vim.fn.maparg(key, 'n', false, true)
    native_brackets[key] = { rhs = mapping.rhs, desc = mapping.desc }
  end
  vim.g.smoke_native_brackets = native_brackets
  vim.ui_attach(vim.api.nvim_create_namespace('smoke_errors'), { ext_messages = true }, function(event, kind)
    if event == 'msg_show' and (kind == 'emsg' or kind == 'echoerr' or kind == 'lua_error') then
      vim.schedule(function()
        vim.g.smoke_error = true
      end)
    end
  end)
  vim.api.nvim_create_autocmd('PackChangedPre', {
    callback = function(ev)
      vim.g.smoke_error = true
      error('smoke forbids package changes: ' .. ev.data.spec.name)
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    callback = function()
      vim.g.smoke_error = true
      error('smoke forbids parser maintenance')
    end,
  })
end

local function check_delete_others()
  vim.cmd('enew!')
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.api.nvim_buf_set_lines(current, 0, -1, false, { 'keep unsaved content' })
  vim.cmd.vsplit()
  local windows = vim.fn.win_findbuf(current)
  local unloaded = false
  local watch = vim.api.nvim_create_autocmd('BufUnload', {
    buffer = current,
    callback = function()
      unloaded = true
    end,
  })
  local clean = vim.api.nvim_create_buf(true, false)
  local unlisted = vim.api.nvim_create_buf(false, false)
  local delete_others = vim.fn.maparg('<leader>bo', 'n', false, true).callback
  delete_others()
  assert(not vim.bo[clean].buflisted, 'other clean buffer was not deleted')
  assert(vim.api.nvim_buf_is_loaded(unlisted), 'unlisted buffer was unloaded')
  assert(not unloaded and vim.api.nvim_buf_is_loaded(current), 'retained buffer was unloaded')
  assert(vim.api.nvim_get_current_buf() == current, 'current buffer changed')
  assert(vim.bo[current].modified and vim.api.nvim_get_current_line() == 'keep unsaved content', 'unsaved edits lost')
  assert(vim.deep_equal(windows, vim.fn.win_findbuf(current)), 'retained buffer windows changed')

  local before = vim.api.nvim_create_buf(true, false)
  local modified = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_lines(modified, 0, -1, false, { 'decline deletion' })
  local after = vim.api.nvim_create_buf(true, false)
  local confirm = vim.fn.confirm
  local prompts = 0
  vim.fn.confirm = function()
    prompts = prompts + 1
    return 1 -- MiniBufremove's default No response.
  end
  local ok, err = xpcall(delete_others, debug.traceback)
  vim.fn.confirm = confirm
  assert(ok, err)
  assert(prompts == 1, 'deletion should prompt only for the modified target')
  assert(not vim.bo[before].buflisted, 'deletion stopped before the declined target')
  assert(vim.bo[modified].buflisted and vim.bo[modified].modified, 'declined target was deleted')
  assert(vim.api.nvim_buf_get_lines(modified, 0, -1, false)[1] == 'decline deletion', 'declined edits lost')
  assert(vim.bo[after].buflisted, 'deletions continued after decline')
  vim.api.nvim_del_autocmd(watch)
  vim.api.nvim_win_close(windows[2], true)
  for _, buf in ipairs({ unlisted, before, modified, after }) do
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  vim.cmd('enew!')
end

local function check_lsp_highlights()
  local buffers = { vim.api.nvim_create_buf(true, false), vim.api.nvim_create_buf(true, false) }
  local clients = {}
  local get_clients, highlight = vim.lsp.get_clients, vim.lsp.buf.document_highlight
  local calls = 0
  vim.lsp.get_clients = function(filter)
    return vim.tbl_filter(function(client)
      return (not filter.id or client.id == filter.id) and (not filter.bufnr or client.buf == filter.bufnr)
    end, clients)
  end
  vim.lsp.buf.document_highlight = function()
    calls = calls + 1
  end
  local function attach(id, buf, supported)
    table.insert(clients, {
      id = id,
      buf = buf,
      name = 'smoke',
      supports_method = function()
        return supported
      end,
    })
    vim.api.nvim_exec_autocmds('LspAttach', { buffer = buf, data = { client_id = id }, group = 'lsp-attach' })
  end
  local function detach(id, buf)
    -- LspDetach runs before the departing client disappears from get_clients().
    vim.api.nvim_exec_autocmds('LspDetach', { buffer = buf, data = { client_id = id }, group = 'lsp-detach' })
    clients = vim.tbl_filter(function(client)
      return client.id ~= id
    end, clients)
  end
  local function expect(buf, count)
    for _, event in ipairs({ 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI' }) do
      local handlers = vim.api.nvim_get_autocmds({ group = 'lsp-highlight', buffer = buf, event = event })
      assert(#handlers == count, event .. ': incorrect highlight handler count')
    end
  end
  local ok, err = xpcall(function()
    attach(1, buffers[1], true)
    attach(2, buffers[1], true)
    attach(3, buffers[1], false)
    attach(4, buffers[2], true)
    expect(buffers[1], 1)
    expect(buffers[2], 1)
    vim.api.nvim_exec_autocmds('CursorHold', { buffer = buffers[1], group = 'lsp-highlight' })
    assert(calls == 1, 'one CursorHold dispatched multiple highlight calls')
    detach(1, buffers[1])
    expect(buffers[1], 1)
    detach(2, buffers[1])
    expect(buffers[1], 0)
    expect(buffers[2], 1)
    attach(5, buffers[1], true)
    expect(buffers[1], 1)
    detach(3, buffers[1])
    expect(buffers[1], 1)
    detach(5, buffers[1])
    detach(4, buffers[2])
    expect(buffers[1], 0)
    expect(buffers[2], 0)
  end, debug.traceback)
  vim.lsp.get_clients, vim.lsp.buf.document_highlight = get_clients, highlight
  for _, buf in ipairs(buffers) do
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  assert(ok, err)
end

local function check_native_editing()
  -- Test native motions directly; exercise MiniClue submodes interactively.
  require('mini.clue').disable_all_triggers()
  for key, native in pairs(vim.g.smoke_native_brackets) do
    local mapping = vim.fn.maparg(key, 'n', false, true)
    assert(mapping.desc == native.desc and mapping.rhs == native.rhs, key .. ': native mapping replaced')
  end
  vim.cmd('enew!')
  vim.b.miniclue_disable = true
  vim.b.completion = false
  vim.api.nvim_feedkeys(vim.keycode('ijk jj<Esc>'), 'mxt', false)
  assert(vim.api.nvim_get_current_line() == 'jk jj', 'escape chords still intercept literal text')
  vim.cmd('enew!')
  vim.b.miniclue_disable = true
  local first = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= first then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  local middle = vim.api.nvim_create_buf(true, false)
  local last = vim.api.nvim_create_buf(true, false)
  vim.b[middle].miniclue_disable = true
  vim.b[last].miniclue_disable = true
  for _, case in ipairs({ { '2]b', last }, { '[b', middle }, { '[B', first }, { ']B', last } }) do
    vim.api.nvim_feedkeys(vim.keycode(case[1]), 'mxt', false)
    assert(
      vim.api.nvim_get_current_buf() == case[2],
      string.format('%s: expected buffer %d, got %d', case[1], case[2], vim.api.nvim_get_current_buf())
    )
    vim.b.miniclue_disable = true
  end
  vim.api.nvim_buf_set_lines(last, 0, -1, false, { 'one', 'two', 'three', 'four', 'five' })
  local ns = vim.api.nvim_create_namespace('smoke_navigation')
  vim.diagnostic.set(ns, last, {
    { lnum = 0, col = 0, message = 'first' },
    { lnum = 2, col = 0, message = 'middle' },
    { lnum = 4, col = 0, message = 'last' },
  })
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  for _, case in ipairs({ { '2]d', 5 }, { '[d', 3 }, { '[D', 1 }, { ']D', 5 } }) do
    vim.api.nvim_feedkeys(vim.keycode(case[1]), 'mxt', false)
    assert(vim.api.nvim_win_get_cursor(0)[1] == case[2], case[1] .. ': diagnostic navigation failed')
  end
  vim.diagnostic.reset(ns)
  vim.api.nvim_buf_delete(last, { force = true })
  vim.api.nvim_buf_delete(middle, { force = true })
  vim.cmd('enew!')
end

local function check_archives()
  vim.fn.writefile({ 'smoke archive content' }, 'archive.txt')
  for _, cmd in ipairs({
    { 'gzip', '-k', 'archive.txt' },
    { 'tar', '-cf', 'archive.tar', 'archive.txt' },
    { 'zip', '-q', 'archive.zip', 'archive.txt' },
  }) do
    local result = vim.system(cmd, { text = true }):wait()
    assert(result.code == 0, result.stderr)
  end
  vim.cmd.edit('archive.txt.gz')
  assert(vim.api.nvim_get_current_line() == 'smoke archive content', 'gzip read failed')
  for _, extension in ipairs({ 'tar', 'zip' }) do
    vim.cmd.edit('archive.' .. extension)
    assert(vim.bo.filetype == extension, extension .. ': archive browser did not load')
    local row = vim.fn.search('^archive.txt$', 'w')
    assert(row > 0, extension .. ': archive member missing')
    vim.api.nvim_feedkeys(vim.keycode('<CR>'), 'mxt', false)
    assert(vim.api.nvim_get_current_line() == 'smoke archive content', extension .. ': member read failed')
  end
  assert(vim.fn.exists(':Tutor') == 2, 'Tutor command missing')
  vim.cmd('enew!')
end

function M.check()
  vim.schedule(function()
    local ok, err = xpcall(function()
      assert(vim.v.errmsg == '', vim.v.errmsg)
      for _, name in ipairs({ 'mini.ai', 'blink.cmp', 'oil', 'fzf-lua', 'plugins.lsp', 'plugins.treesitter' }) do
        assert(package.loaded[name], name .. ' was not loaded eagerly')
      end
      assert(vim.g.colors_name == 'token-ultra', 'colorscheme did not load')
      local servers = {
        'bashls',
        'basedpyright',
        'jsonls',
        'lua_ls',
        'marksman',
        'ruff',
        'tombi',
        'yamlls',
      }
      for _, name in ipairs(servers) do
        assert(vim.lsp.is_enabled(name), name .. ' is not enabled')
        assert(vim.lsp.config[name].cmd, name .. ' has no command')
      end
      for _, name in ipairs({ 'cssls', 'eslint', 'html', 'tinymist', 'vtsls' }) do
        assert(not vim.lsp.is_enabled(name), name .. ' is unexpectedly enabled')
      end
      vim.lsp.enable(servers, false)
      vim.g.disable_auto_lsp = true
      vim.g.disable_auto_lint = true
      local upstream_bashls = dofile(vim.api.nvim_get_runtime_file('lsp/bashls.lua', false)[1])
      assert(
        vim.lsp.config.bashls.settings.bashIde.globPattern == upstream_bashls.settings.bashIde.globPattern,
        'Bash scan default was overridden'
      )
      -- Opening Oil from the initial empty buffer must survive repeated FileType events.
      local oil_ready = false
      require('oil').open_float(nil, nil, function()
        oil_ready = true
      end)
      assert(
        vim.wait(5000, function()
          return oil_ready
        end),
        'Oil did not finish loading from an empty buffer'
      )
      assert(vim.v.errmsg == '', vim.v.errmsg)
      require('oil').close()
      for _, ft in ipairs({
        'css',
        'html',
        'javascript',
        'javascriptreact',
        'json',
        'jsonc',
        'typescript',
        'typescriptreact',
      }) do
        local bufnr = vim.api.nvim_create_buf(true, false)
        vim.bo[bufnr].filetype = ft
        assert(#require('conform').list_formatters_for_buffer(bufnr) == 0, ft .. ': unexpected formatter configured')
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
      for _, filename in ipairs({
        'sample.lua',
        'sample.ts',
        'sample.tsx',
        'sample.md',
        'sample.swift',
        'sample.go',
        'sample.rs',
        'Makefile',
      }) do
        vim.cmd.edit(filename)
        assert(vim.bo.filetype ~= '', filename .. ': no filetype')
        assert(#vim.lsp.get_clients({ bufnr = 0 }) == 0, 'smoke started an LSP client')
      end
      vim.fn.mkdir('editorconfig', 'p')
      vim.fn.writefile(vim.fn.readfile(vim.fn.stdpath('config') .. '/.editorconfig'), 'editorconfig/.editorconfig')
      for _, filename in ipairs({ 'Makefile', 'editorconfig/Makefile' }) do
        vim.cmd.edit(filename)
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'all:' })
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        vim.api.nvim_feedkeys(vim.keycode('oecho ok<Esc>'), 'nxt', false)
        assert(vim.api.nvim_buf_get_lines(0, 1, 2, false)[1] == '\techo ok', filename .. ': recipe needs a tab')
        vim.cmd('enew!')
      end

      for _, buflisted in ipairs({ true, false }) do
        vim.bo.buflisted = buflisted
        vim.bo.filetype = 'help'
        assert(vim.fn.maparg('q', 'n', false, true).desc == 'Close buffer', 'help close mapping missing')
        assert(not vim.bo.buflisted and not vim.wo.number, 'help buffer setup missing')
        vim.cmd.vsplit()
        local split = vim.api.nvim_get_current_win()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'unsaved buffer content' })
        vim.bo.filetype = 'lua'
        assert(vim.fn.maparg('q', 'n') == '', 'help close mapping leaked into Lua')
        assert(vim.bo.buflisted == buflisted, 'original buffer listing was not restored')
        assert(vim.bo.modified and vim.api.nvim_get_current_line() == 'unsaved buffer content', 'buffer edits lost')
        for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
          for _, option in ipairs({ 'number', 'relativenumber', 'signcolumn', 'statuscolumn' }) do
            assert(vim.wo[win][option] == vim.go[option], option .. ': help chrome leaked')
          end
        end
        vim.api.nvim_win_close(split, true)
        vim.cmd('enew!')
      end

      vim.cmd('enew!')
      for _, ft in ipairs({ 'markdown', 'gitcommit', 'typst', 'markdown' }) do
        vim.bo.filetype = ft
        assert(vim.wo.wrap and vim.wo.spell, ft .. ': prose settings missing')
        vim.cmd.vsplit()
        local split = vim.api.nvim_get_current_win()
        vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|let b:smoke_cleanup = 1'
        vim.bo.filetype = 'smoke_unavailable'
        assert(vim.b.smoke_cleanup == 1, 'earlier ftplugin cleanup was lost')
        vim.b.smoke_cleanup = nil
        for _, win in ipairs(vim.fn.win_findbuf(vim.api.nvim_get_current_buf())) do
          local wo = vim.wo[win]
          assert(not wo.wrap and not wo.spell, ft .. ': prose settings leaked')
          assert(wo.colorcolumn == '' and vim.bo.textwidth == 0, ft .. ': commit guides leaked')
          assert(wo.conceallevel == vim.go.conceallevel, ft .. ': conceal level leaked')
          assert(wo.foldmethod == 'manual', 'Treesitter folds leaked')
        end
        assert(not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()], 'Treesitter state leaked')
        vim.api.nvim_win_close(split, true)
      end
      assert(vim.fn.maparg('gr', 'n') == '', 'bare gr shadows native LSP mappings')
      for _, key in ipairs({ 'gra', 'gri', 'grn', 'grr', 'grt' }) do
        assert(vim.fn.maparg(key, 'n') ~= '', key .. ': native mapping missing')
      end
      check_delete_others()
      check_lsp_highlights()
      check_native_editing()
      check_archives()
      vim.wait(100)
      -- Native ftplugin undo uses silent! unmap, which can leave a harmless E31 in v:errmsg.
      assert(not vim.g.smoke_error, 'an error message occurred during startup or buffer checks')
    end, debug.traceback)
    if not ok then
      io.write(tostring(err) .. '\n')
      vim.cmd.cquit()
      return
    end
    io.write('smoke: passed\n')
    vim.cmd('qa!')
  end)
end

return M

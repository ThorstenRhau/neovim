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
        'cssls',
        'eslint',
        'html',
        'jsonls',
        'lua_ls',
        'marksman',
        'ruff',
        'tombi',
        'tinymist',
        'vtsls',
        'yamlls',
      }
      for _, name in ipairs(servers) do
        assert(vim.lsp.is_enabled(name), name .. ' is not enabled')
        assert(vim.lsp.config[name].cmd, name .. ' has no command')
      end
      vim.lsp.enable(servers, false)
      vim.g.disable_auto_lsp = true
      vim.g.disable_auto_lint = true
      for _, config in ipairs({ 'deno.json', 'deno.jsonc' }) do
        local ancestor_config = config == 'deno.json' and 'deno.jsonc' or 'deno.json'
        local repo = vim.fn.getcwd() .. '/vtsls-' .. config
        local node_root = repo .. '/node'
        local deno_root = node_root .. '/deno'
        vim.fn.mkdir(deno_root, 'p')
        vim.fn.writefile({ '{}' }, node_root .. '/package-lock.json')
        local bufnr = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_set_name(bufnr, deno_root .. '/main.ts')
        local function check_root(expected, label)
          local actual = false
          vim.lsp.config.vtsls.root_dir(bufnr, function(root)
            actual = root
          end)
          assert(actual == expected, 'vtsls ' .. config .. ': ' .. label .. ' (got ' .. tostring(actual) .. ')')
        end
        check_root(node_root, 'Node project root')
        vim.fn.writefile({ '{}' }, repo .. '/' .. ancestor_config)
        check_root(node_root, 'nearer Node lockfile below ancestor Deno config')
        vim.fn.writefile({ '{}' }, deno_root .. '/' .. config)
        check_root(false, 'nearest Deno config must exclude the buffer')
        vim.fn.delete(deno_root .. '/' .. config)
        vim.fn.writefile({ '{}' }, node_root .. '/' .. config)
        check_root(false, 'Deno config at Node root must exclude the buffer')
        vim.api.nvim_buf_delete(bufnr, { force = true })
        vim.fn.delete(repo, 'rf')
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
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'all:' })
      vim.api.nvim_feedkeys(vim.keycode('oecho ok<Esc>'), 'nxt', false)
      assert(vim.api.nvim_buf_get_lines(0, 1, 2, false)[1] == '\techo ok', 'Makefile recipe needs a tab')
      vim.cmd('enew!')
      for _, ft in ipairs({ 'markdown', 'gitcommit', 'typst', 'markdown' }) do
        vim.bo.filetype = ft
        assert(vim.wo.wrap and vim.wo.spell, ft .. ': prose settings missing')
        vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|let b:smoke_cleanup = 1'
        vim.bo.filetype = 'smoke_unavailable'
        assert(vim.b.smoke_cleanup == 1, 'earlier ftplugin cleanup was lost')
        vim.b.smoke_cleanup = nil
        assert(not vim.wo.wrap and not vim.wo.spell, ft .. ': prose settings leaked')
        assert(vim.wo.colorcolumn == '' and vim.bo.textwidth == 0, ft .. ': commit guides leaked')
        assert(not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()], 'Treesitter state leaked')
        assert(vim.wo.foldmethod == 'manual', 'Treesitter folds leaked')
        assert(vim.fn.maparg('<leader>tp', 'n') == '', 'Typst preview mapping leaked')
      end
      assert(vim.fn.maparg('gr', 'n') == '', 'bare gr shadows native LSP mappings')
      for _, key in ipairs({ 'gra', 'gri', 'grn', 'grr', 'grt' }) do
        assert(vim.fn.maparg(key, 'n') ~= '', key .. ': native mapping missing')
      end
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

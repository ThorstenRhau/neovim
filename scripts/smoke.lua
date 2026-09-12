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

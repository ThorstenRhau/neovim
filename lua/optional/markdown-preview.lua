---@module "lazy"
---@type LazySpec
return {
  'iamcco/markdown-preview.nvim',
  ft = { 'markdown' },
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  keys = {
    {
      '<leader>uM',
      '<cmd>MarkdownPreviewToggle<cr>',
      desc = 'Markdown preview (browser)',
    },
  },
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_auto_close = 0
  end,
  build = function(plugin)
    -- Define commands
    local install_cmd = { 'npx', '--yes', 'yarn', 'install' }
    local restore_cmd = { 'git', 'restore', 'package.json' } -- Add restore command
    -- Potentially add yarn.lock if it's also modified:
    -- local restore_cmd = { "git", "restore", "package.json", "yarn.lock" }
    local app_dir = plugin.dir .. '/app'
    local plugin_dir = plugin.dir -- Plugin root directory for git restore

    -- Run install command
    if vim.fn.executable('npx') == 1 then
      vim.system(install_cmd, { cwd = app_dir }, function(res)
        if res.code ~= 0 then
          vim.notify('markdown-preview.nvim: yarn install failed', vim.log.levels.ERROR)
        else
          -- Run restore command AFTER successful install
          vim.system(restore_cmd, { cwd = plugin_dir }, function(restore_res)
            if restore_res.code ~= 0 then
              vim.notify('markdown-preview.nvim: git restore failed for package.json', vim.log.levels.WARN)
            end
          end)
        end
      end)
    else
      -- Fallback install method
      vim.fn['mkdp#util#install']()
      -- Also run restore command after fallback install
      vim.system(restore_cmd, { cwd = plugin_dir }, function(restore_res)
        if restore_res.code ~= 0 then
          vim.notify('markdown-preview.nvim: git restore failed for package.json', vim.log.levels.WARN)
        end
      end)
    end
  end,
}

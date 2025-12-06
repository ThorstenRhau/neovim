---@module "lazy"
---@type LazySpec
return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  event = 'VeryLazy',
  opts = {
    auto_update = true,
    run_on_start = true,
    start_delay = 3000, -- 3 second delay
    debounce_hours = 12,
    ensure_installed = {
      'bash-debug-adapter',
      'bashls',
      'checkmake',
      'debugpy',
      'eslint_d',
      'fish-lsp',
      'html',
      'jsonlint',
      'jsonls',
      'lemminx',
      'lua_ls',
      'markdownlint',
      'marksman',
      'prettier',
      'pyright',
      'ruff',
      'shellcheck',
      'shfmt',
      'stylua',
      'taplo',
      'ts_ls',
      'xmlformatter',
      'yamlfmt',
      'yamllint',
      'yamlls',
    },
  },
}

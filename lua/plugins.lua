vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack_changed', { clear = true }),
  callback = function(event)
    if event.data.spec.name == 'nvim-treesitter' and event.data.kind == 'update' then
      if not event.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd.TSUpdate()
    end
  end,
})

local packages = {
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/b0o/schemastore.nvim' },
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/NeogitOrg/neogit' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/mfussenegger/nvim-lint' },
  { src = 'https://github.com/saghen/blink.indent' },
  { src = 'https://github.com/nvim-mini/mini.splitjoin' },
  { src = 'https://github.com/nvim-mini/mini.clue' },
  { src = 'https://github.com/folke/sidekick.nvim' },
}

if vim.env.TOKEN_DEV == '1' then
  vim.opt.runtimepath:prepend('/Users/thorre/github/token')
else
  table.insert(packages, 1, { src = 'https://github.com/ThorstenRhau/token', version = vim.version.range('*') })
end

vim.pack.add(packages)

require('token').setup({
  plugins = {
    blink = true,
    blink_indent = true,
    fzf = true,
    gitsigns = true,
    mini = true,
    neogit = true,
    oil = true,
  },
})
vim.cmd.colorscheme('token-ultra')

require('blink.cmp').setup({
  keymap = { preset = 'super-tab' },
  completion = { trigger = { show_in_snippet = false } },
  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
    },
  },
})

require('fzf-lua').setup({
  defaults = { file_icons = false },
  files = { hidden = true, follow = true },
  grep = { hidden = true, follow = true },
  oldfiles = { include_current_session = true },
})
require('fzf-lua').register_ui_select()

require('oil').setup({
  columns = {},
  view_options = { show_hidden = true },
  delete_to_trash = true,
})

local gitsigns = require('gitsigns')
gitsigns.setup({
  on_attach = function(buf)
    vim.keymap.set('n', '[h', function()
      gitsigns.nav_hunk('prev', { target = 'all' })
    end, { buffer = buf, desc = 'Previous hunk' })
    vim.keymap.set('n', ']h', function()
      gitsigns.nav_hunk('next', { target = 'all' })
    end, { buffer = buf, desc = 'Next hunk' })
    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { buffer = buf, desc = 'Preview hunk' })
    vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { buffer = buf, desc = 'Blame line' })
  end,
})
require('neogit').setup({ integrations = { fzf_lua = true } })

require('conform').setup({
  formatters_by_ft = {
    bash = { 'shfmt' },
    sh = { 'shfmt' },
    python = { 'ruff_format' },
    lua = { 'stylua' },
    markdown = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    toml = { 'tombi' },
  },
})
require('lint').linters_by_ft = {
  bash = { 'shellcheck' },
  sh = { 'shellcheck' },
  lua = { 'selene' },
  markdown = { 'markdownlint' },
  yaml = { 'yamllint' },
}

require('blink.indent').setup({
  blocked = { filetypes = { include_defaults = true, 'oil' } },
  mappings = {
    object_scope = '',
    object_scope_with_border = '',
    goto_top = '',
    goto_bottom = '',
  },
})
require('mini.splitjoin').setup()
require('sidekick').setup({
  nes = { enabled = false },
  cli = { picker = 'fzf-lua' },
  copilot = { status = { enabled = false } },
})

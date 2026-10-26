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
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/NeogitOrg/neogit' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://codeberg.org/mfussenegger/nvim-lint' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim', version = vim.version.range('3.x') },
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-mini/mini.statusline' },
  { src = 'https://github.com/nvim-mini/mini.splitjoin' },
  { src = 'https://github.com/nvim-mini/mini.clue' },
  { src = 'https://github.com/ThorstenRhau/brygga.nvim', version = vim.version.range('*') },
}

if vim.env.TOKEN_DEV == '1' then
  vim.opt.runtimepath:prepend('/Users/thorre/github/token')
  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
      vim.notify('token: DEV mode, loading from /Users/thorre/github/token')
    end,
  })
else
  table.insert(packages, 1, { src = 'https://github.com/ThorstenRhau/token', version = vim.version.range('*') })
end

vim.pack.add(packages)

require('token').setup({
  plugins = {
    blink = true,
    fzf = true,
    gitsigns = true,
    ibl = true,
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
  'fzf-native',
  defaults = { git_icons = true },
  winopts = { border = 'single' },
  files = { follow = true },
  grep = {
    hidden = true,
    follow = true,
    -- fzf-lua clears RIPGREP_CONFIG_PATH, so exclude .git here.
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob=!.git/ -e',
  },
  oldfiles = { include_current_session = true },
})

require('oil').setup({
  columns = {},
  view_options = { show_hidden = true },
  delete_to_trash = true,
})

local gitsigns = require('gitsigns')
gitsigns.setup({
  on_attach = function(buf)
    vim.keymap.set('n', '[h', function()
      --- @diagnostic disable-next-line: missing-fields
      gitsigns.nav_hunk('prev', { target = 'all' })
    end, { buf = buf, desc = 'Previous hunk' })
    vim.keymap.set('n', ']h', function()
      --- @diagnostic disable-next-line: missing-fields
      gitsigns.nav_hunk('next', { target = 'all' })
    end, { buf = buf, desc = 'Next hunk' })
    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { buf = buf, desc = 'Preview hunk' })
    vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { buf = buf, desc = 'Blame line' })
    -- Keep mini.clue triggers ahead of these buffer-local mappings.
    require('mini.clue').ensure_buf_triggers(buf)
  end,
})

require('neogit').setup({
  disable_insert_on_commit = true,
  graph_style = 'kitty',
})

require('conform').setup({
  formatters_by_ft = {
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
  lua = { 'selene' },
  markdown = { 'markdownlint' },
  yaml = { 'yamllint' },
}

require('ibl').setup({
  indent = {
    char = '│',
    tab_char = '│',
  },
  scope = {
    show_exact_scope = true,
  },
})

require('mini.icons').setup()

require('mini.statusline').setup()

require('mini.splitjoin').setup()

require('brygga').setup()

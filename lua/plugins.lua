-- Rebuild Tree-sitter parsers when nvim-treesitter updates
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
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/NeogitOrg/neogit' },
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://codeberg.org/mfussenegger/nvim-lint' },
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-mini/mini.splitjoin' },
  { src = 'https://github.com/nvim-mini/mini.align' },
  { src = 'https://github.com/nvim-mini/mini.clue' },
  { src = 'https://github.com/ThorstenRhau/brygga.nvim', version = vim.version.range('*') },
}

-- Colorscheme from a local checkout with TOKEN_DEV=1
if vim.env.TOKEN_DEV == '1' then
  local token_dev = vim.fn.expand('~/github/token')
  vim.opt.runtimepath:prepend(token_dev)
  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
      vim.notify('token: DEV mode, loading from ' .. token_dev)
    end,
  })
else
  local token = { src = 'https://github.com/ThorstenRhau/token', version = vim.version.range('*') }
  table.insert(packages, 1, token)
end

vim.pack.add(packages)

-- Colorscheme

require('token').setup({
  plugins = {
    blink = true,
    fzf = true,
    gitsigns = true,
    mini = true,
    neogit = true,
    oil = true,
    render_markdown = true,
  },
})

vim.cmd.colorscheme('token')

-- Completion

require('blink.cmp').setup({
  keymap = { preset = 'super-tab', ['<C-c>'] = { 'cancel', 'fallback' } },
  completion = {
    trigger = { show_in_snippet = false },
    menu = {
      auto_show = function()
        return vim.b.completion_auto ~= false
      end,
    },
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },
  signature = { enabled = true },
  cmdline = { completion = { list = { selection = { preselect = false } } } },
})

-- Fuzzy finder

local rg_opts = table.concat({
  '--column',
  '--line-number',
  '--no-heading',
  '--color=always',
  '--smart-case',
  '--max-columns=4096',
  '--glob=!.git/',
  '-e',
}, ' ')

-- man -k is slow on macOS. ~/github/macOS/scripts/update-system.sh writes this cache.
local manpages = vim.fn.shellescape(vim.fn.stdpath('cache') .. '/manpages.txt')

require('fzf-lua').setup({
  { 'ivy' },
  ui_select = function(o, items)
    local preview = o.kind == 'codeaction' and 0.20 or 0
    local height = math.min(math.max((#items + 6) / vim.o.lines + preview, 0.15), 0.70)
    return {
      'default',
      winopts = { fullscreen = false, height = height, width = 0.60, row = 0.40 },
    }
  end,
  fzf_colors = true,
  defaults = { git_icons = true },
  files = { follow = true },
  grep = {
    hidden = true,
    follow = true,
    fzf_opts = { ['--history'] = vim.fn.stdpath('data') .. '/fzf_search_hist' },
    rg_opts = rg_opts,
  },
  manpages = { cmd = 'cat ' .. manpages .. ' 2>/dev/null || man -k .' },
  previewers = { builtin = { limit_b = 200 * 1024 } },
  winopts = {
    border = 'rounded',
    treesitter = { enabled = true, fzf_colors = false },
  },
  oldfiles = { include_current_session = true },
})

-- File explorer

require('oil').setup({
  view_options = { show_hidden = true },
  delete_to_trash = true,
})

-- Git

local gitsigns = require('gitsigns')

gitsigns.setup({
  signs = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '▁' },
    topdelete = { text = '▔' },
    changedelete = { text = '┃' },
    untracked = { text = '┃' },
  },
  signs_staged = {
    add = { text = '┇' },
    change = { text = '┇' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '┇' },
  },
  on_attach = function(buf)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buf = buf, desc = desc })
    end

    local function lines()
      return { vim.fn.line('.'), vim.fn.line('v') }
    end

    map('n', '[h', function()
      gitsigns.nav_hunk('prev', { target = 'all' })
    end, 'Previous hunk')

    map('n', ']h', function()
      gitsigns.nav_hunk('next', { target = 'all' })
    end, 'Next hunk')

    vim.keymap.set('n', '<leader>gh', ']h', { buf = buf, remap = true, desc = 'Next hunk' })

    map('n', '<LocalLeader>h', function()
      gitsigns.nav_hunk('next', { target = 'all', preview = true })
    end, 'Next hunk with preview')

    map('n', '<LocalLeader>H', function()
      gitsigns.nav_hunk('prev', { target = 'all', preview = true })
    end, 'Previous hunk with preview')

    map('n', '<leader>gp', gitsigns.preview_hunk, 'Preview hunk')
    map('n', '<leader>gb', gitsigns.blame_line, 'Blame line')
    map('n', '<leader>gs', gitsigns.stage_hunk, 'Stage or unstage hunk')
    map('n', '<leader>gS', gitsigns.stage_buffer, 'Stage buffer')
    map('n', '<leader>gr', gitsigns.reset_hunk, 'Reset hunk')
    map('n', '<leader>gd', gitsigns.diffthis, 'Diff against index')
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Hunk')

    map('x', '<leader>gs', function()
      gitsigns.stage_hunk(lines())
    end, 'Stage selected lines')

    map('x', '<leader>gr', function()
      gitsigns.reset_hunk(lines())
    end, 'Reset selected lines')

    map('n', '<leader>gq', function()
      gitsigns.setqflist('all')
    end, 'All hunks to quickfix')

    require('mini.clue').ensure_buf_triggers(buf)
  end,
})

require('neogit').setup({
  disable_insert_on_commit = true,
  graph_style = 'kitty',
  treesitter_diff_highlight = true,
  commit_editor = { show_staged_diff = false },
})

-- Markdown

---@diagnostic disable-next-line: undefined-field
require('render-markdown').setup({
  sign = { enabled = false },
})

-- Formatting

local web = { 'biome', 'prettier', stop_after_first = true }

require('conform').setup({
  formatters = { biome = { require_cwd = true } },
  formatters_by_ft = {
    sh = { 'shfmt' },
    python = { 'ruff_format' },
    lua = { 'stylua' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    toml = { 'tombi' },
    javascript = web,
    javascriptreact = web,
    typescript = web,
    typescriptreact = web,
  },
})

-- Linting

require('lint').linters_by_ft = {
  lua = { 'selene' },
  yaml = { 'yamllint' },
  swift = { 'swiftlint' },
}

-- mini.nvim

require('mini.icons').setup()
require('mini.splitjoin').setup()
require('mini.align').setup({
  mappings = { start = '<leader>cl', start_with_preview = '<leader>cL' },
})

-- Claude Code bridge

require('brygga').setup()

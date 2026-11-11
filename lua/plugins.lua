-- Rebuild Tree-sitter parsers after the plugin updates.
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

-- Plugins installed by vim.pack.
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
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
}

-- With TOKEN_DEV=1, load the colorscheme from a local checkout instead of the package.
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
  table.insert(packages, 1, { src = 'https://github.com/ThorstenRhau/token', version = vim.version.range('*') })
end

-- Install and load all packages.
vim.pack.add(packages)

-- Colorscheme and its plugin integrations.
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
  -- <C-c> cancels like it does in fzf-lua and Oil, and leaves insert mode
  -- when the menu is closed.
  keymap = { preset = 'super-tab', ['<C-c>'] = { 'cancel', 'fallback' } },
  completion = {
    trigger = { show_in_snippet = false },
    -- <leader>tc flips vim.b.completion_auto; <C-Space> still opens the menu.
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

-- Fuzzy finder.
require('fzf-lua').setup({
  'ivy',
  defaults = { git_icons = true },
  files = { follow = true },
  grep = {
    hidden = true,
    follow = true,
    -- fzf-lua clears RIPGREP_CONFIG_PATH, so exclude .git here.
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob=!.git/ -e',
  },
  oldfiles = { include_current_session = true },
  -- man -k rebuilds its index on each call on macOS, and fzf-lua runs it
  -- twice. ~/github/macOS/scripts/update-system.sh writes this cache.
  manpages = {
    cmd = 'cat ' .. vim.fn.shellescape(vim.fn.stdpath('cache') .. '/manpages.txt') .. ' 2>/dev/null || man -k .',
  },
})

-- File explorer.
require('oil').setup({
  view_options = { show_hidden = true },
  delete_to_trash = true,
})

-- Git signs and hunk mappings.
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
    vim.keymap.set('n', '[h', function()
      gitsigns.nav_hunk('prev', { target = 'all' })
    end, { buf = buf, desc = 'Previous hunk' })
    vim.keymap.set('n', ']h', function()
      gitsigns.nav_hunk('next', { target = 'all' })
    end, { buf = buf, desc = 'Next hunk' })
    vim.keymap.set('n', '<leader>gh', ']h', { buf = buf, remap = true, desc = 'Next hunk' })
    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { buf = buf, desc = 'Preview hunk' })
    vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { buf = buf, desc = 'Blame line' })
    -- On a staged hunk, stage_hunk unstages it.
    vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { buf = buf, desc = 'Stage or unstage hunk' })
    vim.keymap.set('x', '<leader>gs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { buf = buf, desc = 'Stage selected lines' })
    vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer, { buf = buf, desc = 'Stage buffer' })
    vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { buf = buf, desc = 'Reset hunk' })
    vim.keymap.set('x', '<leader>gr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { buf = buf, desc = 'Reset selected lines' })
    vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, { buf = buf, desc = 'Diff against index' })
    vim.keymap.set('n', '<leader>gq', function()
      gitsigns.setqflist('all')
    end, { buf = buf, desc = 'All hunks to quickfix' })
    vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { buf = buf, desc = 'Hunk' })
    -- Keep mini.clue triggers ahead of these buffer-local mappings.
    require('mini.clue').ensure_buf_triggers(buf)
  end,
})

-- Git client.
require('neogit').setup({
  disable_insert_on_commit = true,
  graph_style = 'kitty',
  -- Syntax colors on the tinted diff lines, like delta in the terminal.
  treesitter_diff_highlight = true,
  -- Git's commit.verbose already puts the diff in the message buffer.
  commit_editor = { show_staged_diff = false },
})

---@diagnostic disable-next-line: undefined-field
-- Markdown renders in normal, command-line and terminal mode, and shows raw
-- text in the other modes.
require('render-markdown').setup({
  -- Its signs outrank gitsigns, and 'signcolumn' auto has room for one sign,
  -- so they would hide Git changes on headings and code blocks.
  sign = { enabled = false },
})

-- Formatters per filetype. C, Go, Rust, Swift, Markdown and Ruby have no
-- entry: the format key falls back to their language servers, which run
-- clang-format, gofmt, rustfmt, swift-format, rumdl and the project's bundled
-- RuboCop.
-- JavaScript and TypeScript use Biome in projects with a Biome config, so the
-- result agrees with `biome check`, and prettier everywhere else.
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

-- Linters per filetype. Rust, Go and C lint through their language servers:
-- clippy in lsp.lua, and the staticcheck and clang-tidy checks that gopls and
-- clangd run by default. JavaScript and TypeScript lint through the biome
-- server, which attaches only in projects with a Biome config. Ruby lints
-- through ruby_lsp, which runs RuboCop when the project's Gemfile has it.
require('lint').linters_by_ft = {
  lua = { 'selene' },
  yaml = { 'yamllint' },
  swift = { 'swiftlint' },
}

-- mini.nvim modules.
require('mini.icons').setup()

require('mini.splitjoin').setup()

require('mini.align').setup({
  mappings = { start = '<leader>cl', start_with_preview = '<leader>cL' },
})

-- Bridge that lets Claude Code use Neovim as its IDE.
require('brygga').setup()

-- Minimal statusline per window. Optional components render only when they have
-- something to say, and the secondary ones also need a wide enough window.
local function wide(columns)
  return function()
    return vim.o.columns >= columns
  end
end

local function recording()
  local reg = vim.fn.reg_recording()
  return reg ~= '' and '@' .. reg or ''
end

-- Only show encoding and format when they differ from utf-8 and unix.
local function encoding()
  local fenc, ff = vim.bo.fileencoding, vim.bo.fileformat
  if (fenc == '' or fenc == 'utf-8') and ff == 'unix' then
    return ''
  end
  return ('%s[%s]'):format(fenc, ff)
end

-- Nerd Font lock, shown after the name of a readonly or unmodifiable buffer.
local readonly = vim.fn.nr2char(0xF023)

-- Use gitsigns' counts instead of running another git diff.
local function gitsigns_diff()
  local status = vim.b.gitsigns_status_dict
  if status then
    return { added = status.added, modified = status.changed, removed = status.removed }
  end
end

-- lualine reassigns its module table after `local M = {}`, and emmylua_ls only
-- sees the empty first table.
---@diagnostic disable-next-line: undefined-field
require('lualine').setup({
  options = {
    component_separators = '',
    section_separators = '',
    refresh = {
      -- Lualine's defaults plus recording and LSP client changes, which would
      -- otherwise wait for the one-second refresh timer. The list replaces the
      -- defaults instead of extending them.
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
        'RecordingEnter',
        'RecordingLeave',
        'LspAttach',
        'LspDetach',
      },
    },
  },
  sections = {
    lualine_a = {
      -- One letter, colored by the theme per mode.
      {
        'mode',
        fmt = function(mode)
          return mode:sub(1, 1)
        end,
      },
    },
    lualine_b = {
      { 'filename', path = 1, symbols = { modified = '●', readonly = readonly } },
    },
    lualine_c = {
      { 'branch', icons_enabled = false, cond = wide(80) },
      { 'diff', source = gitsigns_diff, cond = wide(80) },
      { 'diagnostics', sources = { 'nvim_diagnostic' } },
    },
    lualine_x = {
      { recording, color = 'DiagnosticError' },
      { 'searchcount' },
      { 'selectioncount' },
      -- Names with a spinner while a server works, no check mark when idle.
      { 'lsp_status', icons_enabled = false, symbols = { done = '' }, cond = wide(100) },
    },
    lualine_y = {
      { encoding },
      { 'filetype', icons_enabled = false, cond = wide(60) },
    },
    lualine_z = {
      { 'location', cond = wide(40) },
    },
  },
  inactive_sections = {
    lualine_c = {
      { 'filename', path = 1, symbols = { modified = '●', readonly = readonly } },
    },
  },
})

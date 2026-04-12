local M = {}

-- True when running without a UI (e.g. headless scripts)
M.is_headless = #vim.api.nvim_list_uis() == 0

-- Shared UI tokens consumed by plugins and options
M.ui = {
  border = 'single',

  listchars = {
    extends = '›',
    nbsp = '␣',
    precedes = '‹',
    tab = '→ ',
    trail = '·',
  },

  fillchars = {
    diff = '░',
    eob = ' ',
    fold = '─',
    msgsep = '━',
  },
}

-- Nerd Font icons for vim.diagnostic
M.diagnostic_symbols = {
  error = '󰅚 ',
  hint = '󰌶 ',
  info = '󰋽 ',
  warn = '󰀪 ',
}

-- Filetype groups used by autocmds
M.filetypes = {
  -- Sidebar-style buffers that need special width handling
  tree_views = { 'NvimTree', 'oil' },
  -- Skip "restore last cursor position" for these
  restore_cursor_exclude = {
    'gitcommit',
    'gitrebase',
    'help',
  },

  -- Dismiss with a single `q` keypress, 'man' is excluded on purpose
  close_with_q = {
    'NeogitStatus',
    'checkhealth',
    'git',
    'gitsigns-blame',
    'help',
    'lspinfo',
    'notify',
    'nvim-pack',
    'qf',
    'startuptime',
  },

  -- Hide line numbers, sign column, etc.
  no_chrome = {
    'NeogitStatus',
    'NvimTree',
    'checkhealth',
    'help',
    'oil',
  },
}

return M

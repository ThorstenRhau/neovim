-- Icons (must load first, other plugins depend on it)
require('mini.icons').setup()
_G.MiniIcons.mock_nvim_web_devicons()

-- Align text interactively
require('mini.align').setup()

-- Split and join arguments
require('mini.splitjoin').setup()
vim.keymap.set({ 'n', 'x' }, '<leader>cj', function()
  require('mini.splitjoin').toggle()
end, { desc = 'split/join' })

-- Extended a/i textobjects
require('mini.ai').setup()

-- Surround actions (sa=add, sd=delete, sr=replace)
require('mini.surround').setup()

-- Auto-pairs
require('mini.pairs').setup()

-- Bracket navigation ([b/]b=buffer, [c/]c=comment, [d/]d=diagnostic, etc.)
require('mini.bracketed').setup({
  file = { suffix = '' },
  quickfix = { suffix = '' },
})

-- Move selected text with meta+hjkl
require('mini.move').setup()

-- Statusline
local constants = require('config.constants')
require('mini.statusline').setup({
  use_icons = true,
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git = MiniStatusline.section_git({ trunc_width = 40 })
      local diff = MiniStatusline.section_diff({ trunc_width = 75 })
      local diagnostics = MiniStatusline.section_diagnostics({
        trunc_width = 75,
        signs = {
          ERROR = constants.diagnostic_symbols.error,
          WARN = constants.diagnostic_symbols.warn,
          INFO = constants.diagnostic_symbols.info,
          HINT = constants.diagnostic_symbols.hint,
        },
      })
      local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

      -- Custom location section with lualine-style formatting
      local location = (function()
        if MiniStatusline.is_truncated(75) then
          return '%l│%2v'
        end
        return '%P %l│%2v'
      end)()

      return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
        '%<',
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=',
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location } },
      })
    end,
  },
})

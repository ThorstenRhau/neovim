-- vim-matchup globals must be set before the plugin loads
vim.g.matchup_matchparen_offscreen = { method = 'popup' }
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_treesitter_stopline = 500
vim.g.matchup_treesitter_include_match_words = false
vim.g.matchup_treesitter_enable_quotes = true

-- Build hooks (must be registered before vim.pack.add)
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack_changed', { clear = true }),
  callback = function(ev)
    if ev.data.kind == 'delete' then
      return
    end
    local name = ev.data.spec.name
    if name == 'nvim-treesitter' then
      local ok, err = pcall(function()
        if not ev.data.active then
          vim.cmd.packadd(name)
        end
        vim.cmd('TSUpdate')
      end)
      if not ok then
        vim.notify('Failed to update Treesitter parsers: ' .. tostring(err), vim.log.levels.ERROR)
      end
    end
  end,
})

vim.pack.add({
  -- Colorscheme
  { src = 'https://github.com/ThorstenRhau/token' },

  -- Treesitter
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },

  -- Completion
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },

  -- LSP
  { src = 'https://github.com/b0o/schemastore.nvim' },
  { src = 'https://github.com/folke/lazydev.nvim' },

  -- Editor
  { src = 'https://github.com/abecodes/tabout.nvim' },
  { src = 'https://github.com/andymass/vim-matchup' },
  { src = 'https://github.com/nvim-mini/mini.splitjoin' },

  -- Mini
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-mini/mini.align' },
  { src = 'https://github.com/nvim-mini/mini.ai' },
  { src = 'https://github.com/nvim-mini/mini.surround' },
  { src = 'https://github.com/nvim-mini/mini.pairs' },
  { src = 'https://github.com/nvim-mini/mini.bracketed' },
  { src = 'https://github.com/nvim-mini/mini.bufremove' },
  { src = 'https://github.com/nvim-mini/mini.statusline' },
  { src = 'https://github.com/nvim-mini/mini.clue' },
  { src = 'https://github.com/nvim-mini/mini.sessions' },

  -- Picker
  { src = 'https://github.com/ibhagwan/fzf-lua' },

  -- Git
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },

  -- Format
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/mfussenegger/nvim-lint' },

  -- UI
  { src = 'https://github.com/karb94/neoscroll.nvim' },

  -- AI
  { src = 'https://github.com/folke/sidekick.nvim' },

  -- Explorer
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
}, { load = true, confirm = false })

-- Neogit setup must run before its one-shot command setup, so load it on first use.
vim.pack.add({
  { src = 'https://github.com/NeogitOrg/neogit' },
}, { load = function() end, confirm = false })

-- Load plugin configurations (order matters for dependencies)
require('plugins.mini')
require('plugins.treesitter')
-- Blink preserves existing insert mappings in its fallback chain.
require('plugins.tabout')
require('plugins.completion')
require('plugins.lsp')
require('plugins.gitsigns')
require('plugins.formatter')
require('plugins.linter')
require('plugins.neoscroll')
-- Deferred plugins: fzf, neogit, oil, nvim-tree, sidekick
-- Loaded on first keymap press (see config/defer.lua)
require('config.defer')

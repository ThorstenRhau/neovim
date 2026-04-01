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
      pcall(function()
        vim.cmd('TSUpdate')
      end)
    elseif name == 'mason.nvim' then
      pcall(function()
        vim.cmd('MasonUpdate')
      end)
    end
  end,
})

vim.pack.add({
  -- Treesitter
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },

  -- Completion
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },

  -- LSP
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/williamboman/mason.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  { src = 'https://github.com/b0o/schemastore.nvim' },
  { src = 'https://github.com/folke/lazydev.nvim' },

  -- Editor
  { src = 'https://github.com/abecodes/tabout.nvim' },
  { src = 'https://github.com/andymass/vim-matchup' },
  { src = 'https://github.com/Wansmer/treesj' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/OXY2DEV/markview.nvim' },
  { src = 'https://github.com/tadmccorkle/markdown.nvim', name = 'markdown.nvim' },

  -- Mini
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-mini/mini.align' },
  { src = 'https://github.com/nvim-mini/mini.ai' },
  { src = 'https://github.com/nvim-mini/mini.surround' },
  { src = 'https://github.com/nvim-mini/mini.pairs' },
  { src = 'https://github.com/nvim-mini/mini.bracketed' },
  { src = 'https://github.com/nvim-mini/mini.move' },
  { src = 'https://github.com/nvim-mini/mini.statusline' },
  { src = 'https://github.com/nvim-mini/mini.clue' },

  -- Picker
  { src = 'https://github.com/ibhagwan/fzf-lua' },

  -- Git
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/sindrets/diffview.nvim' },
  { src = 'https://github.com/NeogitOrg/neogit' },

  -- Format
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/mfussenegger/nvim-lint' },

  -- UI

  { src = 'https://github.com/folke/trouble.nvim' },
  { src = 'https://github.com/karb94/neoscroll.nvim' },

  -- Explorer
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },

  -- Session
  { src = 'https://github.com/folke/persistence.nvim' },

  -- Claude Code
  { src = 'https://github.com/coder/claudecode.nvim' },
}, { load = true, confirm = false })

-- Load plugin configurations (order matters for dependencies)
require('plugins.mini')
require('plugins.treesitter')
require('plugins.completion')
require('plugins.lsp')
require('plugins.editor')
require('plugins.picker')
require('plugins.git')
require('plugins.format')
require('plugins.ui')
require('plugins.explorer')
require('plugins.session')
require('plugins.claudecode')

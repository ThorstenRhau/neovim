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

local token_dev = vim.env.TOKEN_DEV == '1'
if token_dev then
  vim.opt.runtimepath:prepend('/Users/thorre/github/token')
end

local packages = {

  -- Treesitter
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
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
  { src = 'https://github.com/nvim-mini/mini.animate' },
  { src = 'https://github.com/nvim-mini/mini.ai' },
  { src = 'https://github.com/nvim-mini/mini.surround' },
  { src = 'https://github.com/nvim-mini/mini.pairs' },
  { src = 'https://github.com/nvim-mini/mini.bracketed' },
  { src = 'https://github.com/nvim-mini/mini.bufremove' },
  { src = 'https://github.com/nvim-mini/mini.statuscolumn' },
  { src = 'https://github.com/nvim-mini/mini.statusline' },
  { src = 'https://github.com/nvim-mini/mini.clue' },
  { src = 'https://github.com/nvim-mini/mini.sessions' },

  -- Picker
  { src = 'https://github.com/ibhagwan/fzf-lua' },

  -- Git
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/NeogitOrg/neogit' },

  -- Format
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/mfussenegger/nvim-lint' },

  -- AI
  { src = 'https://github.com/folke/sidekick.nvim' },

  -- Explorer
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
}

if not token_dev then
  table.insert(packages, 1, { src = 'https://github.com/ThorstenRhau/token', version = vim.version.range('*') })
end

vim.pack.add(packages, { load = true, confirm = false })

-- Configure Blink Indent before loading its plugin scripts so its default mappings are never registered.
vim.pack.add({
  { src = 'https://github.com/saghen/blink.indent' },
}, { load = false, confirm = false })

-- Load plugin configurations (order matters for dependencies)
require('plugins.mini')
require('plugins.indent')
require('plugins.treesitter')
-- Blink preserves existing insert mappings in its fallback chain.
require('plugins.tabout')
require('plugins.completion')
require('plugins.lsp')
require('plugins.gitsigns')
require('plugins.formatter')
require('plugins.linter')
require('plugins.fzf')
require('plugins.neogit')
require('plugins.oil')
require('plugins.nvim-tree')
require('plugins.sidekick')

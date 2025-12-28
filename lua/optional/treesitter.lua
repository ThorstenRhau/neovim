---@module "lazy"
---@type LazySpec
return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        max_lines = 4,
        multiline_threshold = 2,
      },
    },
  },
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    local ts = require('nvim-treesitter')
    local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

    -- Enable treesitter for a buffer
    local function enable_treesitter(buf, lang)
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end

      local ok = pcall(vim.treesitter.start, buf, lang)
      if ok then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == buf and vim.api.nvim_win_is_valid(win) then
            vim.wo[win].foldmethod = 'expr'
            vim.wo[win].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          end
        end
      end
    end

    -- Install core parsers after lazy.nvim finishes loading all plugins
    vim.api.nvim_create_autocmd('User', {
      group = group,
      pattern = 'LazySync',
      once = true,
      desc = 'Install core treesitter parsers',
      callback = function()
        ts.install({
          'bash',
          'comment',
          'css',
          'diff',
          'dockerfile',
          'editorconfig',
          'fish',
          'git_config',
          'git_rebase',
          'gitcommit',
          'gitignore',
          'html',
          'javascript',
          'jsdoc',
          'json',
          'jsonc',
          'lua',
          'luadoc',
          'make',
          'markdown',
          'markdown_inline',
          'python',
          'query',
          'regex',
          'ruby',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
          'xml',
          'yaml',
        }, { max_jobs = 12 })
      end,
    })

    local ignore_filetypes = {
      checkhealth = true,
      lazy = true,
      mason = true,
      notify = true,
      noice = true,
      qf = true,
      toggleterm = true,
    }

    -- Enable treesitter highlighting and indentation on FileType
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      desc = 'Enable treesitter highlighting and indentation',
      callback = function(event)
        if ignore_filetypes[event.match] then
          return
        end

        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        enable_treesitter(event.buf, lang)
      end,
    })
  end,
}

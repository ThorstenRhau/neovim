---@module "lazy"
---@type LazySpec
return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        max_lines = 4,
        multiline_threshold = 2,
      },
    },
  },
  lazy = false,
  priority = 900,
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
      pattern = 'LazyDone',
      once = true,
      desc = 'Install core treesitter parsers',
      callback = function()
        ts.install({
          'bash',
          'c',
          'cmake',
          'comment',
          'cpp',
          'css',
          'diff',
          'dockerfile',
          'editorconfig',
          'elixir',
          'fish',
          'git_config',
          'git_rebase',
          'gitcommit',
          'gitignore',
          'gleam',
          'go',
          'html',
          'java',
          'javascript',
          'jsdoc',
          'json',
          'json5',
          'kotlin',
          'lua',
          'luadoc',
          'make',
          'markdown',
          'markdown_inline',
          'php',
          'python',
          'query',
          'regex',
          'ruby',
          'rust',
          'scala',
          'swift',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
          'xml',
          'yaml',
          'zig',
        }, { max_jobs = 8 })
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

        -- Skip treesitter on large files
        local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(event.buf))
        if vim.api.nvim_buf_line_count(event.buf) > 5000 or (stats and stats.size > 100 * 1024) then
          return
        end

        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        enable_treesitter(event.buf, lang)
      end,
    })
  end,
}

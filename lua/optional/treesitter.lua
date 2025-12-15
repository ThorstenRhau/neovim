---@module "lazy"
---@type LazySpec
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    local ts = require('nvim-treesitter')

    -- Install core parsers at startup
    ts.install({
      'bash',
      'comment',
      'css',
      'diff',
      'fish',
      'git_config',
      'git_rebase',
      'gitcommit',
      'gitignore',
      'html',
      'javascript',
      'json',
      'lua',
      'luadoc',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'regex',
      'toml',
      'typst',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
    })

    -- Auto-install parsers on FileType
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        local buf = event.buf

        require('nvim-treesitter').install({ lang }, {
          callback = function()
            -- Enable highlighting after install completes
            if vim.api.nvim_buf_is_valid(buf) then
              vim.treesitter.start(buf, lang)
            end
          end,
        })
      end,
    })
  end,
}

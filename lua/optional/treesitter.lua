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

    -- Track buffers currently waiting for parser installation
    local pending_buffers = {}

    -- Helper to start treesitter with retry for async parser installation
    local function start_with_retry(buf, lang, attempts)
      attempts = attempts or 10

      -- Use "buffer:language" as key to handle buffer number reuse
      local pending_key = buf .. ':' .. lang

      if not vim.api.nvim_buf_is_valid(buf) then
        pending_buffers[pending_key] = nil -- Cleanup
        return
      end

      -- Prevent duplicate retry loops for the same buffer+language
      if pending_buffers[pending_key] then
        return
      end

      local ok = pcall(vim.treesitter.start, buf, lang)
      if ok then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        pending_buffers[pending_key] = nil -- Success - clear tracking
      elseif attempts > 0 then
        pending_buffers[pending_key] = true -- Mark as pending
        vim.defer_fn(function()
          pending_buffers[pending_key] = nil -- Clear before retry (allows new attempt)
          start_with_retry(buf, lang, attempts - 1)
        end, 500)
      else
        pending_buffers[pending_key] = nil -- Max retries reached - clear tracking
      end
    end

    -- Install core parsers after lazy.nvim finishes loading all plugins
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyDone',
      once = true,
      callback = function()
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
          'latex',
          'lua',
          'luadoc',
          'make',
          'markdown',
          'markdown_inline',
          'norg',
          'python',
          'query',
          'regex',
          'scss',
          'svelte',
          'toml',
          'tsx',
          'typescript',
          'typst',
          'vim',
          'vimdoc',
          'vue',
          'xml',
        }, {
          max_jobs = 8,
        })
      end,
    })

    local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

    local ignore_filetypes = {
      'checkhealth',
      'lazy',
      'mason',
      'snacks_dashboard',
      'snacks_notif',
      'snacks_win',
    }

    -- Auto-install parsers and enable highlighting on FileType
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      desc = 'Enable treesitter highlighting and indentation',
      callback = function(event)
        if vim.tbl_contains(ignore_filetypes, event.match) then
          return
        end

        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        local buf = event.buf

        -- Try to start treesitter, with retry if parser is being installed
        start_with_retry(buf, lang)

        -- Auto-install missing parsers (nvim-treesitter handles async internally)
        ts.install({ lang })
      end,
    })

    -- Clean up pending retries when buffer is deleted
    vim.api.nvim_create_autocmd('BufDelete', {
      group = group,
      callback = function(event)
        for key in pairs(pending_buffers) do
          if key:match('^' .. event.buf .. ':') then
            pending_buffers[key] = nil
          end
        end
      end,
    })
  end,
}

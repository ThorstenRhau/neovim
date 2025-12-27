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

    -- Track buffers waiting for parser installation: { lang = { [buf] = true, ... } }
    local waiting_buffers = {}
    -- Track languages currently being installed to avoid duplicate install tasks
    local installing_langs = {}

    local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

    -- Enable treesitter for a buffer
    local function enable_treesitter(buf, lang)
      if not vim.api.nvim_buf_is_valid(buf) then
        return false
      end

      local ok = pcall(vim.treesitter.start, buf, lang)
      if ok then
        -- Set treesitter indentation (buffer-local)
        vim.api.nvim_set_option_value('indentexpr', "v:lua.require'nvim-treesitter'.indentexpr()", { buf = buf })
        -- Set treesitter folding for all windows displaying this buffer (window-local)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == buf and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_option_value('foldmethod', 'expr', { win = win })
            vim.api.nvim_set_option_value('foldexpr', 'v:lua.vim.treesitter.foldexpr()', { win = win })
          end
        end
      end
      return ok
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
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'regex',
          'vim',
          'vimdoc',
        })
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

    -- Auto-install parsers and enable highlighting on FileType
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      desc = 'Enable treesitter highlighting and indentation',
      callback = function(event)
        if ignore_filetypes[event.match] then
          return
        end

        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        local buf = event.buf

        if not enable_treesitter(buf, lang) then
          -- Parser not available, queue buffer (set handles duplicates)
          waiting_buffers[lang] = waiting_buffers[lang] or {}
          waiting_buffers[lang][buf] = true

          -- Only start install if not already in progress
          if not installing_langs[lang] then
            installing_langs[lang] = true
            ts.install({ lang })

            -- Poll for parser availability
            local attempts = 0
            local max_attempts = 60 -- 30 seconds max (60 * 500ms)
            local function poll_parser()
              attempts = attempts + 1
              local ok, result = pcall(vim.treesitter.language.add, lang)

              if ok and result then
                installing_langs[lang] = nil
                local buffers = waiting_buffers[lang]
                if buffers then
                  for b in pairs(buffers) do
                    enable_treesitter(b, lang)
                  end
                  waiting_buffers[lang] = nil
                end
              elseif attempts < max_attempts then
                vim.defer_fn(poll_parser, 500)
              else
                -- Timeout, clean up
                installing_langs[lang] = nil
                waiting_buffers[lang] = nil
              end
            end

            vim.defer_fn(poll_parser, 1000)
          end
        end
      end,
    })

    -- Clean up waiting buffers when buffer is deleted
    vim.api.nvim_create_autocmd('BufDelete', {
      group = group,
      desc = 'Clean up treesitter waiting buffers',
      callback = function(event)
        for lang, buffers in pairs(waiting_buffers) do
          buffers[event.buf] = nil
          if next(buffers) == nil then
            waiting_buffers[lang] = nil
          end
        end
      end,
    })
  end,
}

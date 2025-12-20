---@module "lazy"
---@type LazySpec

-- Cache for tooling info to avoid repeated queries
local tooling_cache = {}

local function invalidate_tooling_cache()
  tooling_cache = {}
end

vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach', 'BufEnter', 'FileType' }, {
  callback = invalidate_tooling_cache,
})

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'echasnovski/mini.icons' },
    },
    opts = function()
      local function dap_status()
        if not package.loaded['dap'] then
          return ''
        end
        local dap = require('dap')
        local session = dap.session()
        if session then
          return ' ' .. (session.config.type or 'dap')
        end
        return ''
      end

      local function tooling_info()
        local bufnr = vim.api.nvim_get_current_buf()
        if tooling_cache[bufnr] then
          return tooling_cache[bufnr]
        end

        local clients = {}

        local function add_client(name, icon)
          local existing = vim.iter(clients):find(function(c)
            return c.name == name
          end)
          if existing then
            if not vim.tbl_contains(existing.icons, icon) then
              table.insert(existing.icons, icon)
            end
          else
            table.insert(clients, { name = name, icons = { icon } })
          end
        end

        -- LSP Clients
        local lsp_clients = vim.lsp.get_clients({ bufnr = 0 })
        for _, client in ipairs(lsp_clients) do
          add_client(client.name, ' ')
        end

        -- Formatters
        if package.loaded['conform'] then
          local conform = require('conform')
          local formatters = conform.list_formatters_to_run(0)
          for _, f in ipairs(formatters) do
            add_client(f.name, '󰉼 ')
          end
        end

        -- Linters
        if package.loaded['lint'] then
          local lint = require('lint')
          local ft = vim.bo.filetype
          local linters = lint.linters_by_ft[ft] or {}
          for _, name in ipairs(linters) do
            add_client(name, ' ')
          end
        end

        local result
        if #clients == 0 then
          result = ''
        else
          local items = {}
          for _, c in ipairs(clients) do
            table.insert(items, table.concat(c.icons, '') .. c.name)
          end
          result = table.concat(items, ', ')
        end

        tooling_cache[bufnr] = result
        return result
      end

      local function location_with_total()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local total_lines = vim.api.nvim_buf_line_count(0)
        local line_text = vim.api.nvim_get_current_line()
        return string.format('%d:%d|%d:%d', cursor[1], total_lines, cursor[2] + 1, #line_text)
      end

      return {
        options = {
          icons_enabled = true,
          globalstatus = true,
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = { 'checkhealth', 'snacks_dashboard', 'NeogitConsole', 'NeogitStatus' },
            winbar = {},
          },
          refresh = {
            statusline = 500,
            tabline = 1000,
            winbar = 500,
          },
        },
        sections = {
          lualine_a = {
            { 'mode', separator = { left = '', right = '' }, right_padding = 2 },
            'searchcount',
            'selectioncount',
            {
              function()
                local reg = vim.fn.reg_recording()
                return reg ~= '' and '󰑋 @' .. reg or ''
              end,
            },
          },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              'filename',
              file_status = true,
              newfile_status = true,
              path = 1,
              symbols = {
                modified = '[+]',
                readonly = '[-]',
                unnamed = '[No Name]',
                newfile = '[New]',
              },
            },
          },
          lualine_x = {
            dap_status,
            tooling_info,
            {
              require('lazy.status').updates,
              cond = require('lazy.status').has_updates,
            },
          },
          lualine_y = {
            'fileformat',
            'filetype',
            'progress',
          },
          lualine_z = {
            { location_with_total, separator = { left = '', right = '' }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {
          'lazy',
          'man',
          'mason',
          'oil',
          'trouble',
        },
      }
    end,
  },
}

---@module "lazy"
---@type LazySpec
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
        local clients = {}
        local client_index = {}

        local function add_client(name, icon)
          if not client_index[name] then
            table.insert(clients, { name = name, icons = { icon } })
            client_index[name] = #clients
          else
            local idx = client_index[name]
            local has_icon = false
            for _, existing_icon in ipairs(clients[idx].icons) do
              if existing_icon == icon then
                has_icon = true
                break
              end
            end
            if not has_icon then
              table.insert(clients[idx].icons, icon)
            end
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

        if #clients == 0 then
          return ''
        end

        local items = {}
        for _, c in ipairs(clients) do
          table.insert(items, table.concat(c.icons, '') .. c.name)
        end
        return table.concat(items, ', ')
      end

      local function location_with_total()
        local line = vim.fn.line('.')
        local col = vim.fn.col('.')
        local total_lines = vim.fn.line('$')
        local total_cols = #vim.fn.getline(line)
        return string.format('%d:%d|%d:%d', line, total_lines, col, total_cols)
      end

      return {
        options = {
          icons_enabled = true,
          globalstatus = true,
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          disabled_filetypes = {
            'checkhealth',
            'snacks_dashboard',
            'NeogitConsole',
            'NeogitStatus',
            statusline = {},
            winbar = {},
          },
        },
        sections = {
          lualine_a = {
            { 'mode', separator = { left = '', right = '' }, right_padding = 2 },
            'searchcount',
            'selectioncount',
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

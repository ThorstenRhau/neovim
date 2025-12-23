---@module "lazy"
---@type LazySpec
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'echasnovski/mini.icons' },
  opts = {
    sections = {
      lualine_a = { { 'mode', icon = ' ' } },
      lualine_b = { 'branch', 'diff' },
      lualine_c = {
        {
          function()
            local reg = vim.fn.reg_recording()
            if reg ~= '' then
              return '@' .. reg
            end
            return ''
          end,
        },
        'filename',
      },
      lualine_x = {
        {
          function()
            local buf = vim.api.nvim_get_current_buf()
            local parts = {}

            -- LSP: Only show real language servers (with completion/definition/hover)
            local clients = vim.lsp.get_clients({ bufnr = buf })
            local lsp_names = {}
            for _, client in ipairs(clients) do
              local caps = client.server_capabilities
              if caps and (caps.completionProvider or caps.definitionProvider or caps.hoverProvider) then
                table.insert(lsp_names, client.name)
              end
            end
            if #lsp_names > 0 then
              table.insert(parts, ' ' .. table.concat(lsp_names, ','))
            end

            -- Formatters: Always show conform formatters
            local ok_conform, conform = pcall(require, 'conform')
            if ok_conform then
              local formatters = conform.list_formatters(buf)
              local names = {}
              for _, f in ipairs(formatters) do
                table.insert(names, f.name)
              end
              if #names > 0 then
                table.insert(parts, '󰉢 ' .. table.concat(names, ','))
              end
            end

            -- Linters: Always show nvim-lint linters
            local ok_lint, lint = pcall(require, 'lint')
            if ok_lint then
              local ft = vim.bo[buf].filetype
              local linters = lint.linters_by_ft[ft] or {}
              if #linters > 0 then
                table.insert(parts, '󱉶 ' .. table.concat(linters, ','))
              end
            end

            -- DAP: Show when debugging
            local ok_dap, dap = pcall(require, 'dap')
            if ok_dap and dap.session() then
              table.insert(parts, ' ')
            end

            return table.concat(parts, ' ')
          end,
        },
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    extensions = { 'lazy', 'mason', 'oil', 'trouble', 'fzf', 'nvim-dap-ui', 'quickfix' },
  },
}

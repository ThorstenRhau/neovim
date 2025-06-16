---@module "lazy"
---@type LazySpec
return {
    {
        "nvim-lualine/lualine.nvim",
        enabled = true,
        -- Load statusline late to improve startup time
        event = "VeryLazy",
        dependencies = {
            { "echasnovski/mini.icons", lazy = true },
        },
        opts = function()
            local function show_macro_recording()
                local mode = vim.api.nvim_get_mode().mode
                local reg = vim.fn.reg_recording()
                if mode:find("^r") or reg ~= "" then
                    return "Recording @" .. reg
                end
                return ""
            end

            local function lsp_client_names()
                local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
                if #clients == 0 then
                    return ""
                end
                local names = {}
                for _, c in ipairs(clients) do
                    table.insert(names, c.name)
                end
                return table.concat(names, ", ")
            end

            local function location_with_total()
                local line = vim.fn.line(".")
                local col = vim.fn.col(".")
                local total_lines = vim.fn.line("$")
                local total_cols = #vim.fn.getline(line)
                return string.format("%d:%d|%d:%d", line, total_lines, col, total_cols)
            end

            return {
                options = {
                    icons_enabled = true,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        "checkhealth",
                        "snacks_dashboard",
                        "NeogitConsole",
                        "NeogitStatus",
                        statusline = {},
                        winbar = {},
                    },
                },
                sections = {
                    lualine_a = { "mode", show_macro_recording, "searchcount", "selectioncount" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = {
                        {
                            "filename",
                            file_status = true,
                            newfile_status = true,
                            path = 1,
                            symbols = {
                                modified = "[+]",
                                readonly = "[-]",
                                unnamed = "[No Name]",
                                newfile = "[New]",
                            },
                        },
                    },
                    lualine_x = { lsp_client_names, "encoding", "fileformat", "filetype", "filesize" },
                    lualine_y = { "progress" },
                    lualine_z = { location_with_total },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                extensions = {
                    "lazy",
                    "man",
                    "mason",
                    "oil",
                    "trouble",
                },
            }
        end,
    },
}

---@module "lazy"
---@type LazySpec
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "b0o/schemastore.nvim",
        "saghen/blink.cmp",
        "williamboman/mason-lspconfig.nvim",
    },
    ft = {
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "sh",
        "toml",
        "ts",
        "typescript",
        "xml",
        "yaml",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local schemastore = require("schemastore")
        -- Base capabilities - let Neovim/blink handle defaults mostly
        -- We still merge blink.cmp's capabilities and can set offsetEncoding if needed globally
        local capabilities = vim.tbl_deep_extend("force", require("blink.cmp").get_lsp_capabilities(), {
            offsetEncoding = { "utf-16" }, -- Keep if other things rely on it
        })

        mason_lspconfig.setup({
            ensure_installed = {},
            automatic_installation = false,
            automatic_enable = true,
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(event)
                local opts = { buffer = event.buf, silent = true, noremap = true }
                -- stylua: ignore start
                local keymaps = {
                    { "n", "gC",         vim.lsp.buf.outgoing_calls,                                 "Outgoing Calls" },
                    { "n", "gD",         vim.lsp.buf.declaration,                                    "Goto Declaration" },
                    { "n", "gI",         vim.lsp.buf.incoming_calls,                                 "Incoming Calls" },
                    { "n", "gd",         vim.lsp.buf.definition,                                     "Goto Definition" },
                    { "n", "gl",         vim.diagnostic.open_float,                                  "Floating Diagnostic" },
                    { "n", "go",         vim.lsp.buf.type_definition,                                "Goto Type Definition" },
                    { "n", "<leader>ca", vim.lsp.buf.code_action,                                    "Code Action" },
                    { "n", "<leader>cr", vim.lsp.buf.rename,                                         "Rename Symbol" },
                    { "n", "<leader>q",  vim.diagnostic.setloclist,                                  "Diagnostics List" },
                }
                -- stylua: ignore end
                for _, map in ipairs(keymaps) do
                    vim.keymap.set(map[1], map[2], map[3], vim.tbl_extend("force", opts, { desc = map[4] }))
                end
            end,
        })

        local diagnostic_opts = {
            signs = true,
            underline = {
                severity = vim.diagnostic.severity.WARN,
            },
            virtual_text = false,
            virtual_lines = {
                current_line = true,
                format = function(diagnostic)
                    return string.format("[%s] %s", diagnostic.source, diagnostic.message)
                end,
            },
            float = false,
            update_in_insert = false,
            severity_sort = true,
        }

        vim.diagnostic.config(diagnostic_opts) -- Ensure this line applies the config
    end,
}

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
                    { "n", "[d",         function() vim.diagnostic.jump({ direction = "prev" }) end, "Prev Diagnostic" },
                    { "n", "]d",         function() vim.diagnostic.jump({ direction = "next" }) end, "Next Diagnostic" },
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

        vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        mason_lspconfig.setup_handlers({
            -- Default handler: pass the base capabilities
            function(server)
                lspconfig[server].setup({
                    capabilities = capabilities,
                })
            end,

            ["jsonls"] = function()
                lspconfig.jsonls.setup({
                    capabilities = capabilities,
                    settings = { json = { schemas = schemastore.json.schemas(), validate = { enable = true } } },
                })
            end,

            ["yamlls"] = function()
                lspconfig.yamlls.setup({
                    capabilities = capabilities,
                    settings = {
                        yaml = {
                            schemaStore = { enable = false, url = "" },
                            schemas = schemastore.yaml.schemas(),
                            validate = true,
                            completion = true,
                            hover = true,
                        },
                    },
                })
            end,

            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
                            telemetry = { enable = false },
                        },
                    },
                })
            end,

            ["pyright"] = function()
                lspconfig.pyright.setup({
                    capabilities = capabilities,
                    on_attach = function(client)
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end,
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "basic",
                                autoSearchPaths = true,
                                diagnosticMode = "openFilesOnly",
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                })
            end,

            ["ruff"] = function()
                local ruff_capabilities = vim.deepcopy(capabilities)
                ruff_capabilities.general = vim.tbl_deep_extend("force", ruff_capabilities.general or {}, {
                    positionEncodings = { "utf-16" },
                })

                lspconfig.ruff.setup({
                    capabilities = ruff_capabilities,
                })
            end,

            ["harper_ls"] = function()
                lspconfig.harper_ls.setup({
                    capabilities = capabilities,
                })
            end,
        })
    end,
}

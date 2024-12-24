return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "b0o/schemastore.nvim",
        "saghen/blink.cmp",
        "williamboman/mason-lspconfig.nvim",
    },
    ft = {
        "html",
        "json",
        "lua",
        "markdown",
        "python",
        "sh",
        "toml",
        "ts",
        "yaml",
    },
    config = function()
        -- Cache required modules
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local schemastore = require("schemastore")

        -- Initialize Mason-LSPConfig
        mason_lspconfig.setup({
            ensure_installed = {}, -- This is handled by mason-tool-installer
            automatic_installation = false,
        })

        -- Define LSP capabilities
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- Autocommand for LSP Attach
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(event)
                local buffer = event.buf
                local opts = { buffer = buffer, silent = true, noremap = true }

                -- Buffer-local Keybindings
                -- Formatting is done by conform, no need to define vim.lsp.buf.format() here
                -- stylua: ignore start
                local buf_keymaps = {
                    {"n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>",     "CodeAction"},
                    {"n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>",          "Rename"},
                    {"n", "<leader>q",  "<cmd>lua vim.diagnostic.setloclist()<CR>",   "Open diagnostics list" },
                    {"n", "K",          "<cmd>lua vim.lsp.buf.hover()<CR>",           "HoverDocumentation"},
                    {"n", "[d",         "<cmd>lua vim.diagnostic.goto_prev()<CR>",    "Go to previous diagnostic" },
                    {"n", "]d",         "<cmd>lua vim.diagnostic.goto_next()<CR>",    "Go to next diagnostic" },
                    {"n", "cr",         "<cmd>lua vim.lsp.buf.rename()<CR>",          "Rename"},
                    {"n", "gD",         "<cmd>lua vim.lsp.buf.declaration()<CR>",     "GotoDeclaration"},
                    {"n", "gI",         "<cmd>lua vim.lsp.buf.incoming_calls()<CR>",  "GottoIncomingCalls"},
                    {"n", "gO",         "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>",  "GottoOutgoingCalls"},
                    {"n", "gd",         "<cmd>lua vim.lsp.buf.definition()<CR>",      "GotoDefinition"},
                    {"n", "gi",         "<cmd>lua vim.lsp.buf.implementation()<CR>",  "GotoImplementation"},
                    {"n", "gl",         "<cmd>lua vim.diagnostic.open_float()<CR>",   "Open floating diagnostic message" },
                    {"n", "go",         "<cmd>lua vim.lsp.buf.type_definition()<CR>", "GotoTypeDefinition"},
                    {"n", "gr",         "<cmd>lua vim.lsp.buf.references()<CR>",      "GotoReferences"},
                    {"n", "gs",         "<cmd>lua vim.lsp.buf.signature_help()<CR>",  "SignatureHelp"},
                }
                -- stylua: ignore end

                for _, map in ipairs(buf_keymaps) do
                    local modes = type(map[1]) == "table" and map[1] or { map[1] }
                    ---@diagnostic disable-next-line: param-type-mismatch
                    for _, mode in ipairs(modes) do
                        vim.keymap.set(mode, map[2], map[3], vim.tbl_extend("force", opts, { desc = map[4] }))
                    end
                end

                -- Diagnostic Virtual Text for Current Line
                local ns = vim.api.nvim_create_namespace("CurlineDiag")
                vim.opt.updatetime = 100

                vim.api.nvim_create_autocmd("CursorHold", {
                    buffer = buffer,
                    callback = function()
                        pcall(vim.api.nvim_buf_clear_namespace, buffer, ns, 0, -1)
                        local cursor = vim.api.nvim_win_get_cursor(0)
                        local current_line = cursor[1] - 1 -- Zero-based index
                        local diagnostics = vim.diagnostic.get(buffer, { lnum = current_line })
                        if not diagnostics or #diagnostics == 0 then
                            return
                        end

                        local virt_texts = {}
                        for _, diag in ipairs(diagnostics) do
                            local severity = vim.diagnostic.severity[diag.severity] or "Error"
                            table.insert(virt_texts, { diag.message, "Diagnostic" .. severity })
                        end

                        vim.api.nvim_buf_set_extmark(buffer, ns, current_line, 0, {
                            virt_text = virt_texts,
                            hl_mode = "combine",
                        })
                    end,
                })
            end,
        })

        -- Global Diagnostic Configuration
        vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        -- Setup LSP Servers
        mason_lspconfig.setup_handlers({
            function(server)
                lspconfig[server].setup({
                    capabilities = capabilities,
                    on_attach = function()
                        -- Additional on_attach logic can go here if needed
                    end,
                })
            end,
            -- JSON Language Server with SchemaStore
            ["jsonls"] = function()
                lspconfig.jsonls.setup({
                    capabilities = capabilities,
                    settings = {
                        json = {
                            schemas = schemastore.json.schemas(),
                            validate = { enable = true },
                        },
                    },
                })
            end,
            -- YAML Language Server with SchemaStore
            ["yamlls"] = function()
                lspconfig.yamlls.setup({
                    capabilities = capabilities,
                    settings = {
                        yaml = {
                            schemaStore = {
                                enable = false,
                                url = "",
                            },
                            schemas = schemastore.yaml.schemas(),
                        },
                    },
                })
            end,

            -- Lua Language Server with custom settings
            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME,
                                    "$HOME/.config/wezterm",
                                },
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
                })
            end,

            -- Pyright Language Server with custom settings
            ["pyright"] = function()
                lspconfig.pyright.setup({
                    capabilities = capabilities,
                    on_attach = function(client)
                        -- Using different formatter (ruff_format)
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end,
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "strict", -- Options: off, basic, strict
                                autoSearchPaths = true,
                                diagnosticMode = "workspace", -- Options: openFilesOnly, workspace
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                })
            end,
        })
    end,
}

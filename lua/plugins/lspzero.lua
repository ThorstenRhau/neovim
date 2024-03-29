return {
    {
        {
            "VonHeikemen/lsp-zero.nvim",
            branch = "v3.x",
            lazy = true,
            config = false,
            init = function()
                -- Disable automatic setup, we are doing it manually
                vim.g.lsp_zero_extend_cmp = 0
                vim.g.lsp_zero_extend_lspconfig = 0
            end,
        },
        {
            "williamboman/mason.nvim",
            lazy = false,
            config = true,
            opts = {
                ui = {
                    check_outdated_packages_on_open = true,
                    border = "rounded",
                    width = 0.9,
                    height = 0.9,
                },
            },
        },

        -- Autocompletion
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                {
                    "hrsh7th/cmp-nvim-lsp",
                    "L3MON4D3/LuaSnip",
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-path",
                    "saadparwaiz1/cmp_luasnip",
                    "hrsh7th/cmp-nvim-lua",
                    "onsails/lspkind.nvim",
                },
            },
            config = function()
                -- Here is where you configure the autocompletion settings.
                local lsp_zero = require("lsp-zero")
                lsp_zero.extend_cmp()

                -- And you can configure cmp even more, if you want to.
                local cmp = require("cmp")
                local cmp_action = lsp_zero.cmp_action()

                cmp.setup({
                    window = {
                        completion = cmp.config.window.bordered({
                            border = "rounded",
                            scrollbar = true,
                            side_padding = 0,
                        }),
                        documentation = cmp.config.window.bordered({
                            border = "rounded",
                            scrollbar = true,
                            side_padding = 0,
                        }),
                    },
                    --formatting = lsp_zero.cmp_format(),
                    formatting = {
                        fields = { "kind", "abbr", "menu" },
                        format = function(entry, vim_item)
                            local kind =
                                require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                            local strings = vim.split(kind.kind, "%s", { trimempty = true })
                            kind.kind = " " .. (strings[1] or "") .. " "
                            kind.menu = "    (" .. (strings[2] or "") .. ")"

                            return kind
                        end,
                        expandable_indicator = true,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ["<CR>"] = cmp.mapping.confirm({ select = false }),
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-d>"] = cmp.mapping.scroll_docs(4),
                        ["<C-f>"] = cmp_action.luasnip_jump_forward(),
                        ["<C-b>"] = cmp_action.luasnip_jump_backward(),
                        -- Supertab
                        ["<Tab>"] = cmp_action.luasnip_supertab(),
                        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
                    }),
                    sources = cmp.config.sources({
                        { name = "nvim_lsp", priority = 100 },
                        { name = "luasnip", priority = 80 },
                        { name = "path", priority = 60 },
                        { name = "buffer", keyword_length = 4, priority = 40 },
                        { name = "nvim_lua", priority = 20 },
                        { name = "nvim_lsp_signature_help", priority = 10 },
                    }),
                })
            end,
        },

        -- LSP
        {
            "neovim/nvim-lspconfig",
            cmd = { "LspInfo", "LspInstall", "LspStart" },
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                { "folke/neodev.nvim", opts = {} },
                { "hrsh7th/cmp-nvim-lsp" },
                { "williamboman/mason-lspconfig.nvim" },
                { "hrsh7th/cmp-buffer" },
                { "hrsh7th/cmp-path" },
                { "saadparwaiz1/cmp_luasnip" },
                { "b0o/schemastore.nvim" },
            },
            config = function()
                -- Setting rounded border on LSP windows
                require("lspconfig.ui.windows").default_options.border = "rounded"

                -- This is where all the LSP shenanigans will live
                local lsp_zero = require("lsp-zero")
                lsp_zero.extend_lspconfig()

                ---@diagnostic disable-next-line: unused-local
                lsp_zero.on_attach(function(client, bufnr)
                    -- see :help lsp-zero-keybindings
                    -- to learn the available actions
                    lsp_zero.default_keymaps({ buffer = bufnr })
                end)

                require("mason-lspconfig").setup({
                    ensure_installed = {}, -- This is done by lua/plugins/mason-tool-installer.lua
                    handlers = {
                        lsp_zero.default_setup,
                        jsonls = function()
                            require("lspconfig").jsonls.setup({
                                settings = {
                                    json = {
                                        schemas = require("schemastore").json.schemas(),
                                        validate = { enable = true },
                                    },
                                },
                            })
                        end,
                        yamlls = function()
                            require("lspconfig").yamlls.setup({
                                settings = {
                                    yaml = {
                                        schemaStore = {
                                            -- You must disable built-in schemaStore support if you want to use
                                            -- this plugin and its advanced options like `ignore`.
                                            enable = false,
                                            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                                            url = "",
                                        },
                                        schemas = require("schemastore").yaml.schemas(),
                                    },
                                },
                            })
                        end,
                    },
                })
            end,
        },
    },
}

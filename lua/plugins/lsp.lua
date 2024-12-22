return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "L3MON4D3/LuaSnip",
        "b0o/schemastore.nvim",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "hrsh7th/nvim-cmp",
        "onsails/lspkind.nvim",
        "saadparwaiz1/cmp_luasnip",
        "williamboman/mason-lspconfig.nvim",
    },

    -- Only loading LSP for certain file types
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
        -- note: diagnostics are not exclusive to lsp servers
        -- so these can be global keybindings
        vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
        vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
        vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "LSP actions",
            callback = function(event)
                local opts = { buffer = event.buf }

                -- these will be buffer-local keybindings
                -- because they only work if you have an active language server

                vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
                vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
                vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
                vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
                vim.keymap.set("n", "cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                vim.keymap.set({ "n", "x" }, "<leader>cf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
                vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
            end,
        })
        vim.diagnostic.config({
            virtual_text = false,
        })

        local ns = vim.api.nvim_create_namespace("CurlineDiag")
        vim.opt.updatetime = 100
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                vim.api.nvim_create_autocmd("CursorHold", {
                    buffer = args.buf,
                    callback = function()
                        pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)
                        local hi = { "Error", "Warn", "Info", "Hint" }
                        local curline = vim.api.nvim_win_get_cursor(0)[1]
                        local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })
                        local virt_texts = { { (" "):rep(4) } }
                        for _, diag in ipairs(diagnostics) do
                            virt_texts[#virt_texts + 1] = { diag.message, "Diagnostic" .. hi[diag.severity] }
                        end
                        vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
                            virt_text = virt_texts,
                            hl_mode = "combine",
                        })
                    end,
                })
            end,
        })

        local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

        local default_setup = function(server)
            require("lspconfig")[server].setup({
                capabilities = lsp_capabilities,
            })
        end

        require("mason-lspconfig").setup({
            automatic_installation = false,
            ensure_installed = {},
            handlers = {
                default_setup,
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

        local luasnip = require("luasnip")
        local cmp = require("cmp")

        cmp.setup({
            completion = {
                keyword_length = 3,
            },
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
            sources = {
                { name = "nvim_lsp", priority = 100 },
                { name = "luasnip", priority = 80 },
                { name = "path", priority = 60 },
                { name = "buffer", keyword_length = 4, priority = 40 },
                { name = "nvim_lua", priority = 20 },
                { name = "nvim_lsp_signature_help", priority = 10 },
            },
            mapping = cmp.mapping.preset.insert({
                -- Ctrl + space triggers completion menu
                ["<C-Space>"] = cmp.mapping.complete(),

                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if luasnip.expandable() then
                            luasnip.expand()
                        else
                            cmp.confirm({
                                select = true,
                            })
                        end
                    else
                        fallback()
                    end
                end),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    kind.kind = " " .. (strings[1] or "") .. " "
                    kind.menu = "    (" .. (strings[2] or "") .. ")"

                    return kind
                end,
                expandable_indicator = true,
            },
        })

        require("lspconfig").lua_ls.setup({
            capabilities = lsp_capabilities,
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = {
                            vim.env.VIMRUNTIME,
                        },
                    },
                },
            },
        })
    end,
}

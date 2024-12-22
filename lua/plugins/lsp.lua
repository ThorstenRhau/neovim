return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "L3MON4D3/LuaSnip",
        "b0o/schemastore.nvim",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "hrsh7th/nvim-cmp",
        "onsails/lspkind.nvim",
        "saadparwaiz1/cmp_luasnip",
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
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
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        local schemastore = require("schemastore")

        -- Initialize Mason
        mason.setup()

        -- Initialize Mason-LSPConfig
        mason_lspconfig.setup({
            ensure_installed = {}, -- Add servers you want to ensure are installed
            automatic_installation = false,
        })

        -- Define LSP capabilities
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Global Keybindings for Diagnostics
        local diagnostic_keymaps = {
            { "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", "Open floating diagnostic message" },
            { "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to previous diagnostic" },
            { "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", "Go to next diagnostic" },
            { "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", "Open diagnostics list" },
        }

        for _, map in ipairs(diagnostic_keymaps) do
            vim.keymap.set(map[1], map[2], map[3], { silent = true, desc = map[4] })
        end

        -- Autocommand for LSP Attach
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(event)
                local buffer = event.buf
                local opts = { buffer = buffer, silent = true, noremap = true }

                -- Buffer-local Keybindings
                local buf_keymaps = {
                    { "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover Documentation" },
                    { "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to Definition" },
                    { "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to Declaration" },
                    { "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to Implementation" },
                    { "n", "go", "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to Type Definition" },
                    { "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", "Go to References" },
                    { "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
                    { "n", "cr", "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
                    { { "n", "x" }, "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "Format" },
                    { "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
                }

                for _, map in ipairs(buf_keymaps) do
                    local modes = type(map[1]) == "table" and map[1] or { map[1] }
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
                                path = vim.split(package.path, ";"),
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                                checkThirdParty = false,
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
                })
            end,
        })

        -- Setup nvim-cmp
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp", priority = 100 },
                { name = "luasnip", priority = 80 },
                { name = "path", priority = 60 },
                { name = "buffer", keyword_length = 4, priority = 40 },
                { name = "nvim_lua", priority = 20 },
                { name = "nvim_lsp_signature_help", priority = 10 }, -- Ensure this source is valid or remove
            }),
            formatting = {
                fields = { "kind", "abbr", "menu" }, -- Added required 'fields'
                expandable_indicator = true,
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = "...",
                    before = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                            nvim_lua = "[Lua]",
                            nvim_lsp_signature_help = "[Signature]",
                        })[entry.source.name] or vim_item.menu
                        return vim_item
                    end,
                }),
            },
            window = {
                completion = cmp.config.window.bordered({
                    border = "rounded",
                    scrollbar = false,
                    winhighlight = "Normal:Pmenu,CursorLine:CursorLine,Search:None",
                }),
                documentation = cmp.config.window.bordered({
                    border = "rounded",
                    scrollbar = false,
                    winhighlight = "Normal:Pmenu,CursorLine:CursorLine,Search:None",
                }),
            },
            experimental = {
                ghost_text = false,
                native_menu = false,
            },
        })

        -- Setup LuaSnip
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Optional: Setup additional CMP sources or configurations here
    end,
}

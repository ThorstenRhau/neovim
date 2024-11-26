local function get_python_path(workspace)
    local util = require("lspconfig/util")
    local path = util.path
    local python_path = path.join(workspace, ".venv", "bin", "python")
    if vim.fn.executable(python_path) == 1 then
        return python_path
    end
    return nil
end

return {
    {
        {
            "VonHeikemen/lsp-zero.nvim",
            branch = "v3.x",
            config = false,
            init = function()
                -- Disable automatic setup, we are doing it manually
                vim.g.lsp_zero_extend_cmp = 0
                vim.g.lsp_zero_extend_lspconfig = 0
            end,
        },
        {
            "williamboman/mason.nvim",
            cmd = "Mason",
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
                    completion = {
                        keyword_length = 3, -- Minimum length of word to trigger completion
                    },
                    -- performance = {
                    --     debounce = 250, -- Delay for debouncing events
                    --     throttle = 50, -- Throttle time for completion
                    --     fetching_timeout = 350, -- Timeout for completion
                    --     confirm_resolve_timeout = 350, -- Timeout for resolving completion item
                    --     async_budget = 200, -- Budget for async operations (in ms)
                    --     max_view_entries = 75, -- Maximum number of entries to show in the completion menu
                    -- },
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
                "hrsh7th/cmp-nvim-lsp",
                "williamboman/mason-lspconfig.nvim",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "saadparwaiz1/cmp_luasnip",
                "b0o/schemastore.nvim",
                "sontungexpt/better-diagnostic-virtual-text",
            },
            config = function()
                -- Setting up virtual text configuration
                vim.diagnostic.config({
                    virtual_text = false,
                    update_in_insert = false, -- Don't update diagnostics in insert mode
                    -- float = {
                    --     delay = 250, -- Delay before showing float
                    -- },
                })

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
                    require("better-diagnostic-virtual-text.api").setup_buf(bufnr, {
                        ui = {
                            wrap_line_after = 25, -- wrap the line after this length to avoid the virtual text is too long
                            left_kept_space = 3, --- the number of spaces kept on the left side of the virtual text, make sure it enough to custom for each line
                            right_kept_space = 3, --- the number of spaces kept on the right side of the virtual text, make sure it enough to custom for each line
                            arrow = "  ",
                            up_arrow = "  ",
                            down_arrow = "  ",
                            above = true, -- the virtual text will be displayed above the line
                        },
                        priority = 2003, -- the priority of virtual text
                        inline = true,
                    })
                end)

                -- nushell LSP configuration
                require("lspconfig").nushell.setup({
                    cmd = { "nu", "--lsp" },
                    filetypes = { "nu" },
                })

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
                        pyright = function()
                            require("lspconfig").pyright.setup({
                                on_init = function(client)
                                    client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
                                end,
                                settings = {
                                    python = {
                                        analysis = {
                                            typeCheckingMode = "standard", -- "off", "basic", "standard", "strict"
                                            autoSearchPaths = true,
                                            useLibraryCodeForTypes = true, -- May slow things down
                                            pythonPlatform = "Darwin", -- "Windows", "Darwin", "Linux", or "All"
                                        },
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

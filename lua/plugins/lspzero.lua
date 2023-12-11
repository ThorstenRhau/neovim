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
        },

        -- Autocompletion
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                { "L3MON4D3/LuaSnip" },
            },
            config = function()
                -- Here is where you configure the autocompletion settings.
                local lsp_zero = require("lsp-zero")
                lsp_zero.extend_cmp()

                -- And you can configure cmp even more, if you want to.
                local cmp = require("cmp")
                local cmp_action = lsp_zero.cmp_action()

                cmp.setup({
                    formatting = lsp_zero.cmp_format(),
                    mapping = cmp.mapping.preset.insert({
                        -- `Enter` key to confirm completion
                        ["<CR>"] = cmp.mapping.confirm({ select = false }),
                        -- Ctrl+Space to trigger completion menu
                        ["<C-Space>"] = cmp.mapping.complete(),
                        -- Scroll up and down in the completion documentation
                        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-d>"] = cmp.mapping.scroll_docs(4),
                        -- Navigate between snippet placeholder
                        ["<C-f>"] = cmp_action.luasnip_jump_forward(),
                        ["<C-b>"] = cmp_action.luasnip_jump_backward(),
                        -- Supertab
                        ["<Tab>"] = cmp_action.luasnip_supertab(),
                        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
                    }),
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "luasnip" },
                        { name = "path" },
                        { name = "buffer",  keyword_length = 4 },
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
                { "hrsh7th/cmp-nvim-lsp" },
                { "williamboman/mason-lspconfig.nvim" },
                { "hrsh7th/cmp-buffer" },
                { "hrsh7th/cmp-path" },
                { "saadparwaiz1/cmp_luasnip" },
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
                    ---@diagnostic disable-next-line: lowercase-global
                    preserve_mappings = false
                    --local opts = {buffer = bufnr, remap = false}
                    local opts = { buffer = bufnr }

                    vim.keymap.set("n", "gd", function()
                        vim.lsp.buf.definition()
                    end, opts)
                    vim.keymap.set("n", "K", function()
                        vim.lsp.buf.hover()
                    end, opts)
                    vim.keymap.set("n", "<leader>cs", function()
                        vim.lsp.buf.workspace_symbol()
                    end, opts)
                    vim.keymap.set("n", "<leader>cd", function()
                        vim.diagnostic.open_float()
                    end, opts)
                    vim.keymap.set("n", "<C-n>", function()
                        vim.diagnostic.goto_next()
                    end, opts)
                    vim.keymap.set("n", "<C-p>", function()
                        vim.diagnostic.goto_prev()
                    end, opts)
                    vim.keymap.set("n", "<leader>ca", function()
                        vim.lsp.buf.code_action()
                    end, opts)
                    vim.keymap.set("n", "gr", function()
                        vim.lsp.buf.references()
                    end, opts)
                    vim.keymap.set("n", "<leader>cr", function()
                        vim.lsp.buf.rename()
                    end, opts)
                    vim.keymap.set("i", "<C-h>", function()
                        vim.lsp.buf.signature_help()
                    end, opts)
                end)

                require("mason-lspconfig").setup({
                    ensure_installed = {
                        "pyright",
                        "taplo",
                        "bashls",
                        "lua_ls",
                        "marksman",
                    },
                    handlers = {
                        lsp_zero.default_setup,
                        --lua_ls = function()
                        --    -- (Optional) Configure lua language server for neovim
                        --    local lua_opts = lsp_zero.nvim_lua_ls()
                        --    require("lspconfig").lua_ls.setup(lua_opts)
                        --end,
                    },
                })
            end,
        },
    },
}

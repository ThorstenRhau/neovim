return {
    "jay-babu/mason-null-ls.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        {
            "williamboman/mason.nvim",
            opts = {
                ui = {
                    check_outdated_packages_on_open = true,
                    border = "rounded",
                    width = 0.9,
                    height = 0.9,
                },
            },
        },

        {
            "nvimtools/none-ls.nvim",
            init = function()
                local null_ls = require("null-ls")
                null_ls.setup({
                    sources = {
                        null_ls.builtins.formatting.stylua,
                        null_ls.builtins.formatting.jq,
                        null_ls.builtins.formatting.isort,
                        null_ls.builtins.formatting.black,
                        -- null_ls.builtins.diagnostics.pylint,
                        null_ls.builtins.formatting.shfmt,
                        null_ls.builtins.diagnostics.shellcheck,
                        null_ls.builtins.formatting.prettier.with({
                            -- Force wrap when specified in .editorconfig
                            extra_args = { "--prose-wrap", "always" },
                        }),
                        -- null_ls.builtins.diagnostics.markdownlint,
                        null_ls.builtins.diagnostics.eslint,
                        null_ls.builtins.formatting.taplo,
                    },
                })
            end,
        },
    },
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("mason-null-ls").setup({
            ensure_installed = {
                "stylua",
                "jq",
                --"pylint",
                "isort",
                "black",
                "shfmt",
                "shellcheck",
                "prettier",
                --"markdownlint",
                "marksman",
            },
        })
    end,
}

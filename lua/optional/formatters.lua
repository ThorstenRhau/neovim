---@module "lazy"
---@type LazySpec
return {
    "stevearc/conform.nvim",
    ft = {
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "sh",
        "toml",
        "typescript",
        "xml",
        "yaml",
    },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true })
            end,
            mode = { "n", "v" },
            desc = "Format buffer",
        },
    },
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
        default_format_opts = {
            lsp_fallback = true,
        },
        formatters_by_ft = {
            css = { "prettier" },
            html = { "prettier" },
            javascript = { "prettier" },
            json = { "prettier" },
            lua = { "stylua" },
            markdown = { "prettier" },
            python = { "ruff_format" },
            sh = { "shfmt" },
            toml = { "taplo" },
            typescript = { "prettier" },
            xml = { "xmlformatter" },
            yaml = { "yamlfmt" },
        },
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 5000,
        },
        notify_on_error = true,
        formatters = {
            prettier = {
                prepend_args = {
                    "--print-width",
                    "100",
                    "--tab-width",
                    "2",
                    "--use-tabs",
                    "false",
                    "--single-quote",
                    "true",
                    "--trailing-comma",
                    "es5",
                    "--bracket-spacing",
                    "true",
                },
            },
            stylua = {
                prepend_args = {
                    "--indent-type",
                    "Spaces",
                    "--indent-width",
                    "4",
                    "--quote-style",
                    "AutoPreferDouble",
                },
            },
            ruff_format = {
                -- ruff format is mostly not configurable yet, but still explicit
                prepend_args = {},
            },
            shfmt = {
                -- indent 2, switch case indent, simplify
                prepend_args = { "-i", "2", "-ci", "-sr" },
            },
            taplo = {
                -- taplo is opinionated; no args usually needed
                prepend_args = {},
            },
            xmlformatter = {
                prepend_args = {
                    "--indent",
                    "2",
                    "--selfclose",
                    "yes",
                },
            },
            yamlfmt = {
                -- yamlfmt is also mostly non-configurable
                prepend_args = {},
            },
        },
    },
}

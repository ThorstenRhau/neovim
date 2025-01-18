---@module "lazy"
---@type LazySpec
return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
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
    opts = {
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- Define formatters by filetype.
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
            yaml = { "yamlfmt" },
        },
        -- Set up format-on-save
        format_on_save = { timeout_ms = 5000 },
        notify_on_error = true,
        -- Customize formatters
        formatters = {
            shfmt = {
                prepend_args = { "-i", "2" }, -- indent with two spaces
            },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}

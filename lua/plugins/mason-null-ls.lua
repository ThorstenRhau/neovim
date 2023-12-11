return {
    "jay-babu/mason-null-ls.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        { "williamboman/mason.nvim" },
        { "nvimtools/none-ls.nvim" },
    },
    config = function()
        require("mason-null-ls").setup({
            ensure_installed = {
                "stylua",
                "jq",
                "black",
                "shfmt",
                "prettier",
                "isort",
                "marksman",
            },
        })
    end,
}

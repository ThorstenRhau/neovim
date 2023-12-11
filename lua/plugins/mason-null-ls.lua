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

        { "nvimtools/none-ls.nvim" },
    },
    config = function()
        require("mason-null-ls").setup({
            ensure_installed = {
                "stylua",
                "jq",
                "pyright",
                "shfmt",
                "prettier",
                "isort",
                "marksman",
                "black",
            },
        })
    end,
}

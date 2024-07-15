return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        --"nvim-tree/nvim-web-devicons",
        "echasnovski/mini.icons",
    },
    cmd = "AerialToggle",
    opts = {
        backends = { "treesitter", "lsp", "markdown", "man" },
        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
        },
    },
}

return {
    "folke/which-key.nvim",
    dependencies = {
        "echasnovski/mini.icons",
    },
    event = "VeryLazy",
    opts = {
        preset = "modern",
        icons = {
            breadcrumb = "»",
            separator = " ",
            group = "  ",
        },
        delay = 350,
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}

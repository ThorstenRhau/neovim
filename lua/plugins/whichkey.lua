return {
    "folke/which-key.nvim",
    dependencies = {
        "echasnovski/mini.icons",
    },
    opts = {
        preset = "modern",
        icons = {
            separator = ">",
        },
        delay = 250,
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
        "<leader>",
        "<C-g>", -- gp.nvim menues
    },
}

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
        "MeanderingProgrammer/render-markdown.nvim",
        "stevearc/dressing.nvim",
    },
    config = true,
    cmd = {
        "CodeCompanion",
        "CodeCompanionCmd",
        "CodeCompanionActions",
        "CodeCompanionChat",
    },
    keys = {
        {
            "<C-a>",
            "<cmd>CodeCompanionActions<cr>",
            desc = "Code Companion Actions",
            mode = { "n", "v" },
            noremap = true,
            silent = true,
        },
        {
            "<localleader>a",
            "<cmd>CodeCompanionChat Toggle<cr>",
            desc = "Code Companion Chat Toggle",
            mode = { "n", "v" },
            noremap = true,
            silent = true,
        },
        {
            "ga",
            "<cmd>CodeCompanionChat Add<cr>",
            desc = "Code Companion Chat Add",
            mode = "v",
            noremap = true,
            silent = true,
        },
    },
    opts = {
        strategies = {
            chat = { adapter = "ollama" },
            inline = { adapter = "ollama" },
            cmd = { adapter = "ollama" },
        },
        display = {
            chat = {
                render_headers = false,
            },
        },
    },
}

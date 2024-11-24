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
    config = function()
        require("codecompanion").setup({
            strategies = {
                chat = { adapter = "ollama_custom", model = "qwen2.5-coder:7b", temperature = 0.3 },
                inline = { adapter = "ollama_custom", model = "qwen2.5-coder:7b", temperature = 0.3 },
                cmd = { adapter = "ollama_custom", model = "qwen2.5-coder:7b", temperature = 0.3 },
                agent = { adapter = "ollama_custom", temperature = 0.3 },
            },

            adapters = {
                -- Register only the adapters you want to use
                ollama_custom = function()
                    return require("codecompanion.adapters").extend("ollama", {
                        name = "ollama_custom", -- Give this adapter a unique name
                        schema = {
                            model = {
                                default = "qwen2.5-coder:7b",
                            },
                            num_ctx = {
                                default = 4096,
                            },
                            num_predict = {
                                default = -1,
                            },
                            temperature = {
                                default = 0.3,
                            },
                            top_p = {
                                default = 0.8,
                            },
                            frequency_penalty = {
                                default = 0.0,
                            },
                            presence_penalty = {
                                default = 0.0,
                            },
                        },
                    })
                end,
            },
        })
    end,

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
            chat = { adapter = "ollama", model = "qwen2.5-coder:7b" },
            inline = { adapter = "ollama", model = "qwen2.5-coder:7b" },
            cmd = { adapter = "ollama", model = "qwen2.5-coder:7b" },
        },
        display = {
            chat = {
                render_headers = false,
            },
        },
    },
}

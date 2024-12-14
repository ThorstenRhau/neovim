return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "MeanderingProgrammer/render-markdown.nvim",
        "echasnovski/mini.diff",
        "hrsh7th/nvim-cmp",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
    },
    config = function()
        require("codecompanion").setup({
            opts = {
                log_level = "ERROR",
            },
            display = {
                diff = {
                    enabled = true,
                    provider = "mini_diff",
                },
                action_palette = {
                    width = 95,
                    height = 10,
                    prompt = "Prompt ", -- Prompt used for interactive LLM calls
                    provider = "telescope", -- default|telescope|mini_pick
                    opts = {
                        show_default_actions = true, -- Show the default actions in the action palette?
                        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
                    },
                },
            },
            strategies = {
                chat = { adapter = "lm_studio" },
                inline = { adapter = "lm_studio" },
                cmd = { adapter = "lm_studio" },
                agent = { adapter = "lm_studio" },
            },

            adapters = {
                lm_studio = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "lm_studio",
                        env = {
                            url = "http://127.0.0.1:1234",
                            chat_url = "/v1/chat/completions",
                        },
                    })
                end,

                ollama_custom = function()
                    return require("codecompanion.adapters").extend("ollama", {
                        name = "ollama_custom", -- Give this adapter a unique name
                        schema = {
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
}

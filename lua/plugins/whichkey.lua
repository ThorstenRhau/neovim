return {
    {
        "folke/which-key.nvim",
        lazy = true,
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {
            plugins = {
                marks = true,
                registers = true,
                spelling = {
                    enabled = true,
                    suggestions = 20,
                },
                presets = {
                    operators = true,
                    motions = true,
                    text_objects = true,
                    windows = true,
                    nav = true,
                    z = true,
                    g = true,
                },
            },
            key_labels = {},
            motions = {
                count = true,
            },
            icons = {
                breadcrumb = "»",
                -- separator = "➜",
                separator = "",
                group = "+",
            },
            popup_mappings = {
                scroll_down = "<c-d>",
                scroll_up = "<c-u>",
            },
            window = {
                border = "rounded",
                position = "bottom",
                margin = { 3, 0.04, 3, 0.03 },
                padding = { 1, 2, 1, 2 },
                winblend = 0,
                zindex = 1000,
            },
            layout = {
                height = { min = 5, max = 25 },
                width = { min = 5, max = 50 },
                spacing = 3,
                align = "center",
            },
            ignore_missing = false,
            hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
            show_help = true,
            show_keys = true,
            triggers = "auto",
            triggers_nowait = {
                -- marks
                "`",
                "'",
                "g`",
                "g'",
                -- registers
                '"',
                "<c-r>",
                -- spelling
                "z=",
            },
            triggers_blacklist = {
                i = { "j", "k" },
                v = { "j", "k" },
            },
            disable = {
                buftypes = {},
                filetypes = {},
            },
        },
    },
}

return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "InsertEnter",
        opts = {
            indent = {
                char = "┆",
                smart_indent_cap = true,
                priority = 2,
            },
            -- whitespace = { highlight = { "Whitespace", "NonText" } },
            whitespace = {
                highlight = {
                    "Function",
                    "Label",
                },
                remove_blankline_trail = true,
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = true,
                char = "│",
                exclude = { language = {} },
                highlight = {
                    "Function",
                    "Label",
                },
            },
            exclude = {
                filetypes = {
                    "help",
                    "Trouble",
                    "lazy",
                    "mason",
                    "man",
                },
            },
        },
    },
}

return {
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            indent = {
                char = "┆",
                tab_char = "┆",
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = true,
                show_exact_scope = true,
                injected_languages = true,
                highlight = { "Function", "Label" },
                priority = 500,
            },
            exclude = {
                filetypes = {
                    "alpha",
                    "help",
                    "lazy",
                    "mason",
                },
            },
        },
        main = "ibl",
    },
}

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
                enabled = false,
                injected_languages = true,
                highlight = { "Function", "Label" },
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

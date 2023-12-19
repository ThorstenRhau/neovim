return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        enabled = true,
        priority = 1000,
        lazy = false,
        opts = {
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = {
                light = "latte",
                dark = "frappe",
            },
            transparent_background = false,
            show_end_of_buffer = false,
            term_colors = false,
            dim_inactive = {
                enabled = true,
                shade = "dark",
                percentage = 0.10,
            },
            no_italic = false,
            no_bold = false,
            no_underline = false,
            styles = {
                comments = { "italic" },
                conditionals = {},
                loops = {},
                constants = { "bold" },
                functions = { "bold, italic" },
                keywords = { "italic" },
                strings = { "italic" },
                variables = { "bold" },
                numbers = {},
                booleans = {},
                properties = {},
                types = { "bold" },
                operators = {},
            },
            color_overrides = {
                all = {},
                latte = {},
                frappe = {},
                macchiato = {},
                mocha = {},
            },
            custom_highlights = {},
            integrations = {
                cmp = true,
                fidget = true,
                gitsigns = true,
                illuminate = {
                    enabled = false,
                    lsp = false,
                },
                indent_blankline = {
                    enabled = true,
                    colored_indent_levels = false,
                },
                lsp_trouble = true,
                lsp_saga = true,
                markdown = true,
                mini = {
                    enabled = true,
                },
                neotree = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = {},
                        hints = {},
                        warnings = {},
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "underdotted" },
                        warnings = { "underline" },
                        information = { "underdashed" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
                pounce = true,
                semantic_tokens = true,
                treesitter = true,
                treesitter_context = true,
                symbols_outline = true,
                telescope = {
                    enabled = true,
                    style = "lazy",
                },
                which_key = true,
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        },
    },
}

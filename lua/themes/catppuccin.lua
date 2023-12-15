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
            transparent_background = false,     -- disables setting the background color.
            show_end_of_buffer = false,         -- shows the '~' characters after the end of buffers
            term_colors = false,                -- sets terminal colors (e.g. `g:terminal_color_0`)
            dim_inactive = {
                enabled = false,                -- dims the background color of inactive window
                shade = "dark",
                percentage = 0.20,              -- percentage of the shade to apply to the inactive window
            },
            no_italic = false,                  -- Force no italic
            no_bold = false,                    -- Force no bold
            no_underline = false,               -- Force no underline
            styles = {
                comments = { "italic" },        -- Comments: Less prominent, italicized
                conditionals = {},              -- Conditionals: Important, bold
                loops = {},                     -- Loops: Important, bold
                functions = { "bold, italic" }, -- Functions: Key logic, bold
                keywords = { "italic" },        -- Keywords: Core language constructs, bold
                strings = {},                   -- Strings: Distinct, but not stylized here
                variables = {},                 -- Variables: Standard, blend with main code
                numbers = {},                   -- Numbers: Stand out for identification, bold
                booleans = {},                  -- Booleans: Important for logic, bold
                properties = {},                -- Properties: Subtle distinction, italicized
                types = { "bold" },             -- Types: Subtly distinct, italicized
                operators = {},                 -- Operators: Integral but not emphasized
            },

            color_overrides = {},
            custom_highlights = {},
            integrations = {
                alpha = true,
                cmp = true,
                fidget = true,
                gitsigns = true,
                indent_blankline = {
                    enabled = true,
                    scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
                    colored_indent_levels = false,
                },
                lsp_saga = true,
                markdown = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
                semantic_tokens = true,
                treesitter = true,
                treesitter_context = true,
                mini = {
                    enabled = false,
                    indentscope_color = "",
                },
                pounce = true,
                symbols_outline = true,
                lsp_trouble = true,
                illuminate = {
                    enabled = false,
                    lsp = false,
                },
                which_key = true,
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        },
    },
}

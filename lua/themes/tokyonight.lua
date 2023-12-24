return {
    {
        "folke/tokyonight.nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
        opts = {
            style = "storm",
            light_style = "day",
            transparent = false,
            terminal_colors = true,
            styles = { -- Style to be applied to different syntax groups
                comments = { italic = true }, -- Value is any valid attr-list value `:help attr-list`
                conditionals = {}, -- Value is any valid attr-list value for `:help nvim_set_hl`
                constants = { bold = true },
                functions = { bold = true, italic = true },
                keywords = { italic = true },
                number = {},
                operator = {},
                strings = { italic = true },
                types = { bold = true },
                variables = { bold = true },
                -- Background styles. Can be "dark", "transparent" or "normal"
                sidebars = "dark",
                floats = "dark",
            },
            sidebars = { "qf", "help" },
            day_brightness = 0.3, -- Default is 0.3
            hide_inactive_statusline = false,
            dim_inactive = true,
            lualine_bold = true,
        },
    },
}

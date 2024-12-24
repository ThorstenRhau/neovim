return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    version = "*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {

        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = "mono",
        },

        completion = {
            accept = { auto_brackets = { enabled = true } },
            menu = {
                border = "single",
                draw = {
                    treesitter = { "lsp" },
                },
            },
            documentation = {
                window = { border = "single" },
                auto_show = true,
                auto_show_delay_ms = 250,
            },
        },

        keymap = {
            preset = "enter",
            ["<C-y>"] = { "select_and_accept" },
        },

        signature = {
            enabled = true,
            window = { border = "single" },
        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            cmdline = {}, -- Disable sources for command-line mode
        },
    },
    opts_extend = { "sources.default" },
}

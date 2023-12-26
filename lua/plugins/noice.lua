return {
    "folke/noice.nvim",
    dependencies = {
        "VonHeikemen/lsp-zero.nvim",
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
        "nvim-treesitter/nvim-treesitter",
    },
    lazy = true,
    event = "VeryLazy",
    opts = {
        -- routes = {
        --     {
        --         view = "notify",
        --         filter = { event = "msg_showmode" },
        --     },
        -- },
        cmdline = {
            view = "cmdline_popup", -- cmdline_popup or cmdline
        },
        views = { -- Position of the command window
            cmdline_popup = {
                position = {
                    row = "65%",
                    col = "50%",
                },
            },
        },
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
            hover = {
                enabled = true,
            },
            signature = {
                enabled = true,
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
            notify = {
                enabled = true,
                view = "notify",
            },
        },
    },
}

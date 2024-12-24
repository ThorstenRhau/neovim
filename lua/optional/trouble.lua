return {
    {
        "folke/trouble.nvim",
        opts = {
            mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
            auto_close = true, -- Close when last error is fixed
            focus = true, -- Focus the window when opened
            preview = {
                type = "float",
                relative = "editor",
                border = "rounded",
                title = "Preview",
                title_pos = "center",
                position = { 0.7, 1 },
                size = { width = 0.3, height = 0.3 },
                zindex = 200,
            },
        },

        cmd = "Trouble",
        keys = {
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>co",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xl",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
}

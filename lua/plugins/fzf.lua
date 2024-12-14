return {
    "ibhagwan/fzf-lua",
    dependencies = {
        "echasnovski/mini.icons",
        "MeanderingProgrammer/render-markdown.nvim",
        "nvim-treesitter/nvim-treesitter-context",
    },
    cmd = { "FzfLua" },
    config = function()
        require("fzf-lua").setup({
            async = true, -- Enable async for fzf
            defaults = {
                file_icons = true,
                git_icons = true,
                color_icons = true,
            },
            winopts = {
                height = 0.8,
                preview = {
                    layout = "vertical",
                    vertical = "up:70%", -- Place preview above the window
                },
                border = "rounded", -- Rounded borders for aesthetics
                fullscreen = false, -- Avoid fullscreen for flexibility
            },
            keymap = {
                builtin = {
                    ["<C-u>"] = "preview-page-up", -- Page up in preview with Ctrl+b
                    ["<C-d>"] = "preview-page-down", -- Page down in preview with Ctrl+f
                    ["<C-p>"] = "toggle-preview", -- Toggle preview window with Ctrl+p
                },
                fzf = {
                    ["ctrl-q"] = "select-all+accept", -- Select all items and accept with Ctrl+q
                },
            },
            fzf_opts = {
                ["--layout"] = "reverse-list", -- Show results on top, input at the bottom
                ["--marker"] = "+", -- Change multi-select marker
            },
        })
    end,
}

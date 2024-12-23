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
            "default", -- fzf profile
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
                    vertical = "up:70%",
                },
                border = "rounded",
                fullscreen = false,
            },
            keymap = {
                builtin = {
                    ["<C-u>"] = "preview-page-up",
                    ["<C-d>"] = "preview-page-down",
                    ["<C-p>"] = "toggle-preview",
                },
                fzf = {
                    ["ctrl-q"] = "select-all+accept",
                },
            },
            fzf_opts = {
                ["--layout"] = "reverse-list",
                ["--marker"] = "+",
            },
            previewers = {
                builtin = {
                    syntax = true, -- preview syntax highlight?
                    syntax_limit_l = 1024, -- syntax limit (lines), 0=nolimit
                    syntax_limit_b = 1024 * 500, -- syntax limit (bytes), 0=nolimit
                    limit_b = 1024 * 1024 * 5, -- preview limit (bytes), 0=nolimit
                    extensions = {
                        ["jpg"] = { "viu", "-b" },
                        ["jpeg"] = { "viu", "-b" },
                        ["svg"] = { "viu", "-b" },
                        ["png"] = { "viu", "-b" },
                    },
                },
            },
            oldfiles = {
                include_current_session = true,
            },
            grep = {
                rg_glob = true,
                glob_flag = "--iglob",
                glob_separator = "%s%-%-",
            },
        })
        require("which-key").add({
            { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Commits Project" },
            { "<leader>gC", "<cmd>FzfLua git_bcommits<cr>", desc = "Commits Buffer" },
            { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Status" },
            { "<leader>gB", "<cmd>FzfLua git_blame<cr>", desc = "Blame" },
        })
    end,
}

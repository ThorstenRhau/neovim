return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy = true,
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "BurntSushi/ripgrep",
        "nvim-telescope/telescope-fzf-native.nvim",
        "debugloop/telescope-undo.nvim",
        "AckslD/nvim-neoclip.lua",
    },
    config = function()
        require("telescope").setup({
            defaults = {
                layout_strategy = "cursor",
                layout_config = {
                    height = 0.95,
                    width = 0.95,
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
                undo = {},
                neoclip = {},
            },
            require("telescope").load_extension("fzf"),
            require("telescope").load_extension("undo"),
            require("telescope").load_extension("neoclip"),
        })
    end,
}

---@module "lazy"
---@type LazySpec
return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        keys = {
            { "<c-space>", desc = "Increment Selection" },
            { "<bs>", desc = "Decrement Selection", mode = "x" },
        },
        opts = function()
            require("nvim-treesitter.configs").setup({
                modules = {},
                sync_install = false,
                ignore_install = {},
                auto_install = true,
                autotag = {
                    enable = true,
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
                ensure_installed = {
                    "bash",
                    "comment",
                    "diff",
                    "fish",
                    "git_config",
                    "git_rebase",
                    "gitcommit",
                    "gitignore",
                    "lua",
                    "luadoc",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "regex",
                    "toml",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
            })
        end,
    },

    -- Lazy load nvim-treesitter-context for specific file types
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        ft = { "lua", "bash", "python" },
    },
}

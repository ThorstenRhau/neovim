return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter-context",
    version = false,
    build = ":TSUpdate",
    lazy = true,
    event = "VeryLazy",
    opts = function()
        require("nvim-treesitter.configs").setup({
            auto_install = true,
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
                    init_selection = "gna", -- set to `false` to disable one of the mappings
                    node_incremental = "false",
                    scope_incremental = "false",
                    node_decremental = "false",
                },
            },
            ensure_installed = {
                "bash",
                "comment",
                "diff",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "html",
                "http",
                "jsonc",
                "lua",
                "luadoc",
                "python",
                "markdown",
                "markdown_inline",
                "toml",
                "vim",
                "vimdoc",
                "yaml",
            },
        })
    end,
}

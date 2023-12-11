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
            },
            indent = {
                enable = true,
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

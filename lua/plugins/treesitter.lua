return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter-context",
    version = false,
    build = ":TSUpdate",
    lazy = true,
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = function()
        require("nvim-treesitter.configs").setup({
            modules = {},
            sync_install = false,
            ignore_install = {},
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
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
                "regex",
                "toml",
                "vim",
                "vimdoc",
                "yaml",
            },
        })
    end,
}

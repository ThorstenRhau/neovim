return {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    lazy = true,
    event = "BufEnter",
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

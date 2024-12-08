return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter-context",

    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
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
            ---@diagnostic disable-next-line: unused-local
            -- disable = function(lang, buf)
            --     local max_filesize = 500 * 1024 -- 500 KB
            --     ---@diagnostic disable-next-line: undefined-field
            --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            --     if ok and stats and stats.size > max_filesize then
            --         return true
            --     end
            -- end,
            ensure_installed = {
                "bash",
                "comment",
                "diff",
                "git_rebase",
                "gitcommit",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "python",
                "toml",
                "vim",
                "vimdoc",
            },
        })
    end,
}

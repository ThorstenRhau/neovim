return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
        "windwp/nvim-ts-autotag",
    },
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
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
            disable = function(lang, buf)
                local max_filesize = 500 * 1024 -- 500 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            ensure_installed = {
                "bash",
                "comment",
                "css",
                "diff",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "html",
                "http",
                "javascript",
                "json",
                "json5",
                "jsonc",
                "lua",
                "luadoc",
                "make",
                "markdown",
                "markdown_inline",
                "passwd",
                "pem",
                "perl",
                "php",
                "phpdoc",
                "properties",
                "pymanifest",
                "python",
                "regex",
                "requirements",
                "ruby",
                "scheme",
                "sql",
                "ssh_config",
                "todotxt",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            },
        })
    end,
}

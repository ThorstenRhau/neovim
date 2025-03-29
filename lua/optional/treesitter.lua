---@module "lazy"
---@type LazySpec
return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        ft = { "checkhealth" },
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
                    disable = function(_, buf)
                        local max = 256 * 1024
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        return ok and stats and stats.size > max
                    end,
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
                    "css",
                    "diff",
                    "fish",
                    "git_config",
                    "git_rebase",
                    "gitcommit",
                    "gitignore",
                    "html",
                    "javascript",
                    "json",
                    "latex",
                    "lua",
                    "luadoc",
                    "markdown",
                    "markdown_inline",
                    "norg",
                    "python",
                    "query",
                    "regex",
                    "scss",
                    "svelte",
                    "toml",
                    "tsx",
                    "typescript",
                    "typst",
                    "vim",
                    "vimdoc",
                    "vue",
                    "xml",
                    "yaml",
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
    },
}

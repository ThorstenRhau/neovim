return {
    "stevearc/dressing.nvim",
    event = "BufRead",
    opts = {
        input = {
            enabled = true,
            title_pos = "center",
        },
        select = {
            enabled = true,
            backend = { "fzf_lua", "builtin", "nui" },
        },
    },
}

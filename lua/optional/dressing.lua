return {
    "stevearc/dressing.nvim",
    enabled = false,
    event = { "InsertEnter", "CmdlineEnter" },
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

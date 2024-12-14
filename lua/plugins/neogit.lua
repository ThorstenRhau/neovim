return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        {
            "sindrets/diffview.nvim",
            cmd = {
                "DiffviewOpen",
                "DiffviewClose",
                "DiffviewFileHistory",
            },
        },
    },
    cmd = "Neogit",
    config = true,
    opts = {
        disable_insert_on_commit = true,
        disable_hint = true,
        filewatcher = {
            interval = 1000,
            enabled = true,
        },
        graph_style = "unicode",
        auto_show_console_on = "error",
        highlight = {
            italic = true,
            bold = true,
            underline = true,
        },
        signs = {
            section = { "▶", "▼" },
            item = { "▷", "▽" },
            hunk = { "", "" },
        },
        kind = "tab",
        status = {
            recent_commit_count = 20,
        },
        integrations = {
            telescope = true,
            diffview = true,
        },
    },
}

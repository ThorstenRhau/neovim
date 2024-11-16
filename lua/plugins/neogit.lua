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
        graph_style = "unicode",
        kind = "replace",
        status = {
            recent_commit_count = 20,
        },
        integrations = {
            telescope = true,
            diffview = true,
        },
    },
}

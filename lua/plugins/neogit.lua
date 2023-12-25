return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
    },
    lazy = true,
    cmd = { "Neogit" },
    config = true,
    opts = {
        disable_insert_on_commit = true,
        graph_style = "unicode",
        kind = "replace",
        filewatcher = {
            interval = 2500,
            enabled = true,
        },
        status = {
            recent_commit_count = 20,
        },
        integrations = {
            telescope = true,
            diffview = true,
        },
    },
}

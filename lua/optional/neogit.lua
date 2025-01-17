return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        -- "ibhagwan/fzf-lua",
    },
    cmd = "Neogit",
    config = true,
    opts = {
        disable_insert_on_commit = true,
        graph_style = "unicode",
        process_spinner = false,
    },
}

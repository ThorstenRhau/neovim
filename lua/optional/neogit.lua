---@module "lazy"
---@type LazySpec
return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    opts = {
        disable_insert_on_commit = true,
        graph_style = "unicode",
        process_spinner = false,
    },
}

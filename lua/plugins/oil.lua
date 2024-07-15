return {
    "stevearc/oil.nvim",
    dependencies = {
        "echasnovski/mini.icons",
    },
    cmd = "Oil",
    opts = {
        default_file_explorer = true,
        columns = {
            "icon",
            "permissions",
            "size",
            "mtime",
        },
        watch_for_changes = true,
        use_default_keymaps = true,
        show_hidden = true,
    },
}

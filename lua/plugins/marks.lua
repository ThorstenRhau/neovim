return {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        default_mappings = true,
        refresh_interval = 500,
        excluded_filetypes = {},
    },
}

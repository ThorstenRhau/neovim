return {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
        default_mappings = false,
        refresh_interval = 500,
        excluded_filetypes = {},
    },
}

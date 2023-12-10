return {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    lazy = true,
    event = "BufEnter",
    opts = {
        theme = "auto",
        extensions = {
            "fugitive",
            "fzf",
            "lazy",
            "man",
            "mason",
            "trouble",
        },
    },
}

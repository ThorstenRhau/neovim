return {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
        "SmiteshP/nvim-navic",
        "echasnovski/mini.icons",
    },
    event = { "LspAttach" },
    cmd = "Barbecue",
    opts = {
        exclude_filetypes = {
            "snacks_dashboard",
        },
    },
}

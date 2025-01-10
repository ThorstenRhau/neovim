return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 950, -- Plugin needs to be loaded early
    opts = {
        options = {
            show_source = true,
        },
    },
}

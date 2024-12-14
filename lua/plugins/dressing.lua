return {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = function()
        require("dressing").setup({
            input = {
                enabled = false, -- Set to false to disable the vim.ui.input implementation
            },
        })
    end,
}

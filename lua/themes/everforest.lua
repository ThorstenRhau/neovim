return {
    "neanias/everforest-nvim",
    enabled = false,
    priority = 1000,
    config = function()
        require("everforest").setup({
            -- Your config here
        })
    end,
}

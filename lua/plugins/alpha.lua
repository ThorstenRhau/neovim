return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        enabled = true,
        init = false,
        config = function()
            require("alpha").setup(require("alpha.themes.startify").config)
        end,
    },
}

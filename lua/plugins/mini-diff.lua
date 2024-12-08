return {
    "echasnovski/mini.diff",
    event = "VeryLazy",
    keys = {
        {
            "<leader>go",
            function()
                require("mini.diff").toggle_overlay(0)
            end,
            desc = "Toggle mini.diff overlay",
        },
    },
    opts = {
        view = {
            style = "sign",
            signs = {
                add = " ", -- Checked box
                change = " ", -- Wrench or diff icon
                delete = " ", -- Close box
            },
        },
    },
}

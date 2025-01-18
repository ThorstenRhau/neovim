---@module "lazy"
---@type LazySpec
return {
    "echasnovski/mini.nvim",
    dependencies = "echasnovski/mini.icons",
    version = false,
    event = "BufReadPost",
    config = function()
        require("mini.ai").setup()
        require("mini.align").setup()
        require("mini.bracketed").setup()
        require("mini.comment").setup()
        require("mini.jump2d").setup()
        require("mini.operators").setup()
        require("mini.pairs").setup()
        require("mini.surround").setup()
    end,
    keys = {
        { "ga", desc = "Align text", mode = { "v" } },
        { "gA", desc = "Align text interactive", mode = { "v" } },
    },
}

---@module "lazy"
---@type LazySpec
return {
    "echasnovski/mini.icons",
    event = "VeryLazy",
    version = false,
    opts = {},
    --              ╭─────────────────────────────────────────────────╮
    --              │ Handling dependencies towards nvim-web-devicons │
    --              ╰─────────────────────────────────────────────────╯
    specs = {
        { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
        package.preload["nvim-web-devicons"] = function()
            require("mini.icons").mock_nvim_web_devicons()
            return package.loaded["nvim-web-devicons"]
        end
    end,
}

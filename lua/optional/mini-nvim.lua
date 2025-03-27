---@module "lazy"
---@type LazySpec
return {
    "echasnovski/mini.nvim",
    dependencies = { "echasnovski/mini.icons" },
    version = false,
    event = "VeryLazy",
    config = function()
        local function safe_setup(mod)
            local ok, plugin = pcall(require, "mini." .. mod)
            if ok and type(plugin.setup) == "function" then
                plugin.setup()
            end
        end

        for _, mod in ipairs({
            "ai",
            "align",
            "bracketed",
            "comment",
            "jump2d",
            "operators",
            "pairs",
            "splitjoin",
            "surround",
        }) do
            safe_setup(mod)
        end
    end,
    keys = {
        -- stylua: ignore start
        { "ga",         desc = "Align text",                   mode = { "v" } },
        { "gA",         desc = "Align text interactive",       mode = { "v" } },
        { "<leader>cj", function() MiniSplitjoin.toggle() end, desc = "Split/Join text", mode = { "v", "n" } },
        -- stylua: ignore end
    },
}

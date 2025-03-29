---@module "lazy"
---@type LazySpec
return {
    "echasnovski/mini.nvim",
    dependencies = { "echasnovski/mini.icons" },
    version = false,
    event = "VeryLazy",
    config = function()
        local function safe_setup(mod, opts)
            local ok, plugin = pcall(require, "mini." .. mod)
            if ok and type(plugin.setup) == "function" then
                plugin.setup(opts or {})
            end
        end

        for _, mod in ipairs({
            "ai",
            "align",
            "bracketed",
            "comment",
            "operators",
            "pairs",
            "splitjoin",
            "surround",
        }) do
            safe_setup(mod)
        end

        -- Override jump2d setup to disable default mapping
        safe_setup("jump2d", {
            mappings = { start_jumping = "" }, -- disable default <CR>
        })

        -- Map <C-CR> instead of <CR> to start jump2d
        vim.keymap.set("n", "<C-CR>", function()
            require("mini.jump2d").start()
        end, { desc = "MiniJump2d: start jumping" })
    end,
    keys = {
        -- stylua: ignore start
        { "ga",         desc = "Align text",                   mode = { "v" } },
        { "gA",         desc = "Align text interactive",       mode = { "v" } },
        { "<leader>cj", function() MiniSplitjoin.toggle() end, desc = "Split/Join text", mode = { "v", "n" } },
        -- stylua: ignore end
    },
}

---@diagnostic disable: undefined-global
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        animate = {
            enabled = true,
            duration = 20, -- ms per step
            easing = "linear",
            fps = 60, -- frames per second. Global setting for all animations
        },
        bigfile = {
            size = 1 * 1024 * 1024, -- 1 MB
            notify = true,
        },
        dashboard = {
            row = nil, -- dashboard position. nil for center
            col = nil, -- dashboard position. nil for center
            preset = {
                header = [[neovim :: by Thorsten]],
            },
            formats = {
                header = { "%s", align = "center" },
                text = { "%s", align = "center" },
            },
            sections = {
                {
                    section = "header",
                },
            },
        },
        git = { enabled = true },
        gitbrowse = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = {
            style = "compact",
            timeout = 8000,
            sort = { "added" }, -- sort only by time
            width = { min = 12, max = 0.3 },
            height = { min = 1, max = 0.3 },
            top_down = true,
        },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = {
            enabled = true,
            animate = {
                duration = { step = 10, total = 150 },
                easing = "linear",
            },
            spamming = 10,
        },
        statuscolumn = { enabled = true },
        styles = {
            input = {
                backdrop = true,
                border = vim.g.borderStyle,
                title_pos = "left",
                width = 50,
                row = math.ceil(vim.o.lines / 2) - 3,
                wo = { wrap = true },
                keys = {
                    i_esc = { "<Esc>", { "cmp_close", "stopinsert" }, mode = "i" },
                    BS = { "<BS>", "<Nop>", mode = "n" }, -- prevent accidental closing (<BS> -> :bprev)
                    CR = { "<CR>", "confirm", mode = "n" },
                },
                history = {
                    border = vim.g.border_style,
                },
            },
            notification = {
                border = vim.g.borderStyle,
                wo = { winblend = 0, wrap = true },
            },
            blame_line = {
                width = 0.6,
                height = 0.6,
                border = vim.g.borderStyle,
                title = " 󰉚 Git blame ",
            },
        },
        terminal = {
            enabled = true,
            win = {
                style = "terminal",
                border = vim.g.border_style,
                position = "float",
                height = 0.8,
                width = 0.8,
            },
        },
        toggle = { enabled = true },
        words = { modes = { "n", "c" } }, -- No word highlights in insert mode
    },

    keys = {
    -- stylua: ignore start
        { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
        { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
        { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
        { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
        { "<leader>gw", function() Snacks.gitbrowse() end, desc = "Git Browse Web" },
        { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
        { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
        { "<leader>t",  function() Snacks.terminal() end, desc = "Toggle Terminal" },
        { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
        -- stylua: ignore end
    },

    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle
                    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<leader>uc")
                Snacks.toggle.treesitter():map("<leader>uT")
                Snacks.toggle
                    .option("background", { off = "light", on = "dark", name = "Dark Background" })
                    :map("<leader>ub")
                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.dim():map("<leader>uD")
            end,
        })
    end,
}

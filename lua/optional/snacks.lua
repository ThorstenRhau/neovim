---@module "lazy"
---@type LazySpec
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
        animate = { enabled = true },
        bigfile = {
            size = 1 * 1024 * 1024,
            notify = true,
        },
        dashboard = { enabled = false },
        explorer = { enabled = false },
        git = { enabled = true },
        gitbrowse = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        image = { enabled = true },
        notifier = {
            padding = true,
            sort = { "added" },
            style = "compact",
            timeout = 4000,
            top_down = true,
        },
        picker = {
            layout = {
                fullscreen = true,
                cycle = true,
                preset = function()
                    local columns = vim.api.nvim_get_option_value("columns", {})
                    return columns >= 120 and "default" or "vertical"
                end,
            },
            sources = {
                notifications = {
                    layout = "ivy_split",
                },
            },
            undo = {
                enabled = true,
                mappings = {
                    ["<C-y>"] = "yank_added",
                    ["<C-S-y>"] = "yank_deleted",
                },
            },
        },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scratch = { enabled = false },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        terminal = { enabled = false },
        toggle = { enabled = true },
        words = {
            modes = { "n", "c" },
        },
    },

    keys = {
    -- stylua: ignore start
    { "<leader>z", function() require("snacks").zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z", function() require("snacks").zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>bd", function() require("snacks").bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() require("snacks").rename.rename_file() end, desc = "Rename File" },
    { "<leader>gw", function() require("snacks").gitbrowse() end, desc = "Git Browse Web" },
    { "<leader>gb", function() require("snacks").git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gf", function() require("snacks").lazygit.log_file() end, desc = "Lazygit Current File History" },
    { "<leader>gl", function() require("snacks").lazygit() end, desc = "Lazygit" },
    { "<leader>gL", function() require("snacks").lazygit.log() end, desc = "Lazygit Log (cwd)" },
    { "<leader>un", function() require("snacks").notifier.hide() end, desc = "Dismiss All Notifications" },
    { "]]", function() require("snacks").words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() require("snacks").words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    -- Snacks.picker
    { "<leader>/", function() require("snacks").picker.grep() end, desc = "Grep" },
    { "<leader>:", function() require("snacks").picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() require("snacks").picker.notifications() end, desc = "Notification History" },
    { "<leader>U", function() require("snacks").picker.undo() end, desc = "Undo" },
    { "<leader><space>", function() require("snacks").picker.files() end, desc = "Find Files" },
    -- Find
    { "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Buffers" },
    { "<leader>ff", function() require("snacks").picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() require("snacks").picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent" },
    -- Git
    { "<leader>gL", function() require("snacks").picker.git_log() end, desc = "Git Log" },
    { "<leader>gs", function() require("snacks").picker.git_status() end, desc = "Git Status" },
    -- Grep
    { "<leader>sb", function() require("snacks").picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() require("snacks").picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() require("snacks").picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() require("snacks").picker.grep_word() end,
            desc = "Visual selection or word", mode = { "n", "x" }
    },
    -- Search
    { '<leader>s"', function() require("snacks").picker.registers() end, desc = "Registers" },
    { "<leader>sa", function() require("snacks").picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() require("snacks").picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() require("snacks").picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() require("snacks").picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sh", function() require("snacks").picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() require("snacks").picker.highlights() end, desc = "Highlights" },
    { "<leader>sj", function() require("snacks").picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() require("snacks").picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() require("snacks").picker.loclist() end, desc = "Location List" },
    { "<leader>sM", function() require("snacks").picker.man() end, desc = "Man Pages" },
    { "<leader>sm", function() require("snacks").picker.marks() end, desc = "Marks" },
    { "<leader>sR", function() require("snacks").picker.resume() end, desc = "Resume" },
    { "<leader>sq", function() require("snacks").picker.qflist() end, desc = "Quickfix List" },
    { "<leader>uX", function() require("snacks").picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader>qp", function() require("snacks").picker.projects() end, desc = "Projects" },
    { "<leader>fs", function() require("snacks").picker.spelling() end, desc = "Spelling suggestions" },
    -- LSP
    { "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gr", function() require("snacks").picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() require("snacks").picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() require("snacks").picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() require("snacks").picker.lsp_symbols() end, desc = "LSP Symbols" },
        -- stylua: ignore end
    },

    init = function()
        local Snacks = require("snacks")
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
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

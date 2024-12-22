---@diagnostic disable: undefined-global
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "",
                        value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})
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
            height = { min = 1, max = 0.5 },
            padding = true,
            sort = { "added" }, -- sort only by time
            style = "compact",
            timeout = 8000,
            top_down = true,
            width = { min = 12, max = 0.3 },
        },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scratch = { enabled = false },
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
        { "<leader>z",  function() Snacks.zen() end,                     desc = "Toggle Zen Mode" },
        { "<leader>Z",  function() Snacks.zen.zoom() end,                desc = "Toggle Zoom" },
        { "<leader>n",  function() Snacks.notifier.show_history() end,   desc = "Notification History" },
        { "<leader>bd", function() Snacks.bufdelete() end,               desc = "Delete Buffer" },
        { "<leader>cR", function() Snacks.rename.rename_file() end,      desc = "Rename File" },
        { "<leader>gw", function() Snacks.gitbrowse() end,               desc = "Git Browse Web" },
        { "<leader>gb", function() Snacks.git.blame_line() end,          desc = "Git Blame Line" },
        { "<leader>gf", function() Snacks.lazygit.log_file() end,        desc = "Lazygit Current File History" },
        { "<leader>gl", function() Snacks.lazygit() end,                 desc = "Lazygit" },
        { "<leader>gL", function() Snacks.lazygit.log() end,             desc = "Lazygit Log (cwd)" },
        { "<leader>un", function() Snacks.notifier.hide() end,           desc = "Dismiss All Notifications" },
        { "<leader>t",  function() Snacks.terminal() end,                desc = "Toggle Terminal" },
        { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",              mode = { "n", "t" } },
        { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",              mode = { "n", "t" } },
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

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
-- Launch Telescope main window
vim.keymap.set("n", "<c-t>", ":Telescope<CR>")

-- Function to toggle virtual text
local function toggle_virtual_text()
    local current_value = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({
        virtual_text = not current_value,
    })
    if current_value then
        print("Virtual text disabled")
    else
        print("Virtual text enabled")
    end
end

--Function to list active linters
local function ListActiveLinters()
    local linters = require("lint").linters_by_ft[vim.bo.filetype]
    if linters then
        print("Active linters for filetype '" .. vim.bo.filetype .. "':")
        for _, linter in ipairs(linters) do
            print(linter)
        end
    else
        print("No active linters for filetype '" .. vim.bo.filetype .. "'.")
    end
end

-- Setting up register for 'which key' with keymappings
local wk = require("which-key")
wk.add({
    { "<leader>E", "<cmd>Explore<cr>", desc = "Explore" },
    { "<leader>U", "<cmd>Telescope undo<cr>", desc = "Undo" },
    --
    { "<leader>b", group = "Buffer" },
    { "<leader>bb", "<cmd>bprev<CR>", desc = "Previous" },
    { "<leader>be", "<cmd>Neotree buffers<CR>", desc = "Neotree buffers" },
    { "<leader>bl", "<cmd>ls<CR>", desc = "List" },
    --
    { "<leader>c", group = "Code" },
    {
        "<leader>cD",
        function()
            vim.lsp.buf.declaration()
        end,
        desc = "Go to declaration",
    },
    { "<leader>cL", ListActiveLinters, desc = "Linters list" },
    { "<leader>cT", "<Cmd>CBllline<CR>", desc = "Titled Line" },
    {
        "<leader>ca",
        function()
            vim.lsp.buf.code_action()
        end,
        desc = "Code action",
    },
    { "<leader>cb", "<Cmd>CBcabox<CR>", desc = "Box Title" },
    {
        "<leader>cd",
        function()
            vim.lsp.buf.definition()
        end,
        desc = "Go to definition",
    },
    {
        "<leader>ci",
        function()
            vim.lsp.buf.implementation()
        end,
        desc = "List implementations",
    },
    {
        "<leader>cr",
        function()
            vim.lsp.buf.rename()
        end,
        desc = "Rename",
    },
    {
        "<leader>cs",
        function()
            vim.lsp.buf.signature_help()
        end,
        desc = "Signature help",
    },
    {
        "<leader>ct",
        function()
            vim.lsp.buf.type_definition()
        end,
        desc = "Jump to definition",
    },
    --
    { "<leader>f", group = "Find" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "man pages" },
    { "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Notify messages" },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
    { "<leader>fy", "<cmd>Telescope neoclip<cr>", desc = "Old Yanks" },
    { "<leader>fz", "<cmd>Telescope spell_suggest<cr>", desc = "Spelling suggestions" },
    --
    { "<leader>g", group = "Git" },
    { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Blame toggle" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Shows previous commits" },
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Interactive Git" },
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
    { "<leader>l", "<cmd>Lazy<cr>", desc = "Lazy - plugin manager" },
    { "<leader>m", "<cmd>Mason<cr>", desc = "Mason - package manager" },
    { "<leader>o", "<cmd>Oil --float<cr>", desc = "Oil - file manager" },
    { "<leader>p", "<cmd>Pounce<cr>", desc = "Pounce - motion" },
    { "<leader>s", '<cmd> lua require("persistence").load() <cr>', desc = "Restore last session" },
    { "<leader>t", "<cmd>Telescope<cr>", desc = "Telescope - fuzzy finder" },
    --
    { "<leader>u", group = "User Interface" },
    { "<leader>uC", "<cmd>set colorcolumn=80<CR>", desc = "Colorcolumn at 80" },
    { "<leader>uc", "<cmd>ColorizerToggle<CR>", desc = "Colorize color codes" },
    { "<leader>uh", "<cmd>set list!<CR>", desc = "Hidden Characters Toggle" },
    { "<leader>ui", "<cmd>IlluminateToggle<cr>", desc = "Illuminate word highlighting" },
    { "<leader>ul", "<cmd>set number!<cr>", desc = "Line number toggle" },
    { "<leader>uo", "<cmd>AerialToggle!<CR>", desc = "Outline" },
    { "<leader>up", "<cmd>PickColor<CR>", desc = "Pick Color" },
    { "<leader>ur", "<cmd>set relativenumber!<cr>", desc = "Relative line number toggle" },
    { "<leader>ut", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal toggle" },
    { "<leader>uv", toggle_virtual_text, desc = "Toggle Virtual Text" },
    { "<leader>uw", "<cmd>set wrap!<cr>", desc = "Wrap line toggle" },
    --
    { "<leader>x", group = "Trouble" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics (Trouble)" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location list(Trouble)" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix list(Trouble)" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics (Trouble)" },
})
--wk.register({
--    ["<leader>E"] = { "<cmd>Explore<cr>", "Explore" },
--    ["<leader>l"] = { "<cmd>Lazy<cr>", "Lazy - plugin manager" },
--    ["<leader>m"] = { "<cmd>Mason<cr>", "Mason - package manager" },
--    ["<leader>o"] = { "<cmd>Oil --float<cr>", "Oil - file manager" },
--    ["<leader>p"] = { "<cmd>Pounce<cr>", "Pounce - motion" },
--    ["<leader>s"] = { [[<cmd> lua require("persistence").load() <cr>]], "Restore last session" },
--    ["<leader>t"] = { "<cmd>Telescope<cr>", "Telescope - fuzzy finder" },
--    ["<leader>U"] = { "<cmd>Telescope undo<cr>", "Undo" },
--
--    ["<leader>"] = {
--        b = {
--            name = "Buffer",
--            b = { "<cmd>bprev<CR>", "Previous" },
--            e = { "<cmd>Neotree buffers<CR>", "Neotree buffers" },
--            l = { "<cmd>ls<CR>", "List" },
--        },
--        c = {
--            name = "Code",
--            a = {
--                function()
--                    vim.lsp.buf.code_action()
--                end,
--                "Code action",
--            },
--            d = {
--                function()
--                    vim.lsp.buf.definition()
--                end,
--                "Go to definition",
--            },
--            D = {
--                function()
--                    vim.lsp.buf.declaration()
--                end,
--                "Go to declaration",
--            },
--            i = {
--                function()
--                    vim.lsp.buf.implementation()
--                end,
--                "List implementations",
--            },
--            r = {
--                function()
--                    vim.lsp.buf.rename()
--                end,
--                "Rename",
--            },
--            s = {
--                function()
--                    vim.lsp.buf.signature_help()
--                end,
--                "Signature help",
--            },
--            t = {
--                function()
--                    vim.lsp.buf.type_definition()
--                end,
--                "Jump to definition",
--            },
--            L = {
--                function()
--                    function ListActiveLinters()
--                        local linters = require("lint").linters_by_ft[vim.bo.filetype]
--                        if linters then
--                            print("Active linters for filetype '" .. vim.bo.filetype .. "':")
--                            for _, linter in ipairs(linters) do
--                                print(linter)
--                            end
--                        else
--                            print("No active linters for filetype '" .. vim.bo.filetype .. "'.")
--                        end
--                    end
--
--                    ListActiveLinters()
--                end,
--                "Linters list",
--            },
--            b = { "<Cmd>CBcabox<CR>", "Box Title" },
--            T = { "<Cmd>CBllline<CR>", "Titled Line" },
--        },
--        f = {
--            name = "Find",
--            b = { "<cmd>Telescope buffers<cr>", "Buffers" },
--            f = { "<cmd>Telescope find_files<cr>", "Files" },
--            g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
--            h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
--            m = { "<cmd>Telescope man_pages<cr>", "man pages" },
--            n = { "<cmd>Telescope notify<cr>", "Notify messages" },
--            o = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
--            s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find in buffer" },
--            y = { "<cmd>Telescope neoclip<cr>", "Old Yanks" },
--            z = { "<cmd>Telescope spell_suggest<cr>", "Spelling suggestions" },
--        },
--        g = {
--            name = "Git",
--            b = { "<cmd>GitBlameToggle<cr>", "Blame toggle" },
--            c = { "<cmd>Telescope git_commits<cr>", "Shows previous commits" },
--            g = { "<cmd>Neogit<cr>", "Interactive Git" },
--            s = { "<cmd>Telescope git_status<cr>", "Status" },
--        },
--        u = {
--            name = "User Interface",
--            C = { "<cmd>set colorcolumn=80<CR>", "Colorcolumn at 80" },
--            c = { "<cmd>ColorizerToggle<CR>", "Colorize color codes" },
--            h = { "<cmd>set list!<CR>", "Hidden Characters Toggle" },
--            i = { "<cmd>IlluminateToggle<cr>", "Illuminate word highlighting" },
--            l = { "<cmd>set number!<cr>", "Line number toggle" },
--            o = { "<cmd>AerialToggle!<CR>", "Outline" },
--            p = { "<cmd>PickColor<CR>", "Pick Color" },
--            r = { "<cmd>set relativenumber!<cr>", "Relative line number toggle" },
--            t = { "<cmd>ToggleTerm direction=float<cr>", "Terminal toggle" },
--            v = { toggle_virtual_text, "Toggle Virtual Text" },
--            w = { "<cmd>set wrap!<cr>", "Wrap line toggle" },
--        },
--        x = {
--            name = "Trouble",
--            d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document diagnostics (Trouble)" },
--            l = { "<cmd>TroubleToggle loclist<cr>", "Location list(Trouble)" },
--            q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix list(Trouble)" },
--            w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace diagnostics (Trouble)" },
--        },
--    },
-- })

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
-- Launch Telescope main window
vim.keymap.set("n", "<c-t>", ":Telescope<CR>")

-- Setting up register for 'which key' with keymappings
local wk = require("which-key")
wk.register({
    ["<leader>E"] = { "<cmd>Explore<cr>", "Explore" },
    ["<leader>l"] = { "<cmd>Lazy<cr>", "Lazy" },
    ["<leader>m"] = { "<cmd>Mason<cr>", "Mason" },
    ["<leader>o"] = { "<cmd>Oil --float<cr>", "Oil file manager" },
    ["<leader>p"] = { "<cmd>Pounce<cr>", "Pounce" },
    ["<leader>s"] = { [[<cmd> lua require("persistence").load() <cr>]], "Restore last session" },
    ["<leader>t"] = { "<cmd>Telescope<cr>", "Telescope" },
    ["<leader>U"] = { "<cmd>Telescope undo<cr>", "Undo" },

    ["<leader>"] = {
        b = {
            name = "Buffer",
            b = { "<cmd>bprev<CR>", "Previous" },
            e = { "<cmd>Neotree buffers<CR>", "Neotree buffers" },
            l = { "<cmd>ls<CR>", "List" },
        },
        c = {
            name = "Code",
            a = {
                function()
                    vim.lsp.buf.code_action()
                end,
                "Code action",
            },
            d = {
                function()
                    vim.lsp.buf.definition()
                end,
                "Go to definition",
            },
            D = {
                function()
                    vim.lsp.buf.declaration()
                end,
                "Go to declaration",
            },
            i = {
                function()
                    vim.lsp.buf.implementation()
                end,
                "List implementations",
            },
            r = {
                function()
                    vim.lsp.buf.rename()
                end,
                "Rename",
            },
            s = {
                function()
                    vim.lsp.buf.signature_help()
                end,
                "Signature help",
            },
            t = {
                function()
                    vim.lsp.buf.type_definition()
                end,
                "Jump to definition",
            },
            L = {
                function()
                    function ListActiveLinters()
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

                    ListActiveLinters()
                end,
                "Linters list",
            },
            b = { "<Cmd>CBlabox<CR>", "Box Title" },
            T = { "<Cmd>CBllline<CR>", "Titled Line" },
        },
        f = {
            name = "Find",
            b = { "<cmd>Telescope buffers<cr>", "Buffers" },
            f = { "<cmd>Telescope find_files<cr>", "Files" },
            g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
            h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
            m = { "<cmd>Telescope man_pages<cr>", "man pages" },
            n = { "<cmd>Telescope notify<cr>", "Notify messages" },
            o = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
            s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find in buffer" },
            y = { "<cmd>Telescope neoclip<cr>", "Old Yanks" },
            z = { "<cmd>Telescope spell_suggest<cr>", "Spelling suggestions" },
        },
        g = {
            name = "Git",
            b = { "<cmd>GitBlameToggle<cr>", "Blame toggle" },
            c = { "<cmd>Telescope git_commits<cr>", "Shows previous commits" },
            g = { "<cmd>Neogit<cr>", "Interactive Git" },
            s = { "<cmd>Telescope git_status<cr>", "Status" },
        },
        u = {
            name = "User Interface",
            C = { "<cmd>set colorcolumn=80<CR>", "Colorcolumn at 80" },
            c = { "<cmd>ColorizerToggle<CR>", "Colorize color codes" },
            h = { "<cmd>set list!<CR>", "Hidden Characters Toggle" },
            i = { "<cmd>IlluminateToggle<cr>", "Illuminate word highlighting" },
            l = { "<cmd>set number!<cr>", "Line number toggle" },
            o = { "<cmd>AerialToggle!<CR>", "Outline" },
            p = { "<cmd>PickColor<CR>", "Pick Color" },
            r = { "<cmd>set relativenumber!<cr>", "Relative line number toggle" },
            t = { "<cmd>ToggleTerm direction=float<cr>", "Terminal toggle" },
            w = { "<cmd>set wrap!<cr>", "Wrap line toggle" },
        },
        x = {
            name = "Trouble",
            d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document diagnostics (Trouble)" },
            l = { "<cmd>TroubleToggle loclist<cr>", "Location list(Trouble)" },
            q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix list(Trouble)" },
            w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace diagnostics (Trouble)" },
        },
    },
})

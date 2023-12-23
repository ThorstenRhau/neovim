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
    ["<leader>l"] = { "<cmd>Lazy<cr>", "Lazy" },
    ["<leader>t"] = { "<cmd>Telescope<cr>", "Telescope" },
    ["<leader>p"] = { "<cmd>Pounce<cr>", "Pounce" },
    ["<leader>U"] = { "<cmd>Telescope undo<cr>", "Undo" },
    ["<leader>o"] = { "<cmd>Oil --float<cr>", "Oil file manager" },
    ["<leader>s"] = { [[<cmd> lua require("persistence").load() <cr>]], "Restore last session" },

    ["<leader>"] = {
        b = {
            name = "Buffer",

            b = { "<cmd>bprev<CR>", "Previous" },
            l = { "<cmd>ls<CR>", "List" },
        },
        c = {
            name = "Code",
            a = { "<cmd>Lspsaga code_action<CR>", "Action" },
            -- f = { "<cmd>LspZeroFormat timeout=2000<CR>", "Format" },
            g = { "<cmd>Lspsaga goto_definition<CR>", "Go to definition" },
            k = { "<cmd>Lspsaga hover_doc<CR>", "LSP Doc" },
            m = { "<cmd>Mason<cr>", "Mason" },
            o = { "<cmd>SymbolsOutline<CR>", "Outline" },
            r = { "<cmd>Lspsaga rename<CR>", "Rename" },
            t = { "<cmd>Lspsaga term_toggle<CR>", "Terminal" },
        },
        f = {
            name = "Find",
            B = { "<cmd>Telescope file_browser<cr>", "File Browser" },
            b = { "<cmd>Telescope buffers<cr>", "Buffers" },
            f = { "<cmd>Telescope find_files<cr>", "Files" },
            g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
            h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
            m = { "<cmd>Telescope man_pages<cr>", "man pages" },
            o = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
            s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find in buffer" },
            y = { "<cmd>Telescope neoclip<cr>", "Old Yanks" },
            z = { "<cmd>Telescope spell_suggest<cr>", "Spelling suggestions" },
        },
        g = {
            name = "Git",
            A = { "<cmd>Git commit -a --verbose<cr>", "Commit all changes" },
            b = { "<cmd>Git blame<cr>", "Blame" },
            C = { "<cmd>Git commit --verbose %<cr>", "Commit the current file" },
            c = { "<cmd>Telescope git_commits<cr>", "Shows previous commits" },
            d = { "<cmd>Git diff<cr>", "Diff" },
            h = { "<cmd>Git log --all --decorate --oneline --graph<cr>", "History" },
            l = { "<cmd>Git pull<cr>", "Pull" },
            P = { "<cmd>Git push<cr>", "Push" },
            s = { "<cmd>Telescope git_status<cr>", "Status" },
        },
        u = {
            name = "User Interface",
            C = { "<cmd>set colorcolumn=80<CR>", "Colorcolumn at 80" },
            c = { "<cmd>ColorizerToggle<CR>", "Colorize color codes" },
            h = { "<cmd>set list!<CR>", "Hidden Characters Toggle" },
            i = { "<cmd>IlluminateToggle<cr>", "Illuminate word highlighting" },
            l = { "<cmd>loadview<cr>", "Load view" },
            m = { "<cmd>mkview<cr>", "Make (save) view" },
            n = { "<cmd>set number!<cr>", "Line number toggle" },
            p = { "<cmd>PickColor<CR>", "Pick Color" },
            r = { "<cmd>set relativenumber!<cr>", "Relative line number toggle" },
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

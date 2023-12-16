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
    ["<leader>l"] = { "<cmd>Lazy<cr>", "Lazy plugin manager" },
    ["<leader>T"] = { "<cmd>Telescope<cr>", "Telescope search" },
    ["<leader>p"] = { "<cmd>Pounce<cr>", "Pounce!" },
    ["<leader>u"] = { "<cmd>Telescope undo<cr>", "Pounce!" },
    ["<leader>o"] = { "<cmd>Oil --float<cr>", "Oil file manager" },
    ["<leader>"] = {
        c = {
            name = "code",
            a = { "<cmd>Lspsaga code_action<CR>", "Action" },
            c = { "<cmd>ColorizerToggle<CR>", "Colorize color codes" },
            C = { "<cmd>ChatGPTCompleteCodec<CR>", "Complete code with ChatGPT" },
            e = { "<cmd>ChatGPTEditWithInstructions<CR>", "Edit with ChatGPT" },
            f = { "<cmd>LspZeroFormat timeout=2000<CR>", "Format" },
            g = { "<cmd>Lspsaga goto_definition<CR>", "Go to definition" },
            h = { "<cmd>set list!<CR>", "Hidden Characters Toggle" },
            k = { "<cmd>Lspsaga hover_doc<CR>", "LSP Doc" },
            l = { "<cmd>Lspsaga lsp_finder<CR>", "LSP Finder" },
            m = { "<cmd>Mason<cr>", "Mason" },
            o = { "<cmd>SymbolsOutline<CR>", "Outline" },
            p = { "<cmd>PickColor<CR>", "Pick Color" },
            r = { "<cmd>Lspsaga rename<CR>", "Rename" },
            t = { "<cmd>Lspsaga term_toggle<CR>", "Terminal as overlay" },
            w = { "<cmd>set wrap!<CR>", "Wrap text toggle" },
        },
        f = {
            name = "Find",
            B = { "<cmd>Telescope file_browser<cr>", "File Browser" },
            b = { "<cmd>Telescope buffers<cr>", "Buffers" },
            f = { "<cmd>Telescope find_files<cr>", "Files" },
            g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
            h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
            o = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
            s = { "<cmd>Telescope grep_string<cr>", "Grep strings" },
            y = { "<cmd>Telescope neoclip<cr>", "Old Yanks" },
        },
        g = {
            name = "Git",
            C = { "<cmd>Git commit --verbose %<cr>", "commit the current file" },
            A = { "<cmd>Git commit -a --verbose<cr>", "commit all changes" },
            b = { "<cmd>Git blame<cr>", "blame" },
            d = { "<cmd>Git diff<cr>", "Diff" },
            h = { "<cmd>Git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short<cr>", "history" },
            l = { "<cmd>Git log --oneline<cr>", "log" },
            p = { "<cmd>Git pull<cr>", "Pull" },
            s = { "<cmd>Telescope git_status<cr>", "Status" },
        },
        h = {
            name = "ChatGPT",
            c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
            e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
            g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
            t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
            k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
            d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
            a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
            o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
            s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
            f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
            x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
            r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
            l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
        },
        u = {
            name = "User Interface",
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

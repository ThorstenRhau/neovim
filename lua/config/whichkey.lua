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
    -- Switch between open tabs
    ["<leader>1"] = { "1gt<cr>", "Tab 1" },
    ["<leader>2"] = { "2gt<cr>", "Tab 2" },
    ["<leader>3"] = { "3gt<cr>", "Tab 3" },
    ["<leader>"] = {
        c = {
            name = "code",
            u = { "<cmd>Telescope undo<cr>", "undo changes" },
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
        },
    },
})

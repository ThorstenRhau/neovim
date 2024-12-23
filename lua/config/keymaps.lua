local map = vim.keymap.set

-- Better up/down navigation using Lua functions
map({ "n", "x" }, "j", function()
    return vim.v.count == 0 and "gj" or "j"
end, { desc = "Down", expr = true, silent = true })

map({ "n", "x" }, "<Down>", function()
    return vim.v.count == 0 and "gj" or "j"
end, { desc = "Down Arrow", expr = true, silent = true })

map({ "n", "x" }, "k", function()
    return vim.v.count == 0 and "gk" or "k"
end, { desc = "Up", expr = true, silent = true })

map({ "n", "x" }, "<Up>", function()
    return vim.v.count == 0 and "gk" or "k"
end, { desc = "Up Arrow", expr = true, silent = true })

-- Window navigation with non-recursive mappings
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", noremap = true, silent = true })

-- Resize windows with non-recursive mappings
map("n", "<S-Up>", "<cmd>resize +2<CR>", { desc = "Increase Window Height", noremap = true, silent = true })
map("n", "<S-Down>", "<cmd>resize -2<CR>", { desc = "Decrease Window Height", noremap = true, silent = true })
map("n", "<S-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Window Width", noremap = true, silent = true })
map("n", "<S-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Window Width", noremap = true, silent = true })

-- Move Lines with alternative keybindings to avoid conflicts
map("n", "<C-j>", "<cmd>m .+1<CR>==", { desc = "Move Line Down", noremap = true, silent = true })
map("n", "<C-k>", "<cmd>m .-2<CR>==", { desc = "Move Line Up", noremap = true, silent = true })
map("i", "<C-j>", "<C-o>:m .+1<CR>==", { desc = "Move Line Down in Insert Mode", noremap = true, silent = true })
map("i", "<C-k>", "<C-o>:m .-2<CR>==", { desc = "Move Line Up in Insert Mode", noremap = true, silent = true })
map("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down", noremap = true, silent = true })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up", noremap = true, silent = true })

-- Clear search highlights with a dedicated key
map({ "n", "i" }, "<Leader>c", "<cmd>noh<CR>", { desc = "Clear Search Highlights", noremap = true, silent = true })

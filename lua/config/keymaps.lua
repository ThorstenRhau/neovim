local map = vim.keymap.set

-- Smarter vertical navigation for wrapped lines
local function smart_motion(key, direction)
    map({ "n", "x" }, key, function()
        return vim.v.count == 0 and direction or key
    end, { desc = direction == "gj" and "Down" or "Up", expr = true, silent = true })
end

smart_motion("j", "gj")
smart_motion("k", "gk")
smart_motion("<Down>", "gj")
smart_motion("<Up>", "gk")

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", noremap = true, silent = true, nowait = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", noremap = true, silent = true, nowait = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", noremap = true, silent = true, nowait = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", noremap = true, silent = true, nowait = true })

-- Resize windows
map("n", "<S-Up>", "<cmd>resize +2<CR>", { desc = "Increase Window Height", noremap = true, silent = true })
map("n", "<S-Down>", "<cmd>resize -2<CR>", { desc = "Decrease Window Height", noremap = true, silent = true })
map("n", "<S-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Window Width", noremap = true, silent = true })
map("n", "<S-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Window Width", noremap = true, silent = true })

-- Clear search highlights (Normal mode only)
map("n", "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear hlsearch", silent = true })

-- Optional: Buffer navigation
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer", silent = true })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer", silent = true })

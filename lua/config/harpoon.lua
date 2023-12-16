local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function()
    harpoon:list():append()
end)
vim.keymap.set("n", "<C-e>", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<a-1>", function()
    harpoon:list():select(1)
end)
vim.keymap.set("n", "<a-2>", function()
    harpoon:list():select(2)
end)
vim.keymap.set("n", "<a-3>", function()
    harpoon:list():select(3)
end)
vim.keymap.set("n", "<a-4>", function()
    harpoon:list():select(4)
end)

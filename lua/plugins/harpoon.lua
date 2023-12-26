return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        lazy = false,
        config = function()
            local harpoon = require("harpoon")
            ---@diagnostic disable-next-line: missing-parameter
            harpoon:setup()
            local function map(lhs, rhs, opts)
                vim.keymap.set("n", lhs, rhs, opts or {})
            end
            map("<leader>hh", function()
                harpoon:list():append()
            end, { desc = "Harpoon current file" })
            map("<leader>hm", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Harpoon menu" })
            map("<leader>h1", function()
                harpoon:list():select(1)
            end, { desc = "File 1" })
            map("<leader>h2", function()
                harpoon:list():select(2)
            end, { desc = "File 2" })
            map("<leader>h3", function()
                harpoon:list():select(3)
            end, { desc = "File 3" })
            map("<leader>h4", function()
                harpoon:list():select(4)
            end, { desc = "File 4" })
        end,
    },
}

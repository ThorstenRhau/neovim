return {
    "kdheepak/lazygit.nvim",
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>gl", "<cmd>:LazyGit<cr>", desc = "LazyGit" },
    },
    config = function()
        -- Keymap to open Lazygit in a new buffer
        vim.keymap.set("n", "<leader>gl", function()
            vim.cmd("enew") -- Open a new buffer
            vim.fn.termopen("LazyGit") -- Launch Lazygit in the terminal
            vim.cmd("startinsert") -- Enter insert mode for interaction
        end, { desc = "LazyGit in New Buffer" })
    end,
}

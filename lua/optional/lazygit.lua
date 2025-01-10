return {
    "kdheepak/lazygit.nvim",
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- Optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>gl", "<cmd>:LazyGit<cr>", desc = "LazyGit" },
    },
}

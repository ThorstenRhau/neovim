return {
    "ibhagwan/fzf-lua",
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    dependencies = {
        "echasnovski/mini.icons",
        "MeanderingProgrammer/render-markdown.nvim",
        "nvim-treesitter/nvim-treesitter-context",
    },
    cmd = { "FzfLua" },
    config = function()
        require("fzf-lua").setup({})
    end,
}

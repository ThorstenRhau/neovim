return {
    "MeanderingProgrammer/render-markdown.nvim",
    cmd = "RenderMarkdown",
    ft = { "markdown", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    opts = {
        enabled = true,
        latex = { enabled = false },
    },
}

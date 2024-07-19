return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    keys = {
        {
            "<leader>uM",
            "<cmd>MarkdownPreviewToggle<cr>",
            desc = "Markdown preview",
        },
    },
}

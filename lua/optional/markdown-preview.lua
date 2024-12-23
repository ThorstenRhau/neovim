return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
        if vim.fn.executable("npx") then
            vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
        else
            vim.cmd([[Lazy load markdown-preview.nvim]])
            vim.fn["mkdp#util#install"]()
        end
    end,
    keys = {
        {
            "<leader>uM",
            "<cmd>MarkdownPreviewToggle<cr>",
            desc = "Markdown preview",
        },
    },
}

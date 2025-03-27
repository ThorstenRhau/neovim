---@module "lazy"
---@type LazySpec
return {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    keys = {
        {
            "<leader>uM",
            "<cmd>MarkdownPreviewToggle<cr>",
            desc = "Markdown preview",
        },
    },
    build = function(plugin)
        local install_cmd = { "npx", "--yes", "yarn", "install" }
        local app_dir = plugin.dir .. "/app"

        if vim.fn.executable("npx") == 1 then
            vim.system(install_cmd, { cwd = app_dir }, function(res)
                if res.code ~= 0 then
                    vim.notify("markdown-preview.nvim: yarn install failed", vim.log.levels.ERROR)
                end
            end)
        else
            vim.fn["mkdp#util#install"]()
        end
    end,
}

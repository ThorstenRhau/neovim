return {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
        symbol = "│",
        options = { try_as_border = true },
    },
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "help",
                "alpha",
                "neo-tree",
                "trouble",
                "lazy",
                "mason",
                "checkhealth",
            },
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        })
    end,
}

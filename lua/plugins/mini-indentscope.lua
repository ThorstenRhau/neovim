return {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
        symbol = "│",
        options = { try_as_border = true },
        draw = {
            delay = 200, -- 200 ms delay before drawing line
            priority = 2,
        },
    },
    init = function()
        vim.api.nvim_create_autocmd({ "FileType" }, {
            desc = "Disable indentscope for certain filetypes",
            callback = function()
                local ignore_filetypes = {
                    "aerial",
                    "help",
                    "lazy",
                    "leetcode.nvim",
                    "man",
                    "mason",
                    "neo-tree",
                    "neogitstatus",
                    "notify",
                    "toggleterm",
                    "Trouble",
                }
                if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
                    local bufnr = vim.api.nvim_get_current_buf()
                    vim.b[bufnr].miniindentscope_disable = true
                end
            end,
        })
    end,
}

return {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        symbol = "│",
        options = { try_as_border = true },
        draw = {
            delay = 100, -- 100 ms delay before drawing line
            priority = 2,
            animation = function()
                return 0
            end, -- Disable animation by setting immediate duration
        },
    },
    init = function()
        vim.api.nvim_create_autocmd({ "FileType" }, {
            desc = "Disable indentscope for certain filetypes",
            callback = function()
                local ignore_filetypes = {
                    "aerial",
                    "checkhealth",
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

---@module "lazy"
---@type LazySpec
return {
    "mfussenegger/nvim-lint",
    ft = {
        "javascript",
        "json",
        "lua",
        "python",
        "sh",
        "typescript",
        "yaml",
    },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            javascript = { "eslint_d" },
            json = { "jsonlint" },
            lua = { "selene" },
            python = { "ruff" },
            sh = { "shellcheck" },
            typescript = { "eslint_d" },
            yaml = { "yamllint" },
        }

        local custom_config = vim.fn.getcwd() .. "/.nvim-lint.lua"
        if vim.fn.filereadable(custom_config) == 1 then
            dofile(custom_config)
        end

        local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

        vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
            group = lint_augroup,
            callback = function()
                if vim.bo.modified then
                    lint.try_lint()
                end
            end,
        })

        vim.keymap.set("n", "<leader>cl", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}

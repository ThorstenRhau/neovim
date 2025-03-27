---@module "lazy"
---@type LazySpec
return {
    "mfussenegger/nvim-lint",
    event = "LspAttach",
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            javascript = { "eslint_d" },
            json = { "jsonlint" },
            lua = { "selene" }, -- Installed via Homebrew
            python = { "ruff" },
            sh = { "shellcheck" },
            typescript = { "eslint_d" },
            yaml = { "yamllint" },
        }

        local config = vim.fn.getcwd() .. "/.nvim-lint.lua"
        if vim.fn.filereadable(config) == 1 then
            dofile(config)
        end

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>cl", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}

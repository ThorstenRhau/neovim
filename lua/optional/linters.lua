local vim = vim
---@module "lazy"
---@type LazySpec
return {
    "mfussenegger/nvim-lint",
    event = { "LspAttach" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            javascript = { "eslint_d" },
            json = { "jsonlint" },
            lua = { "selene" }, -- Install 'selene' via homebrew instead of Mason
            python = { "ruff" },
            sh = { "shellcheck" },
            typescript = { "eslint_d" },
            yaml = { "yamllint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
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

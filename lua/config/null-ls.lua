local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.taplo,
    },
})

---@module "lazy"
---@type LazySpec
return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    cmd = {
        "MasonToolsInstall",
        "MasonToolsUpdate",
        "MasonToolsClean",
    },
    opts = {
        auto_update = true,
        ensure_installed = {
            "bashls",
            "eslint_d",
            "fish-lsp",
            "harper_ls",
            "html",
            "jsonlint",
            "jsonls",
            "lemminx",
            "lua_ls",
            "markdownlint",
            "marksman",
            "prettier",
            "pyright",
            "ruff",
            "shellcheck",
            "shfmt",
            "stylua",
            "taplo",
            "ts_ls",
            "xmlformatter",
            "yamlfmt",
            "yamllint",
            "yamlls",
        },
    },
}

return {
    "L3MON4D3/LuaSnip",
    enabled = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v2.*",
    build = "make install_jsregexp",
    event = "InsertEnter",
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })
        require("luasnip.loaders.from_vscode").lazy_load()
    end,
}

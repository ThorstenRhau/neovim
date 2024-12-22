return {
    "svampkorg/moody.nvim",
    event = { "ModeChanged", "BufWinEnter", "WinEnter" },
    dependencies = "folke/tokyonight.nvim",
    opts = {
        disabled_filetypes = { "TelescopePrompt" },
        disabled_buftypes = {},
        bold_nr = true,
        extend_to_linenr = true,
        extend_to_linenr_visual = false,
    },
}

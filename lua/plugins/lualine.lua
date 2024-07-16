local function show_macro_recording()
    local recording_register = vim.fn.reg_recording()
    if recording_register == "" then
        return ""
    else
        return "Recording @" .. recording_register
    end
end
return {
    {
        "nvim-lualine/lualine.nvim",
        enabled = true,
        event = "VeryLazy",
        dependencies = {
            "echasnovski/mini.icons",
        },
        opts = {
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    "alpha",
                    "intro",
                    statusline = {},
                    winbar = {},
                },
            },
            sections = {
                lualine_a = { "mode", show_macro_recording },
                lualine_b = { "branch", { "diff", colored = false }, "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype", "filesize" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            extensions = {
                "fugitive",
                "fzf",
                "lazy",
                "man",
                "mason",
                "quickfix",
                "symbols-outline",
                "trouble",
            },
        },
    },
}

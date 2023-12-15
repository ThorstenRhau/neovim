return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {
                component_separators = "|",
            },
            sections = {
                lualine_a = { "mode" },
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
            --  tabline = {
            --      lualine_a = {
            --          {
            --              "buffers",
            --              right_padding = 2,
            --              symbols = { alternate_file = "" },
            --          },
            --      },
            --  },
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

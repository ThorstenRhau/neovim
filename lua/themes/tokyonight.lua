return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        style = "night",
        light_style = "day",
        transparent = false,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = { italic = true, bold = true },
            variables = { bold = true },
            constants = { bold = true },
            types = { bold = true },
            -- Background styles. Can be "dark", "transparent" or "normal"
            sidebars = "normal",
            floats = "normal",
        },
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        dim_inactive = true, -- dims inactive windows
        lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
        cache = true,
        plugins = {
            -- enable all plugins when not using lazy.nvim
            -- set to false to manually enable/disable plugins
            all = package.loaded.lazy == nil,
            -- uses your plugin manager to automatically enable needed plugins
            -- currently only lazy.nvim is supported
            auto = true,
            -- add any plugins here that you want to enable
            -- for all possible plugins, see:
            --   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
            -- telescope = true,
        },
    },
}

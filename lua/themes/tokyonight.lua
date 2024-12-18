return {
    "folke/tokyonight.nvim",
    lazy = false, -- Load immediately (not lazily)
    priority = 1100, -- Highest priority to load first
    config = function()
        -- Function to determine the preferred theme based on macOS light/dark mode
        local function getPreferredStyle()
            local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
            if not handle then
                return "day" -- Default to light style if detection fails
            end

            local result = handle:read("*a")
            handle:close()

            if result and result:match("Dark") then
                return "night" -- Dark style
            else
                return "day" -- Light style
            end
        end

        -- Apply the preferred style
        local preferred_style = getPreferredStyle()

        require("tokyonight").setup({
            style = preferred_style,
            light_style = "day",
            transparent = false,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                functions = { italic = true, bold = true },
                variables = { bold = true },
                constants = { bold = true },
                types = { bold = true },
                -- Background styles: "dark", "transparent", or "normal"
                sidebars = "normal",
                floats = "normal",
            },
            day_brightness = 0.3, -- Adjusts brightness for the day style (0 to 1)
            dim_inactive = true, -- Dims inactive windows
            lualine_bold = true, -- Bold section headers in lualine theme
            cache = true,
            plugins = {
                all = package.loaded.lazy == nil, -- Enable all plugins if not using lazy.nvim
                auto = true, -- Automatically enable needed plugins for lazy.nvim
            },
        })

        -- Apply the colorscheme
        vim.cmd.colorscheme("tokyonight")
    end,
}

return {
    "folke/tokyonight.nvim",
    lazy = false, -- Load immediately (not lazily)
    priority = 1100, -- Highest priority to load first
    config = function()
        -- Function to determine the preferred theme based on macOS light/dark mode
        local function getPreferredStyle()
            -- Execute the command without redirecting stderr
            local result = vim.fn.system("defaults read -g AppleInterfaceStyle")
            -- Check if the command was successful
            if vim.v.shell_error ~= 0 then
                return "night" -- Default to dark style if detection fails
            end

            -- Trim any trailing whitespace or newline characters
            result = result:match("^%s*(.-)%s*$")

            if result == "Dark" then
                return "night" -- Dark style, alternatives are: storm, moon, and night
            else
                return "day" -- Light style
            end
        end

        -- Apply the preferred style
        local preferred_style = getPreferredStyle()

        require("tokyonight").setup({
            style = preferred_style,
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
                auto = true, -- Automatically enable needed plugins for lazy.nvim
            },
        })

        -- Apply the colorscheme
        vim.cmd.colorscheme("tokyonight")
    end,
}

-- Function to determine the preferred theme based on macOS light/dark mode
local function getPreferredStyle()
    if vim.fn.executable("defaults") == 0 then
        -- Fallback to "Dark" style if `defaults` is not available
        return "night" -- Dark style
    end

    local result = vim.fn.system("defaults read -g AppleInterfaceStyle")

    -- Trim any trailing whitespace or newline characters
    result = result:match("^%s*(.-)%s*$")

    if result == "Dark" then
        return "night" -- Dark style, alternatives are: storm, moon, and night
    else
        return "day" -- Light style
    end
end

local preferred_style = getPreferredStyle()

return {
    "folke/tokyonight.nvim",
    lazy = false, -- Load immediately (not lazily)
    priority = 1100, -- Highest priority to load first
    opts = {
        style = preferred_style,
        transparent = false,
        styles = {
            comments = { italic = true },
            keywords = { bold = true },
            functions = {},
            variables = {},
            types = { bold = true },
            -- Background styles: "dark", "transparent", or "normal"
            sidebars = "dark",
            floats = "dark",
        },
        day_brightness = 0.3, -- Adjusts brightness for the day style (0 to 1)
        dim_inactive = true, -- Dims inactive windows
        lualine_bold = true, -- Bold section headers in lualine theme
        cache = true,
        plugins = {
            auto = true, -- Automatically enable needed plugins for lazy.nvim
        },
    },
}

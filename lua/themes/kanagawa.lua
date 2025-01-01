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
        return "wave" -- Dark style, alternatives are: storm, moon, and night
    else
        return "lotus" -- Light style
    end
end

local preferred_style = getPreferredStyle()

return {
    "rebelot/kanagawa.nvim",
    priority = 1100,
    lazy = false,
    opts = {
        theme = preferred_style,
        compile = true, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = true, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
    },
}

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
        return "mocha" -- Dark style, alternatives are: storm, moon, and night
    else
        return "latte" -- Light style
    end
end

local preferred_style = getPreferredStyle()

---@module "lazy"
---@type LazySpec
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1100,
        lazy = false,
        opts = {
            flavour = preferred_style, -- latte, frappe, macchiato, mocha
            transparent_background = false,
            show_end_of_buffer = false,
            term_colors = true,
            dim_inactive = {
                enabled = true,
                shade = "dark",
                percentage = 0.10,
            },
            no_italic = false,
            no_bold = false,
            no_underline = false,
            styles = {
                comments = { "italic" },
                conditionals = {},
                loops = {},
                constants = { "bold" },
                functions = { "bold, italic" },
                keywords = { "italic" },
                strings = {},
                variables = { "bold" },
                numbers = {},
                booleans = {},
                properties = {},
                types = { "bold" },
                operators = {},
            },
            integrations = {
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "underdotted" },
                        warnings = { "underline" },
                        information = { "underdashed" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
                illuminate = {
                    enabled = true,
                    lsp = false,
                },
                blink_cmp = true,
                diffview = true,
                fzf = true,
                lsp_trouble = true,
                mason = true,
                neogit = true,
                noice = true,
                pounce = true,
                render_markdown = true,
                semantic_tokens = true,
                snacks = true,
                treesitter = true,
                treesitter_context = true,
                which_key = true,
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        },
    },
}

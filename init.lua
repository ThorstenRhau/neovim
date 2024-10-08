local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true
-- Disabling netrw so that 'oil' can take it's place
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lazy").setup({
    spec = {
        { import = "plugins" },
        { import = "themes" },
    },
    defaults = {
        lazy = true,
    },
    install = { colorscheme = { "catppuccin", "default" } },
    checker = {
        enabled = true,
        notify = true,
        frequency = 604800, -- Check for updates every week
    },
    ui = {
        size = { width = 0.9, height = 0.9 },
        border = "rounded",
    },
    rtp = {
        reset = true,
        ---@type string[]
        paths = {},
        ---@type string[]
        disabled_plugins = {
            "netrwPlugin",
            "tohtml",
            "tutor",
            "gzip",
            "rplugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
        },
    },
    rocks = {
        hererocks = false,
        enabled = false,
    },
})

require("config.options")
require("config.whichkey")
require("config.autocmd")
require("config.keymaps")

require("config.intro")
require("config.gp-keys")

-- Check macOS light / dark user interface state and return theme accordingly
local function getPreferredTheme()
    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    if not handle then
        return "habamax"
    end

    local result = handle:read("*a")
    handle:close()

    if result and result:match("Dark") then
        return "catppuccin-macchiato" -- Dark theme
    else
        return "catppuccin-latte" -- Light theme
    end
end

-- Apply the preferred theme
local preferred_theme = getPreferredTheme()
if preferred_theme then
    vim.cmd.colorscheme(preferred_theme)
else
    vim.cmd.colorscheme("default")
end

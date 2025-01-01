-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Basic Neovim Settings
vim.g.mapleader = " "
vim.g.maplocalleader = "'"
vim.opt.termguicolors = true

-- Disable netrw for 'oil' plugin
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Define the plugin specifications
local specs = {
    { import = "themes" },
    { import = "plugins" },
}
-- Check if optional plugins should be enabled
local enable_optional_plugins = os.getenv("NVIM_OPTIONAL_PLUGINS")

-- Conditionally add optional plugins
if enable_optional_plugins then
    table.insert(specs, { import = "optional" })
end

-- Setup lazy.nvim
require("lazy").setup({
    spec = specs,
    defaults = {
        lazy = true, -- Set global lazy loading
    },
    install = {
        missing = true,
        colorscheme = { "habamax" },
    },
    checker = {
        enabled = true,
        notify = true,
        frequency = 604800, -- Check for updates every week
    },
    ui = {
        size = { width = 0.9, height = 0.9 },
        border = "rounded",
    },
    diff = {
        cmd = "diffview.nvim",
    },
    rtp = {
        reset = true,
        paths = {},
        disabled_plugins = {
            "gzip",
            "matchit",
            "netrwPlugin",
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

-- Load Configuration Modules After lazy.nvim
if enable_optional_plugins then
    require("config.whichkey")
end
require("config.options")
require("config.autocmd")
require("config.keymaps")

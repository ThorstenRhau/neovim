-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { import = "themes" },
        { import = "plugins" },
    },
    defaults = {
        lazy = true, -- Set global lazy loading
    },
    install = {
        colorscheme = { "tokyonight", "habamax" },
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
    rtp = {
        reset = true,
        paths = {},
        disabled_plugins = {
            "netrwPlugin",
            "tohtml",
            "tutor",
            "gzip",
            "rplugin",
            "tarPlugin",
            "zipPlugin",
        },
    },
    rocks = {
        hererocks = false,
        enabled = false,
    },
})

-- Load Configuration Modules After lazy.nvim
require("config.options")
require("config.whichkey")
require("config.autocmd")
require("config.keymaps")

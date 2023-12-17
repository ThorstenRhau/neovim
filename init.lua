local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

require("lazy").setup({
    spec = {
        { import = "plugins" },
        { import = "themes" },
    },
    defaults = {
        lazy = true,
        version = false,
    },
    install = { colorscheme = { "catppuccin", "habamax" } },
    checker = {
        enabled = true,
        notify = true,
        frequency = 3600, -- Check for updates every hour
    },
    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true, -- reset the package path to improve startup time
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    ui = {
        size = { width = 0.9, height = 0.9 },
        border = "rounded",
    },
})

require("config.options")
require("config.whichkey")
require("config.autocmd")

require("config.intro")
require("config.my-status-line")
require("config.null-ls")

-- vim.cmd.colorscheme("habamax")
local function getPreferredTheme()
    local interfaceHandleStyle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    if not interfaceHandleStyle then
        return "habamax"
    end

    local result = interfaceHandleStyle:read("*a")
    interfaceHandleStyle:close()

    if result and string.find(result, "Dark") then
        return "catppuccin-macchiato" -- Dark theme
    else
        return "catppuccin-latte"     -- Light theme
    end
end

vim.cmd.colorscheme(getPreferredTheme())

-- Utility function to create auto groups
local function augroup(name)
    return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end

-- Function to close or quit Neovim
local function close_or_quit()
    local win_count = #vim.api.nvim_list_wins()

    if win_count == 1 then
        if #vim.api.nvim_list_bufs() > 1 then
            vim.notify("Cannot close the last window without quitting Neovim.", vim.log.levels.WARN)
        else
            vim.api.nvim_command("quit")
        end
    else
        pcall(vim.api.nvim_command, "close")
    end
end

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
    group = augroup("insert_mode"),
    pattern = "*",
    callback = function()
        vim.o.paste = false
    end,
})

-- Remove 'c', 'r', 'o' from formatoptions for all file types
-- No help with comments
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("remove_formatoptions_cro"),
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Markdown settings: textwidth, colorcolumn, wrap, spell
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("markdown_settings"),
    pattern = "markdown",
    callback = function()
        vim.bo.textwidth = 80
        -- vim.wo.colorcolumn = "80"
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Close specific file types with 'q' key
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "checkhealth",
        "git",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "snacks_dashboard",
        "spectre_panel",
        "startuptime",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", close_or_quit, {
            buffer = event.buf,
            silent = true,
            noremap = true,
            desc = "Close window",
        })
    end,
})

-- Resize splits when the window is resized
vim.api.nvim_create_autocmd("VimResized", {
    group = augroup("resize_splits"),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Check if we need to reload the file when it changes
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    callback = function()
        vim.cmd.checktime()
    end,
})

-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Git commit message settings
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("commit_message_settings"),
    pattern = "gitcommit",
    callback = function()
        vim.bo.textwidth = 72
        vim.wo.colorcolumn = "50,73"
        vim.schedule(function()
            vim.wo.spell = true
            vim.wo.wrap = true
        end)
    end,
})

-- Open Oil file manager if Neovim is opened with a directory argument
vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("open_oil_on_dir"),
    callback = function()
        -- Check if the last argument is a directory
        local arg = vim.fn.argv(0)
        if arg and vim.fn.isdirectory(arg) == 1 then
            vim.cmd.Oil(arg)
        end
    end,
})

-- Automatically jump to last position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("auto-last-position"),
    callback = function(args)
        local position = vim.api.nvim_buf_get_mark(args.buf, [["]])
        local winid = vim.fn.bufwinid(args.buf)
        pcall(vim.api.nvim_win_set_cursor, winid, position)
    end,
    desc = "Auto jump to last position",
})

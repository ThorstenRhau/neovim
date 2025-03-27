-- Utility function to create auto groups
local function augroup(name)
    return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end

-- Function to close or quit Neovim
local function close_or_quit()
    local win_count = #vim.api.nvim_list_wins()
    local listed_bufs = vim.fn.getbufinfo({ buflisted = 1 })

    if win_count == 1 and #listed_bufs <= 1 then
        vim.cmd("qall!")
    elseif win_count == 1 then
        vim.notify("Cannot close the last window without quitting Neovim.", vim.log.levels.WARN)
    else
        pcall(vim.api.nvim_command, "close")
    end
end

-- Remove 'c', 'r', 'o' from formatoptions for all file types
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("formatoptions"),
    pattern = "*",
    desc = "Remove auto-comment formatoptions",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Markdown-specific settings
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("markdown"),
    pattern = "markdown",
    desc = "Set markdown textwidth/wrap/spell",
    callback = function()
        vim.bo.textwidth = 80
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Git commit message settings
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("gitcommit"),
    pattern = "gitcommit",
    desc = "Set gitcommit formatting",
    callback = function()
        vim.bo.textwidth = 72
        vim.wo.colorcolumn = "50,73"
        vim.schedule(function()
            vim.wo.spell = true
            vim.wo.wrap = true
        end)
    end,
})

-- Close with 'q' in special buffers
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("q_close"),
    pattern = {
        "checkhealth", "git", "help", "lspinfo", "man",
        "notify", "qf", "snacks_dashboard", "spectre_panel", "startuptime",
    },
    desc = "Map 'q' to close for helper filetypes",
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

-- Resize splits on window resize
vim.api.nvim_create_autocmd("VimResized", {
    group = augroup("resize"),
    desc = "Auto resize splits",
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Reload file if changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    desc = "Check for file changes",
    callback = function()
        vim.defer_fn(function()
            vim.cmd.checktime()
        end, 50)
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    desc = "Highlight yanked text",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Restore last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("restore_cursor"),
    desc = "Jump to last known position",
    callback = function(args)
        local pos = vim.api.nvim_buf_get_mark(args.buf, [["]])
        local winid = vim.fn.bufwinid(args.buf)
        local line = math.min(pos[1], vim.api.nvim_buf_line_count(args.buf))
        pcall(vim.api.nvim_win_set_cursor, winid, { line, pos[2] })
    end,
})

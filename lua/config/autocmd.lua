local function augroup(name)
    return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    command = "set nopaste",
})

-- Format options ,no help with comments :-)
vim.cmd([[ autocmd FileType * set formatoptions-=cro ]])

-- Setting textwidth to 80 for markdown
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.bo.textwidth = 80
        vim.wo.colorcolumn = "80"
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "Git",
        "PlenaryTestPopup",
        "checkhealth",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", function()
            Close_or_quit()
        end, { buffer = event.buf, silent = true })
    end,
})

function Close_or_quit()
    local win_count = #vim.api.nvim_list_wins()

    -- If there's only one window, try quitting Neovim
    if win_count == 1 then
        if #vim.api.nvim_list_bufs() > 1 then
            vim.notify("Cannot close the last window without quitting Neovim.", vim.log.levels.WARN)
        else
            vim.cmd.quit()
        end
    else
        -- Safely close the current window
        pcall(vim.cmd.close) -- Use pcall to prevent errors if `close` fails
    end
end

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Markdown
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("markdown_warp_spell"),
    pattern = { "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("commit_message_settings"),
    pattern = { "gitcommit" },
    callback = function()
        vim.bo.textwidth = 72 -- Set text width for wrapping
        vim.wo.colorcolumn = "50,73" -- Visual guide for 50/72 rule
        vim.schedule(function() -- Schedule to avoid race conditions
            vim.wo.spell = true -- Enable spell checking
            vim.wo.wrap = true -- Enable line wrapping
        end)
    end,
})

-- If neovim is opened with a directory as argument open oil-filemanager
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local first_arg = vim.v.argv[3]
        if first_arg and vim.fn.isdirectory(first_arg) == 1 then
            vim.cmd.Oil(first_arg)
        end
    end,
})

-- Expand 'cc' into 'CodeCompanion' in the command line
-- vim.cmd([[cab cc CodeCompanion]])

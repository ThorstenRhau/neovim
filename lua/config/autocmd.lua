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

-- Setting textwidth to 72 for git commit messages
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.textwidth = 72
        vim.opt_local.colorcolumn = "72"
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
        "Git",
        "checkhealth",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

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

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

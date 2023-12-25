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
    pattern = { "gitcommit", "NeogitCommitMessage" },
    callback = function()
        vim.opt_local.textwidth = 72
        vim.opt_local.colorcolumn = "72"
    end,
})

-- Setting textwidth to 80 for markdown
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.textwidth = 80
        vim.opt_local.colorcolumn = "80"
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

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Sort visual block
-- Function to sort the lines in a visually selected block
local function sort_visual_block()
    -- Get the start and end of the visual selection
    local start_line, _, end_line, _ = unpack(vim.fn.getpos("'<"), 2, 5), unpack(vim.fn.getpos("'>"), 2, 5)

    -- Adjust for zero-based indexing
    start_line = start_line - 1
    end_line = end_line - 1

    -- Get the lines in the range
    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)

    -- Sort the lines
    table.sort(lines)

    -- Replace the lines in the buffer
    vim.api.nvim_buf_set_lines(0, start_line, end_line + 1, false, lines)
end

-- Map the function to a command for easy use
vim.api.nvim_create_user_command("SortVisualBlock", sort_visual_block, { range = true })

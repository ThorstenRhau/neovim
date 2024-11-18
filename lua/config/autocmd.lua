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
        vim.keymap.set("n", "q", "<cmd>lua Close_or_quit()<cr>", { buffer = event.buf, silent = true })
    end,
})

function Close_or_quit()
    local win_count = #vim.api.nvim_list_wins()
    if win_count == 1 and #vim.api.nvim_list_bufs() == 1 then
        vim.cmd.quit()
    else
        vim.cmd.close()
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

-- Wrap text and check spelling
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Override neogit default settings
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("neogit_spell_override"),
    pattern = "NeogitCommitMessage",
    callback = function()
        vim.schedule(function()
            vim.wo.spell = true
            vim.wo.wrap = true
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

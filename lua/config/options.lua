local opt = vim.opt

opt.mouse = "nv"
opt.clipboard = ""
opt.cursorline = true
opt.autoread = true
opt.cmdheight = 1
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.number = false
opt.relativenumber = false
opt.scrolloff = 8
opt.winbar = "%=%m\\ %f"
opt.ignorecase = true
opt.smartcase = true
opt.winblend = 0
opt.wildoptions = "pum"
opt.pumblend = 0
opt.title = true
opt.autoindent = true
opt.smartindent = true
opt.hlsearch = true
opt.incsearch = true
opt.showcmd = true
opt.laststatus = 2
opt.inccommand = "split"
opt.smarttab = true
opt.breakindent = true
opt.linebreak = true
opt.wrap = false
opt.backspace = { "start", "eol", "indent" }
opt.path:append({ "**" })
opt.wildignore:append({ "*/node_modules/*" })
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.signcolumn = "yes:1"
opt.cmdheight = 0
opt.cmdwinheight = 10

-- Add asterisks in block comments
opt.formatoptions:append({ "r" })

-- use spaces for tabs and whatnot
opt.tabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true

opt.listchars = {
    -- Definíng symbols for hidden characters
    --eol = "↴",
    eol = "⏎",
    tab = ">-",
    space = "⋅",
}

-- Disable yank/copy for 'x'
vim.api.nvim_set_keymap("n", "x", '"_x', { noremap = true })

-- Disable Python 3 provider
vim.g.loaded_python3_provider = 1

-- Disabling some providers that I do not use
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Setting up undo
opt.swapfile = false
opt.backup = false
---@diagnostic disable-next-line: assign-type-mismatch
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- Setting global variable for lspzero borders
vim.g.lsp_zero_ui_float_border = "rounded"

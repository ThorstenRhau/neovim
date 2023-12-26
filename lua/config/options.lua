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
opt.hlsearch = false
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
vim.opt.formatoptions:append({ "r" })

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

-- Setting up providers
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"

-- Disabling some providers that I do not use
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Setting up undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

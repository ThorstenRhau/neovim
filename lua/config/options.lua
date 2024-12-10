local opt = vim.opt
local o = vim.o

o.autoindent = true
o.autoread = true
o.breakindent = true
o.clipboard = ""
o.cmdheight = 0
o.cmdheight = 1
o.cmdwinheight = 10
o.cursorline = true
o.foldenable = false
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = "expr"
o.hlsearch = true
o.ignorecase = true
o.inccommand = "split"
o.incsearch = true
o.laststatus = 2
o.linebreak = true
o.maxmempattern = 5000
o.mouse = "nv"
o.number = true
o.pumblend = 0
o.relativenumber = true
o.scrolloff = 8
o.shell = "/opt/homebrew/bin/fish"
o.showcmd = true
o.signcolumn = "yes:1"
o.smartcase = true
o.smartindent = true
o.smarttab = true
o.smoothscroll = true
o.splitbelow = true
o.synmaxcol = 200
o.tabline = nil
o.title = true
o.ttyfast = true
o.updatetime = 250
o.wildmenu = true
o.wildmode = "longest:full,full"
o.wildoptions = "pum"
o.winbar = "%=%m\\ %f"
o.winbar = nil
o.winblend = 0
o.wrap = false
opt.backspace = { "start", "eol", "indent" }
opt.path:append({ "**" })
opt.spelllang = { "en", "sv" }
opt.wildignore:append({ "*/node_modules/*" })
if vim.fn.executable("rg") == 1 then
    o.grepprg = "rg --vimgrep --smart-case --follow"
end
-- Add asterisks in block comments
opt.formatoptions:append({ "r" })

-- use spaces for tabs and whatnot
o.tabstop = 4
o.shiftwidth = 4
o.shiftround = true
o.expandtab = true

opt.listchars = {
    -- Definíng symbols for hidden characters
    --eol = "↴",
    eol = "⏎",
    tab = ">-",
    space = "⋅",
}

-- Disable yank/copy for 'x'
vim.api.nvim_set_keymap("n", "x", '"_x', { noremap = true })

-- Language providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0

-- Setting up undo
opt.swapfile = false
opt.backup = false
---@diagnostic disable-next-line: assign-type-mismatch
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true
o.undolevels = 10000

-- Setting global variable for lspzero borders
vim.g.lsp_zero_ui_float_border = "rounded"

local opt = vim.opt
local o = vim.o

o.mouse = "nv"
o.clipboard = ""
o.cursorline = true
o.autoread = true
o.cmdheight = 1
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldenable = false
o.number = false
o.relativenumber = false
o.scrolloff = 8
o.winbar = "%=%m\\ %f"
o.ignorecase = true
o.smartcase = true
o.winblend = 0
o.wildoptions = "pum"
o.pumblend = 0
o.title = true
o.autoindent = true
o.smartindent = true
o.hlsearch = true
o.incsearch = true
o.showcmd = true
o.laststatus = 2
o.inccommand = "split"
o.smarttab = true
o.breakindent = true
o.linebreak = true
o.wrap = false
opt.backspace = { "start", "eol", "indent" }
opt.path:append({ "**" })
opt.wildignore:append({ "*/node_modules/*" })
o.wildmenu = true
o.wildmode = "longest:full,full"
o.signcolumn = "yes:1"
o.cmdheight = 0
o.cmdwinheight = 10
o.updatetime = 500
o.ttyfast = true
o.synmaxcol = 200
o.maxmempattern = 5000
if vim.fn.executable("rg") == 1 then
    o.grepprg = "rg --vimgrep --smart-case --follow"
end
o.winbar = nil
o.tabline = nil

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
vim.g.loaded_python3_provider = 1
vim.g.loaded_python_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0

-- Disabling some providers that I do not use
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Setting up undo
opt.swapfile = false
opt.backup = false
---@diagnostic disable-next-line: assign-type-mismatch
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true

-- Setting global variable for lspzero borders
vim.g.lsp_zero_ui_float_border = "rounded"

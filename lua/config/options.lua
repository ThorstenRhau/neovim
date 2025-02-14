local opt = vim.opt
local o = vim.o
local g = vim.g

g.borderStyle = "rounded"
o.autoindent = true
o.autoread = true
o.breakindent = true
o.clipboard = ""
o.cmdheight = 0
o.cmdwinheight = 10
o.completeopt = "menu,menuone,noselect"
o.conceallevel = 2
o.cursorline = true
o.foldenable = false
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = "expr"
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"
o.hlsearch = true
o.ignorecase = true
o.inccommand = "split"
o.incsearch = true
o.jumpoptions = "view"
o.laststatus = 0
o.linebreak = true
o.maxmempattern = 5000
o.mouse = "nv"
o.number = true
o.pumblend = 0
o.relativenumber = true
o.scrolloff = 8
o.showcmd = true
o.sidescrolloff = 8
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
o.winblend = 0
o.wrap = false
opt.backspace = { "start", "eol", "indent" }
opt.path:append({ "**" })
opt.spelllang = { "en", "sv" }
opt.wildignore:append({
    "*.o",
    "*.obj",
    "*.dll",
    "*.exe",
    "*.pyc",
    "*.class",
    "*.swp",
    "*.swo",
    "*.DS_Store",
    "*/node_modules/*",
    "*/target/*",
    "*/build/*",
    "*/dist/*",
    "*/.git/*",
    "*/.svn/*",
    "*/.venv/*",
    "*/venv/*",
})
if vim.fn.executable("rg") == 1 then
    opt.grepprg = "rg --vimgrep --smart-case --follow"
else
    opt.grepprg = "grep -n $* /dev/null"
end
-- Add asterisks in block comments
opt.formatoptions:append({ "r" })

-- Use spaces for tabs and whatnot
o.tabstop = 4
o.shiftwidth = 4
o.shiftround = true
o.expandtab = true

-- Disable yank/copy for 'x' and 'X' (backward yank)
vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })
vim.keymap.set("n", "X", '"_X', { noremap = true, silent = true })

-- Language providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0

-- Setting up undo
opt.swapfile = false
opt.backup = false

local undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"
vim.fn.mkdir(undodir, "p") -- Create the directory if it doesn't exist
opt.undodir = undodir
opt.undofile = true
opt.undolevels = 10000

-- Command-line abbreviation: Expand 'ff' into 'FzfLua'
vim.cmd([[cabbrev ff FzfLua]])

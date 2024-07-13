-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
-- Launch Telescope main window
vim.keymap.set("n", "<c-t>", ":Telescope<CR>")

-- Function to toggle virtual text
local function toggle_virtual_text()
    local current_value = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({
        virtual_text = not current_value,
    })
    if current_value then
        print("Virtual text disabled")
    else
        print("Virtual text enabled")
    end
end

--Function to list active linters
local function ListActiveLinters()
    local linters = require("lint").linters_by_ft[vim.bo.filetype]
    if linters then
        print("Active linters for filetype '" .. vim.bo.filetype .. "':")
        for _, linter in ipairs(linters) do
            print(linter)
        end
    else
        print("No active linters for filetype '" .. vim.bo.filetype .. "'.")
    end
end

-- Setting up register for 'which key' with keymappings
local wk = require("which-key")
wk.add({
    { "<leader>E", "<cmd>Explore<cr>", desc = "Explore" },
    { "<leader>U", "<cmd>Telescope undo<cr>", desc = "Undo" },
    --
    { "<leader>b", group = "Buffer" },
    { "<leader>bb", "<cmd>bprev<CR>", desc = "Previous" },
    { "<leader>be", "<cmd>Neotree buffers<CR>", desc = "Neotree buffers" },
    { "<leader>bl", "<cmd>ls<CR>", desc = "List" },
    --
    { "<leader>c", group = "Code" },
    {
        "<leader>cD",
        function()
            vim.lsp.buf.declaration()
        end,
        desc = "Go to declaration",
    },
    { "<leader>cL", ListActiveLinters, desc = "Linters list" },
    { "<leader>cT", "<Cmd>CBllline<CR>", desc = "Titled Line" },
    {
        "<leader>ca",
        function()
            vim.lsp.buf.code_action()
        end,
        desc = "Code action",
    },
    { "<leader>cb", "<Cmd>CBcabox<CR>", desc = "Box Title" },
    {
        "<leader>cd",
        function()
            vim.lsp.buf.definition()
        end,
        desc = "Go to definition",
    },
    {
        "<leader>ci",
        function()
            vim.lsp.buf.implementation()
        end,
        desc = "List implementations",
    },
    {
        "<leader>cr",
        function()
            vim.lsp.buf.rename()
        end,
        desc = "Rename",
    },
    {
        "<leader>cS",
        function()
            vim.lsp.buf.signature_help()
        end,
        desc = "Signature help",
    },
    {
        "<leader>ct",
        function()
            vim.lsp.buf.type_definition()
        end,
        desc = "Jump to definition",
    },
    --
    { "<leader>f", group = "Find" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "man pages" },
    { "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Notify messages" },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
    { "<leader>fy", "<cmd>Telescope neoclip<cr>", desc = "Old Yanks" },
    { "<leader>fz", "<cmd>Telescope spell_suggest<cr>", desc = "Spelling suggestions" },
    --
    { "<leader>g", group = "Git" },
    { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Blame toggle" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Shows previous commits" },
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Interactive Git" },
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
    { "<leader>l", "<cmd>Lazy<cr>", desc = "Lazy - plugin manager" },
    { "<leader>m", "<cmd>Mason<cr>", desc = "Mason - package manager" },
    { "<leader>o", "<cmd>Oil --float<cr>", desc = "Oil - file manager" },
    { "<leader>p", "<cmd>Pounce<cr>", desc = "Pounce - motion" },
    { "<leader>s", '<cmd> lua require("persistence").load() <cr>', desc = "Restore last session" },
    { "<leader>t", "<cmd>Telescope<cr>", desc = "Telescope - fuzzy finder" },
    --
    { "<leader>u", group = "User Interface" },
    { "<leader>uC", "<cmd>set colorcolumn=80<CR>", desc = "Colorcolumn at 80" },
    { "<leader>uc", "<cmd>ColorizerToggle<CR>", desc = "Colorize color codes" },
    { "<leader>uh", "<cmd>set list!<CR>", desc = "Hidden Characters Toggle" },
    { "<leader>ui", "<cmd>IlluminateToggle<cr>", desc = "Illuminate word highlighting" },
    { "<leader>ul", "<cmd>set number!<cr>", desc = "Line number toggle" },
    { "<leader>uo", "<cmd>AerialToggle!<CR>", desc = "Outline" },
    { "<leader>up", "<cmd>PickColor<CR>", desc = "Pick Color" },
    { "<leader>ur", "<cmd>set relativenumber!<cr>", desc = "Relative line number toggle" },
    { "<leader>ut", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal toggle" },
    { "<leader>uv", toggle_virtual_text, desc = "Toggle Virtual Text" },
    { "<leader>uw", "<cmd>set wrap!<cr>", desc = "Wrap line toggle" },
    --
    { "<leader>x", group = "Trouble" },
})

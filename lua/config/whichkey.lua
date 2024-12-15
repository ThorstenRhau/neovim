--                            ╭─────────────────────╮
--                            │ Toggle virtual text │
--                            ╰─────────────────────╯

local function toggle_virtual_text()
    ---@diagnostic disable-next-line: undefined-field
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

--                            ╭─────────────────────╮
--                            │ List active linters │
--                            ╰─────────────────────╯

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

--           ╭──────────────────────────────────────────────────────╮
--           │ Setting up register for 'which key' with keymappings │
--           ╰──────────────────────────────────────────────────────╯

local wk = require("which-key")
wk.add({
    --                                 ╭───────────╮
    --                                 │ Root menu │
    --                                 ╰───────────╯
    { "<leader>,", "<cmd>b#<CR>", desc = "Switch buffer", icon = { icon = "󰯍 ", color = "yellow" } },
    { "<leader>-", "<C-W>s", desc = "Split window", icon = { icon = " ", color = "grey" } },
    { "<leader>l", "<cmd>Lazy<cr>", desc = "Lazy - plugin manager" },
    { "<leader>m", "<cmd>Mason<cr>", desc = "Mason - package manager", icon = "󰏖 " },
    { "<leader>o", "<cmd>Oil --float<cr>", desc = "Oil - file manager", icon = { icon = "󰏇 ", color = "grey" } },
    { "<leader>p", "<cmd>Pounce<cr>", desc = "Pounce", icon = { icon = "󰿄 ", color = "purple" } },
    { "<leader>s", '<cmd>lua require("persistence").load()<cr>', desc = "Restore last session" },
    --                                  ╭────────╮
    --                                  │ Buffer │
    --                                  ╰────────╯
    { "<leader>b", group = "Buffer", icon = { icon = " ", color = "blue" } },
    { "<leader>bb", "<cmd>b#<CR>", desc = "Switch to alternate" },
    { "<leader>bd", "<cmd>bd<CR>", desc = "Delete" },
    { "<leader>be", "<cmd>Neotree buffers<CR>", desc = "Neotree" },
    { "<leader>bf", "<cmd>FzfLua buffers<cr>", desc = "Find" },
    { "<leader>bl", "<cmd>ls<CR>", desc = "List" },
    { "<leader>bm", "<cmd>bm<CR>", desc = "Go to next modified" },
    { "<leader>bn", "<cmd>bnext<CR>", desc = "Previous" },
    { "<leader>bp", "<cmd>bprevious<CR>", desc = "Previous" },
    --                                   ╭──────╮
    --                                   │ Code │
    --                                   ╰──────╯
    { "<leader>c", group = "Code" },
    { "<leader>cA", "<cmd>LspInfo<CR>", desc = "LSP list" },
    {
        "<leader>cD",
        function()
            vim.lsp.buf.declaration()
        end,
        desc = "Go to declaration",
    },
    { "<leader>cF", "<cmd>ConformInfo<CR>", desc = "Formatters list" },
    {
        "<leader>cI",
        function()
            vim.lsp.buf.incoming_calls()
        end,
        desc = "Incoming calls",
    },
    { "<leader>cL", ListActiveLinters, desc = "Linters list" },
    {
        "<leader>cO",
        function()
            vim.lsp.buf.outgoing_calls()
        end,
        desc = "Outgoign calls",
    },
    {
        "<leader>cS",
        function()
            vim.lsp.buf.signature_help()
        end,
        desc = "Signature help",
    },
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
        "<leader>ct",
        function()
            vim.lsp.buf.type_definition()
        end,
        desc = "Jump to definition",
    },
    { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Venv select", icon = { icon = "󰌠 ", color = "yellow" } },
    --                                   ╭──────╮
    --                                   │ Find │
    --                                   ╰──────╯
    { "<leader>f", group = "Find" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "File" },
    { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help" },
    { "<leader>fm", "<cmd>FzfLua manpages<cr>", desc = "man pages" },
    { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
    { "<leader>fr", "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>fs", "<cmd>FzfLua grep<cr>", desc = "FZF in buffer" },
    { "<leader>fz", "<cmd>FzfLua spell_suggest<cr>", desc = "Spelling suggestions" },
    --                                    ╭─────╮
    --                                    │ Git │
    --                                    ╰─────╯
    { "<leader>g", group = "Git" },
    --                                 ╭───────────╮
    --                                 │ Interface │
    --                                 ╰───────────╯
    { "<leader>u", group = "Interface", icon = { icon = " ", color = "azure" } },
    { "<leader>uB", "<cmd>Barbecue<CR>", desc = "Barbecue winbar" },
    { "<leader>uC", "<cmd>ColorizerToggle<CR>", desc = "Colorize color codes" },
    { "<leader>uH", "<cmd>set list!<CR>", desc = "Hidden Characters" },
    { "<leader>ui", "<cmd>IlluminateToggle<cr>", desc = "Illuminate word highlighting" },
    { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown render" },
    { "<leader>uo", "<cmd>AerialToggle!<CR>", desc = "Outline" },
    { "<leader>up", "<cmd>PickColor<CR>", desc = "Pick Color" },
    { "<leader>ut", "<cmd>TodoLocList<cr>", desc = "Todo location list" },
    { "<leader>uv", toggle_virtual_text, desc = "Virtual Text" },
    --                                  ╭─────────╮
    --                                  │ Window  │
    --                                  ╰─────────╯
    { "<leader>w", group = "Window" },
    { "<leader>wc", "<cmd>close<cr>", desc = "Close" },
    { "<leader>wh", "<cmd>split<cr>", desc = "Split horizontal" },
    { "<leader>wo", "<cmd>only<cr>", desc = "Close all but not current" },
    { "<leader>wv", "<cmd>vsplit<cr>", desc = "Split vertical" },
    --                                  ╭─────────╮
    --                                  │ Trouble │
    --                                  ╰─────────╯
    -- The mappings are done in the Trouble plugin configuration
    { "<leader>x", group = "Trouble", icon = { icon = "󰨰 ", color = "orange" } },
})

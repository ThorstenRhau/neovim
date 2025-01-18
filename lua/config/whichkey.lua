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
    { "<leader>l", "<cmd>Lazy<cr>", desc = "Lazy - plugin manager" },
    { "<leader>m", "<cmd>Mason<cr>", desc = "Mason - package manager", icon = "󰏖 " },
    { "<leader>o", "<cmd>Oil --float<cr>", desc = "Oil - file manager", icon = { icon = "󰏇 ", color = "grey" } },
    {
        "<leader>p",
        function()
            MiniJump2d.start()
        end,
        desc = "Pounce",
        icon = { icon = "󰿄 ", color = "purple" },
    },
    { "<leader>S", '<cmd>lua require("persistence").load()<cr>', desc = "Restore last session" },
    { "<leader>T", "<cmd>Trouble<cr>", desc = "Trouble", icon = { icon = " ", color = "red" } },
    --                                  ╭────────╮
    --                                  │ Buffer │
    --                                  ╰────────╯
    { "<leader>b", group = "Buffer", icon = { icon = " ", color = "blue" } },
    { "<leader>bb", "<cmd>b#<CR>", desc = "Switch to alternate" },
    { "<leader>bd", "<cmd>bd<CR>", desc = "Delete" },
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
    { "<leader>cF", "<cmd>ConformInfo<CR>", desc = "Formatters list" },
    { "<leader>cL", ListActiveLinters, desc = "Linters list" },
    --                                   ╭──────╮
    --                                   │ Find │
    --                                   ╰──────╯
    { "<leader>f", group = "Find", icon = { icon = "󰍉 ", color = "azure" } },
    --                                    ╭─────╮
    --                                    │ Git │
    --                                    ╰─────╯
    { "<leader>g", group = "Git" },
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "NeoGit" },
    --                                    ╭─────╮
    --                                    │ gpt │
    --                                    ╰─────╯
    { "<C-g>", group = "GPT" },
    --                                 ╭───────────╮
    --                                 │ Interface │
    --                                 ╰───────────╯
    { "<leader>u", group = "Interface", icon = { icon = " ", color = "azure" } },
    { "<leader>uC", "<cmd>ColorizerToggle<CR>", desc = "Colorize color codes" },
    { "<leader>uH", "<cmd>set list!<CR>", desc = "Hidden Characters" },
    { "<leader>ui", "<cmd>IlluminateToggle<cr>", desc = "Toggle Word Illumination" },
    { "<leader>uk", "<cmd>set cursorline!<CR>", desc = "Toggle Cursor Line" },
    { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown render" },
    { "<leader>up", "<cmd>PickColor<CR>", desc = "Pick Color" },
    { "<leader>ut", "<cmd>TodoLocList<cr>", desc = "Todo location list" },
    { "<leader>uv", toggle_virtual_text, desc = "Virtual Text" },
    --
    -- Search
    --
    { "<leader>s", group = "Search", icon = { icon = "󰍉 ", color = "azure" } },

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

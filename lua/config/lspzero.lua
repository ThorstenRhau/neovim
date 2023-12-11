local lsp_zero = require("lsp-zero")

---@diagnostic disable-next-line: unused-local
lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
    ---@diagnostic disable-next-line: lowercase-global
    preserve_mappings = false
    --local opts = {buffer = bufnr, remap = false}
    local opts = { buffer = bufnr }

    vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set("n", "<leader>cs", function()
        vim.lsp.buf.workspace_symbol()
    end, opts)
    vim.keymap.set("n", "<leader>cd", function()
        vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "<C-n>", function()
        vim.diagnostic.goto_next()
    end, opts)
    vim.keymap.set("n", "<C-p>", function()
        vim.diagnostic.goto_prev()
    end, opts)
    vim.keymap.set("n", "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "gr", function()
        vim.lsp.buf.references()
    end, opts)
    vim.keymap.set("n", "<leader>cr", function()
        vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
    end, opts)
end)

require("mason").setup({})

require("mason-lspconfig").setup({
    automatic_installation = true,
    ensure_installed = {
        "pyright",
        "taplo",
        "bashls",
        "lua_ls",
        "marksman",
    },
    handlers = {
        lsp_zero.default_setup,
    },
})

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        -- `Enter` key to confirm completion
        ["<CR>"] = cmp.mapping.confirm({ select = false }),

        -- Ctrl+Space to trigger completion menu
        ["<C-Space>"] = cmp.mapping.complete(),

        -- Navigate between snippet placeholder
        ["<C-f>"] = cmp_action.luasnip_jump_forward(),
        ["<C-b>"] = cmp_action.luasnip_jump_backward(),

        -- Scroll up and down in the completion documentation
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),

        -- Supertab
        ["<Tab>"] = cmp_action.luasnip_supertab(),
        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer", keyword_length = 4 },
    }),
})

local wk = require("which-key")
wk.add({
    {
        mode = { "v" },
        {
            "<C-g><C-t>",
            ":<C-u>'<,'>GpChatNew tabnew<cr>",
            desc = "Visual Chat New tabnew",
            nowait = true,
            remap = false,
        },
        {
            "<C-g><C-v>",
            ":<C-u>'<,'>GpChatNew vsplit<cr>",
            desc = "Visual Chat New vsplit",
            nowait = true,
            remap = false,
        },
        {
            "<C-g><C-x>",
            ":<C-u>'<,'>GpChatNew split<cr>",
            desc = "Visual Chat New split",
            nowait = true,
            remap = false,
        },
        { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append (after)", nowait = true, remap = false },
        { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)", nowait = true, remap = false },
        { "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New", nowait = true, remap = false },
        { "<C-g>g", group = "generate into new ..", nowait = true, remap = false },
        { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew", nowait = true, remap = false },
        { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew", nowait = true, remap = false },
        { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup", nowait = true, remap = false },
        { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew", nowait = true, remap = false },
        { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew", nowait = true, remap = false },
        { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection", nowait = true, remap = false },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", nowait = true, remap = false },
        { "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste", nowait = true, remap = false },
        { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite", nowait = true, remap = false },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", nowait = true, remap = false },
        { "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat", nowait = true, remap = false },
        { "<C-g>x", ":<C-u>'<,'>GpContext<cr>", desc = "Visual GpContext", nowait = true, remap = false },
    },

    {
        { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew", nowait = true, remap = false },
        { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit", nowait = true, remap = false },
        { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split", nowait = true, remap = false },
        { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)", nowait = true, remap = false },
        { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)", nowait = true, remap = false },
        { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat", nowait = true, remap = false },
        { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder", nowait = true, remap = false },
        { "<C-g>g", group = "generate into new ..", nowait = true, remap = false },
        { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew", nowait = true, remap = false },
        { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew", nowait = true, remap = false },
        { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup", nowait = true, remap = false },
        { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew", nowait = true, remap = false },
        { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew", nowait = true, remap = false },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", nowait = true, remap = false },
        { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite", nowait = true, remap = false },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", nowait = true, remap = false },
        { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat", nowait = true, remap = false },
        { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext", nowait = true, remap = false },
    },

    {
        mode = { "i" },
        { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew", nowait = true, remap = false },
        { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit", nowait = true, remap = false },
        { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split", nowait = true, remap = false },
        { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)", nowait = true, remap = false },
        { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)", nowait = true, remap = false },
        { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat", nowait = true, remap = false },
        { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder", nowait = true, remap = false },
        { "<C-g>g", group = "generate into new ..", nowait = true, remap = false },
        { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew", nowait = true, remap = false },
        { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew", nowait = true, remap = false },
        { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup", nowait = true, remap = false },
        { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew", nowait = true, remap = false },
        { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew", nowait = true, remap = false },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", nowait = true, remap = false },
        { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite", nowait = true, remap = false },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", nowait = true, remap = false },
        { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat", nowait = true, remap = false },
        { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext", nowait = true, remap = false },
    },
})

--  -- VISUAL mode mappings
--  -- s, x, v modes are handled the same way by which_key
--  require("which-key").register({
--      -- ...
--      ["<C-g>"] = {
--          c = { ":<C-u>'<,'>GpChatNew<cr>", "Visual Chat New" },
--          p = { ":<C-u>'<,'>GpChatPaste<cr>", "Visual Chat Paste" },
--          t = { ":<C-u>'<,'>GpChatToggle<cr>", "Visual Toggle Chat" },
--
--          ["<C-x>"] = { ":<C-u>'<,'>GpChatNew split<cr>", "Visual Chat New split" },
--          ["<C-v>"] = { ":<C-u>'<,'>GpChatNew vsplit<cr>", "Visual Chat New vsplit" },
--          ["<C-t>"] = { ":<C-u>'<,'>GpChatNew tabnew<cr>", "Visual Chat New tabnew" },
--
--          r = { ":<C-u>'<,'>GpRewrite<cr>", "Visual Rewrite" },
--          a = { ":<C-u>'<,'>GpAppend<cr>", "Visual Append (after)" },
--          b = { ":<C-u>'<,'>GpPrepend<cr>", "Visual Prepend (before)" },
--          i = { ":<C-u>'<,'>GpImplement<cr>", "Implement selection" },
--
--          g = {
--              name = "generate into new ..",
--              p = { ":<C-u>'<,'>GpPopup<cr>", "Visual Popup" },
--              e = { ":<C-u>'<,'>GpEnew<cr>", "Visual GpEnew" },
--              n = { ":<C-u>'<,'>GpNew<cr>", "Visual GpNew" },
--              v = { ":<C-u>'<,'>GpVnew<cr>", "Visual GpVnew" },
--              t = { ":<C-u>'<,'>GpTabnew<cr>", "Visual GpTabnew" },
--          },
--
--          n = { "<cmd>GpNextAgent<cr>", "Next Agent" },
--          s = { "<cmd>GpStop<cr>", "GpStop" },
--          x = { ":<C-u>'<,'>GpContext<cr>", "Visual GpContext" },
--      },
--      -- ...
--  }, {
--      mode = "v", -- VISUAL mode
--      prefix = "",
--      buffer = nil,
--      silent = true,
--      noremap = true,
--      nowait = true,
--  })
--
--  -- NORMAL mode mappings
--  require("which-key").register({
--      -- ...
--      ["<C-g>"] = {
--          c = { "<cmd>GpChatNew<cr>", "New Chat" },
--          t = { "<cmd>GpChatToggle<cr>", "Toggle Chat" },
--          f = { "<cmd>GpChatFinder<cr>", "Chat Finder" },
--
--          ["<C-x>"] = { "<cmd>GpChatNew split<cr>", "New Chat split" },
--          ["<C-v>"] = { "<cmd>GpChatNew vsplit<cr>", "New Chat vsplit" },
--          ["<C-t>"] = { "<cmd>GpChatNew tabnew<cr>", "New Chat tabnew" },
--
--          r = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
--          a = { "<cmd>GpAppend<cr>", "Append (after)" },
--          b = { "<cmd>GpPrepend<cr>", "Prepend (before)" },
--
--          g = {
--              name = "generate into new ..",
--              p = { "<cmd>GpPopup<cr>", "Popup" },
--              e = { "<cmd>GpEnew<cr>", "GpEnew" },
--              n = { "<cmd>GpNew<cr>", "GpNew" },
--              v = { "<cmd>GpVnew<cr>", "GpVnew" },
--              t = { "<cmd>GpTabnew<cr>", "GpTabnew" },
--          },
--
--          n = { "<cmd>GpNextAgent<cr>", "Next Agent" },
--          s = { "<cmd>GpStop<cr>", "GpStop" },
--          x = { "<cmd>GpContext<cr>", "Toggle GpContext" },
--      },
--      -- ...
--  }, {
--      mode = "n", -- NORMAL mode
--      prefix = "",
--      buffer = nil,
--      silent = true,
--      noremap = true,
--      nowait = true,
--  })
--
--  -- INSERT mode mappings
--  require("which-key").register({
--      -- ...
--      ["<C-g>"] = {
--          c = { "<cmd>GpChatNew<cr>", "New Chat" },
--          t = { "<cmd>GpChatToggle<cr>", "Toggle Chat" },
--          f = { "<cmd>GpChatFinder<cr>", "Chat Finder" },
--
--          ["<C-x>"] = { "<cmd>GpChatNew split<cr>", "New Chat split" },
--          ["<C-v>"] = { "<cmd>GpChatNew vsplit<cr>", "New Chat vsplit" },
--          ["<C-t>"] = { "<cmd>GpChatNew tabnew<cr>", "New Chat tabnew" },
--
--          r = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
--          a = { "<cmd>GpAppend<cr>", "Append (after)" },
--          b = { "<cmd>GpPrepend<cr>", "Prepend (before)" },
--
--          g = {
--              name = "generate into new ..",
--              p = { "<cmd>GpPopup<cr>", "Popup" },
--              e = { "<cmd>GpEnew<cr>", "GpEnew" },
--              n = { "<cmd>GpNew<cr>", "GpNew" },
--              v = { "<cmd>GpVnew<cr>", "GpVnew" },
--              t = { "<cmd>GpTabnew<cr>", "GpTabnew" },
--          },
--
--          x = { "<cmd>GpContext<cr>", "Toggle GpContext" },
--          s = { "<cmd>GpStop<cr>", "GpStop" },
--          n = { "<cmd>GpNextAgent<cr>", "Next Agent" },
--      },
--      -- ...
--  }, {
--      mode = "i", -- INSERT mode
--      prefix = "",
--      buffer = nil,
--      silent = true,
--      noremap = true,
--      nowait = true,
--  })

---@module "lazy"
---@type LazySpec
return {
    "robitx/gp.nvim",
    cmd = {
        "GpChatNew",
        "GpAppend",
        "GpPrepend",
        "GpChatFinder",
        "GpNextAgent",
        "GpRewrite",
        "GpStop",
        "GpChatToggle",
        "GpEnew",
        "GpNew",
        "GpPopup",
        "GpTabnew",
        "GpVnew",
        "GpImplement",
        "GpChatPaste",
    },
    keys = {
        -- NORMAL mode
        { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew", mode = "n" },
        { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit", mode = "n" },
        { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split", mode = "n" },
        { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat", mode = "n" },
        { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)", mode = "n" },
        { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)", mode = "n" },
        { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder", mode = "n" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", mode = "n" },
        { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite", mode = "n" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", mode = "n" },
        { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat", mode = "n" },

        -- VISUAL mode
        { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "ChatNew tabnew", mode = "v" },
        { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "ChatNew vsplit", mode = "v" },
        { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", desc = "ChatNew split", mode = "v" },
        { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append", mode = "v" },
        { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend", mode = "v" },
        { "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New", mode = "v" },
        { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew", mode = "v" },
        { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew", mode = "v" },
        { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup", mode = "v" },
        { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew", mode = "v" },
        { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew", mode = "v" },
        { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection", mode = "v" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", mode = "v" },
        { "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Chat Paste", mode = "v" },
        { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite", mode = "v" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", mode = "v" },
        { "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Toggle Chat", mode = "v" },

        -- INSERT mode
        { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew", mode = "i" },
        { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit", mode = "i" },
        { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split", mode = "i" },
        { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat", mode = "i" },
        { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)", mode = "i" },
        { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)", mode = "i" },
        { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder", mode = "i" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", mode = "i" },
        { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite", mode = "i" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", mode = "i" },
        { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat", mode = "i" },
    },
    opts = function()
        local prompt = [[
You are NeoVim AI, a specialized coding assistant seamlessly integrated into Neovim via gp.nvim.

### Responsibilities:
- 🛠️ **Code Assistance:** Accurate suggestions, debugging, refactoring, optimization, and configuration help.
- 🚨 **Error Guidance:** Clearly explain errors and provide practical, secure, and optimized solutions.
- 📚 **Interactive Examples:** Offer concise, actionable code snippets formatted in Markdown blocks with brief inline comments.
- 🎯 **Context Sensitivity:** Adapt your responses based on file type, coding conventions, and active integrations (e.g., LSP, linting, formatting).

### When Answering:
- Stay direct, minimal, yet complete.
- Provide step-by-step debugging or configuration guidance proactively.
- Anticipate follow-up questions and include relevant clarifications upfront.
- Match the user's experience level inferred from the context, adjusting detail accordingly.
- Use a friendly, informal-professional tone to enhance clarity and enjoyment.

Your goal is to boost developer productivity, confidence, and enjoyment within the Neovim environment. 🚀
]]

        return {
            providers = {
                openai = {
                    disable = true,
                    endpoint = "https://api.openai.com/v1/chat/completions",
                    secret = os.getenv("OPENAI_API_KEY"),
                    model = "gpt-4o-mini",
                    temperature = 0.2,
                    max_tokens = 32768,
                },
                ollama = {
                    disable = true,
                    endpoint = "http://127.0.0.1:11434",
                    model = "qwen2.5-coder:14b",
                    temperature = 0.2,
                    max_tokens = 4096,
                },
                googleai = {
                    disable = false,
                    endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
                    secret = os.getenv("GOOGLEAI_API_KEY"),
                },
            },
            agents = {
                {
                    provider = "googleai",
                    name = "Gemini 2.0 Flash",
                    chat = true,
                    command = true,
                    model = { model = "gemini-2.0-flash", temperature = 1.0, top_p = 1 },
                    system_prompt = prompt,
                },
                {
                    name = "CodeGemini",
                    disable = true,
                },
                {
                    name = "ChatGemini",
                    disable = true,
                },
                -- {
                --     name = "GPT-4o Mini",
                --     provider = "openai",
                --     chat = true,
                --     command = true,
                --     model = "gpt-4o-mini",
                --     system_prompt = prompt,
                --     default = true,
                -- },
                -- {
                --     name = "Ollama Coder",
                --     provider = "ollama",
                --     chat = true,
                --     command = true,
                --     model = "qwen2.5-coder:14b",
                --     system_prompt = prompt,
                -- },
            },
        }
    end,
}

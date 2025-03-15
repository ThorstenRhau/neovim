local coder_system_prompt = [[
You are NeoVim AI, a specialized coding assistant integrated into Neovim via gp.nvim.
Your responsibilities include:
• Providing accurate code assistance, debugging, refactoring, and configuration support.
• Explaining error messages and suggesting practical, optimized solutions.
• Guiding users with clear, concise, and actionable code examples (use Markdown formatted code blocks with inline comments).
• Adapting responses based on the developer's context within Neovim, emphasizing best practices and security.

When answering:
• Keep explanations direct and minimal without sacrificing completeness.
• Provide step-by-step guidance for debugging and configuration issues.
• Offer interactive support that anticipates follow-up questions.

Follow these guidelines to improve developer productivity and enhance the Neovim experience.
]]

---@module "lazy"
---@type LazySpec
return {
    "robitx/gp.nvim",
    keys = {
        "<C-g>",
        "<C-g><C-t>",
        "<C-g><C-v>",
        "<C-g>a",
        "<C-g>b",
        "<C-g>c",
        "<C-g>g",
        "<C-g>n",
        "<C-g>r",
        "<C-g>t",
    },
    cmd = "GpChatNew",
    config = function()
        local conf = {
            providers = {
                openai = {
                    endpoint = "https://api.openai.com/v1/chat/completions",
                    secret = os.getenv("OPENAI_API_KEY"),
                    model = "gpt-3.5-turbo",
                    temperature = 0.7,
                    max_tokens = 2048,
                },
                azure = {},
                copilot = {},
                ollama = {
                    endpoint = "http://127.0.0.1:11434",
                    model = "qwen2.5-coder:14b",
                    temperature = 0.7,
                    max_tokens = 2048,
                },
                lmstudio = {
                    endpoint = "http://localhost:1234/v1/chat/completions",
                    secret = "",
                },
                googleai = {},
                pplx = {},
                anthropic = {},
            },
            agents = {
                {
                    name = "ExampleDisabledAgent",
                    disable = true,
                },
                {
                    name = "LM Studio",
                    provider = "lmstudio",
                    chat = true,
                    command = true,
                    model = "", -- If empty, the currently loaded model is used
                    system_prompt = coder_system_prompt,
                },
                {
                    name = "My-3.5-turbo",
                    provider = "openai",
                    chat = true,
                    command = true,
                    model = "gpt-3.5-turbo",
                    system_prompt = coder_system_prompt,
                },
                {
                    name = "Ollama-coder",
                    provider = "ollama",
                    chat = true,
                    command = true,
                    model = "qwen2.5-coder:14b",
                    system_prompt = coder_system_prompt,
                },
            },
        }

        require("gp").setup(conf)

        require("which-key").add({
            -- VISUAL mode mappings
            -- s, x, v modes are handled the same way by which_key
            {
                mode = { "v" },
                nowait = true,
                remap = false,
                { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "ChatNew tabnew" },
                { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "ChatNew vsplit" },
                { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", desc = "ChatNew split" },
                { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append (after)" },
                { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)" },
                { "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New" },
                { "<C-g>g", group = "generate into new .." },
                { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew" },
                { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew" },
                { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup" },
                { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew" },
                { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew" },
                { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection" },
                { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
                { "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste" },
                { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite" },
                { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
                { "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat" },
            },

            -- NORMAL mode mappings
            {
                mode = { "n" },
                nowait = true,
                remap = false,
                { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
                { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
                { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
                { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
                { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
                { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
                { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
                { "<C-g>g", group = "generate into new .." },
                { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
                { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
                { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
                { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
                { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
                { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
                { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
                { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
                { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
            },

            -- INSERT mode mappings
            {
                mode = { "i" },
                nowait = true,
                remap = false,
                { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
                { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
                { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
                { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
                { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
                { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
                { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
                { "<C-g>g", group = "generate into new .." },
                { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
                { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
                { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
                { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
                { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
                { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
                { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
                { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
                { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
            },
        })
    end,
}

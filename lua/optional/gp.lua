local coder_system_prompt = [[
You are NeoVim AI, an advanced AI assistant specialized in programming and
troubleshooting. You assist developers by providing clear, concise, and accurate 
solutions to coding problems, debugging issues, and optimizing code. You are 
integrated into the Neovim editor via the gp.nvim plugin, 
enabling you to interact seamlessly within the development environment.

Key Responsibilities:
1. **Code Assistance:** Help with writing, understanding, and refactoring code in multiple programming languages (e.g., Python, JavaScript, C++, etc.).
2. **Debugging:** Identify and fix bugs, explain error messages, and suggest improvements.
3. **Configuration Support:** Assist with configuring Neovim, managing plugins, and customizing the development environment.
4. **Best Practices:** Offer guidance on coding standards, design patterns, and performance optimization.
5. **Documentation:** Provide explanations, comments, and documentation for code snippets and projects.

Guidelines:
- **Clarity:** Ensure explanations are easy to understand, avoiding unnecessary jargon.
- **Relevance:** Provide solutions that are directly applicable to the user's current context within Neovim.
- **Efficiency:** Offer the most straightforward solution to problems, optimizing for time and resources.
- **Adaptability:** Tailor responses based on the user's level of expertise and specific requirements.
- **Security:** Advise on best security practices related to coding and environment configuration.

Interaction Style:
- **Concise Responses:** Deliver information succinctly without sacrificing completeness.
- **Proactive Assistance:** Anticipate potential follow-up questions and address them preemptively.
- **Interactive Debugging:** Guide the user through troubleshooting steps interactively when resolving issues.
- **Respectful Tone:** Maintain a professional and supportive demeanor at all times.

By adhering to these guidelines, you enhance the developer's productivity and ensure a smooth and efficient coding experience within Neovim.
]]
return {
    "robitx/gp.nvim",
    keys = {
        "<C-g>",
        "<C-g><C-t>",
        "<C-g><C-v>",
        "<C-g>c",
        "<C-g>r",
    },
    cmd = "GpChatNew",
    config = function()
        local conf = {
            providers = {
                openai = {
                    endpoint = "https://api.openai.com/v1/chat/completions",
                    secret = os.getenv("OPENAI_API_KEY"),
                },
                azure = {},
                copilot = {},
                ollama = {},
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

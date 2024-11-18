return {
    "David-Kunz/gen.nvim",
    opts = {
        model = "qwen2.5-coder:3b", -- The default model to use.
        quit_map = "q", -- set keymap to close the response window
        retry_map = "<c-r>", -- set keymap to re-send the current prompt
        accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last result
        host = "127.0.0.1", -- The host running the Ollama service.
        port = "11434", -- The port on which the Ollama service is listening.
        display_mode = "float", -- The display mode. Can be "float" or "split" or "horizontal-split".
        show_prompt = false, -- Shows the prompt submitted to Ollama.
        show_model = true, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false, -- Never closes the window automatically.
        file = false, -- Write the payload to a temporary file to keep the command short.
        hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
    },
    keys = {
        {
            "<C-o>",
            ":Gen<CR>",
            desc = "Ollama prompt",
            mode = { "n", "v" },
        },
    },
}

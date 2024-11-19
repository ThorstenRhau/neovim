return {
    "David-Kunz/gen.nvim",
    opts = {
        model = "qwen2.5-coder:3b",
        quit_map = "q",
        retry_map = "<c-r>",
        accept_map = "<c-cr>",
        host = "127.0.0.1",
        port = "11434",
        display_mode = "float",
        show_prompt = false,
        show_model = true,
        no_auto_close = false,
        file = false,
        hidden = false,
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

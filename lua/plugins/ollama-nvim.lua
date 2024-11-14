return {
    "nomnivore/ollama.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = {
        "Ollama",
        "OllamaModel",
        "OllamaServe",
        "OllamaServeStop",
    },
    keys = {
        {
            "<C-o>",
            ":<c-u>lua require('ollama').prompt()<cr>",
            desc = "ollama prompt",
            mode = { "n", "v" },
        },
    },
    opts = {
        model = "qwen2.5-coder:latest",
        url = "http://127.0.0.1:11434",
        serve = {
            on_start = false,
            command = "ollama",
            args = { "serve" },
            stop_command = "pkill",
            stop_args = { "-SIGTERM", "ollama" },
        },
    },
}

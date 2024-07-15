return {
    "robitx/gp.nvim",
    cmd = {
        "GpChatNew",
        "GpChatPaste",
        "GpChatToggle",
        "GpChatFinder",
        "GpChatDelete",
        "GpRewrite",
        "GpAppend",
        "GpPrepend",
        "GpNew",
        "GpVnew",
        "GpTabnew",
        "GpPopup",
        "GpImplement",
        "GpAgent",
        "GpStop",
    },
    config = function()
        require("gp").setup()
    end,
}

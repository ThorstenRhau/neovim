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
        --
        "GpCodeReview",
        "GpFixBugs",
    },
    config = function()
        require("gp").setup({
            hooks = {
                --                               ╭──────────────╮
                --                               │ GpCodeReview │
                --                               ╰──────────────╯
                CodeReview = function(gp, params)
                    local template = "I have the following code from {{filename}}:\n\n"
                        .. "```{{filetype}}\n{{selection}}\n```\n\n"
                        .. "Please analyze for code smells and suggest improvements."
                    local agent = gp.get_chat_agent()
                    gp.Prompt(params, gp.Target.enew("markdown"), nil, agent.model, template, agent.system_prompt)
                end,
                --                                 ╭───────────╮
                --                                 │ GpFixBugs │
                --                                 ╰───────────╯
                FixBugs = function(gp, params)
                    local template = [[
                        You are an expert in {{filetype}}.
                        Fix bugs in the below code from {{filename}} carefully and logically:
                        Your task is to analyze the provided {{filetype}} code snippet, identify
                        any bugs or errors present, and provide a corrected version of the code
                        that resolves these issues. Explain the problems you found in the
                        original code and how your fixes address them. The corrected code should
                        be functional, efficient, and adhere to best practices in
                        {{filetype}} programming.

                        ```{{filetype}}
                        {{selection}}
                        ```

                        Fixed code:
                        ]]
                    local agent = gp.get_chat_agent()
                    gp.Prompt(params, gp.Target.enew("markdown"), nil, agent.model, template, agent.system_prompt)
                end,
            },
        })
    end,
}

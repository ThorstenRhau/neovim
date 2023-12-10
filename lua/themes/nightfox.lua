return {
  {
    "EdenEast/nightfox.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    event = "VeryLazy",
    config = function()
      require("nightfox").setup({
        options = {
          -- Compiled file's destination location
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled", -- Compiled file suffix
          transparent = false, -- Disable setting background
          terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
          dim_inactive = true, -- Non focused panes set to alternative background
          module_default = true, -- Default enable value for modules
          colorblind = {
            enable = false, -- Enable colorblind support
            simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
            severity = {
              protan = 0, -- Severity [0,1] for protan (red)
              deutan = 0, -- Severity [0,1] for deutan (green)
              tritan = 0, -- Severity [0,1] for tritan (blue)
            },
          },
          styles = { -- Style to be applied to different syntax groups
            comments = "italic", -- Value is any valid attr-list value `:help attr-list`
            conditionals = "NONE",
            constants = "bold",
            functions = "bold, italic",
            keywords = "italic",
            numbers = "NONE",
            operators = "NONE",
            strings = "italic",
            types = "bold",
            variables = "NONE",
          },
          inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false,
          },
          modules = { -- List of various plugins and additional options
            "cmp",
            "dap-ui",
            "dashboard",
            "fidget",
            "gitsigns",
            "illuminate",
            "indent_blanklines",
            "lazy.nvim",
            "lsp_trouble",
            "mini",
            "modes",
            "native_lsp",
            "neotree",
            "notify",
            "pounce",
            "symbol-outline",
            "telescope",
            "treesitter",
            "wichkey",
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })
    end,
  },
}

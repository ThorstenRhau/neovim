return {
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-treesitter/nvim-treesitter",
		},
		event = { "LspAttach" },
		cmd = "Lspsaga",
		config = function()
			require("lspsaga").setup({
				ui = {
					code_action = "",
				},
			})
		end,
	},
}

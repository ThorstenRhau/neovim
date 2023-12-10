return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local dashboard = require("alpha.themes.dashboard")
		local logo = [[
               __      _______ __  __
   by thorre   \ \    / /_   _|  \/  |
  _ __   ___  __\ \  / /  | | | \  / |
 | '_ \ / _ \/ _ \ \/ /   | | | |\/| |
 | | | |  __/ (_) \  /   _| |_| |  | |
 |_| |_|\___|\___/ \/   |_____|_|  |_|]]
		dashboard.section.header.val = vim.split(logo, "\n")
		dashboard.section.buttons.val = {
			dashboard.button("e", " " .. "   New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("o", " " .. "   Recent files", ":Telescope oldfiles<CR>"),
			dashboard.button("s", "󰑓 " .. "   Restore session", [[:lua require("persistence").load() <cr>]]),
			dashboard.button("l", "󰒲 " .. "   Lazy plugin manager", ":Lazy<CR>"),
			dashboard.button("m", " " .. "   Mason package manager", ":Mason<CR>"),
			dashboard.button("q", " " .. "   Quit", ":qa<CR>"),
		}
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end
		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.opts.layout[1].val = 8
		vim.b.miniindentscope_disable = true

		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					require("lazy").show()
				end,
			})
		end
		require("alpha").setup(dashboard.opts)
	end,
}

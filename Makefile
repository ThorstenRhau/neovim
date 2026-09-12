.DEFAULT_GOAL := check
CONFIG_PATHS := init.lua lua after

.PHONY: check lint format startup install-hooks

check: lint
	stylua --check $(CONFIG_PATHS)

lint:
	selene $(CONFIG_PATHS)

format:
	stylua $(CONFIG_PATHS)

startup:
	nvim --headless -i NONE -n '+lua if vim.v.errmsg ~= "" then vim.cmd.cquit() end' +qa

install-hooks:
	git config core.hooksPath .githooks

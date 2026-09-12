.DEFAULT_GOAL := check
CONFIG_PATHS := init.lua lua after scripts

.PHONY: check lint format startup clean install-hooks

check: lint
	stylua --check $(CONFIG_PATHS)

lint:
	selene $(CONFIG_PATHS)

format:
	stylua $(CONFIG_PATHS)

startup:
	nvim --headless -i NONE -n '+lua if vim.v.errmsg ~= "" then vim.cmd.cquit() end' +qa

clean:
	NVIM_LOG_FILE=/dev/null nvim --headless -u NONE -i NONE -n -l scripts/clean.lua

install-hooks:
	git config core.hooksPath .githooks

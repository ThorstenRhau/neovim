SHELL     := /usr/bin/env bash
ROOT      := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STYLUAC   := $(ROOT)/.stylua.toml
CHECKLUAC := $(ROOT)/.luacheckrc
NVIM      := nvim --headless -Es -u $(ROOT)/init.lua

.PHONY: all check clean format test install-hooks

all: format check lint

# Install git hooks
install-hooks:
	@git config core.hooksPath .githooks

# Format all Lua files according to .stylua.toml
format:
	@stylua --config-path "$(STYLUAC)" "$(ROOT)"

# Start Neovim headless, check Lazy and plugins, then run :checkhealth
check:
	@echo "Running Neovim health checks..."
	@temp_file=$$(mktemp) ;\
	nvim --headless -u $(ROOT)/init.lua \
	  -c 'silent! Lazy! load all' \
	  -c 'checkhealth' \
	  -c 'lua vim.wait(1000)' \
	  -c 'lua print(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"))' \
	  -c 'qall!' > "$$temp_file" 2>&1 ;\
	if grep "❌ ERROR" "$$temp_file" | \
		grep -v "kitty graphics protocol" | \
		grep -v "vim.ui.input.*Snacks.input" | \
		grep -v "vim.ui.select.*Snacks.picker.select" | \
		grep -q "❌ ERROR"; then \
	  echo "Neovim health check failed! Errors found:"; \
	  cat "$$temp_file"; \
	  rm "$$temp_file"; \
	  exit 1; \
	else \
	  echo "Neovim health check passed."; \
	  rm "$$temp_file"; \
	fi

# Lint all Lua files
lint:
	@luacheck --config "$(CHECKLUAC)" "$(ROOT)"


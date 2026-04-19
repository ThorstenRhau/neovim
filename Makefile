SHELL            := /usr/bin/env bash
ROOT             := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STYLUAC          := $(ROOT)/.stylua.toml
SELENEC          := $(ROOT)/selene.toml
NVIM             := nvim --headless -Es -u $(ROOT)/init.lua
CONFIG_PATHS     := "$(ROOT)/init.lua" "$(ROOT)/lua" "$(ROOT)/after"

.PHONY: all check clean format lint install-hooks help

all: format lint

# Verify formatting and lint (used by pre-commit hook)
check: lint
	@stylua --check --config-path "$(STYLUAC)" $(CONFIG_PATHS)

# Install git hooks
install-hooks:
	@git config core.hooksPath .githooks

# Format all Lua files according to .stylua.toml
format:
	@stylua --config-path "$(STYLUAC)" $(CONFIG_PATHS)

# Lint all Lua files
lint:
	@selene --config "$(SELENEC)" $(CONFIG_PATHS)

# Clean Neovim cache, state, and data directories
clean:
	@rm -rf "$(HOME)/.cache/nvim"
	@rm -rf "$(HOME)/.local/state/nvim"
	@rm -rf "$(HOME)/.local/share/nvim"
	@rm -f "$(HOME)/.config/nvim/nvim-pack-lock.json"
	@echo "Cleaned Neovim cache, state, lock-file, and data directories"

# Display available targets
help:
	@echo "Available targets:"
	@echo "  all           - Format and lint"
	@echo "  check         - Verify formatting and lint (pre-commit)"
	@echo "  format        - Format Lua files with stylua"
	@echo "  lint          - Lint Lua files with selene"
	@echo "  clean         - Remove Neovim cache/state/data"
	@echo "  install-hooks - Enable git pre-commit hook"

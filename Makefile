SHELL            := /usr/bin/env bash
ROOT             := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STYLUAC          := $(ROOT)/.stylua.toml
SELENEC          := $(ROOT)/selene.toml
NVIM             := nvim --headless -Es -u $(ROOT)/init.lua
EXCLUDED_ERRORS  := kitty graphics protocol|vim%.ui%.input.*Snacks%.input|vim%.ui%.select.*Snacks%.picker%.select|tectonic.*pdflatex

.PHONY: all clean format lint install-hooks help

all: format lint

# Install git hooks
install-hooks:
	@git config core.hooksPath .githooks

# Format all Lua files according to .stylua.toml
format:
	@stylua --config-path "$(STYLUAC)" "$(ROOT)"

# Lint all Lua files
lint:
	@selene "$(ROOT)"

# Clean Neovim cache, state, and data directories
clean:
	@rm -rf "$(HOME)/.cache/nvim"
	@rm -rf "$(HOME)/.local/state/nvim"
	@rm -rf "$(HOME)/.local/share/nvim"
	@echo "Cleaned Neovim cache, state, and data directories"

# Display available targets
help:
	@echo "Available targets:"
	@echo "  all           - Format and lint"
	@echo "  format        - Format Lua files with stylua"
	@echo "  lint          - Lint Lua files with selene"
	@echo "  clean         - Remove Neovim cache/state/data"
	@echo "  install-hooks - Enable git pre-commit hook"

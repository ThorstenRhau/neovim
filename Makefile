SHELL   := /usr/bin/env bash
ROOT    := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STYLUAC := $(ROOT)/.stylua.toml
NVIM    := nvim --headless -Es -u $(ROOT)/init.lua

.PHONY: all check clean format test

all: format check lint

# Format all Lua files according to .stylua.toml
format:
	@stylua --config-path "$(STYLUAC)" "$(ROOT)"

# Start Neovim headless, check Lazy and plugins, then run :checkhealth
check:
	$(NVIM) \
	  -c 'silent! Lazy! load all' \
	  -c 'silent! checkhealth' \
	  -c 'qall!'

# Lint all Lua files
lint:
	@luacheck --config .luacheckrc "$(ROOT)"


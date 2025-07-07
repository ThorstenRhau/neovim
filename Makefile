SHELL   := /usr/bin/env bash
ROOT    := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STYLUAC := $(ROOT)/.stylua.toml
NVIM    := nvim --headless -Es -u $(ROOT)/init.lua

.PHONY: all check clean format test

all: format check

# Format all Lua files according to .stylua.toml
format:
	@stylua --config-path "$(STYLUAC)" "$(ROOT)"

# Start Neovim headless, load Lazy and all plugins, then quit
check:
	$(NVIM) \
	  -c 'silent! Lazy! check' \
	  -c 'qall!'

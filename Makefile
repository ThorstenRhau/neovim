SHELL := /usr/bin/env bash
ROOT   := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STYLUAC := $(ROOT)/.stylua.toml

.PHONY: all format check

all: format check

format:
	stylua init.lua lua/ --color auto --config-path $(STYLUAC)

check:
	nvim --headless -u $(ROOT)/init.lua \
	  "+Lazy! sync" \
	  '+lua print(vim.inspect(require("lazy").stats()))' \
	  +qa


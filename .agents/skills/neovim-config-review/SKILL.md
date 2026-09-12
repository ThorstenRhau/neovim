---
name: neovim-config-review
description: >-
  Audit this repository's Neovim 0.12+ Lua configuration for correctness,
  compatibility, and stale wiring. Use for read-only config reviews; do not use
  for instruction-system audits, implementation requests, Git workflows, or
  general Neovim advice.
---

# Neovim Config Review

## Outcome

Produce a findings-first, read-only audit backed by current repository and
upstream evidence. An unqualified invocation means a full audit; a scoped prompt
limits the review to that area and its relevant dependencies.

## Scope and evidence

- Inspect Git status first and preserve unrelated worktree changes.
- For a full audit, inspect `AGENTS.md`, `init.lua`, `lua/config/`,
  `lua/plugins/`, `after/ftplugin/`, `Makefile`, `scripts/smoke.sh`,
  `scripts/smoke.lua`, `README.md`, `nvim-pack-lock.json`, `.editorconfig`,
  and the StyLua and Selene configuration.
- Record `nvim --version` and use `nvim-pack-lock.json` as the plugin revision
  baseline. Note local installation drift that affects runtime verification.
- Account for every in-scope plugin declared in `lua/config/pack.lua`. For each
  plugin with local options, globals, mappings, commands, or load-order
  requirements, verify the configured API against documentation for the
  reviewed revision. Mark declared-only plugins and unavailable documentation
  explicitly in the coverage list.
- Prefer Neovim `:help` for the installed version and official plugin
  documentation at the locked revision. When consulting current upstream docs
  or Context7, confirm they apply to the reviewed versions. Distinguish newer
  upstream changes from defects in the locked configuration.

## Checks

- Run `make check` when its tools are available. Separate tool-availability
  failures from repository findings.
- Check startup and load order, plugin declarations and setup, keymap
  descriptions and scope, LSP and formatter/linter wiring, stale references, and
  Neovim 0.12 API usage.
- Check buffer/window and filetype transitions for leaked options, mappings,
  autocmds, and parser state, including chainable `b:undo_ftplugin` cleanup.
  Verify native indentation with EditorConfig precedence.
- Use `make smoke` for offline startup and filetype checks in disposable XDG
  directories. Inspect its scripts to understand the coverage. If the required
  macOS tooling or locally installed locked dependencies are unavailable,
  report the verification gap without installing, updating, or repairing them.
- Report only reproducible findings. Do not infer a defect from an undocumented
  assumption.

## Boundaries

- Do not edit, stage, commit, create report files, install dependencies, update
  plugins, or change normal Neovim state.
- Use `make check`, not the rewriting `make all` target. Never use `make clean`
  as an audit step.

## Report

- Order findings by severity. Give each finding a `path:line`, observed and
  expected behavior, impact, and minimal fix direction.
- List the Neovim version, validation commands and results, plugin documentation
  sources and revisions checked, unchecked coverage, and other verification
  gaps. Distinguish smoke coverage from live LSP and interactive editing checks;
  report the latter as unverified unless separately exercised.
- If there are no verified findings, say so directly. Do not claim a full audit
  when required coverage is incomplete.

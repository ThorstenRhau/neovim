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
  `lua/plugins/`, `after/ftplugin/`, `Makefile`, `README.md`,
  `nvim-pack-lock.json`, and the StyLua and Selene configuration.
- Account for every plugin declared in `lua/config/pack.lua`. For each plugin
  with local options, globals, mappings, commands, or load-order requirements,
  verify the configured API against current documentation. Mark declared-only
  plugins and unavailable documentation explicitly in the coverage list.
- Prefer current Neovim `:help`, official plugin documentation, and Context7.
  Do not use memory alone for version-sensitive claims.

## Checks

- Run `make check` when its tools are available. Separate tool-availability
  failures from repository findings.
- Check startup and load order, plugin declarations and setup, keymap
  descriptions and scope, formatter/linter wiring, stale references, and
  Neovim 0.12 API usage.
- When practical, run a headless startup smoke test without installing or
  updating plugins or touching normal Neovim cache, state, or data. Otherwise
  report the gap.
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
- List validation commands and results, plugin documentation checked, unchecked
  coverage, and other verification gaps.
- If there are no verified findings, say so directly. Do not claim a full audit
  when required coverage is incomplete.

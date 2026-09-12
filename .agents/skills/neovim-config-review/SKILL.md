---
name: neovim-config-review
description: >-
  Review this repository's Neovim configuration for simplicity, correct plugin
  settings, and current Neovim API usage. Use for configuration reviews and
  audits, not implementation requests or general Neovim advice.
---

# Neovim Config Review

Review without editing configuration or changing installed packages or user
data. An unqualified request covers the whole configuration; a scoped request
covers that area and its relevant dependencies. Read `AGENTS.md`, Git status,
and the configuration before judging it.

## Priorities

1. **Simplicity first.** Prefer native behavior, direct commands, plugin defaults,
   and short configuration tables. Flag unnecessary helpers, wrappers, state,
   fallbacks, duplicate settings, and custom code that repeats built-in behavior.
   For example, keep `<leader>o` as a direct `!open` command mapping instead of
   a Lua function. Use Lua callbacks where the documented API or required behavior
   needs them. Recommend the smallest clear change that preserves the intended
   workflow and correctness; do not invent features or abstractions.
2. **Check every in-scope plugin against its documentation.** Derive the plugin
   list from `lua/plugins.lua`, including configuration elsewhere. Use Context7
   when available or read official upstream documentation online. Check options,
   functions, commands, dependencies, and setup order for deprecated, removed,
   ignored, or incorrectly used settings. Establish the reviewed revisions from
   the local lockfile and installed sources, noting any mismatch. Compare current
   guidance with those revisions so newer documentation does not create false
   findings. Do not skip plugins that use defaults; verify their setup and
   requirements too.
3. **Check Neovim itself.** Read the current official Neovim documentation and API
   specification at <https://neovim.io/doc/user/>. Check options, mappings,
   autocmds, package loading, LSP, and Tree-sitter usage against those contracts.
   Confirm applicability with `nvim --version` and matching installed `:help` or
   release documentation. Check option and mapping scope, filetype cleanup, and
   native defaults. Separate current configuration defects from upgrade advice.

## Evidence and report

Use the repository's non-rewriting checks where relevant. Inspect startup checks
before running them; do not install, update, repair, or clean runtime data during
a review. Report unavailable tools or documentation as verification gaps.

Lead with concrete findings: file and line, the unnecessary complexity or
incorrect behavior, why it matters, and the smallest fix. Cite documentation for
API and deprecation claims. Distinguish simplification suggestions from defects.
Finish with a compact list of plugins and documentation/revisions checked,
validation results, and unverified coverage, including live workflows. If there
are no findings, say so; do not claim a full review when coverage is incomplete.

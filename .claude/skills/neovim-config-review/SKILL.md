---
name: neovim-config-review
description: >-
  Reviews this repository's Neovim configuration for simplicity, correct plugin
  settings, and current Neovim API usage. Use for configuration reviews and
  audits, such as checking plugin options, deprecated APIs, or whether custom
  code repeats built-in behavior. Not for implementation requests or general
  Neovim advice.
argument-hint: "[scope]"
allowed-tools: Read, Grep, Glob, Bash(nvim --version), Bash(git status *), Bash(git diff *), Bash(git log *), Bash(make check), Bash(make lint)
disallowed-tools: Edit, Write, NotebookEdit
---

# Neovim Config Review

Review without editing configuration or changing installed packages or user
data. An unqualified request covers the whole configuration; a scoped request
covers that area and its relevant dependencies. Follow `AGENTS.md` (loaded
through `CLAUDE.md`), then read Git status and the configuration before judging
it.

## Priorities

1. **Simplicity first.** Prefer native behavior, direct commands, plugin defaults,
   and short configuration tables. Flag unnecessary helpers, wrappers, state,
   fallbacks, duplicate settings, and custom code that repeats built-in behavior.
   Use Lua callbacks where the documented API or required behavior
   needs them. Recommend the smallest clear change that preserves the intended
   workflow and correctness; do not invent features or abstractions.
2. **Check every in-scope plugin against its documentation.** Derive the plugin
   list from `lua/plugins.lua`, including configuration elsewhere. Use installed
   documentation and source first. Fall back to official upstream documentation
   online, directly or through Context7, when local information is missing or
   insufficient. Check options, functions, commands, dependencies, and setup
   order for deprecated, removed, ignored, or incorrectly used settings.
   Establish the reviewed revisions from the local lockfile and installed
   sources, noting any mismatch. Match guidance to those revisions so newer
   documentation does not create false findings. Do not skip plugins that use
   defaults; verify their setup and requirements too.
3. **Check Neovim itself.** Establish the installed version with `nvim --version`
   and use matching installed `:help` and source first. Fall back to official
   documentation at <https://neovim.io/doc/user/> or matching release documentation
   when local information is missing or insufficient. Check options, mappings,
   autocmds, package loading, LSP, and Tree-sitter usage against those contracts.
   Confirm online guidance applies to the installed version. Check option and
   mapping scope and native defaults.
   Separate current configuration defects from upgrade advice.

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

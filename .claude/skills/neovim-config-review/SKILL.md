---
name: neovim-config-review
description: >-
  Reviews this repository's Neovim configuration for simplicity, correct plugin
  settings, and current Neovim API usage. Use for configuration reviews and
  audits, such as checking plugin options, deprecated APIs, or whether custom
  code repeats built-in behavior. Not for implementation requests or general
  Neovim advice.
argument-hint: "[scope]"
allowed-tools: Read, Grep, Glob, Bash(nvim --version), Bash(git status *), Bash(git diff *), Bash(git log *), Bash(make check), Bash(make lint), Bash(make startup)
disallowed-tools: Edit, Write, NotebookEdit
---

# Neovim Config Review

Review without editing configuration or changing installed packages or user
data. An unqualified request covers the whole configuration; a scoped request
(a plugin, module, or topic) covers that area and its relevant dependencies.
Follow `AGENTS.md`, then read Git status and the in-scope configuration before
judging it.

## Where the evidence is

- Plugins: `lua/plugins.lua` declares packages, including conditional ones,
  with `vim.pack.add()`. Setup calls live there and in the other `lua/` modules.
- Revisions: `nvim-pack-lock.json` records each plugin's `rev` and version
  range. Plugins are installed in `~/.local/share/nvim/site/pack/core/opt/`;
  compare a checkout with `git -C <plugin dir> log -1 --format='%h %cs'`.
- Plugin docs and source: `doc/`, `README.md`, and the `lua/` source that sets
  defaults, in each plugin directory.
- Neovim: `nvim --version`, then help and runtime source under `$VIMRUNTIME`
  (`doc/*.txt`, `lua/vim/`). `doc/deprecated.txt` and `doc/news.txt` list
  removals and changes for the installed release.

Use these first. Fall back to official upstream documentation, directly or
through Context7, only when local information is missing or insufficient, and
confirm it matches the installed revision.

## Priorities

1. **Simplicity first.** Prefer native behavior, plugin defaults, and short
   configuration tables. Flag unnecessary helpers, wrappers, state, fallbacks,
   duplicate settings, restated defaults, and custom code that repeats built-in
   behavior; Lua callbacks are fine where the API needs them. Recommend the
   smallest clear change that keeps the intended workflow, without new features
   or abstractions. Keymaps that alias a native mapping, such as a leader key
   for a `gr*` LSP default, are deliberate muscle-memory choices; mention one
   only if it changes behavior.
2. **Check every in-scope plugin against its documentation.** For each option,
   function, command, dependency, and setup-order requirement the configuration
   uses, find it in the installed docs or source. Flag settings that are
   deprecated, removed, ignored, misspelled, or used incorrectly. Check
   requirements and load order for plugins with bare or no `setup()` too, and
   note any lockfile and checkout mismatch.
3. **Check Neovim itself.** Check options, mappings, autocmds, package loading,
   LSP, and Tree-sitter against the installed release, including buffer-local
   versus global scope and native defaults the configuration repeats.

## Evidence rule

A finding needs evidence from the installed version: a help tag, doc line, or
source location you read. If only newer upstream docs call something
deprecated, removed, or ignored, report it as upgrade advice. List suspicions
you could not confirm under unverified coverage. Report every confirmed issue,
however small; evidence, not severity, decides what is a finding.

## Process

A whole-configuration review checks every plugin in `lua/plugins.lua`. The
plugins are independent, so in Claude Code you can split them across a few
parallel subagents, giving each its configured settings, plugin paths, and the
evidence rule. Review a single plugin or module yourself.

Run `make check`; it does not rewrite files. Read the `startup` target before
running `make startup`, which loads the live configuration headlessly. Never
install, update, repair, or clean packages, parsers, or runtime data during a
review. Report unavailable tools or documentation as verification gaps.

## Report

Lead with findings, most important first, in this shape:

```markdown
## Findings

1. **[Defect|Simplification|Upgrade advice]** `file:line`: what is wrong or
   unnecessary, and why it matters.
   Evidence: help tag, doc path, or source line, with revision.
   Fix: the smallest change.

## Coverage

- Checked: Neovim version and plugin revisions, with the docs or source used.
- Checks: commands run and results.
- Unverified: plugins, claims, or live workflows not confirmed.
```

Defects are incorrect or ignored behavior; simplifications keep behavior with
less configuration; upgrade advice applies only to newer releases. If there are
no findings, say so. Do not claim a full review when coverage is incomplete.

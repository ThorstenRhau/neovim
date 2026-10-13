---
name: neovim-config-review
description: >-
  Reviews and audits this repository's Neovim configuration: every tracked
  configuration file, plugin settings against their installed docs, current
  Neovim API usage, keymaps and load order across modules, and whether the
  language servers, formatters, linters, and Tree-sitter parsers it uses are
  installed. Use for configuration reviews, audits, and health checks, such as
  finding deprecated APIs, wrong plugin options, keymap conflicts, missing
  tools, documentation drift, or custom code that repeats built-in behavior.
  Not for implementation requests or general Neovim advice.
---

# Neovim Config Review

- [Scope](#scope)
- [Inventory](#inventory)
- [Where the evidence is](#where-the-evidence-is)
- [What to check](#what-to-check)
- [Settled choices](#settled-choices)
- [Evidence rule](#evidence-rule)
- [Process](#process)
- [Report](#report)

Review without editing configuration or changing installed packages, parsers,
tools, or user data. An unqualified request is a full audit of everything
under Scope; a scoped request (a plugin, module, file, or topic) covers that
area and what it depends on. Follow `AGENTS.md`; its layout and conventions
are also audit criteria.

## Scope

A full audit starts from `git ls-files`: every tracked file is in scope except
agent configuration (`.claude/`, `.agents/`, `.codex/`, `.mcp.json`,
`CLAUDE.md`). That includes `after/ftplugin/`, the `Makefile` and Git hook,
the style and lint policy files, and `scripts/clean.lua`. Read `clean.lua`,
but never run `make clean`: it deletes the live installation. `README.md` and
`AGENTS.md` are checked for drift from what the configuration does. The
language servers, formatters, linters, and parsers the configuration uses are
in scope too.

## Inventory

Start every review with the bundled read-only inventory, run from the
repository root:

```sh
nvim --headless -V1 -i NONE -n -S .agents/skills/neovim-config-review/scripts/inventory.lua
```

It loads the live configuration and exits by itself in a few seconds. It
reports Neovim's version and startup errors; options and keymaps (global, then
buffer-local after LSP and gitsigns attach in `init.lua`) with the file:line
that set them; package revisions against `nvim-pack-lock.json`; LSP, formatter,
and linter executables; Tree-sitter parsers for the configured filetypes; and
`:checkhealth` warnings and errors. Neovim's default mappings are left out;
see `:h default-mappings`.

Use it instead of rebuilding these probes. It is evidence of the installed
state, not a list of findings: a missing executable is installation drift,
and a checkhealth warning matters only when it concerns something the
configuration uses or sets. When a question needs another headless probe,
write one Lua file in a temporary directory outside the repository, run it
with `-S`, and end it with `qa!`. Long `-c` chains hit Neovim's limit of ten,
and macOS has no `timeout` command.

## Where the evidence is

- Plugins: `lua/plugins.lua` declares packages, including conditional ones,
  with `vim.pack.add()`. Setup calls live there and in the other `lua/`
  modules. Each checkout under `~/.local/share/nvim/site/pack/core/opt/` has
  `doc/`, `README.md`, and the `lua/` source that sets defaults.
- Tools: nvim-lspconfig's `lsp/<name>.lua` holds each server's defaults;
  conform's `lua/conform/formatters/<name>.lua` and nvim-lint's
  `lua/lint/linters/<name>.lua` define each tool's command. Check server
  settings against the server's documentation for its installed version
  (`<tool> --version`).
- Neovim: help and runtime source under `$VIMRUNTIME` (`doc/*.txt`,
  `lua/vim/`). `doc/deprecated.txt` and `doc/news.txt` list removals and
  changes for the installed release.

Use these first. Fall back to official upstream documentation, directly or
through Context7, only when local information is missing or insufficient, and
confirm it matches the installed revision.

## What to check

1. **Simplicity first.** Prefer native behavior, plugin defaults, and short
   configuration tables. Flag unnecessary helpers, wrappers, state,
   fallbacks, duplicate settings, restated defaults, and custom code that
   repeats built-in behavior; Lua callbacks are fine where the API needs them.
   Recommend the smallest clear change that keeps the intended workflow,
   without new features or abstractions.
2. **Every plugin against its documentation.** For each option, function,
   command, dependency, and setup-order requirement the configuration uses,
   find it in the installed docs or source. Flag settings that are deprecated,
   removed, ignored, misspelled, or used incorrectly. Check requirements and
   load order for plugins with bare or no `setup()` too.
3. **Neovim itself.** Check options, mappings, autocmds, ftplugins, package
   loading, LSP, diagnostics, and Tree-sitter against the installed release,
   including buffer-local versus global scope and native defaults the
   configuration repeats.
4. **Across modules.** These span files and plugins, so plugin-by-plugin
   checks miss them:
   - Load order: the `require` order in `init.lua`, and setup that depends on
     something a later module defines.
   - Keymaps, from the inventory: conflicts between modules, plugins, and
     native defaults; a `desc` on every custom mapping; LSP and Git inspection
     mappings kept buffer-local; mini.clue triggers and clue groups matching
     the real prefixes, modes, and buffer-local mappings.
   - Filetypes: the FileType autocmd patterns, conform, nvim-lint, and LSP
     filetypes, the parsers in the inventory, and the `:TSInstall` list in
     `README.md` should agree. Flag entries for filetypes nothing uses.
   - Stale references: integration flags such as the `token` plugin list,
     README tool lists, and comments that name plugins, tools, or files that
     are gone or unused.
5. **Installed state.** From the inventory: missing executables or parsers,
   checkouts that differ from the lockfile, and installed packages the
   configuration no longer adds.
6. **Repository checks.** The `Makefile` targets and the Git hook do what
   `AGENTS.md` and `README.md` say; the style and lint policy files agree with
   each other and with `.editorconfig`; `scripts/clean.lua` removes only what
   `AGENTS.md` describes.

## Settled choices

These were reviewed and kept, so do not report them. If the code around one
has changed since, review it normally.

- Anything that only happens when a buffer's filetype changes after it is
  opened, or when an ftplugin is sourced again, such as `b:undo_ftplugin`
  cleanup or repeated buffer-local autocmds. That is not a workflow here.
- Leader keymaps that alias a native mapping, such as `<leader>ca` for `gra`:
  they are deliberate muscle memory. Mention one only if it changes behavior.
- `{ clear = true }` in `nvim_create_augroup()`; the `active`
  guard in the PackChanged hook, which mirrors the `vim.pack` help example;
  and the `'textobjects'` query group argument.
- The design in `AGENTS.md`: eager setup, Homebrew-managed tools without
  automatic installation, explicit parser installation, and an untracked
  lockfile. Do not suggest lazy loading, Mason, or another plugin manager.
- Missing defensive code, such as `pcall`, executable checks, or fallbacks,
  for situations outside normal workflows.

## Evidence rule

A finding needs evidence from the installed version: a help tag, doc line, or
source location you read, or inventory or probe output you ran. If only newer
upstream docs call something deprecated, removed, or ignored, report it as
upgrade advice. List suspicions you could not confirm under unverified
coverage. Report every confirmed issue, however small; evidence, not
severity, decides what is a finding, and the recommendation says whether it
is worth fixing.

## Process

1. Read Git status, run the inventory, and run `make check`; neither changes
   files.
2. Read every in-scope file yourself and do checks 3 to 6 yourself, because
   they need the whole configuration in view.
3. Check plugins against their docs. If the user asks for agents or
   parallel work, split the plugins across a few `explorer` agents. Give each
   its plugins' configuration lines with file:line, their checkout paths and
   revisions from the inventory, the evidence rule, and the settled choices,
   so it does not re-read the configuration. Ask for candidate findings in
   the report shape plus a list of what it checked. Otherwise review the
   plugins yourself.
4. Before reporting an agent's candidate, read its cited evidence and confirm
   it against the whole configuration: an agent sees only its plugins and can
   miss that another module relies on a setting.
5. Never install, update, delete, repair, or clean packages, parsers, tools,
   or runtime data: no `vim.pack.update()`, `vim.pack.del()`, `:TSInstall`,
   `:TSUpdate`, `brew`, or `make clean`. Report unavailable tools or
   documentation as verification gaps.

## Report

Lead with findings, most important first, in this shape:

```markdown
## Findings

1. **[Category]** `file:line`: what is wrong or unnecessary, and why it
   matters.
   Evidence: help tag, doc path, source line, or inventory output, with
   revision.
   Fix: the smallest change.
   Recommendation: fix or optional, with a one-line reason.

## Coverage

| Area | Status | Evidence |
| --- | --- | --- |
| `lua/options.lua` | Checked | `:h options`, Neovim 0.12.6 |
| blink.cmp `78336bc8` | Checked | `doc/blink-cmp.txt`, `lua/` config source |
| basedpyright settings | Unverified | no local docs for the installed version |

Checks: commands run and their results.
```

Categories:

- **Defect**: incorrect or ignored behavior, or a break of a rule in
  `AGENTS.md`.
- **Installation drift**: missing tools or parsers, lockfile and checkout
  mismatches, or leftover packages. These are fixed by installing or
  cleaning, not by editing the configuration.
- **Docs drift**: `README.md` or `AGENTS.md` disagrees with the
  configuration. Changing `README.md` needs the user's explicit permission.
- **Simplification**: the same behavior with less configuration.
- **Upgrade advice**: applies only to newer releases.

The coverage table has a row for each in-scope file, plugin, and external
tool group; small related files, such as the style and lint policy files, may
share a row. If there are no findings, say so. Do not claim a full review
when coverage is incomplete.

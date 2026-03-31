---
name: config-review
description: Comprehensive audit of the Neovim configuration for conventions, issues, and improvements
user-invocable: true
---

Perform a **read-only** structured audit of this Neovim configuration. Do NOT modify any files. Read everything, analyze, and produce a single markdown report.

## Setup

Before starting, read these files to understand the project:

1. `CLAUDE.md` (project conventions)
2. `lua/config/pack.lua` (vim.pack plugin declarations and require order)
3. All files in `lua/config/`
4. All files in `lua/plugins/`
5. All files in `after/ftplugin/`

## Tool Usage

Use the available tools to **verify findings before reporting**. A finding based only on grep without verification is not production-grade.

### context7 MCP (library documentation)

Use `resolve-library-id` then `query-docs` to fetch current plugin API docs. Required when:

- Verifying correct option names, types, or defaults for border/UI config (Phase 2)
- Confirming Mason package names map to the correct server/tool (Phase 4)
- Checking conform.nvim or nvim-lint API for formatter/linter configuration (Phase 4)
- Determining if two plugins have genuinely overlapping functionality (Phase 5)

### LSP tool (Lua code intelligence)

Use LSP operations (hover, go-to-definition, find-references, document-symbols) to:

- Confirm a grep match is an actual function call, not a comment or string (Phase 1)
- Trace keymap callbacks to their definitions to check for conflicts (Phase 3)
- Verify require paths resolve and function signatures are correct (Phase 4)
- Check call hierarchy when uncertain whether a module-scope variable is used (Phase 4)

## Audit Phases

Execute all 5 phases in order. For each finding, record a severity, an ID tag, the file:line reference, and a suggested fix.

### Phase 1: Static Analysis

1. Run `make all` and capture output. Report any lint or format errors.
2. Grep all Lua files for deprecated Neovim 0.12+ APIs. Use LSP hover to confirm each match is a real call (not a comment or string) before reporting:
   - `vim.lsp.buf_get_clients` (use `vim.lsp.get_clients`)
   - `vim.lsp.get_active_clients` (use `vim.lsp.get_clients`)
   - `vim.lsp.for_each_buffer_client`
   - `vim.lsp.util.trim_empty_lines`
   - `vim.lsp.util.try_trim_markdown_code_blocks`
   - `vim.lsp.util.get_effective_tabstop`
   - `vim.lsp.util.set_lines`
   - `vim.lsp.util.extract_completion_items`
   - `vim.lsp.util.parse_snippet`
   - `vim.lsp.util.text_document_completion_list_to_complete_items`
   - `vim.diagnostic.disable` (use `vim.diagnostic.enable(false)`)
   - `vim.diagnostic.is_disabled` (use `not vim.diagnostic.is_enabled`)
   - `vim.treesitter.query.get_node_text` (use `vim.treesitter.get_node_text`)
   - `vim.treesitter.query.parse_query` (use `vim.treesitter.query.parse`)
   - `vim.treesitter.query.get_query` (use `vim.treesitter.query.get`)
   - `vim.keymap.del` with wrong signature
   - `vim.api.nvim_buf_set_option` (use `vim.bo`)
   - `vim.api.nvim_win_set_option` (use `vim.wo`)
   - `vim.api.nvim_set_option` (use `vim.o` / `vim.opt`)
   - `vim.api.nvim_buf_get_option` (use `vim.bo`)
   - `vim.api.nvim_win_get_option` (use `vim.wo`)
   - `vim.api.nvim_get_option` (use `vim.o`)

### Phase 2: Convention Compliance

Check config files against CLAUDE.md conventions:

1. **desc on keymaps**: every `vim.keymap.set` call must have a `desc` field (either in the opts table or via a wrapper that passes desc).
   - Guard: local `map` wrappers that accept `desc` as a parameter (e.g., `local map = function(mode, lhs, rhs, desc)`) satisfy this requirement. Check the wrapper definition before flagging.

2. **border = 'single'**: check plugins rendering floating UI for border consistency.
   - Guard: this config sets `vim.o.winborder = 'single'` globally (Neovim 0.12+). Only flag plugins that explicitly override border to something other than `'single'`, or plugins documented to ignore `vim.o.winborder` and need explicit border config. Use context7 to verify whether a plugin respects `vim.o.winborder` before flagging.

3. **Plugin declaration vs setup separation**: plugin declarations belong in `config/pack.lua`, setup and keymaps belong in `lua/plugins/*.lua`. Flag setup calls in `pack.lua` or `vim.pack.add` calls in plugin files.
   - Guard: `vim.g.*` variables that must be set before a plugin loads (e.g., vim-matchup globals) are correctly placed in `pack.lua` before `vim.pack.add()`.

### Phase 3: Keymap Audit

1. Collect ALL keymaps from `lua/config/keymaps.lua` and all `vim.keymap.set` calls in `lua/plugins/*.lua`, plus keymaps set in LspAttach/FileType autocmd callbacks.
2. Find duplicate or conflicting bindings (same lhs in same mode).
   - Guard: buffer-local keymaps (from LspAttach, ftplugin, FileType autocmds) intentionally override global keymaps. Only flag duplicates within the same scope (both global, or both in the same buffer-attach context).
3. Identify keymaps that shadow important Neovim builtins without clear intent.
   - Guard: intentional overrides with a `desc` field are not findings. Standard overrides like `j`/`k` with `gj`/`gk`, `p` with `"_dP`, `<Esc>` with `nohlsearch` are well-known patterns. Do not flag these.
4. Check which-key registrations: verify all `<leader>` prefixes used in keymaps are registered as groups.

### Phase 4: Toolchain Coherence

1. **LSP root markers**: verify each server config in the `servers` table has `root_markers`.
   - Guard: `.git` as the sole root marker is acceptable for file-level servers (bashls, fish_lsp, lemminx, taplo). Only flag missing root markers for project-oriented servers that need project-level context (basedpyright, vtsls, eslint, lua_ls, etc.).

2. **Mason cross-reference**: cross-reference `mason-tool-installer` `ensure_installed` list against:
   - Servers configured in the LSP `servers` table (use Mason-to-server name mapping, e.g., `bash-language-server` maps to `bashls`)
   - Formatters referenced in conform.nvim `formatters_by_ft`
   - Linters referenced in nvim-lint `linters_by_ft`
   - Flag tools in Mason not referenced anywhere, or tools referenced but not in Mason.
   - Guard: tools that are system-installed or bundled with an LSP server (e.g., ruff provides both linting and formatting) should not be flagged as missing from Mason.

3. **Ftplugin helper consistency**: check that `after/ftplugin/*.lua` files use `require('config.ftplugin')` helper consistently.
   - Guard: `expandtab = false` (tabs) cannot be set via the indent helper, so files like `make.lua` that set tabs manually are correct. Only flag files that set `tabstop`/`shiftwidth`/`softtabstop` manually when the helper's `.indent(N)` would work.

4. **Textobject symmetry**: if `@function.outer` exists as a keymap, `@function.inner` should too. Same for `@class` and `@parameter`.

5. **Augroup hygiene**: check all `nvim_create_autocmd` calls use a named `nvim_create_augroup`.
   - Guard: `clear = false` is correct when multiple autocmds intentionally share a group across different events. Only flag autocmds with no group at all.

6. **Global state**: flag non-local variables in module scope.
   - Guard: accessing documented globals (`vim`, `MiniIcons`, `MiniStatusline`) is correct. Only flag when a module-scope variable lacks `local` and is not an access to a known global.

7. **Require path validity**: verify that all `require()` calls in `lua/plugins/*.lua` resolve to installed plugins (present in `vim.pack.add` list in `config/pack.lua`) or local modules.

### Phase 5: Plugin Health

1. **Redundant plugins**: look for plugins with overlapping functionality that are both loaded.
   - Use context7 to verify overlap claims. Two plugins in the same domain (e.g., file explorers, autopairs, surround) are only redundant if they are both actively loaded and serve the same use case.

2. **Startup impact**: since all plugins load eagerly via `vim.pack` (no lazy-loading), flag plugins that are heavy at startup but only needed for specific filetypes or commands.
   - Guard: only flag if the plugin is demonstrably heavy (large init cost) AND has a clear trigger (filetype, command, keymap). Do not flag plugins that need to be available immediately (completion, statusline, icons, keymaps).

3. **Completion keymap conflicts**: check that blink.cmp keymaps do not conflict with other insert-mode keymaps.
   - Use context7 to look up the blink.cmp keymap preset and compare against insert-mode keymaps from `lua/config/keymaps.lua` and `lua/plugins/*.lua`.

4. **PackChanged hook coverage**: verify that `PackChanged` autocmd in `pack.lua` covers plugins that need post-install/update build steps.
   - Guard: only flag plugins that document a required build step (e.g., `TSUpdate` for treesitter, `MasonUpdate` for mason). Do not flag plugins that work without build steps.

## Output Format

Produce a single markdown report with this structure:

```markdown
# Neovim Config Audit Report

## Summary

| Severity | Count |
|----------|-------|
| Critical | X     |
| Warning  | X     |
| Info     | X     |

## Critical

### [C-01] Title
- **File**: `path/to/file.lua:42`
- **Issue**: Description of the problem
- **Fix**: Suggested resolution

## Warnings

### [W-01] Title
- **File**: `path/to/file.lua:10`
- **Issue**: Description
- **Fix**: Suggested resolution

## Info

### [I-01] Title
- **File**: `path/to/file.lua:5`
- **Issue**: Description
- **Suggestion**: Optional improvement
```

## Severity Definitions

- **Critical**: broken functionality right now. Runtime errors. `make all` failures.
- **Warning**: convention violations from CLAUDE.md. Toolchain mismatches (Mason vs configured tools). Duplicate keymaps in the same scope. Deprecated APIs (still functional but should be updated).
- **Info**: consistency improvements, minor opportunities. Not wrong, just could be better.

## Rules

1. Do NOT modify any files. This is a read-only audit.
2. Do NOT create any files (no reports saved to disk).
3. Use context7 MCP (`resolve-library-id` then `query-docs`) to verify plugin APIs when uncertain about correct configuration.
4. Use the LSP tool to verify grep matches are real code, not comments or strings.
5. Be specific: always include file:line references.
6. Do not flag intentional design choices as issues (e.g., all plugins loading eagerly is intentional with vim.pack, pre-load globals in pack.lua are correct).
7. Group related findings under the same ID if they share a root cause.
8. **Zero false positives is more important than coverage.** If a check might flag correct code, skip the finding rather than report it. The user can request deeper investigation.
9. **Do not report the absence of optional features.** Missing pcall around non-optional requires, missing ftplugin for a filetype, missing treesitter parser for an LSP server: none of these are findings unless they cause a concrete problem.

---
name: config-review
description: Comprehensive audit of the Neovim configuration for conventions, issues, and improvements
user-invocable: true
---

Perform a **read-only** structured audit of this Neovim configuration. Do NOT modify any files. Read everything, analyze, and produce a single markdown report.

## Setup

Before starting, read these files to understand the project:

1. `CLAUDE.md` (project conventions)
2. `init.lua` (entry point: background, leaders, module load order)
3. `lua/config/pack.lua` (vim.pack plugin declarations and require order)
4. All files in `lua/config/`
5. All files in `lua/plugins/`
6. All files in `lua/claude-theme/` (bundled colorscheme: palette, highlight groups)
7. All files in `after/ftplugin/`
8. `Makefile`, `selene.toml`, `selene_mini.yml` (validation toolchain config)

## Tool Usage

Use the available tools to **verify findings before reporting**. A finding based only on grep without verification is not production-grade.

### context7 MCP (library documentation)

Use `resolve-library-id` then `query-docs` to fetch current plugin API docs. Required when:

- Verifying correct option names, types, or defaults for border/UI config (Phase 2)
- Verifying mini.clue trigger and clue configuration API (Phase 3)
- Checking blink.cmp default keymaps for the configured preset when analyzing insert-mode conflicts (Phase 3/5)
- Confirming Mason package names map to the correct server/tool (Phase 4)
- Checking conform.nvim or nvim-lint API for formatter/linter configuration (Phase 4)
- Confirming Neovim 0.12 internal module paths like `vim._core.ui2` are still valid (Phase 4)
- Determining if two plugins have genuinely overlapping functionality (Phase 5)

### LSP tool (Lua code intelligence)

Use LSP operations (hover, go-to-definition, find-references, document-symbols) to:

- Confirm a grep match is an actual function call, not a comment or string (Phase 1)
- Trace keymap callbacks to their definitions to check for conflicts (Phase 3)
- Verify require paths resolve and function signatures are correct (Phase 4)
- Check call hierarchy when uncertain whether a module-scope variable is used (Phase 4)

## Audit Phases

Execute all 6 phases in order. For each finding, record a severity, an ID tag, the file:line reference, and a suggested fix.

### Phase 1: Static Analysis

1. Run `make all` and capture output. Report any lint or format errors.
2. Grep all Lua files for deprecated Neovim 0.12+ APIs. Use LSP hover to confirm each match is a real call (not a comment or string) before reporting:

   **vim.lsp:**
   - `vim.lsp.buf_get_clients` (use `vim.lsp.get_clients`)
   - `vim.lsp.get_active_clients` (use `vim.lsp.get_clients`)
   - `vim.lsp.for_each_buffer_client`
   - `vim.lsp.start_client` (use `vim.lsp.start`)
   - `vim.lsp.stop_client` (use `client:stop()`)
   - `vim.lsp.buf_attach_client` (use `vim.lsp.buf_attach`)
   - `vim.lsp.buf_detach_client` (use `vim.lsp.buf_detach`)
   - `vim.lsp.buf.formatting` (removed, use `vim.lsp.buf.format()`)
   - `vim.lsp.buf.formatting_sync` (removed, use `vim.lsp.buf.format()`)
   - `vim.lsp.buf.range_formatting` (removed, use `vim.lsp.buf.format({range=...})`)

   **vim.lsp.util:**
   - `vim.lsp.util.trim_empty_lines`
   - `vim.lsp.util.try_trim_markdown_code_blocks`
   - `vim.lsp.util.get_effective_tabstop`
   - `vim.lsp.util.set_lines`
   - `vim.lsp.util.extract_completion_items`
   - `vim.lsp.util.parse_snippet`
   - `vim.lsp.util.text_document_completion_list_to_complete_items`

   **vim.diagnostic:**
   - `vim.diagnostic.disable` (use `vim.diagnostic.enable(false)`)
   - `vim.diagnostic.is_disabled` (use `not vim.diagnostic.is_enabled`)
   - `vim.diagnostic.goto_next` (use `vim.diagnostic.jump({count=1})`)
   - `vim.diagnostic.goto_prev` (use `vim.diagnostic.jump({count=-1})`)
   - `vim.diagnostic.get_next` (deprecated)
   - `vim.diagnostic.get_prev` (deprecated)
   - `vim.diagnostic.get_next_pos` (deprecated)
   - `vim.diagnostic.get_prev_pos` (deprecated)

   **vim.treesitter:**
   - `vim.treesitter.query.get_node_text` (use `vim.treesitter.get_node_text`)
   - `vim.treesitter.query.parse_query` (use `vim.treesitter.query.parse`)
   - `vim.treesitter.query.get_query` (use `vim.treesitter.query.get`)

   **vim.api (option accessors):**
   - `vim.api.nvim_buf_set_option` (use `vim.bo`)
   - `vim.api.nvim_win_set_option` (use `vim.wo`)
   - `vim.api.nvim_set_option` (use `vim.o` / `vim.opt`)
   - `vim.api.nvim_buf_get_option` (use `vim.bo`)
   - `vim.api.nvim_win_get_option` (use `vim.wo`)
   - `vim.api.nvim_get_option` (use `vim.o`)

   **Other:**
   - `vim.keymap.del` with wrong signature
   - `vim.tbl_flatten` (use `vim.iter(t):flatten():totable()`)
   - `vim.tbl_islist` (use `vim.islist`)
   - `vim.tbl_add_reverse_lookup` (removed in 0.12)
   - `vim.loop` (use `vim.uv`)

### Phase 2: Convention Compliance

Check config files against CLAUDE.md conventions:

1. **desc on keymaps**: every `vim.keymap.set` call must have a `desc` field (either in the opts table or via a wrapper that passes desc).
   - Guard: local `map` wrappers that accept `desc` as a parameter (e.g., `local map = function(mode, lhs, rhs, desc)`) satisfy this requirement. Check the wrapper definition before flagging.

2. **border = 'single'**: check plugins rendering floating UI for border consistency.
   - Guard: this config sets `vim.o.winborder = 'single'` globally (Neovim 0.12+). Only flag plugins that explicitly override border to something other than `'single'`, or plugins documented to ignore `vim.o.winborder` and need explicit border config. Use context7 to verify whether a plugin respects `vim.o.winborder` before flagging.

3. **Plugin declaration vs setup separation**: plugin declarations belong in `config/pack.lua`, setup and keymaps belong in `lua/plugins/*.lua`. Flag setup calls in `pack.lua` or `vim.pack.add` calls in plugin files.
   - Guard: `vim.g.*` variables that must be set before a plugin loads (e.g., vim-matchup globals) are correctly placed in `pack.lua` before `vim.pack.add()`.

4. **Modern API patterns**: grep for legacy Vim-style Lua patterns that have idiomatic replacements:
   - `vim.api.nvim_set_keymap` should be `vim.keymap.set`
   - `vim.cmd('autocmd` or `vim.cmd("autocmd` should be `vim.api.nvim_create_autocmd`
   - `vim.cmd('augroup` or `vim.cmd("augroup` should be `vim.api.nvim_create_augroup`
   - `vim.cmd('highlight` or `vim.cmd("highlight` should be `vim.api.nvim_set_hl`
   - `vim.cmd('set ` or `vim.cmd("set ` should use `vim.o` / `vim.opt`
   - Guard: `vim.cmd.colorscheme()` and other `vim.cmd.*` calls that have no Lua API equivalent are not findings. Only flag the specific patterns above.

### Phase 3: Keymap Audit

1. Collect ALL keymaps from `lua/config/keymaps.lua` and all `vim.keymap.set` calls in `lua/plugins/*.lua`, plus keymaps set in LspAttach/FileType autocmd callbacks.
2. Find duplicate or conflicting bindings (same lhs in same mode).
   - Guard: buffer-local keymaps (from LspAttach, ftplugin, FileType autocmds) intentionally override global keymaps. Only flag duplicates within the same scope (both global, or both in the same buffer-attach context).
3. Identify keymaps that shadow important Neovim builtins without clear intent.
   - Guard: intentional overrides with a `desc` field are not findings. Standard overrides like `j`/`k` with `gj`/`gk`, `p` with `"_dP`, `<Esc>` with `nohlsearch` are well-known patterns. Do not flag these.
4. Check mini.clue coverage: verify all `<leader>` prefixes used in keymaps have a corresponding clue entry in `mini.clue` setup (the `clues` table with `desc = '+...'`). Also verify all mini.clue leader-prefix clues have at least one keymap that uses them.
   - Guard: built-in triggers (marks, registers, `g`, `z`, `<C-w>`, `[`, `]`) provided via `gen_clues.*()` do not need manual keymap coverage. Only check `<Leader>` prefix clues against actual keymaps.

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

8. **Diagnostic symbol consistency**: verify that `config/constants.lua` diagnostic symbols are used consistently everywhere they appear (LSP `signs.text`, statusline `section_diagnostics`, and any other references). Flag locations that hardcode symbol values instead of referencing the constants module.

9. **Neovim 0.12 feature usage**: verify bleeding-edge APIs are called correctly. Use context7 to confirm current signatures:
   - `vim.pack.add()` in `config/pack.lua`: verify table structure matches current API
   - `vim.lsp.config[]` / `vim.lsp.enable()` in `plugins/lsp.lua`: verify config keys are valid
   - `vim.ui.progress_status()` in `plugins/mini.lua`: verify return type handling
   - `require('vim._core.ui2').enable()` in `config/options.lua`: verify this internal module path is still valid (underscore-prefixed modules may change between releases)
   - Guard: do not flag usage of stable 0.12 options (`winborder`, `pumborder`, `pummaxwidth`). Only flag API calls where the signature or module path may have changed.

10. **Filetype coverage cross-reference**: compare these four lists for gaps:
    - Treesitter parsers (listed in `plugins/treesitter.lua`)
    - Ftplugin files (in `after/ftplugin/`)
    - LSP server filetypes (from the `servers` table in `plugins/lsp.lua`)
    - Formatters/linters filetypes (from `plugins/format.lua`)
    - Guard: not every filetype needs all four. Only flag when a filetype has an LSP server or formatter configured but no ftplugin (missing indent/treesitter settings), or when a ftplugin references treesitter features but the parser is not in the install list. Do not flag ftplugins that exist without a matching LSP server or formatter (some exist purely for indent settings, e.g., `editorconfig`, `diff`, `gitignore`).

### Phase 5: Plugin Health

1. **Redundant plugins**: look for plugins with overlapping functionality that are both loaded. Specifically investigate: `oil.nvim` and `nvim-tree.lua` are both file explorers in `config/pack.lua`. Determine whether both serve distinct purposes (e.g., oil for editing, nvim-tree for sidebar navigation) or whether one is vestigial.
   - Use context7 to verify overlap claims. Two plugins in the same domain (e.g., file explorers, autopairs, surround) are only redundant if they are both actively loaded and serve the same use case. If both are used but for different workflows, report as Info, not Warning.

2. **Startup impact**: since all plugins load eagerly via `vim.pack` (no lazy-loading), flag plugins that are heavy at startup but only needed for specific filetypes or commands.
   - Guard: only flag if the plugin is demonstrably heavy (large init cost) AND has a clear trigger (filetype, command, keymap). Do not flag plugins that need to be available immediately (completion, statusline, icons, keymaps).

3. **Completion keymap conflicts**: check that blink.cmp keymaps do not conflict with other insert-mode keymaps.
   - Use context7 to look up the blink.cmp keymap preset and compare against insert-mode keymaps from `lua/config/keymaps.lua` and `lua/plugins/*.lua`.

4. **PackChanged hook coverage**: verify that `PackChanged` autocmd in `pack.lua` covers plugins that need post-install/update build steps.
   - Guard: only flag plugins that document a required build step (e.g., `TSUpdate` for treesitter, `MasonUpdate` for mason). Do not flag plugins that work without build steps.

### Phase 6: Colorscheme Integrity

1. **Stale plugin highlight groups**: compare the comment-delimited plugin sections in `lua/claude-theme/groups/plugins.lua` against plugins listed in `config/pack.lua`. Flag highlight group sections for plugins that are not installed.
   - Guard: groups that match Neovim built-in highlight namespaces (e.g., `Diagnostic*`, `LspReference*`) belong in `base.lua`, not `plugins.lua`, and should not be flagged.

2. **Missing plugin highlight groups**: for each plugin in `config/pack.lua` that defines custom highlight groups, check whether `plugins.lua` has a section for it. Use context7 to look up the plugin's highlight group names.
   - Guard: plugins that only use built-in highlight groups or link to standard groups (e.g., `friendly-snippets`, `schemastore.nvim`, `plenary.nvim`) do not need entries in `plugins.lua`. Only flag plugins that define their own highlight namespace.

3. **Palette key validity**: verify that every `p.*` reference in all `groups/*.lua` files corresponds to a key that exists in both the dark and light tables in `palette.lua`.

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

---
name: config-review
description: Comprehensive audit of the Neovim configuration for conventions, issues, and improvements
user-invocable: true
---

Perform a **read-only** structured audit of this Neovim configuration. Do NOT modify any files. Read everything, analyze, and produce a single markdown report.

## Setup

Before starting, read these files to understand the project:

1. `CLAUDE.md` (project conventions)
2. `lua/config/lazy.lua` (plugin manager setup, note `defaults.lazy = false`)
3. All files in `lua/config/`
4. All files in `lua/plugins/`
5. All files in `after/ftplugin/`

## Audit Phases

Execute all 10 phases in order. For each finding, record a severity, an ID tag, the file:line reference, and a suggested fix.

### Phase 1: Static Analysis

1. Run `make all` and capture output. Report any lint or format errors.
2. Grep all Lua files for deprecated Neovim 0.11+ APIs:
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

Check all plugin specs and config files against CLAUDE.md conventions:

1. **desc on keymaps**: every `vim.keymap.set` and every `keys = {}` entry in plugin specs must have a `desc` field.
2. **opts over config**: flag any plugin spec using `config = function()` that could use `opts = {}` instead. Only allow `config` when it needs conditional logic or multiple function calls.
3. **border = 'single'**: any plugin that renders floating UI should set `border = 'single'`. Check completion, LSP hover/signature, pickers, trouble, neogit, diffview, etc.
4. **Lazy-load triggers**: since `defaults.lazy = false`, every plugin without an explicit `event`, `cmd`, `keys`, or `ft` trigger loads at startup. Flag plugins that could be lazy-loaded.
5. **Style**: single quotes, trailing commas, 2-space indent (StyLua handles this, but flag any manual violations).

### Phase 3: Keymap Audit

1. Collect ALL keymaps from `lua/config/keymaps.lua` and all plugin spec `keys = {}` tables.
2. Find duplicate or conflicting bindings (same lhs in same mode).
3. Identify keymaps that shadow important Neovim builtins without clear intent.
4. Check which-key spec registrations: are all `<leader>` prefixes documented?

### Phase 4: LSP Configuration

1. Verify each LSP server config has appropriate root markers (`root_markers` or `root_dir`).
2. Check that blink.cmp capabilities are propagated to LSP servers.
3. Cross-reference Mason `ensure_installed` list against:
   - Servers configured in LSP setup
   - Formatters referenced in conform.nvim
   - Linters referenced in nvim-lint
4. Flag Mason tools that are installed but not referenced, or referenced but not installed.
5. Check for deprecated LSP API patterns.

### Phase 5: Plugin Health

1. Look for potentially redundant plugins (overlapping functionality).
2. Check that lazy-load events make sense (e.g., `BufReadPre` vs `VeryLazy` vs `BufEnter`).
3. Verify declared `dependencies` are actually needed and present.
4. Check for plugins that declare dependencies on things already loaded unconditionally.

### Phase 6: Performance

1. List all plugins that load at startup (no lazy trigger, given `defaults.lazy = false`).
2. Flag plugins that could safely be deferred.
3. Check autocmds for expensive patterns (e.g., `*` pattern with heavy callbacks, missing buffer-local cleanup).
4. Check for disabled builtins in options (e.g., builtin plugins like netrw, matchparen).

### Phase 7: Filetype Plugins

1. Check `after/ftplugin/` for consistency:
   - Are indent sizes consistent per language? Expected: 2 for lua/yaml/json/html/css/nix, 4 for python/rust/go, tab for make/go.
   - Do all ftplugin files use the helper from `lua/config/ftplugin.lua` if one exists?
2. For each LSP server configured, check if there is a corresponding ftplugin.
3. Flag missing ftplugins for common filetypes that have configured LSP servers.

### Phase 8: Treesitter

1. List Treesitter `ensure_installed` parsers.
2. Cross-reference against LSP servers: flag languages with an LSP server but no Treesitter parser, and vice versa.
3. Check textobject definitions for symmetry (if `@function.outer` exists, `@function.inner` should too).

### Phase 9: Completion

1. Review blink.cmp source configuration.
2. Verify LSP capabilities include completion snippets if a snippet source is configured.
3. Check that completion keymaps don't conflict with other insert-mode bindings.

### Phase 10: Code Quality

1. Check that all autocmds use named `vim.api.nvim_create_augroup` with `clear = true`.
2. Flag unnecessary global state (non-local variables in module scope).
3. Look for missing pcall/error handling around operations that can fail (e.g., `require` in optional contexts).
4. Identify code that could be simplified.

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

- **Critical**: broken functionality, security issues, deprecated APIs that will break on upgrade
- **Warning**: convention violations, missing best practices, potential performance issues
- **Info**: suggestions for improvement, minor inconsistencies, nice-to-haves

## Rules

1. Do NOT modify any files. This is a read-only audit.
2. Do NOT create any files (no reports saved to disk).
3. Use context7 MCP (`resolve-library-id` then `query-docs`) to verify plugin APIs when uncertain about correct configuration.
4. Be specific: always include file:line references.
5. Do not flag intentional design choices as issues (e.g., `defaults.lazy = false` is intentional, but plugins that could benefit from lazy triggers should still be noted as Info).
6. Group related findings under the same ID if they share a root cause.

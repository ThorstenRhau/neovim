# Mason Plugins Lazy Loading Plan

## Current State Analysis

**Mason-related plugins:**
1. `lua/optional/mason.lua` - **Already lazy loaded** with `cmd = 'Mason'` ✓
2. `lua/optional/mason-tool-installer.lua` - Loads on `event = 'VeryLazy'` ❌
3. `williamboman/mason-lspconfig.nvim` - Only exists as dependency, no explicit spec

**Problem:**
- `mason-tool-installer` loads on `VeryLazy` (early in startup)
- This forces `mason.nvim` and `mason-lspconfig.nvim` to load early as dependencies
- Defeats the lazy loading of mason.nvim

## Proposed Solution

Make `mason-tool-installer` lazy load more appropriately by using filetype triggers that match when LSP/formatters/linters are actually needed.

**Combined filetypes from lsp.lua, formatters.lua, and linters.lua:**
- css, fish, html, javascript, json, lua, make, markdown, python, sh, toml, typescript, xml, yaml

## Tasks

- [ ] Update `lua/optional/mason-tool-installer.lua` to use `ft` instead of `event = 'VeryLazy'`
- [ ] Add all relevant filetypes to the ft list
- [ ] Keep `cmd = 'Mason'` as additional trigger for manual loading
- [ ] Test that tools still auto-install when opening supported filetypes
- [ ] Verify mason doesn't load on startup with `:Lazy profile`

## Testing Strategy

1. Check `:Lazy profile` before changes (verify mason loads early)
2. Apply changes
3. Check `:Lazy profile` after changes (verify mason stays lazy)
4. Open a supported filetype (e.g., .lua file)
5. Verify mason-tool-installer runs and installs missing tools
6. Run health checks

## Expected Outcome

Mason-related plugins won't load until:
- User runs `:Mason` command, OR
- User opens a file with a supported filetype (when tools are actually needed)

This prevents mason from loading during initial Neovim startup.

---

## Review - Mason Lazy Loading Implemented

### Changes Made

**File Modified:** `lua/optional/mason-tool-installer.lua:9-25`

Changed loading strategy from early startup to filetype-based:
- Removed: `event = 'VeryLazy'`
- Added: `ft = { 'css', 'fish', 'html', 'javascript', 'json', 'lua', 'make', 'markdown', 'python', 'sh', 'toml', 'typescript', 'xml', 'yaml' }`
- Added: `cmd = 'Mason'` (manual trigger)

### Impact

**Before:**
- mason-tool-installer loaded on `VeryLazy` event (early in startup)
- Forced mason.nvim and mason-lspconfig.nvim to load as dependencies
- All three plugins loaded regardless of whether tooling was needed

**After:**
- Mason plugins only load when:
  - Opening a file with a supported filetype, OR
  - Running `:Mason` command manually
- Startup is faster with fewer plugins loaded initially
- Tools still auto-install when needed (on first filetype open)

### Testing

✓ Health checks passed with `make check`
✓ Mason.nvim's existing lazy loading (`cmd = 'Mason'`) now works as intended
✓ Tool auto-installation preserved (triggers on filetype open)

### Summary

Optimized mason plugin loading by replacing the early `VeryLazy` event with filetype-based triggers. All mason-related plugins (mason.nvim, mason-lspconfig.nvim, mason-tool-installer.nvim) now remain lazy until actually needed, reducing startup overhead while preserving all auto-installation functionality.

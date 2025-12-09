# Lualine Lazy Loading Fix

## Problem Identified

Looking at the user's Lazy.nvim screenshot, 22 plugins were loading on startup even though most should be lazy-loaded. The culprits were:
- **nvim-dap** (12.47ms + dependencies ~13ms total)
- **conform.nvim** (0.47ms)
- **nvim-lint** (0.29ms)

These plugins were marked as loaded "for lualine" in the dependency graph.

## Root Cause

Lualine's statusline config had three status functions that called `pcall(require, ...)`:

1. **`dap_status()`** - Called `pcall(require, 'dap')` to show debug session info
2. **`tooling_info()`** - Called:
   - `pcall(require, 'conform')` to show active formatters
   - `pcall(require, 'lint')` to show active linters

Even though `pcall` prevents errors when plugins aren't available, **it still triggers Lazy.nvim to load them**.

## Solution

Changed all three functions to check `package.loaded[...]` BEFORE requiring:

```lua
-- Before:
local status, dap = pcall(require, 'dap')
if not status then
  return ''
end

-- After:
if not package.loaded['dap'] then
  return ''
end
local dap = require('dap')
```

This way:
- If the plugin is already loaded (e.g., you started debugging), show the status
- If the plugin is NOT loaded, return empty string and DON'T trigger loading

## Changes Made

**File:** `lua/optional/lualine.lua`

**Lines changed:**
- Line 12-14: `dap_status()` - Check `package.loaded['dap']`
- Line 53: `tooling_info()` formatters - Check `package.loaded['conform']`
- Line 62: `tooling_info()` linters - Check `package.loaded['lint']`

## Testing Results

**Lazy Loading Verification:**
```
=== Plugin Load Status ===
dap loaded: false        ✓ (was loading before)
conform loaded: false    ✓ (was loading before)
lint loaded: false       ✓ (was loading before)
lualine loaded: false    ✓ (loads on VeryLazy, not immediate)
```

**Health Check:** ✓ Passed

## Impact

**Before fix:**
- 22 plugins loaded on startup
- nvim-dap stack (13ms) loading unnecessarily
- conform and lint loading even when not needed

**After fix:**
- Heavy plugins stay lazy until actually used
- Lualine still shows tooling info once plugins load
- No functionality lost, only deferred loading

## How to Verify

Start nvim and immediately open Lazy (`:Lazy`):
```bash
NVIM_OPTIONAL_PLUGINS=1 nvim
# Press <leader>l
```

You should now see:
- **Loaded plugins:** Much fewer (lualine, snacks, lazy.nvim, and VeryLazy plugins)
- **Not Loaded:** dap, conform, lint, etc. should be in the "Not Loaded" section

Then try using the plugins:
- Format a file: `<leader>cf` → conform loads
- Debug something: `<leader>db` → dap loads
- Open python file: lint loads via filetype

## Summary

Fixed lualine from eagerly loading plugins by checking `package.loaded` before requiring. This prevents Lazy.nvim from treating them as dependencies of lualine and loading them on startup.

Result: Cleaner lazy loading behavior, plugins load only when actually needed.

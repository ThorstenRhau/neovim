# Debugger Loading Strategy Analysis

## Current State

**File:** `lua/optional/debuggers.lua`

**Loading Strategy:** Key-based lazy loading only
- Loads when any `<leader>d*` keymap is pressed (15+ keymaps)
- Uses `nvim-dap`, `nvim-dap-ui`, `mason-nvim-dap`, `nvim-dap-virtual-text`

## Installed Debug Adapters

From `mason-tool-installer.lua`:
- **bash-debug-adapter** → sh, bash files
- **debugpy** → python files

## Debuggable Filetypes

Based on installed adapters:
- `python` (debugpy)
- `sh` (bash-debug-adapter)

## Comparison: Key-Based vs Filetype-Based Loading

### Option 1: Current Approach (Key-Based Only) ✓

**Pros:**
- Loads ONLY when you actually want to debug
- No wasted resources if you edit python/bash files without debugging
- Debugging is typically infrequent compared to editing
- Simple, single trigger point

**Cons:**
- Small delay on first debug keymap press while plugin loads
- Not pre-loaded when opening debuggable files

**Use Case Fit:**
- OPTIMAL if you edit python/sh files frequently but debug rarely
- OPTIMAL if you want minimal resource usage

### Option 2: Filetype-Based Loading

**Configuration:**
```lua
ft = { 'python', 'sh' },
keys = { ... }, -- Keep as fallback
```

**Pros:**
- Pre-loads when opening debuggable files
- No delay when pressing debug keymaps
- More convenient if you debug frequently

**Cons:**
- Loads DAP stack even if you're just editing (not debugging)
- Python/shell files are commonly edited without debugging
- Wastes resources on non-debug workflows
- DAP + UI + virtual-text is a relatively heavy stack

**Use Case Fit:**
- BETTER if you debug python/sh files in most editing sessions
- WORSE if you frequently edit these files without debugging

### Option 3: Hybrid Approach (NOT RECOMMENDED)

Add both `ft` and `keys` triggers.

**Why Not:**
- Defeats the purpose of lazy loading
- Loads unnecessarily on file open
- The key-based fallback becomes redundant

## Resource Analysis

**DAP Stack Weight:**
- nvim-dap (core debugger)
- nvim-dap-ui (UI overlay)
- nvim-dap-virtual-text (inline values)
- mason-nvim-dap (adapter manager)
- nvim-nio (async library)

This is a **moderately heavy** stack that:
- Sets up UI components
- Configures event listeners
- Defines signs and highlights
- Initializes mason integration

## Recommendation

**Keep current key-based loading strategy.**

**Reasoning:**
1. Python and shell files are frequently edited without debugging
2. The delay on first keymap press is acceptable for debugging workflows
3. Debugging is typically a deliberate action (you know when you need it)
4. Current approach minimizes resource usage
5. DAP stack is heavy enough that loading it on every python/sh file would be wasteful

**When Filetype Loading Would Make Sense:**
- If you have a dedicated "debugging session" workflow
- If you primarily open python/sh files TO debug them
- If the debug keymap delay is problematic for your workflow

## Conclusion

**No changes recommended.** The current key-based lazy loading is already optimal for the typical use case where editing is frequent and debugging is occasional.

If you want to test filetype loading, you can easily add `ft = { 'python', 'sh' }` to the spec, but be aware you'll load the DAP stack on every python/shell file you open.

# Neovim Config Audit Checks

Use this checklist as review guidance, not as a mandate to report unverified issues. Findings need current file or command evidence.

## Static Validation

- Run `make check` when available. It should run Selene and StyLua check mode.
- If `make check` fails, separate tool availability failures from real repo failures.
- Check `Makefile` paths and command names against the repo shape: `init.lua`, `lua/`, and `after/`.
- Confirm `.stylua.toml`, `selene.toml`, and `selene_mini.yml` match the validation commands.
- Treat malformed Lua, startup errors, broken validation commands, and missing required tools as high priority when they affect normal editing.

## Repo Conventions

- Use `AGENTS.md` as the Codex instruction source.
- Keep `.codex/config.toml` limited to repo-specific Codex configuration.
- Do not reference or recreate obsolete assistant files such as `CLAUDE.md` or `.claude/`.
- Keep plugin declarations in `lua/config/pack.lua`.
- Keep plugin setup and plugin-specific keymaps in `lua/plugins/*.lua`.
- Keep heavier filetype-specific logic in `after/ftplugin/`.
- Do not introduce another plugin manager; this repo uses `vim.pack.add()`.

## Keymaps

- Every keymap should include `desc`.
- Check mappings for duplicate left-hand sides in the same mode unless the override is intentional.
- Respect existing leader group names and local naming style.
- Check filetype-specific keymaps for appropriate buffer-local scope.
- Treat invalid keymap modes, malformed options, and startup-breaking mappings as high priority.

## Toolchain Coherence

- Formatter references should use `lua/plugins/formatter.lua`.
- Linter references should use `lua/plugins/linter.lua`.
- Validation references should use `make check`, not `make all`.
- Stale references in README, AGENTS, Codex config, plugin modules, or workflow docs are findings when they would mislead future edits.
- External formatters, linters, and LSP servers are installed outside this repo, usually with Homebrew. Do not assume Mason or another plugin manager unless current files prove it.

## Plugin Health

- Cross-check each `vim.pack.add()` entry in `lua/config/pack.lua` with setup modules in `lua/plugins/`.
- For each plugin configuration issue, verify the option names, value types, defaults, renamed fields, and deprecations against current plugin docs.
- Prefer Context7 MCP results, official plugin README/help docs, or upstream internet documentation. If docs are unavailable, report the verification gap instead of guessing.
- Check `PackChanged` hooks near plugin declarations when plugins require build/update steps.
- Confirm deferred loading through `lua/config/defer.lua` is coherent with plugin setup timing.
- Treat missing required setup, invalid module names, and plugin load ordering that can break startup as high priority.
- Use plugin README docs, Context7, or upstream internet documentation before claiming current plugin API incompatibility or invalid configuration parameters.

## Delegation Slices

Use sub-agents for these read-only slices only when the review is broad and parallel work is allowed:

- Keymaps: duplicate mappings, missing `desc`, mode mistakes, and buffer-local scope.
- Plugin docs: one plugin or a small plugin group, checking option names, value types, defaults, renamed fields, and deprecations.
- Stale references: obsolete assistant files, old module names, old validation commands, and old plugin managers.
- Toolchain: `Makefile`, StyLua, Selene, and config-path coherence.
- Runtime/API claims: Neovim help, Context7, plugin README docs, or upstream docs for unstable behavior.

Do not accept delegated results directly. Re-check the file evidence and documentation source before reporting.

## Stale-Reference Checks

Search for obsolete or misleading references:

- `CLAUDE.md`
- `.claude/`
- `format.lua`
- `lint.lua`
- `make all`
- old plugin manager names such as `lazy.nvim`, `packer.nvim`, or `vim-plug`
- obsolete plugin paths or renamed commands

Only report these when the reference exists and can mislead current work.

## Neovim 0.12 API Usage

- Prefer current Neovim help, official docs, plugin README docs, or Context7 for unstable API behavior.
- Validate claims involving `vim.pack`, LSP APIs, diagnostics, Treesitter, and autocmd behavior.
- Distinguish compatibility issues from intentional Neovim 0.12-only usage.
- Record assumptions when the local runtime or docs cannot be checked.

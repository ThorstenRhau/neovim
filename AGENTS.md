# AGENTS.md - Neovim Configuration

Personal Neovim config in Lua. Requires Neovim 0.12+.

## Project Shape

- `init.lua` is the entry point. It sets leaders and loads `lua/config/`.
- `lua/config/` contains core configuration: options, keymaps, autocmds,
  plugin declarations, deferred loading, terminal helpers, and filetype
  helpers.
- `lua/plugins/` contains plugin setup and plugin-specific keymaps, one module
  per plugin area.
- `after/ftplugin/` contains heavier filetype-specific configuration.
- External LSP servers, formatters, and linters are installed outside this repo,
  usually with Homebrew.

## Codex Documents

- `AGENTS.md` is the project instruction source for Codex.
- `.codex/config.toml` contains project-scoped Codex configuration. Codex loads
  it only when the project is trusted.
- Keep `.codex/config.toml` limited to repo-specific tool configuration.
  Validate keys against the Codex config schema before changing it.
- Do not recreate obsolete assistant files such as `CLAUDE.md` or `.claude/`.

## Plugin Model

- Use native `vim.pack.add()` in `lua/config/pack.lua`.
- Put plugin declarations in `lua/config/pack.lua`.
- Put setup code and keymaps in `lua/plugins/*.lua`.
- Use `lua/config/defer.lua` for deferred plugin loading.
- Keep `PackChanged` build/update hooks near the pack declarations.
- Do not introduce another plugin manager.

## Style

- Lua formatting is StyLua: 2 spaces, 120 columns, single quotes, trailing
  commas.
- Linting is Selene with the `neovim+selene_mini` standard.
- Always include `desc` on keymaps.
- Match surrounding naming and module boundaries.
- Prefer table-driven config where the repo already uses it.
- Avoid broad refactors while making focused config changes.

## Validation

- Run `make check` before finishing changes that touch Lua config.
- Use narrower commands first when useful:
  - `make lint`
  - `stylua --check` with the same config and paths as the `check` target.
- There is no test suite.

## External Docs

- Use Context7 for current Neovim and plugin API documentation when validating
  external behavior.
- Prefer official Neovim help, plugin README docs, and Context7 results over
  memory for unstable APIs.
- Record assumptions when external behavior cannot be verified.

## Audit Rules

- Check for stale references when renaming files, plugins, commands, or
  workflow docs.
- Keep references aligned with current filenames, especially `formatter.lua`,
  `linter.lua`, `vim.pack.add()`, and `make check`.
- Do not add references to obsolete plugin managers, non-Codex assistant files,
  or obsolete plugin paths.

## Review Guidelines

- Treat startup errors, malformed Lua, missing plugin setup, invalid keymaps, and
  broken validation commands as high-priority findings.
- Treat stale references in Codex instructions, plugin declarations,
  formatter/linter modules, and workflow commands as high-priority findings when
  they would mislead future edits.
- Check that changed keymaps include `desc`, respect existing leader group
  names, and avoid duplicate mappings unless the overlap is intentional.
- Do not flag style-only preferences unless they violate StyLua, Selene, this
  file, or existing repo conventions.

## Git

- Use the `gs` git steward agent for routine git workflows when available.
- Do not commit unless asked.
- Stage specific files only when asked to stage.
- Commit format:

```txt
type(scope): description

Body text that explains the change
```

- Types: `feat`, `fix`, `chore`, `refactor`, `style`, `docs`.
- Scope should be a filename or feature area without extension.

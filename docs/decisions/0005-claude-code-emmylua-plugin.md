# ADR-0005: Give Claude Code emmylua_ls through a project-local plugin

Status: accepted
Recorded: 2026-11-15
Supersedes: none
Superseded by: none
Related: `.claude/settings.json`, `.claude/marketplace/`, `.emmyrc.json`, `CLAUDE.md`

## Context

Claude Code gets language servers only from plugins. The official
`lua-lsp@claude-plugins-official` plugin hardcodes the `lua-language-server`
command. After this configuration moved to emmylua_ls, only Homebrew
`emmylua_ls` was installed, so every Claude Code session here reported that
`plugin:lua-lsp:lua` couldn't start. The official marketplace has no
emmylua_ls plugin.

emmylua_ls replaces `$NAME` in `workspace.library` paths with the server's
environment variable, and an unset variable becomes an empty string. Neovim
sets `VIMRUNTIME` for the servers it starts. A Claude Code session started
from a shell does not, so `"$VIMRUNTIME"` resolved to the workspace root and
emmylua_ls had no types for `vim`.

## Decision

The repository has its own marketplace, `nvim-config`, in
`.claude/marketplace/`. Its single plugin, `emmylua-lsp`, runs `emmylua_ls`
over stdio for `.lua` files. It sets `VIMRUNTIME` in its `env` to Homebrew's
version-independent runtime link, `/opt/homebrew/share/nvim/runtime`, so the
`"$VIMRUNTIME"` entry in `.emmyrc.json` resolves the same as in Neovim.

`.claude/settings.json` registers the marketplace through
`extraKnownMarketplaces` as a `directory` source with the relative path
`./.claude/marketplace`, enables `emmylua-lsp@nvim-config`, and no longer
enables `lua-lsp`. On 2026-11-15 Thorsten chose to scope the plugin to this
project rather than share it from a marketplace outside the repository.

## Consequences

- A trusted Claude Code session in this checkout loads the plugin at startup
  without `claude plugin install`. Claude Code ignores the project settings in
  an untrusted folder.
- emmylua_ls starts with this repository as its workspace and reads
  `.emmyrc.json`, the same settings Neovim uses.
- Other Lua projects, such as brygga.nvim, still enable `lua-lsp`. To use
  emmylua_ls there, each project needs its own copy of the plugin, or the
  plugin has to move to a shared marketplace.
- The plugin runs `emmylua_ls` from `PATH`, so it relies on the Homebrew
  install that `README.md` lists.
- Only the plugin hardcodes the runtime path; `.emmyrc.json` keeps
  `$VIMRUNTIME`. A Neovim installed outside Homebrew needs the plugin's `env`
  changed.

## Alternatives considered

- Keep the official `lua-lsp` plugin and install `lua-language-server`.
  Rejected because Neovim uses emmylua_ls and `.emmyrc.json`.
- One emmylua_ls plugin in a local marketplace outside the repository, such as
  `~/github/claude-plugins/`, shared by all Lua projects. Thorsten chose the
  project-local version instead.

## Verification anchors

- `claude plugin validate .claude/marketplace` passed on 2026-11-15, warning
  only about the missing author and description fields.
- A headless `claude -p` session on 2026-11-15 listed the marketplace as
  "Folder (/Users/thorre/.config/nvim/.claude/marketplace)" and logged
  "Loaded 1 LSP server(s) from plugin: emmylua-lsp". The settings reference
  does not say whether a `directory` path may be relative.
- `replace_env_var` in emmylua_ls 0.25.1
  `crates/emmylua_code_analysis/src/config/pre_process.rs`, read on
  2026-11-15. With the `"$VIMRUNTIME"` entry, `emmylua_check .` reported
  `undefined global variable: vim` when `VIMRUNTIME` was unset and no issues
  with `VIMRUNTIME=/opt/homebrew/share/nvim/runtime`.
- The `lspServers` field table in
  <https://code.claude.com/docs/en/plugins/manifest-reference.md> lists `env`.
- The official plugin's manifest:
  `plugins/lua-lsp/.claude-plugin/plugin.json` in `claude-plugins-official`.
- A new Claude Code session on 2026-11-15 started emmylua_ls with
  `VIMRUNTIME=/opt/homebrew/share/nvim/runtime` in its environment, while
  the session's shell had none. Hover on `vim.api.nvim_create_autocmd`
  showed its documentation, and go to definition reached
  `lua/vim/_meta/api.gen.lua` in the runtime and conform.nvim's `setup`.
  `claude plugin list` does not show `emmylua-lsp`, although the plugin is
  loaded.

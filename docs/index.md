# Project knowledge

## Purpose and authority

This index maps the decision records for this Neovim configuration. The Lua
modules and `README.md` describe the current state, and `AGENTS.md` holds the
rules that always apply. The records below explain choices that the code does
not explain by itself.

## Decision history

- [ADR-0001](decisions/0001-typescript-native-language-server.md): use the
  native `tsc` language server for TypeScript and JavaScript, not `vtsls`.
- [ADR-0002](decisions/0002-biome-through-language-server.md): lint JavaScript
  and TypeScript through the Biome language server, not nvim-lint.
- [ADR-0003](decisions/0003-format-through-language-servers.md): format C, Go,
  Rust and Swift through their language servers, without conform entries.

## Maintenance

When a decision changes after its record reached `main`, add a new record and
mark the old one superseded. Do not rewrite an accepted record.

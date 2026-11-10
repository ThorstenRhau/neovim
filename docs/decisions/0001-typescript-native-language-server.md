# ADR-0001: Use the native `tsc` language server for TypeScript and JavaScript

Status: accepted
Recorded: 2026-11-10
Supersedes: none
Superseded by: none
Related: `lua/lsp.lua`, `README.md`

## Context

TypeScript 7 is the native compiler and ships its own language server,
started with `tsc --lsp`. tsserver no longer exists in TypeScript 7. The
installed nvim-lspconfig has a `tsc` config for it and marks its `tsgo` config
as deprecated in favour of `tsc`.

`vtsls` 0.3.0 wraps tsserver and bundles TypeScript 5.9.3. It therefore checks
code with an older compiler than the Homebrew `typescript` formula, which was
7.0.2 when this was recorded.

## Decision

`lua/lsp.lua` enables `tsc` for JavaScript and TypeScript. `vtsls` is not
enabled. The Homebrew `typescript` formula provides the server.

## Consequences

- The server needs TypeScript 7 or newer. nvim-lspconfig skips a `tsc` binary
  older than 7, and then no TypeScript server attaches.
- The native server does not support Vue, Svelte, Astro or tsserver plugins.
  This configuration uses none of them.
- Only diagnostics and the formatting capability were checked. Rename, code
  actions and completion were not.

## Alternatives considered

- `vtsls`: enabled first and replaced, for the reasons in the context.

## Verification anchors

- `lsp/tsc.lua`, `lsp/tsgo.lua` and `lsp/vtsls.lua` in the installed
  nvim-lspconfig (revision `443d92c6`).
- A headless Neovim probe on 2026-11-10: `tsc` attached to a sample
  TypeScript file and reported the same three type errors as `vtsls` (2322,
  7006 and 2454).
- Commit `acd951b`.

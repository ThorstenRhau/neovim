# ADR-0003: Format C, Go, Rust and Swift through their language servers

Status: accepted
Recorded: 2026-11-10
Supersedes: none
Superseded by: none
Related: `lua/plugins.lua`, `lua/keymaps.lua`, `AGENTS.md`

## Context

The format key calls conform with `lsp_format = 'fallback'`, so a filetype
without a conform entry is formatted by its language server. `clangd`,
`gopls`, `rust-analyzer` and `sourcekit-lsp` all offer formatting, which made
conform entries for `gofmt`, `rustfmt` and `swift format` look redundant.

## Decision

conform has no entry for C, Go, Rust or Swift. The format key falls back to
`clangd`, `gopls`, `rust-analyzer` and `sourcekit-lsp`.

## Consequences

- Go and Rust format exactly as `gofmt` and `rustfmt` do.
- Swift formats as `swift format` does when the project has a `.swift-format`
  file. Without one, `sourcekit-lsp` indents with the buffer's width, which
  Neovim's Swift ftplugin sets to 4, where `swift format` uses its own default
  of 2. This was kept on purpose: it follows the native filetype indentation
  rule in `AGENTS.md`.
- Formatting these filetypes needs an attached server.

## Alternatives considered

- conform entries for `rustfmt`, `gofmt` and `swift`: configured first and
  removed after the comparison below.

## Verification anchors

- Headless Neovim probes on 2026-11-10 that formatted the same buffer with
  the conform formatter and with the server. The output was byte-identical
  for `gofmt` and `gopls` and for `rustfmt` and `rust-analyzer`, on two sample
  files each. For Swift it was identical with a `.swift-format` file and
  differed only in indent width without one.
- C was checked through `clangd` only; there was never a conform entry for
  it.
- Commit `acd951b`.

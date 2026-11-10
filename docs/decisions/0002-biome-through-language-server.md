# ADR-0002: Lint JavaScript and TypeScript through the Biome language server

Status: accepted
Recorded: 2026-11-10
Supersedes: none
Superseded by: none
Related: `lua/lsp.lua`, `lua/plugins.lua`

## Context

nvim-lint has a `biomejs` linter that parses the text output of `biome lint`.
With Biome 2.6.6 that parser gives wrong results. On a sample file it dropped
both `noUnusedVariables` warnings, and it attached the `noDoubleEquals`
message to the wrong rule name and to line 1, where the finding was on line 2.
The `biome` language server reported all five findings correctly on the same
file.

## Decision

`lua/lsp.lua` enables the `biome` server, and nvim-lint has no entry for
JavaScript or TypeScript.

The server is limited to the JavaScript and TypeScript filetypes. Its default
filetypes also cover JSON, YAML and Markdown, where `jsonls`, `yamlls` and
`rumdl` already attach.

conform formats JavaScript and TypeScript with Biome in projects with a Biome
config and with prettier everywhere else. The `biome` formatter is set to
`require_cwd = true`, so it only counts as available when a Biome config is
found above the file.

## Consequences

- nvim-lspconfig attaches `biome` only in projects with a `biome.json` or
  `biome.jsonc`. Other projects get no Biome lint.
- In a Biome project the format key agrees with `biome check`.
- Not handled: a project that disables Biome's formatter in its config and
  formats with prettier. The format key still picks Biome there.

## Alternatives considered

- `biomejs` through nvim-lint: configured first and removed because of the
  parser results above.

## Verification anchors

- `lua/lint/linters/biomejs.lua` in the installed nvim-lint, and
  `lsp/biome.lua` in the installed nvim-lspconfig (revision `443d92c6`).
- Headless Neovim probes on 2026-11-10 with Biome 2.6.6, on the same sample
  file with and without a `biome.json`.
- Commit `acd951b`.

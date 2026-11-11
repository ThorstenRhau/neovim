# ADR-0004: Lint and format Ruby through Ruby LSP and the bundled RuboCop

Status: accepted
Recorded: 2026-11-11
Supersedes: none
Superseded by: none
Related: `lua/lsp.lua`, `lua/plugins.lua`, `README.md`

## Context

Ruby LSP (`ruby_lsp`) runs inside a composed bundle that contains the
project's Gemfile. Its `formatter = 'auto'` default, which nvim-lspconfig
sets, and its detected linters enable RuboCop when the bundle depends on a
`rubocop*` gem directly, or on `rubocop` indirectly with a `.rubocop.yml`.
Ruby LSP does not use a RuboCop installed outside the bundle. A Homebrew
`rubocop` run through nvim-lint and conform would work outside projects, but
lacks the plugins that a project's `.rubocop.yml` can require, such as
`rubocop-rails`, and may differ from the project's pinned version.

## Decision

Ruby uses `ruby_lsp` with its default settings for language features, lint
and format. conform and nvim-lint have no Ruby entries, and the format key
falls back to the server. Thorsten chose this on 2026-11-11 because he
mainly works in bundled projects.

## Consequences

- In a project that bundles RuboCop, diagnostics and formatting use the
  project's RuboCop version, plugins and configuration.
- Files outside such a project get language features but no RuboCop
  diagnostics or formatting.
- Ruby LSP needs the project's Ruby version. Homebrew `ruby-lsp` runs on
  Homebrew `ruby`; a project pinned to another Ruby needs a version manager
  and a matching `cmd`.

## Alternatives considered

- Homebrew `rubocop` through nvim-lint and conform for all Ruby files.
  Rejected for the plugin and version mismatch above.
- Ruby LSP inside projects and Homebrew `rubocop` outside them. Rejected as
  two owners split by a Gemfile check.

## Verification anchors

- `detect_formatter` and `detect_linters` in Ruby LSP's
  `lib/ruby_lsp/global_state.rb`, read on 2026-11-11.
- Ruby LSP documentation: "Using globally installed formatters or linters is
  not supported, they must in your Gemfile or gemspec."
- `lsp/ruby_lsp.lua` in nvim-lspconfig sets `init_options.formatter = 'auto'`.

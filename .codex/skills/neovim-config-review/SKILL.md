---
name: neovim-config-review
description: Use when asked to audit, review, check, inspect, or find issues in this Neovim 0.12 Lua configuration. Focus on read-only config review for /Users/thorre/.config/nvim. Do not use for implementation requests, general Neovim help, git workflows, unrelated code review, or requests to create/edit files.
---

# Neovim Config Review

## Outcome

Produce a read-only, verified markdown audit for this Neovim 0.12 configuration. Lead with concrete findings, ordered by severity, each with `file:line` evidence and the user-visible risk. If there are no findings, say so and list residual verification gaps.

## Required Context

Before reporting, inspect the relevant current files instead of relying on memory:

- `AGENTS.md`
- `init.lua`
- `lua/config/`
- `lua/plugins/`
- `after/ftplugin/`
- `Makefile`
- `README.md`
- `.codex/config.toml`
- `selene.toml`
- `selene_mini.yml`
- `.stylua.toml`

Read `references/audit-checks.md` when doing a full audit, checking stale references, or deciding what evidence is sufficient.

## Workflow

1. Confirm scope is this repo unless the user explicitly points elsewhere.
2. Inspect current files and git status. Do not edit, stage, commit, or create report files.
3. Run focused searches for startup risks, stale names, keymaps, plugin declarations, formatter/linter wiring, and validation commands.
4. Delegate narrow read-only checks to sub-agents only when the audit is broad enough that parallel review will improve coverage without losing coherence. See "Sub-Agent Delegation".
5. Run `make check` as the primary validation command when the environment has the required tools. Use narrower checks such as `make lint` or `stylua --check --config-path .stylua.toml init.lua lua after` only when useful.
6. For plugin configuration findings, identify the plugin source from `lua/config/pack.lua` and verify option names, value types, defaults, and deprecations against current plugin documentation. Prefer Context7, official plugin README/help docs, or upstream internet documentation when available. Do not infer plugin parameters from memory alone.
7. Use Context7 or official upstream docs for unstable Neovim or plugin API claims. State assumptions when external behavior cannot be verified.
8. Report only verified findings. Do not speculate.

## Sub-Agent Delegation

Keep the lead reviewer responsible for scope, severity, final wording, and every reported finding. Use sub-agents only for read-only, self-contained review slices that can run in parallel and return evidence.

Delegate when:

- The user explicitly asks for sub-agents, delegation, or parallel review.
- The audit spans multiple independent areas, such as keymaps, plugin option docs, stale references, and validation/toolchain checks.
- A plugin documentation check can be isolated to one plugin or one small plugin group.
- A suspected issue needs an independent verification pass without editing files.

Do not delegate when:

- The request is a small targeted review.
- The next step depends directly on the answer; do that check locally.
- The task requires editing, staging, committing, or changing runtime state.
- The sub-agent would need broad context or would duplicate the lead review.

Sub-agent prompts should be concrete and bounded. Tell sub-agents this is a read-only audit, name the exact files or plugin docs to inspect, require `file:line` evidence, require source links or documentation names for plugin-parameter claims, and ask them to return only verified findings plus commands run. The lead reviewer must re-check any candidate finding before including it in the final report.

## Success Criteria

- Findings are reproducible from current repo files or command output.
- Each finding has severity, location, observed behavior, expected behavior, and a minimal fix direction.
- Plugin option findings cite the checked documentation source or state why current plugin documentation could not be reached.
- Any delegated finding has been reviewed by the lead agent before being reported.
- The report references `AGENTS.md`, `formatter.lua`, `linter.lua`, `vim.pack.add()`, and `make check` when those conventions matter.
- The audit creates no files and makes no repo changes.

## Stop Conditions

- Stop and ask for clarification if the user requests both read-only audit and implementation in the same prompt.
- Stop before destructive or stateful commands.
- Stop if validation would require installing tools or changing external Neovim state; report the blocker instead.

## Output Format

Use this structure:

```markdown
**Findings**
- High: `path:line` - concise problem statement.
  Evidence: what was observed.
  Impact: user-visible or maintenance risk.
  Fix: minimal direction.

**Verification**
- `make check` ... result, or why it could not run.
- Other commands ... result.

**Notes**
- Assumptions, skipped areas, or "No findings" when applicable.
```

Keep the final report concise. Do not include broad summaries before findings.

## Gotchas

- Do not recreate `.claude/` or `CLAUDE.md`.
- Do not use `make all` as the review validator; this repo uses `make check`.
- Do not flag style preferences unless they violate StyLua, Selene, `AGENTS.md`, or existing repo conventions.
- Do not make API or configuration-parameter claims about Neovim 0.12 or plugins without local help, official docs, plugin README, Context7, or upstream internet documentation support.

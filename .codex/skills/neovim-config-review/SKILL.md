---
name: neovim-config-review
description: Use when asked to audit, review, check, inspect, or find issues in this Neovim 0.12 Lua configuration. Focus on read-only config review for /Users/thorre/.config/nvim. Do not use for implementation requests, general Neovim help, git workflows, unrelated code review, or requests to create/edit files.
---

# Neovim Config Review

## Outcome

Produce a read-only, verified markdown audit for this Neovim 0.12 configuration. An unqualified invocation of this skill means a full audit. Lead with concrete findings, ordered by severity, each with `file:line` evidence and the user-visible risk. If there are no findings, say so and list residual verification gaps.

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

For a full audit, treat every plugin declared in `lua/config/pack.lua` as in scope. Read current plugin documentation before judging option names, value types, defaults, setup order, commands, keymap APIs, or deprecations. Use Context7 MCP when it has the plugin. Otherwise use the upstream README, help docs, release notes, or official repository documentation on the internet. Treat memory and old local assumptions as insufficient evidence for plugin API claims.

## Workflow

1. Confirm scope is this repo unless the user explicitly points elsewhere.
2. Inspect current files and git status. Do not edit, stage, commit, or create report files.
3. Run focused searches for startup risks, stale names, keymaps, plugin declarations, formatter/linter wiring, and validation commands.
4. Delegate narrow read-only checks to sub-agents only when the audit is broad enough that parallel review will improve coverage without losing coherence. See "Sub-Agent Delegation".
5. Run `make check` as the primary validation command when the environment has the required tools. Use narrower checks such as `make lint` or `stylua --check --config-path .stylua.toml init.lua lua after` only when useful.
6. Build a plugin documentation coverage list from `lua/config/pack.lua`. For each plugin with local setup, globals, keymaps, commands, or deferred loading, check current documentation before marking that plugin covered. Verify option names, value types, defaults, setup order, commands, keymap APIs, and deprecations against Context7 MCP, official plugin README/help docs, release notes, or upstream internet documentation. Do not infer plugin parameters from memory alone.
7. Use Context7 or official upstream docs for unstable Neovim or plugin API claims. If documentation cannot be reached for any plugin or API area, record the attempted source and list it as a verification gap.
8. Report only verified findings. Do not speculate. Do not claim a full audit if plugin documentation coverage is incomplete.

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

Sub-agent prompts should be concrete and bounded. Tell sub-agents this is a read-only audit, name the exact files or plugin docs to inspect, require `file:line` evidence, require the current documentation source checked for each plugin-parameter claim, and ask them to return only verified findings plus commands run. Prefer giving one plugin or plugin group per sub-agent when documentation lookup is the main task. The lead reviewer must re-check any candidate finding before including it in the final report.

## Success Criteria

- Findings are reproducible from current repo files or command output.
- Each finding has severity, location, observed behavior, expected behavior, and a minimal fix direction.
- Every plugin declared in `lua/config/pack.lua` is accounted for in the final plugin documentation coverage list.
- Plugin option findings cite the checked current documentation source, such as Context7, upstream README/help docs, release notes, or official repository documentation.
- If any plugin documentation could not be reached, the final report lists the plugin, attempted source, and limitation; the report must not say the plugin configuration was fully audited.
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
- Plugin docs checked: plugin/source list, or "none" only for a targeted non-plugin audit.
- Plugin docs not checked: plugin/source/reason list, or "none".

**Notes**
- Assumptions, skipped areas, or "No findings" when applicable.
```

Keep the final report concise. Do not include broad summaries before findings.

## Gotchas

- Do not recreate `.claude/` or `CLAUDE.md`.
- Do not use `make all` as the review validator; this repo uses `make check`.
- Do not flag style preferences unless they violate StyLua, Selene, `AGENTS.md`, or existing repo conventions.
- Do not make API or configuration-parameter claims about Neovim 0.12 or plugins without local help, official docs, plugin README, Context7, or upstream internet documentation support.
- Do not treat plugin config as audited just because it looks plausible locally; read the current plugin docs or explicitly report that external documentation was unavailable.

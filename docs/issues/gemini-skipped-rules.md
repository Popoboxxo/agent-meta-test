---
title: "[provider] Gemini skips 5 important rules via rules-preset"
labels: [bug, provider, gemini, P1]
---

## Problem
The Gemini rules-preset skips 5 critical rules:

```yaml
# config/rules-presets.yaml
gemini:
  dod-criteria: { gemini: skip }
  issue-lifecycle: { gemini: skip }
  lifecycle-tasks: { gemini: skip }
  use-orchestrator: { gemini: skip }
  sync-interface: { gemini: skip }
```

## Impact

| Rule | Purpose | Risk of Skipping |
|------|---------|------------------|
| `dod-criteria` | Definition of Done checks | Agents don't know completion criteria |
| `issue-lifecycle` | GitHub issue management | Agents won't close issues after fixes |
| `lifecycle-tasks` | Pending task handling | Tasks from git events are ignored |
| `use-orchestrator` | Entry point enforcement | Agents might bypass orchestrator |
| `sync-interface` | sync.py command reference | Agents don't know sync commands |

## Why They Were Skipped
Likely because Gemini doesn't support `alwaysApply` frontmatter. But rules should still be embedded as plain text.

## Fix
Either:
1. Remove the skip — Gemini ignores `alwaysApply` anyway
2. Embed skipped rules into `GEMINI.md` as plain text
3. Create Gemini-specific rule variants without `alwaysApply`

## Acceptance Criteria
- [ ] All 5 rules available to Gemini agents
- [ ] `GEMINI.md` includes full rule context
- [ ] `sync.log` shows no `[SKIP] (rules-preset: gemini: skip)` for these

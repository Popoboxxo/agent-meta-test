---
title: "[hooks] lifecycle-check hook is disabled"
labels: [bug, hooks, P1]
---

## Problem
The `lifecycle-check` hook is copied but not enabled in `.meta-config/project.yaml`:

```yaml
hooks:
  dod-push-check:
    enabled: true
  lifecycle-check:
    enabled: false   # ← disabled
```

## Impact
- Git events (release, merge) don't trigger lifecycle tasks
- `.claude/pending-tasks.md` is never populated
- Documenter agent is never notified to update docs after releases

## Fix
Enable the hook:
```yaml
hooks:
  lifecycle-check:
    enabled: true
```

## Acceptance Criteria
- [ ] `lifecycle-check` enabled in `project.yaml`
- [ ] Hook registered in `.claude/settings.json`
- [ ] Test: git tag triggers pending-tasks generation

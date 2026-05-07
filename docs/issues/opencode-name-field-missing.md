---
title: "[critical] Opencode agents missing 'name' field — cannot be invoked"
labels: [bug, provider, opencode, P0]
---

## Problem
Opencode agents are generated without a `name` field in their frontmatter. This makes it impossible to invoke them by name in opencode.

## Current Frontmatter
```yaml
---
description: "Koordiniert alle Agenten..."
mode: subagent
generated-from: "1-generic/orchestrator.md@2.5.0"
---
```

## Expected Frontmatter
```yaml
---
name: orchestrator
description: "Koordiniert alle Agenten..."
mode: subagent
generated-from: "1-generic/orchestrator.md@2.5.0"
---
```

## Impact
- **All 15 Opencode agents** are affected
- Users cannot invoke agents by name: `@orchestrator`, `@developer`, etc.
- Agents only work if opencode falls back to file-stem matching

## Fix
Add `name` field generation in `scripts/lib/context.py` for Opencode provider.

## Acceptance Criteria
- [ ] All `.opencode/agents/*.md` files have `name:` in frontmatter
- [ ] Name matches the role (e.g. `name: developer`)
- [ ] `sync.py` generates correct frontmatter on next run

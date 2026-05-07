---
title: "[gitignore] Missing entries for other providers' local settings"
labels: [bug, config, P2]
---

## Problem
`.gitignore` only covers Claude local settings, but other providers also generate local/personal files:

```gitignore
# Current (only Claude)
.claude/settings.local.json
CLAUDE.personal.md
sync.log
```

## Missing Entries

| Provider | Local File | Risk |
|----------|-----------|------|
| Continue | `.continue/settings.local.yaml` | Personal config committed |
| Gemini | `.gemini/settings.local.json` | Personal config committed |
| Opencode | `.opencode/settings.local.json` | Personal config committed |
| Opencode | `AGENTS.personal.md` | Already covered |

## Fix
Add to `.gitignore`:
```gitignore
.continue/settings.local.yaml
.gemini/settings.local.json
.opencode/settings.local.json
```

## Acceptance Criteria
- [ ] All provider local settings are gitignored
- [ ] `sync.py` adds these entries automatically
- [ ] No personal configs can be accidentally committed

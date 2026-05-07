---
title: "[config] Missing LLM parameters: temperature, max_tokens, context_window"
labels: [enhancement, config, P1]
---

## Problem
No agent specifies LLM parameters like `temperature`, `max_tokens`, or `context_window`. This leads to suboptimal behavior:

- **High temperature** for creative tasks (ideation) → more varied output
- **Low temperature** for deterministic tasks (git, validator) → consistent output
- **Context window** not managed → potential truncation for large HA configs

## Recommended Defaults

| Role | temperature | max_tokens | context_window |
|------|-------------|------------|----------------|
| `developer` | 0.2 | 8192 | 128000 |
| `tester` | 0.2 | 4096 | 128000 |
| `validator` | 0.1 | 4096 | 128000 |
| `ideation` | 0.7 | 4096 | 128000 |
| `git` | 0.1 | 2048 | 128000 |

## Fix
Add to `config/role-defaults.yaml`:
```yaml
roles:
  developer:
    model: balanced
    temperature: 0.2
    max_tokens: 8192
```

## Acceptance Criteria
- [ ] `role-defaults.yaml` includes temperature/max_tokens defaults
- [ ] `sync.py` injects these into agent frontmatter (where supported)
- [ ] Provider-specific mapping documented

---
title: "[ci-cd] Missing validation pipeline for generated files"
labels: [enhancement, ci-cd, P2]
---

## Problem
There is no automated validation that:
1. `sync.py` produces consistent output
2. All agents have valid frontmatter
3. No `{{VAR}}` placeholders remain
4. All providers generate the same agent count
5. Rules are valid markdown

## Impact
- Broken agents can be committed unnoticed
- Placeholders leak into production
- Provider drift (different agent counts) goes undetected

## Proposed CI/CD

### `.github/workflows/validate.yml`
```yaml
name: Validate agent-meta
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - name: Install dependencies
        run: pip install pyyaml jsonschema
      - name: Run sync dry-run
        run: python .agent-meta/scripts/sync.py --dry-run
      - name: Check for placeholders
        run: |
          ! grep -r "{{[A-Z]" .claude/agents/ .gemini/agents/ .continue/agents/ .opencode/agents/
      - name: Validate frontmatter
        run: python .agent-meta/scripts/validate-frontmatter.py
```

## Acceptance Criteria
- [ ] GitHub Actions workflow created
- [ ] Validates `sync.py --dry-run` passes
- [ ] Checks for remaining `{{VAR}}` placeholders
- [ ] Validates all agent frontmatter
- [ ] Runs on every PR and push

---
title: "[config] Missing variables cause raw {{VAR}} placeholders in generated files"
labels: [bug, config, P0]
---

## Problem
Multiple variables referenced in agent templates are not defined in `.meta-config/project.yaml`. This causes raw `{{VAR}}` syntax to remain in generated agent files.

## Missing Variables

| Variable | Referenced In | Count |
|----------|---------------|-------|
| `PROJECT_GOAL` | developer, documenter, ideation, release, requirements, tester, validator, docker | 8 files |
| `DEV_COMMANDS` | orchestrator, developer | 2 files |
| `TESTER_SNIPPETS_PATH` | tester | 4 files |
| `APP_URL` | docker | 1 file |
| `STARTUP_CREDENTIALS` | docker | 2 files |
| `EXTRA_STARTUP_INFO` | docker | 1 file |
| `BINARY_NAME` | docker | 4 files |
| `BINARY_URL` | docker | 1 file |
| `BASE_IMAGE` | docker | 1 file |
| `APT_PACKAGES` | docker | 1 file |
| `APP_USER` | docker | 1 file |
| `TEST_BASE_IMAGE` | docker | 1 file |
| `TEST_APT_PACKAGES` | docker | 1 file |
| `TEST_BINARY_INSTALL` | docker | 1 file |
| `LOCKFILE` | docker | 1 file |
| `INSTALL_COMMAND` | docker | 1 file |
| `DEFAULT_TEST_COMMAND` | docker | 1 file |
| `SMOKE_TEST_COMMAND` | docker | 1 file |
| `E2E_ENV_VARS` | docker | 1 file |
| `E2E_TEST_COMMAND` | docker | 1 file |
| `PORT` | docker | 2 files |
| `VOLUME_NAME` | docker | 1 file |

## Impact
Agents see raw template syntax like `{{PROJECT_GOAL}}` instead of actual values.

## Fix
Add missing variables to `.meta-config/project.yaml` or remove references from templates.

## Acceptance Criteria
- [ ] `sync.py` produces zero "Variable X not in config" warnings
- [ ] All agents contain resolved values, not raw placeholders

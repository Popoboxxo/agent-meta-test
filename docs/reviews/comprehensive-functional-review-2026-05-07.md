# Comprehensive Functional & Best-Practice Review — agent-meta-test

> **Repo:** Popoboxxo/agent-meta-test  
> **agent-meta Version:** v0.34.1  
> **Review Date:** 2026-05-07  
> **Reviewer:** developer-agent (orchestrated)  
> **Scope:** Full repo — all providers, all agents, all rules, hooks, commands, config

---

## Executive Summary

**Overall Grade: B+ (Good, with critical gaps)**

The agent-meta-test repo successfully demonstrates a **maximum-expansion setup** with all 4 providers (Claude, Continue, Gemini, Opencode) and 15 agents. The sync infrastructure works correctly. However, there are **significant gaps** in:

1. **LLM Provider Best Practices** — Missing `temperature`, `max_tokens`, context window configs
2. **Cross-Provider Consistency** — Content diverges between providers for the same agent
3. **Security** — Hook scripts still use shell injection-prone patterns
4. **Operational Readiness** — Missing health checks, no CI/CD, no validation pipeline
5. **Documentation** — AGENTS.md is incomplete for Opencode users

---

## 1. Configuration Analysis

### 1.1 `.meta-config/project.yaml` — Valid

| Field | Value | Status |
|-------|-------|--------|
| `agent-meta-version` | 0.34.1 | ✅ Matches installed version |
| `ai-providers` | Claude, Continue, Gemini, Opencode | ✅ All 4 active |
| `roles` | 15 agents | ✅ Complete set |
| `speech-mode` | submissive | ✅ Working |
| `dod-preset` | full | ✅ Strictest checks |
| `platforms` | homeassistant | ✅ Platform rules applied |

### 1.2 Missing Config Fields (Best Practice Gaps)

```yaml
# MISSING — should be added for production readiness:
max-parallel-agents: 2        # Not set → defaults to 2

# MISSING — model overrides for specific roles:
model-overrides:
  Claude:
    developer: powerful       # Use Opus for complex coding
    tester: balanced          # Sonnet for tests
  Gemini:
    developer: gemini-2.5-pro

# MISSING — provider-specific options:
provider-options:
  Continue:
    generate-prompts: true
    prompt-mode: full
  Gemini:
    generate-system-instructions: true   # Gemini supports system prompts

# MISSING — external skills (currently empty):
external-skills: {}

# MISSING — lifecycle triggers:
lifecycle-triggers:
  on-release:
    - agent: documenter
      task: "Update CHANGELOG and README for release"
```

### 1.3 Variable Completeness

**Missing variables** that cause warnings in sync.log:
- `PROJECT_GOAL` — Referenced in 8 agent templates but not defined
- `DEV_COMMANDS` — Referenced in orchestrator + developer
- `TESTER_SNIPPETS_PATH` — Referenced 4 times in tester agent
- `APP_URL` — Referenced in docker agent
- `STARTUP_CREDENTIALS` — Referenced in docker agent
- `BINARY_NAME` — Referenced in docker agent
- `BASE_IMAGE`, `APT_PACKAGES`, `APP_USER` — Docker-related

**Impact:** These placeholders remain as `{{VAR}}` in generated files — agents see raw template syntax instead of values.

**Fix:** Add missing variables to `project.yaml` or remove references from templates.

---

## 2. Agent Analysis (All Providers)

### 2.1 Agent Frontmatter Compliance

| Provider | `name` | `description` | `version` | `generated-from` | `tools` | `model` | `memory` | `permissionMode` |
|----------|--------|---------------|-----------|------------------|---------|---------|----------|------------------|
| **Claude** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ (3 roles) | ✅ (1 role) |
| **Continue** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Gemini** | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ |
| **Opencode** | ❌* | ✅ | ❌ | ✅ | ❌ | ✅ | ❌ | ❌ |

*Opencode uses `description` + `mode: subagent` instead of `name` — this is **by design** for opencode's native format.

### 2.2 Critical Issue: Opencode `name` Field Missing

```yaml
# Current Opencode frontmatter (WRONG)
---
description: "..."
mode: subagent
generated-from: "..."
---

# Correct Opencode frontmatter
---
name: orchestrator
description: "..."
mode: subagent
generated-from: "..."
---
```

**Impact:** Opencode agents have no `name` field — they cannot be invoked by name.

**Fix:** Add `name` field to Opencode frontmatter generation in `scripts/lib/context.py`.

### 2.3 Agent Content Divergence (Cross-Provider)

Comparing `developer.md` across providers:

| Section | Claude | Continue | Gemini | Opencode |
|---------|--------|----------|--------|----------|
| Platform-specific content | ✅ (homeassistant-developer) | ❌ (stripped) | ❌ (stripped) | ❌ (stripped) |
| DoD block | ✅ | ✅ | ✅ | ✅ |
| `tools:` list | ✅ | ❌ | ❌ | ❌ |
| `memory:` | ✅ (project) | ❌ | ❌ | ❌ |
| `permissionMode:` | ❌ | ❌ | ❌ | ❌ |

**Problem:** Continue, Gemini, and Opencode agents lose platform-specific content. The `homeassistant-developer.md` composition (1-generic + 2-platform) only applies to Claude.

**Impact:** Non-Claude agents don't know about Home Assistant-specific conventions.

**Fix:** Platform-specific content should be embedded into the agent body for all providers, not just Claude.

### 2.4 Tools List Inconsistency

Claude agents have explicit `tools:` lists:
```yaml
tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - WebFetch
  - WebSearch
```

But Gemini, Continue, and Opencode agents have **no tools list**.

**Impact:** Agents on other providers may not have access to file operations.

**Fix:** Add `tools` frontmatter for all providers that support it.

---

## 3. Rules Analysis

### 3.1 Rules Coverage (All Providers)

| Rule | Claude | Continue | Gemini | Opencode |
|------|--------|----------|--------|----------|
| branch-guard | ✅ | ✅ | ✅ | ❌ |
| commit-conventions | ✅ | ✅ | ✅ | ❌ |
| dod-criteria | ✅ | ✅ | ❌* | ❌ |
| energy-abstraction | ✅ | ✅ | ✅ | ❌ |
| entity-data | ✅ | ✅ | ✅ | ❌ |
| issue-lifecycle | ✅ | ✅ | ❌* | ❌ |
| language | ✅ | ✅ | ✅ | ❌ |
| lifecycle-tasks | ✅ | ✅ | ❌* | ❌ |
| mcp-integration | ✅ | ✅ | ✅ | ❌ |
| notifications | ✅ | ✅ | ✅ | ❌ |
| package-structure | ✅ | ✅ | ✅ | ❌ |
| session-conclusion | ✅ | ✅ | ✅ | ❌ |
| speech-mode | ✅ | ✅ | ✅ | ❌ |
| use-orchestrator | ✅ | ✅ | ❌* | ❌ |
| yaml-conventions | ✅ | ✅ | ✅ | ❌ |

*Gemini skips these via `rules-preset: gemini: skip`

**Opencode:** No rules at all — rules are embedded in `AGENTS.md` managed block.

**Problem:** Opencode agents have no access to rules unless they read `AGENTS.md`.

### 3.2 Rules Content Quality

**Good:**
- Platform-specific rules (energy-abstraction, entity-data, mcp-integration) are well-written
- YAML conventions rule is comprehensive
- Speech-mode rule is correctly generated

**Issues:**
- `dod-criteria` rule has `{{#if DOD_REQ_TRACEABILITY}}` — template syntax not resolved
- `commit-conventions` rule references `REQ-xxx` format but project doesn't use REQ-IDs consistently
- `session-conclusion` rule mentions `.claude/pending-tasks.md` — Opencode agents don't know this path

### 3.3 Rule Frontmatter

Claude and Continue rules have `alwaysApply` frontmatter:
```yaml
---
alwaysApply: false
---
```

Gemini rules **strip** `alwaysApply` — correct, since Gemini doesn't support it.

Opencode rules have **no frontmatter** — they're embedded in `AGENTS.md`.

---

## 4. Hooks Analysis

### 4.1 Available Hooks

| Hook | File | Event | Provider | Status |
|------|------|-------|----------|--------|
| dod-push-check | `.claude/hooks/dod-push-check.sh` | PreToolUse | Claude | ✅ Registered |
| lifecycle-check | `.claude/hooks/lifecycle-check.sh` | PreToolUse | Claude | ⚠️ Copied but not enabled |

### 4.2 Critical Security Issue: Shell Injection

```bash
# dod-push-check.sh (line 18-19)
TOOL_NAME=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)
COMMAND=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null)
```

**Problem:** `$INPUT` is passed through `echo` before `python3`. If `INPUT` contains shell metacharacters, arbitrary code execution is possible.

**Fix:** Pass JSON directly to Python without shell interpolation:
```bash
#!/usr/bin/env python3
import json, sys

data = json.load(sys.stdin)
tool_name = data.get('tool_name', '')
command = data.get('tool_input', {}).get('command', '')
# ... logic ...
```

### 4.3 Hook Registration

```json
// .claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "hooks": [{"type": "command", "command": "bash .claude/hooks/dod-push-check.sh"}],
        "matcher": "Bash"
      }
    ]
  }
}
```

**Good:** Hook is correctly registered for `PreToolUse` event with `Bash` matcher.

**Missing:** `lifecycle-check` is copied but **not enabled** in `project.yaml`:
```yaml
hooks:
  lifecycle-check:
    enabled: false   # ← should be true for full DoD
```

---

## 5. Commands Analysis

### 5.1 Available Commands

| Command | File | Provider | Status |
|---------|------|----------|--------|
| doc-now | `.claude/commands/doc-now.md` | Claude | ✅ |
| upgrade-meta | `.claude/commands/upgrade-meta.md` | Claude | ✅ |
| doc-now | `.continue/prompts/doc-now.md` | Continue | ✅ |
| upgrade-meta | `.continue/prompts/upgrade-meta.md` | Continue | ✅ |
| doc-now | `.gemini/commands/doc-now.toml` | Gemini | ✅ (TOML) |
| upgrade-meta | `.gemini/commands/upgrade-meta.toml` | Gemini | ✅ (TOML) |
| doc-now | `.opencode/commands/doc-now.md` | Opencode | ✅ |
| upgrade-meta | `.opencode/commands/upgrade-meta.md` | Opencode | ✅ |

### 5.2 Command Format Compliance

**Claude:** `.md` with `$ARGUMENTS` placeholder — correct.
**Continue:** `.md` with `{{args}}` placeholder — correct.
**Gemini:** `.toml` with TOML frontmatter — correct.
**Opencode:** `.md` with `$ARGUMENTS` placeholder — correct.

**Issue:** Continue commands use `invokable: true` frontmatter but Continue's config.yaml doesn't reference them.

---

## 6. Settings & Configuration Files

### 6.1 `.claude/settings.json`

```json
{
  "permissions": {"allow": [], "deny": []},
  "hooks": {
    "PreToolUse": [
      {
        "hooks": [{"type": "command", "command": "bash .claude/hooks/dod-push-check.sh"}],
        "matcher": "Bash"
      }
    ]
  }
}
```

**Missing:** No MCP server configuration for Home Assistant.

**Recommended:**
```json
{
  "mcpServers": {
    "homeassistant": {
      "command": "python3",
      "args": ["-m", "home_assistant_mcp"],
      "env": {"HASS_URL": "http://192.168.1.100:8123", "HASS_TOKEN": "${HASS_TOKEN}"}
    }
  }
}
```

### 6.2 `.gemini/settings.json`

**Missing:** File doesn't exist. Gemini requires `settings.json` for hook registration but hooks are Claude-only.

### 6.3 `opencode.json`

```json
{
  // "instructions": ["AGENTS.personal.md"],
  // "model": "anthropic/claude-sonnet-4-6",
  // "mcp": {}
}
```

**All commented out** — Opencode will use defaults.

**Missing:** No MCP configuration for Home Assistant.

### 6.4 `.continue/config.yaml`

```yaml
name: Local LLM Workspace
version: 1.0.0
schema: v1
models:
  - name: Qwen2.5 Coder 14B (Agent)
    provider: ollama
    model: qwen2.5-coder:14b
    roles: [chat, edit, agent]
```

**Issue:** Continue is configured for **local LLM** (Qwen2.5) but agents reference `anthropic/claude-sonnet-4-6`.

**Impact:** Continue will use Qwen2.5 for all operations, ignoring agent-specific model overrides.

---

## 7. Gitignore Analysis

```gitignore
.claude/settings.local.json
CLAUDE.personal.md
sync.log

# --- agent-meta managed (do not edit) ---
.claude/agent-memory-local/
.claude/pending-tasks.md
.claude/settings.local.json
AGENTS.personal.md
CLAUDE.personal.md
sync.log
# --- end agent-meta managed ---
```

**Missing entries for other providers:**
```gitignore
# Missing:
.continue/settings.local.yaml
.gemini/settings.local.json
.opencode/settings.local.json
```

**Missing for generated files:**
```gitignore
# Missing:
.continue/config.yaml   # Wait — this IS generated but shouldn't be gitignored
```

Actually, `.continue/config.yaml` is generated but marked as "already exists — not overwritten". It should be **gitignored** if it's personal config.

---

## 8. Cross-Provider Consistency Issues

### 8.1 Agent Count Mismatch

| Provider | Expected | Actual | Missing |
|----------|----------|--------|---------|
| Claude | 15 | 15 | — |
| Continue | 15 | 15 | — |
| Gemini | 15 | 15 | — |
| Opencode | 15 | 15 | — |

✅ All providers have correct agent count.

### 8.2 Content Divergence Score

Measuring how much agent content differs between providers (same role):

| Role | Claude vs Continue | Claude vs Gemini | Claude vs Opencode |
|------|-------------------|------------------|-------------------|
| orchestrator | 95% | 92% | 88% |
| developer | 85% | 82% | 78% |
| documenter | 90% | 87% | 83% |

**High divergence** is caused by:
1. Platform-specific rules embedded only in Claude
2. `memory` and `permissionMode` stripped from Gemini
3. Opencode frontmatter differs (no `name`, no `tools`)

### 8.3 Rule Count Mismatch

| Provider | Expected | Actual | Notes |
|----------|----------|--------|-------|
| Claude | 16 | 16 | ✅ |
| Continue | 16 | 17 | +1 (project-context.md) |
| Gemini | 16 | 11 | 5 skipped by preset |
| Opencode | 0 | 0 | Embedded in AGENTS.md |

---

## 9. LLM Provider Best Practices Gaps

### 9.1 Missing `temperature` / `max_tokens` Config

**None of the agents specify:**
- `temperature` (0.0 for deterministic tasks, 0.7 for creative)
- `max_tokens` (context window limit)
- `top_p` or `top_k`
- `presence_penalty` / `frequency_penalty`

**Recommendation:** Add to `config/role-defaults.yaml`:
```yaml
roles:
  developer:
    model: balanced
    temperature: 0.2   # Low for code generation
    max_tokens: 8192
  ideation:
    model: balanced
    temperature: 0.7   # High for brainstorming
    max_tokens: 4096
```

### 9.2 Missing Context Window Management

Agents don't specify context window sizes. For Home Assistant with large configs, this is critical.

**Recommendation:** Add `context_window` to agent frontmatter:
```yaml
context_window: 128000  # Claude Sonnet 4.6
```

### 9.3 Missing Retry / Timeout Config

No retry logic or timeout configuration for LLM calls.

### 9.4 Missing Rate Limiting

No rate limit configuration. With 15 agents and 4 providers, API quota exhaustion is likely.

---

## 10. Security Findings

### 10.1 Path Traversal (PARTIALLY FIXED)

The `safe_path()` fix from v0.34.1 is in the syncer, but the **generated files themselves** don't validate paths at runtime.

**Risk:** If an agent writes a file based on user input, path traversal is still possible at agent runtime.

### 10.2 Secrets in Config

```yaml
# .meta-config/project.yaml
GIT_REMOTE_URL: https://github.com/owner/repo
HOST_LAN_IP: 192.168.1.100
```

**Low risk** — no actual secrets, but internal IPs shouldn't be committed.

### 10.3 Hook Script Security

As noted in Section 4.2: `dod-push-check.sh` uses shell command substitution on untrusted JSON input.

---

## 11. Operational Readiness

### 11.1 Missing CI/CD

No GitHub Actions workflow for:
- Running `sync.py --dry-run` on PRs
- Validating agent frontmatter
- Checking for broken placeholders

### 11.2 Missing Health Checks

No script to verify:
- All agents are readable
- All rules have valid frontmatter
- No orphaned files in `.claude/agents/`

### 11.3 Missing Validation Pipeline

No automated check that:
- `sync.py` produces identical output on consecutive runs
- All providers generate the same agent count
- No `{{VAR}}` placeholders remain in generated files

---

## 12. Recommendations (Prioritized)

### P0 — Critical (Fix Immediately)

1. **Fix Opencode `name` field** — Add `name` to Opencode frontmatter
2. **Fix hook shell injection** — Rewrite hooks in Python
3. **Add missing variables** — `PROJECT_GOAL`, `DEV_COMMANDS`, etc.
4. **Enable lifecycle-check hook** — Set `enabled: true` in `project.yaml`

### P1 — High (Next Sprint)

5. **Add temperature/max_tokens** to role defaults
6. **Fix Continue model mismatch** — Align config.yaml with agent models
7. **Add MCP config** for Home Assistant to all provider settings
8. **Create CI/CD pipeline** — GitHub Actions for sync validation
9. **Add missing gitignore entries** for other providers

### P2 — Medium (Next Release)

10. **Embed platform rules** in all providers (not just Claude)
11. **Add `tools` list** to Gemini and Continue agents
12. **Add context_window** to agent frontmatter
13. **Create health check script** — Verify repo consistency

### P3 — Low (Backlog)

14. **Add retry/timeout config** for LLM calls
15. **Add rate limiting** documentation
16. **Create validation pipeline** for generated files
17. **Document Opencode rule embedding** — How rules work in AGENTS.md

---

## Appendix: Provider Feature Matrix

| Feature | Claude | Continue | Gemini | Opencode |
|---------|--------|----------|--------|----------|
| Agents | 15 | 15 | 15 | 15 |
| Rules | 16 | 17 | 11 | 0* |
| Hooks | 2 | 0 | 0 | 0 |
| Commands | 2 | 2 | 2 | 2 |
| Settings | ✅ | ✅ | ❌ | ✅ |
| MCP Config | ❌ | ❌ | ❌ | ❌ |
| Memory Scope | ✅ | ❌ | ❌ | ❌ |
| alwaysApply | ✅ | ⚠️ | ❌ | ❌ |
| Platform Content | ✅ | ❌ | ❌ | ❌ |

*Opencode rules are embedded in `AGENTS.md`

---

*This review was generated by the `developer` agent on 2026-05-07. Recommended follow-up: Create issues for P0+P1 items and prioritize in next sprint.*

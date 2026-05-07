---
title: "[provider] Platform-specific content only embedded in Claude agents"
labels: [bug, provider, P1]
---

## Problem
Platform-specific content from `agents/2-platform/homeassistant-developer.md` and `homeassistant-documenter.md` is only embedded into Claude agents. Continue, Gemini, and Opencode agents get the generic version without Home Assistant-specific conventions.

## Impact
| Provider | Gets HA-specific content? |
|----------|---------------------------|
| Claude | ✅ Yes |
| Continue | ❌ No |
| Gemini | ❌ No |
| Opencode | ❌ No |

## Example
The `developer` agent for Claude contains:
- Home Assistant package structure
- YAML anchor conventions
- Template sensor patterns

But the same agent for Gemini only contains generic developer instructions.

## Fix
Platform-specific content should be embedded into the agent body for ALL providers, not just Claude.

## Acceptance Criteria
- [ ] All providers include platform-specific agent content
- [ ] `developer` agent mentions Home Assistant on all providers
- [ ] `documenter` agent mentions HA documentation on all providers

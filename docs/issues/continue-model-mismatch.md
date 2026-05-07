---
title: "[provider] Continue config.yaml uses local LLM instead of agent-specified models"
labels: [bug, provider, continue, P1]
---

## Problem
`.continue/config.yaml` is configured for local LLM (`qwen2.5-coder:14b`) but agents specify Claude models (`anthropic/claude-sonnet-4-6`). Continue ignores agent model overrides.

## Current Config
```yaml
models:
  - name: Qwen2.5 Coder 14B (Agent)
    provider: ollama
    model: qwen2.5-coder:14b
```

## Expected
Continue should either:
1. Use the agent-specified model (Claude via API)
2. Or have a model mapping from agent tiers to local models

## Impact
- Continue users get Qwen2.5 instead of Claude Sonnet
- Model capability mismatch (local 14B vs cloud 4.6)
- Agent instructions assume Claude capabilities

## Fix Options
1. Add model mapping in `config/ai-providers.yaml` for Continue
2. Document that Continue requires manual model configuration
3. Generate `config.yaml` with agent-aware model overrides

## Acceptance Criteria
- [ ] Continue uses appropriate models for each agent
- [ ] Model mapping documented
- [ ] `sync.py` generates model-aware Continue config

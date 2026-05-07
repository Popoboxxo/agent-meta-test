---
title: "[config] Missing MCP server configuration for Home Assistant"
labels: [enhancement, config, P1]
---

## Problem
No provider has MCP (Model Context Protocol) server configuration for Home Assistant. The `mcp-integration` rule references MCP tools like `GetLiveContext` but no server is configured.

## Impact
- Agents cannot query real-time Home Assistant state
- Cannot use InfluxDB for historical data
- Cannot read todo lists or device statuses
- Rule `mcp-integration.md` is ineffective without config

## Recommended Config

### Claude
```json
// .claude/settings.json
{
  "mcpServers": {
    "homeassistant": {
      "command": "python3",
      "args": ["-m", "home_assistant_mcp"],
      "env": {
        "HASS_URL": "http://192.168.1.100:8123",
        "HASS_TOKEN": "${HASS_TOKEN}"
      }
    }
  }
}
```

### Opencode
```json
// opencode.json
{
  "mcp": {
    "homeassistant": {
      "command": "python3",
      "args": ["-m", "home_assistant_mcp"],
      "env": {"HASS_URL": "http://192.168.1.100:8123"}
    }
  }
}
```

## Acceptance Criteria
- [ ] MCP config added to `.claude/settings.json`
- [ ] MCP config added to `opencode.json`
- [ ] `.gitignore` updated to exclude `HASS_TOKEN`
- [ ] Documentation updated in `mcp-integration.md`

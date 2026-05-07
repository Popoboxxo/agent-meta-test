---
title: "[security] Hook scripts vulnerable to shell injection"
labels: [security, hooks, P0]
---

## Problem
Hook scripts (`dod-push-check.sh`, `lifecycle-check.sh`) parse JSON input via shell command substitution, making them vulnerable to shell injection if the JSON contains metacharacters.

## Vulnerable Code
```bash
# dod-push-check.sh line 18-19
TOOL_NAME=$(echo "$INPUT" | python3 -c "import json,sys; ...")
COMMAND=$(echo "$INPUT" | python3 -c "import json,sys; ...")
```

If `$INPUT` contains shell metacharacters (e.g. `'; rm -rf /; '`), arbitrary code execution is possible.

## Fix
Rewrite hooks in Python (or use `python3 -c` with proper JSON handling without shell interpolation):

```python
#!/usr/bin/env python3
import json, sys

data = json.load(sys.stdin)
tool_name = data.get('tool_name', '')
command = data.get('tool_input', {}).get('command', '')
# ... logic ...
```

## Acceptance Criteria
- [ ] All hook scripts rewritten in Python
- [ ] No shell command substitution on untrusted JSON input
- [ ] Security note added to `howto/hooks.md`
- [ ] `sync.py` generates Python-based hooks instead of `.sh`

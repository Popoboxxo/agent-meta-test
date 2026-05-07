# Issue Creation Script
# Run after: gh auth login
# Usage: .\scripts\create-issues.ps1

$issues = @(
    @{
        title = "[critical] Opencode agents missing 'name' field — cannot be invoked"
        body = Get-Content -Raw -Path "docs/issues/opencode-name-field-missing.md"
        labels = "bug,provider,opencode,P0"
    },
    @{
        title = "[security] Hook scripts vulnerable to shell injection"
        body = Get-Content -Raw -Path "docs/issues/hook-shell-injection.md"
        labels = "security,hooks,P0"
    },
    @{
        title = "[config] Missing variables cause raw {{VAR}} placeholders in generated files"
        body = Get-Content -Raw -Path "docs/issues/missing-variables.md"
        labels = "bug,config,P0"
    },
    @{
        title = "[provider] Platform-specific content only embedded in Claude agents"
        body = Get-Content -Raw -Path "docs/issues/platform-content-only-claude.md"
        labels = "bug,provider,P1"
    },
    @{
        title = "[provider] Continue config.yaml uses local LLM instead of agent-specified models"
        body = Get-Content -Raw -Path "docs/issues/continue-model-mismatch.md"
        labels = "bug,provider,continue,P1"
    },
    @{
        title = "[config] Missing LLM parameters: temperature, max_tokens, context_window"
        body = Get-Content -Raw -Path "docs/issues/missing-llm-parameters.md"
        labels = "enhancement,config,P1"
    },
    @{
        title = "[provider] Gemini skips 5 important rules via rules-preset"
        body = Get-Content -Raw -Path "docs/issues/gemini-skipped-rules.md"
        labels = "bug,provider,gemini,P1"
    },
    @{
        title = "[config] Missing MCP server configuration for Home Assistant"
        body = Get-Content -Raw -Path "docs/issues/missing-mcp-config.md"
        labels = "enhancement,config,P1"
    },
    @{
        title = "[hooks] lifecycle-check hook is disabled"
        body = Get-Content -Raw -Path "docs/issues/lifecycle-check-disabled.md"
        labels = "bug,hooks,P1"
    },
    @{
        title = "[ci-cd] Missing validation pipeline for generated files"
        body = Get-Content -Raw -Path "docs/issues/missing-ci-cd.md"
        labels = "enhancement,ci-cd,P2"
    },
    @{
        title = "[gitignore] Missing entries for other providers' local settings"
        body = Get-Content -Raw -Path "docs/issues/gitignore-missing-entries.md"
        labels = "bug,config,P2"
    }
)

foreach ($issue in $issues) {
    Write-Host "Creating issue: $($issue.title)"
    gh issue create `
        --repo Popoboxxo/agent-meta-test `
        --title $issue.title `
        --body $issue.body `
        --label $issue.labels
}

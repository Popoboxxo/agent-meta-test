# homeassistant-config

Home Assistant Power-User Setup auf Proxmox/Unraid

<!-- agent-meta:managed-begin -->
<!-- This block is automatically updated by sync.py on every sync. -->
<!-- Manual changes here will be overwritten. -->

Generiert von agent-meta v0.34.2 — `2026-05-07`
DoD-Preset: **full** | REQ-Traceability: true | Tests: true | Codebase-Overview: true | Security-Audit: false

> **Einstiegspunkt:** Starte mit dem `orchestrator`-Agenten für alle Entwicklungsaufgaben.

| Agent | Zuständigkeit |
|-------|--------------|
| `agent-meta-manager` | agent-meta verwalten: Upgrade, Sync, Feedback, projektspezifische Agenten anlegen |
| `agent-meta-scout` | Claude-Ökosystem scouten: neue Skills, Rollen, Rules und Patterns für agent-meta entdecken |
| `developer` | Feature-Implementierung und Bugfixes für Home Assistant (YAML, Jinja2, Packages) |
| `docker` | Dev-Stack starten/stoppen, Dockerfiles, Binary-Management |
| `documenter` | HA-Doku pflegen: MkDocs-Seiten, Package-Übersichten, Architektur-Diagramme (Mermaid) |
| `feature` | Neues Feature end-to-end durchführen: Branch → REQ → TDD → Dev → Validate → PR |
| `git` | Commits, Branches, Tags, Push/Pull und alle Git-Operationen |
| `ideation` | Neue Ideen explorieren, Vision schärfen, Übergabe an requirements |
| `meta-feedback` | Verbesserungsvorschläge für agent-meta als GitHub Issues einreichen |
| `openscad-developer` | OpenSCAD-Code generieren: parametrische 3D-Modelle, Render-Feedback, STL-Export, Druck-Optimierung |
| `orchestrator` | Einstiegspunkt für alle Entwicklungsaufgaben — koordiniert alle anderen Agenten |
| `release` | Versioning, Changelog, Build-Artifact, GitHub Release erstellen |
| `requirements` | Anforderungen aufnehmen, REQ-IDs vergeben, REQUIREMENTS.md pflegen |
| `tester` | Tests schreiben (TDD), Test-Suite ausführen, Coverage sicherstellen |
| `validator` | Code gegen REQs prüfen, DoD-Checkliste, Traceability-Audit |
<!-- agent-meta:managed-end -->

## Agents

Agent files are in `.gemini/agents/`. Use them with `@agent-name` in Gemini CLI.

## Project Setup

- **Build:** `ha core check-config`
- **Test:** `ha core check-config && ha core validate --config config/`
- **Platform:** Home Assistant OS / Core 2026.x
- **Runtime:** Home Assistant (Python-basiert)

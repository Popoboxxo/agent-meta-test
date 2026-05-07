# homeassistant-config

> Projektbeschreibung für Claude-Agenten. Diese Datei ist die **einzige Quelle**
> für projektspezifischen Kontext — Agenten lesen sie, statt eigenen Kontext zu haben.
>
> Generiert von agent-meta v0.14.2 — `2026-04-05`

---

## Projekt

**Name:** homeassistant-config
**Präfix:** ha
**Plattform:** Home Assistant OS / Core 2026.x
**Beschreibung:** High-End Home Assistant Konfigurationsmanagement für Power-User: YAML-Packages, Automationen, Jinja2-Templates, Dashboards (Mushroom, Bubble Card, card-mod) auf Proxmox/Unraid mit Docker Add-ons.

---

## Tech-Stack

- **Runtime:** Home Assistant (Python-basiert)
- **Sprache:** YAML, Jinja2, CSS (card-mod)
- **Key-Dependencies:** - Home Assistant Core: `2026.x`
- YAML Parser
- Zigbee2MQTT (Addon)
- Frigate (Addon)
- InfluxDB 2 (optional)
- MQTT Broker (optional)
- ESPHome (optional)

---

## Architektur

```
config/
  packages/              # Thematische Cluster (home, solar, car, heating, etc.)
    abstraction/         # Energy Power Abstraction
    home/                # Kern (climate, windows, air_quality)
    solar/               # Solar DTU, Forecast, Manager
    car/                 # Auto-Ladung (SAIC, evcc)
    grid/                # Stromnetz, Spotpreise
    heating/             # Heizungs-Steuerung
  automations/           # YAML Automations (oder in Packages)
  scripts/               # Script-Definitionen
  customize.yaml         # Entity-Anpassungen
  configuration.yaml     # Main Config (verweist auf Packages)
```

**Entry-Point:**
```
config/configuration.yaml — Root-Konfiguration mit Package-Loader (homeassistant: packages: !include_dir_named packages)
```

**Besondere Patterns:**
- Modular: Ein Package = Eine Fachdomäne (z.B. packages/solar/, packages/home/)
- YAML-Anker (&) für Code-Wiederverwendung
- Template-Sensoren mit Fehlerbehandlung (| float(0))
- Utility Meter für Energy-Zähler (Quelle IMMER abstrahiert)
- Keine versionierten IDs: unique_id/entity_id/id sind stabil!

---

## Code-Konventionen

- YAML: 2-Space Indent
- IDs: kebab-case, keine Versionen (v1, v2 etc.)
- Friendly Name: Kann [Vx.y] enthalten
- Templates: Nutze | float(0) für Fehlerbehandlung
- Keine Root-Dateien (sensor.yaml, automation.yaml) — alles in Packages
- Code-Header mit Versionierung (alias/friendly_name nur!)

---

## Build & Development

```bash
# Build
ha core check-config

# Tests
ha core check-config && ha core validate --config config/

# Dev-Stack starten
docker-compose -f docker-compose.dev.yml up -d

# Nach Änderungen neu laden
ha core restart
```

---

## Anforderungs-Kategorien

Kategorien für `docs/REQUIREMENTS.md`:

- **Automationen & Logik** — Trigger, Actions, Conditions, Scripts
- **Energy Management** — Solar, Storage, Spotpreise, Lasten
- **Frontends & Dashboards** — Mushroom, Bubble Card, Layouts
- **Netzwerk & Infrastruktur** — MQTT, Zigbee, IP-Kameras
- **Smart Home Integration** — Neue Devices, Sensoren hinzufügen

---

## Agenten-Konfiguration

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

---

## Sprachregeln

- `README.md` → **Englisch**
- Alle anderen Dokumente → **Deutsch**
- Code-Kommentare, Commit-Messages → **Englisch**
- Kommunikation mit dem Nutzer → **Deutsch**

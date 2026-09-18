# ARTIFACT MANIFEST

> Entregables esperados por fase. `✔` completo, `⏳` en progreso, `✗` faltante.

## Control Plane

### FASE 0 — Plan y auditoria [✔ PASS]

- ✔ `docs/MASTER_IMPLEMENTATION_PLAN.md`
- ✔ Research Claude y ChatGPT leidos y auditados

### FASE 1 — Fundacion instalable y estado coherente [✔ PASS]

- ✔ `install.sh` instala context skills y registry canonico
- ✔ `settings.json` valido y wiring auditado
- ✔ `PROJECT_STATE.md`, `DECISION_REGISTRY.md`, `ARTIFACT_MANIFEST.md`
- ✔ `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`
- ✔ Contexto de subagentes verificado sin dependencia de `skills:`
- ✔ Evidencia EV-001 y smoke test reproducible

### FASE 2 — Evidence Contract y TaskCompleted [✔ PASS]

- ✔ Schema de evidence con hashes, checks, reviewer, exceptions y timestamp
- ✔ TaskCompleted valida el contrato por risk level
- ✔ Matriz reproducible de casos PASS/BLOCKED
- ✔ Evidencia EV-002 y gate

### FASE 3 — SDLC lanes y verificacion independiente [✔ PASS]

- ✔ Tier 1 structural y Tier 2 routing fixtures
- ✔ Tier 3 behavioral: dos corridas autenticadas con firma normalizada identica
- ✔ Evidencia EV-005 y gate

### FASE 4 — Incident learning cerrado [✔ PASS]

- ✔ `INCIDENT_REGISTRY.md` con RCA y cierre
- ✔ `CONTROL_REGISTRY.md` vinculando el control
- ✔ `REGRESSION_REGISTRY.md` vinculando el reproducer
- ✔ Fixture “sin control pasa / con control bloquea”
- ✔ Evidencia EV-006 y gate

### FASE 5 — Integridad de estado y provenance [✔ PASS]

- ✔ Hash de campos criticos en PreCompact
- ✔ Deteccion de drift en SessionStart compact
- ✔ Provenance en EVIDENCE_REGISTRY
- ✔ Smoke test reproducible de estado
- ✔ Evidencia EV-007 y gate

### FASE 6 — Evals y mantenimiento [✔ PASS]

- ✔ `evals/maintenance.sh` determinista
- ✔ Regression budget y benchmark baseline
- ✔ Workflow CI
- ✔ Evidencia EV-008 y gate

### FASE 7 — Evidence Integrity + Behavioral Reliability [✔ VERIFIED]

- ✔ Stop anti-loop con fixture de idempotencia
- ✔ Firewall endurecido con tolerancia de espacios/case y fixture positivo
- ✔ Freshness Tier 3 y `evidence_freshness_days=30`
- ✔ Fixture positivo de `secret-guard`
- ✔ Coupling de `task_id` + `contract_hash` y ARCH-004
- ✔ Rotacion diaria reversible de session log
- ✔ Instalador idempotente con prompt y `--force`
- ✔ EV-009 a EV-014 y REG-002 a REG-009
- ✔ Fresh independent review PASS
- ✔ Scripts verificados; runtime nativo de Claude Code NOT_VERIFIED

### FASE 8 — Cierre de gaps diferidos de F7 [⏳ RESEARCH COMPLETE · IMPLEMENTATION NOT AUTHORIZED]

- ✔ Research completo: `docs/00_SYSTEM/F8_RESEARCH.md` (2026-09-18)
- ⏳ Bundle F8-A (contract_hash fail-closed; cierra A-03) — propuesto, no implementado
- ⏳ Bundle F8-B (firewall fail-closed sobre JSON malformed; cierra A-04) — propuesto, no implementado
- ⏳ A-06 convencion de reviewer identity en Handbook — propuesto, no implementado
- ⏳ Owner debe aprobar explicitamente antes de cualquier implementacion F8

### FASES 9-12 — Estado [UNKNOWN / RESEARCH REQUIRED]

- ⏳ No existen definicion, evidencia ni implementacion historica en este repositorio
- ⏳ No iniciar sin research adicional y aprobacion del owner

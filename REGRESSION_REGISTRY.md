# REGRESSION_REGISTRY

> Regresiones reproducibles que demuestran que un control sigue funcionando.

## Schema

```text
## REG-001 — {regresion en una linea}
- **Incident:** INC-001
- **Test/Eval:** {ruta y comando}
- **Baseline Outcome:** ACCEPTED | BLOCKED
- **Control Outcome:** BLOCKED | ACCEPTED
- **Last Verified:** YYYY-MM-DD
- **Evidence:** EV-NNN
- **Status:** ACTIVE | RETIRED
```

## Regressions

## REG-001 — TaskCompleted blocks completion without evidence
- **Incident:** INC-001
- **Test/Eval:** `evals/incidents/INC-001-task-completed-evidence.sh`
- **Baseline Outcome:** ACCEPTED
- **Control Outcome:** BLOCKED
- **Last Verified:** 2026-09-17
- **Evidence:** EV-006
- **Status:** ACTIVE

## REG-002 — Firewall positive fixture blocks malicious command families
- **Incident:** NONE (preventive; G-T1)
- **Test/Eval:** `evals/hooks/firewall-positive.sh`; `bash evals/maintenance.sh`
- **Baseline Outcome:** ACCEPTED
- **Control Outcome:** BLOCKED
- **Last Verified:** 2026-09-18
- **Evidence:** EV-011
- **Status:** ACTIVE

## REG-003 — Secret guard positive fixture blocks credential-shaped content
- **Incident:** NONE (preventive; G-T1)
- **Test/Eval:** `evals/hooks/secret-guard-positive.sh`; `bash evals/maintenance.sh`
- **Baseline Outcome:** ACCEPTED
- **Control Outcome:** BLOCKED
- **Last Verified:** 2026-09-18
- **Evidence:** EV-009
- **Status:** ACTIVE

## REG-004 — Tier 3 evidence freshness rejects stale and reused results
- **Incident:** NONE (preventive; G-V1/G-Bob-2)
- **Test/Eval:** `evals/skills/evidence-freshness.sh`; duplicate-session and stale-timestamp probes
- **Baseline Outcome:** ACCEPTED
- **Control Outcome:** BLOCKED
- **Last Verified:** 2026-09-18
- **Evidence:** EV-009
- **Status:** ACTIVE

## REG-005 — Stop hook does not re-emit active-hook reminders
- **Incident:** NONE (preventive; F-LOOP-01)
- **Test/Eval:** `evals/hooks/stop-hook-idempotency.sh`
- **Baseline Outcome:** ACCEPTED
- **Control Outcome:** BLOCKED
- **Last Verified:** 2026-09-18
- **Evidence:** EV-010
- **Status:** ACTIVE

## REG-006 — Firewall regexes resist whitespace, case and read-form mutations
- **Incident:** NONE (preventive; F-BYPASS-01/02/03)
- **Test/Eval:** `evals/hooks/firewall-positive.sh`; adversarial firewall variant probe
- **Baseline Outcome:** ACCEPTED
- **Control Outcome:** BLOCKED
- **Last Verified:** 2026-09-18
- **Evidence:** EV-011
- **Status:** ACTIVE

## REG-007 — TaskCompleted rejects mismatched completion contracts
- **Incident:** NONE (preventive; F-FALSE_PASS-01)
- **Test/Eval:** `evals/hooks/task-completed-coupling.sh`; `evals/incidents/INC-001-task-completed-evidence.sh`
- **Baseline Outcome:** ACCEPTED
- **Control Outcome:** BLOCKED
- **Last Verified:** 2026-09-18
- **Evidence:** EV-012
- **Status:** ACTIVE

## REG-008 — Session log rotation preserves archives and truncates active state
- **Incident:** NONE (preventive; F-ROTATION-01)
- **Test/Eval:** `evals/hooks/session-log-rotation.sh`
- **Baseline Outcome:** ACCEPTED
- **Control Outcome:** BLOCKED
- **Last Verified:** 2026-09-18
- **Evidence:** EV-013
- **Status:** ACTIVE

## REG-009 — Installer preserves user settings unless forced
- **Incident:** NONE (preventive; F-INSTALL-01)
- **Test/Eval:** `evals/install/idempotency.sh`; `bash evals/maintenance.sh`
- **Baseline Outcome:** ACCEPTED
- **Control Outcome:** BLOCKED
- **Last Verified:** 2026-09-18
- **Evidence:** EV-014
- **Status:** ACTIVE

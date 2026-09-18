# POST-F7 AUDIT REPORT — Claude Control Plane

**Date:** 2026-09-18
**Phase:** F7 Extended
**Variant:** C — Evidence Integrity Hardening + Behavioral Reliability Hardening
**Baseline commit:** `b6e8fd0b76742ec0320af5a1b8598e712c8c67b6`
**Implementation range:** `b6e8fd0..b659dfb` before documentation closure

## 1. Status

- **CURRENT:** F7 Extended is VERIFIED / COMPLETE after implementation, review, evidence and final gate.
- **IMPLEMENTED:** Bundles A-E, freshness checks, positive fixtures and ARCH-004.
- **HISTORICAL:** F1-F6, EV-001 through EV-008, INC-001, CTRL-001 and REG-001 are preserved.
- **DEFERRED:** G-B6, G-B10, G-B11, G-M1, G-L1 and G-N3/N4/N5 remain outside F7.
- **UNKNOWN:** F8-F12 are not defined and require research; native Claude Code runtime execution was
  not available in OpenCode.

## 2. Baseline Gate

- `git rev-parse HEAD`: `b6e8fd0b76742ec0320af5a1b8598e712c8c67b6`
- `bash evals/maintenance.sh`: 9/9 PASS before implementation.
- `PROJECT_STATE.md`: F6 COMPLETE, `IMPLEMENTATION_READY=true`.
- Evidence: EV-001 through EV-008 intact.
- Incident/control/regression: INC-001 CLOSED, CTRL-001 ACTIVE, REG-001 ACTIVE.
- State integrity: PASS with expected baseline drift detection.

## 3. Implemented Bundles

| Bundle | Result | Evidence | Regression |
|---|---|---|---|
| ADR-004 | Task semantics convention recorded | EV-012 | REG-007 |
| A — Stop anti-loop | `stop_hook_active=true` is idempotent | EV-010 | REG-005 |
| B — Firewall | Space/case/read-form bypasses blocked; legitimate probes allowed | EV-011 | REG-002, REG-006 |
| Freshness + positive fixtures | Tier 3 uniqueness/age and firewall/secret-guard suites wired | EV-009 | REG-002, REG-003, REG-004 |
| C — Evidence coupling | Exact task/status and supplied hash coupling enforced | EV-012 | REG-007 |
| D — Rotation | Daily, reversible `mv` rotation with same-day suffixes | EV-013 | REG-008 |
| E — Installer | Existing user settings preserved unless confirmed or forced | EV-014 | REG-009 |

No hook, skill, agent, registry type, external dependency or F8-F12 component was added.

## 4. Verification

Executed after implementation and review fixes:

- `bash evals/maintenance.sh`: 12/12 PASS.
- `bash evals/incidents/INC-001-task-completed-evidence.sh`: PASS.
- `bash evals/state/state-integrity.sh`: PASS; drift detection remains expected.
- `evals/skills/validate.sh`: Tier 1 PASS, Tier 2 PASS, Tier 3 PASS.
- `evals/hooks/stop-hook-idempotency.sh`: PASS.
- `evals/hooks/firewall-positive.sh`: PASS.
- `evals/hooks/secret-guard-positive.sh`: PASS.
- `evals/skills/evidence-freshness.sh`: PASS; duplicate and stale probes blocked.
- `evals/hooks/task-completed-coupling.sh`: PASS.
- `evals/hooks/session-log-rotation.sh`: PASS.
- `evals/install/idempotency.sh`: PASS.
- `bash -n` on `install.sh`, maintenance, hooks and F7 fixtures: PASS.
- Adversarial probes for whitespace, case, quoting, process substitution, malformed input, repeated
  execution, stale evidence, historical-task mismatch, reinstall and fail-closed dependency paths:
  PASS.

## 5. Evidence And Review

- EV-009 through EV-014 are `VERIFIED`, `GENERATED`, timestamped, hashed and linked to REG-002
  through REG-009.
- EV-001 through EV-008 were not rewritten.
- Independent fresh review of the committed implementation range returned **PASS** after two rounds
  of adversarial findings and fixes.
- This report makes no claim that native Claude Code hook lifecycle behavior was exercised.

## 6. Change Budget

| Item | Planned | Actual |
|---|---:|---:|
| Runtime/test additions | approximately 80 LOC | 591 additions, 17 deletions in committed F7 implementation/test surface |
| Fixtures | approximately 5 | 7 fixture files |
| ADR/convention | 1 | 1 (ARCH-004) |
| Config fields | 1 | 1 (`evidence_freshness_days`) |
| New runtime components | 0 | 0 |
| New dependencies | 0 | 0 |

The variance was raised as a blocking reassessment before closure. The owner explicitly accepted the
scoped overrun because it came from executable adversarial coverage and independent review findings;
the approved five-bundle scope and side-effect budget did not expand.

## 7. Rollback

- **Available:** YES.
- **Method:** `git revert <bundle-commit>` per bundle, or revert the complete F7 implementation range.
- **Verification:** rollback commands were reviewed; an implementation-destructive rollback was not
  executed because the contract prefers preserving the verified working tree.
- **Limitation:** native runtime rollback was not exercised because native Claude Code was not
  available in OpenCode.
- **Historical preservation:** rollback does not require rewriting EV-001 through EV-008 or the
  INC-001 control cycle.

## 8. Known Limitations

- Native Claude Code runtime claims remain `NOT_VERIFIED`.
- Firewall regexes cover the demonstrated and reviewed nearby bypass families, not arbitrary shell
  obfuscation. `TRUNCATE users` remains outside the demonstrated SQL pattern.
- Malformed firewall JSON is treated as an empty command by the pre-existing fail-open extraction
  path; missing `jq` remains fail-closed. This was not expanded into a new firewall architecture.
- The one-phase absent-`contract_hash` warning path is intentional ARCH-004 backwards compatibility;
  the next phase must make it fail-closed.
- Whole-worktree `git diff --check` is affected by pre-existing trailing whitespace in the baseline
  user-modified `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md`; all F7-scoped diffs pass the check and that
  historical/user change was not normalized.

## 9. Next Allowed Phase

`F8 RESEARCH REQUIRED`. Do not begin F8 implementation from this report.

## 10. Closure Gate

- **F7_STATUS:** VERIFIED / COMPLETE
- **PROJECT_STATE:** CURRENT_PHASE 7, PHASE_STATUS COMPLETE
- **NEXT_ALLOWED_PHASE:** F8 RESEARCH REQUIRED
- **CHECKPOINT:** implementation commits through `b659dfb`; documentation/evidence checkpoints are
  `3ed9609`, `69b2c23` and evidence identity correction `ec8b76e`; historical evidence was not
  rewritten.

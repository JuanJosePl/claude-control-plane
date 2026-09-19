# POST-F8 AUDIT REPORT — Claude Control Plane

**Date:** 2026-09-19
**Phase:** F8
**Status:** COMPLETE / FROZEN
**Baseline HEAD:** `f6eb0d529a8c1ec67714926678a5d47dfb209dbe`
**F7 checkpoint:** `47874a54e2c293c8fa74cacf41479650a638d013`
**F8 evidence checkpoint:** `95f1555`

## 1. Authorization And Decisions

- **D1:** GO — F8-A + F8-B + A-06 authorized.
- **D2:** AMEND_IN_PLACE — ARCH-004 amended without deleting its F7 wording.
- **D3:** TOGETHER — A-06 included in the F8 closure/review path.
- **D4:** DEFER — `docs/DESIGN.md` discrepancy remains untouched.

## 2. Scope

F8 closed only A-03, A-04 and A-06. No new hook, fixture file, skill, agent, rule, dependency,
registry or identity field was introduced. A-05, A-07 and all other deferred items remain deferred.

## 3. Implemented Changes

### F8-A — contract_hash fail-closed

`.claude/hooks/task-completed-evidence.sh` now blocks an otherwise valid completion payload that
omits `contract_hash`, with `exit 2` and an explicit `contract_hash` reason. Existing matching,
bare hash, mismatch, empty/null hash, historical-task, nonexistent-task, malformed-input, risk and
reviewer behavior remains covered.

Fixture: `evals/hooks/task-completed-coupling.sh`.
Commit: `f840c71`.

### F8-B — malformed firewall JSON fail-closed

`.claude/hooks/bash-firewall.sh` now rejects empty, whitespace-only, malformed, truncated,
multi-document and raw-NUL payloads before command extraction. Valid single JSON payloads with no
command, an empty command, Unicode content or an innocuous command remain allowed. Existing F7
regex controls remain unchanged.

Fixture: `evals/hooks/firewall-positive.sh`.
Commits: `0f79b68`, `e25179f`, `1427fbe`.

### A-06 — reviewer identity convention

Handbook §12 documents `PASS (code-reviewer@fresh-context)`, `PASS (human/@owner)` and
`NOT_REQUIRED` as documentation conventions only. No schema or runtime enforcement was added.

Commit: `92050dd`.

### ARCH-004

ARCH-004 was amended in place. Its original F7 transitional wording remains traceable; the F8-A
addendum makes `contract_hash` mandatory and marks the warning behavior `SUPERSEDED`.

## 4. Verification

- `bash evals/maintenance.sh`: 12/12 PASS.
- `bash evals/incidents/INC-001-task-completed-evidence.sh`: PASS.
- `bash evals/state/state-integrity.sh`: PASS.
- `evals/skills/validate.sh`: Tier 1/2/3 PASS.
- All existing F7 fixtures: PASS.
- F8 coupling and firewall fixtures: PASS.
- Boundary probes: malformed, empty, whitespace-only, truncated, invalid, multi-document and raw-NUL firewall payloads BLOCK; `{}`, empty command, Unicode JSON and innocuous commands ALLOW.
- All required `bash -n` checks: PASS.

## 5. Independent Review

Three fresh review rounds were recorded:

1. **BLOCK:** whitespace-only/multi-document firewall payloads and pending closure artifacts.
2. **BLOCK:** raw-NUL payload bypass after the first correction.
3. **PASS:** after both F8-scoped corrections; no remaining findings.

Reviewer identity convention: `PASS (code-reviewer@fresh-context)`. The reviewer was an independent
fresh-context subagent; this does not prove Claude Opus identity.

## 6. Evidence And Regressions

- EV-015 — F8-A, contract hash `sha256:a0bbbd9f01d99110aa9674316d30b7525fbfb8f4b0a7e3d2c3829a4c0579a7e7`.
- EV-016 — F8-B, contract hash `sha256:a0bbbd9f01d99110aa9674316d30b7525fbfb8f4b0a7e3d2c3829a4c0579a7e7`.
- REG-010 — absent `contract_hash` blocked; baseline was observed `ALLOW` with F7 warning.
- REG-011 — malformed firewall JSON blocked; baseline was observed `ALLOW` through empty-command extraction.

Historical EV-001..EV-014 and REG-001..REG-009 were compared append-only against the baseline and
remain byte-identical.

## 7. Change Budget

| Item | Planned | Actual |
|---|---:|---:|
| Runtime Bash | <=20 changed lines | 18 changed lines / 14 additions |
| Existing fixture extensions | 2 | 2 |
| New fixture files | 0 | 0 |
| New hooks/skills/agents/rules | 0 | 0 |
| New dependencies/registries | 0 | 0 |
| ADR | 1 in-place amendment | 1 |
| Evidence entries | 2 | 2 |
| Regression entries | 2 | 2 |

The two review corrections stayed inside F8-B and did not expand the threat model.

## 8. Historical Preservation

- F7 checkpoint `47874a5` remains unchanged.
- EV-001..EV-014, REG-001..REG-009, INC-001, CTRL-001, POST_F6_AUDIT_REPORT.md and
  POST_F7_AUDIT_REPORT.md were not modified.
- `docs/DESIGN.md` was not modified because D4 was DEFER.
- The historical evidence registry prefix was compared at 258 lines; the historical regression
  prefix was compared at 99 lines.

## 9. Rollback

Rollback is commit-based and local:

- Revert `1427fbe`, `e25179f`, `0f79b68` and `f840c71` for runtime bundles.
- Revert `92050dd` for A-06/ARCH-004 documentation.
- Revert `95f1555` for evidence/regression closure if a full F8 rollback is required.

Rollback does not require rewriting F1-F7 evidence.

## 10. Final State

- **F7:** COMPLETE / FROZEN at `47874a5`.
- **F8:** COMPLETE / FROZEN.
- **IMPLEMENTATION_READY:** false.
- **F9-F12:** UNKNOWN / RESEARCH REQUIRED; no F9 implementation started.
- **Native Claude Code verified:** NO. OpenCode only executed scripts and fixtures.

## 11. Known Limitations

- Native Claude Code lifecycle behavior remains NOT VERIFIED.
- Reviewer model identity is not proven to be Claude Opus 4.7.
- Firewall pattern coverage remains finite and does not claim arbitrary shell-obfuscation coverage.
- The prompt's illustrative EV-014 task ID used `F7-installer-idempotency`; the repository's actual
  canonical ID is `F7-install-idempotency`, which was used for baseline reproduction.

**Next allowed phase:** F9 research only. No implementation is authorized automatically.

# EVIDENCE_REGISTRY

> Fuente unica canonica de evidencia de cambios del control plane.

## Schema

```text
## EV-001 — {claim en una linea}
- **Task ID:** {task_id}
- **Date:** YYYY-MM-DD
- **Claim:** {texto completo}
- **Source:** {test, comando, documento o artifact}
- **Provenance:** EXTRACTED | INFERRED | ASSUMED | EXTERNAL | GENERATED
- **Confidence:** HIGH | MEDIUM | LOW | HIPOTESIS
- **Status:** VERIFIED | BLOCKED | PROPOSED | REJECTED
- **Affects:** {archivo, decision o control}
- **Notes:** {observaciones}
```

## Evidence

## EV-001 — F1 foundation is installable and state-coherent
- **Task ID:** F1-foundation-2026-09-16
- **Date:** 2026-09-16
- **Claim:** F1 produces a clean installation with valid settings, canonical registries, all context skills, executable hook wiring, and role-based SubagentStart context injection without unsupported agent skill loading.
- **Source:** `bash -n install.sh`; `bash -n .claude/hooks/*.sh`; `jq empty .claude/settings.json`; clean temporary install smoke test; TaskCompleted wiring assertion; SubagentStart JSON payload assertion; duplicate/obsolete reference checks.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** `install.sh`, `.claude/settings.json`, `.claude/hooks/subagent-context.sh`, `.claude/agents/*`, canonical state and evidence registries.
- **Artifact Hash:** sha256:e9ede2707de1b407a9988aa3d6eca7b2135aa0574ddd35d16ca5566db87fc804
- **Contract Hash:** sha256:4849b26096fc536caca6a87e853e61da32a65b29659a97aa257e36c24b255063
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-16T23:59:00Z
- **Notes:** F1 evidence was verified before F2; no F2 feature was implemented in F1.

## EV-002 — F2 Evidence Contract blocks incomplete completion evidence
- **Task ID:** F2-evidence-contract-2026-09-16
- **Date:** 2026-09-16
- **Claim:** TaskCompleted validates the canonical evidence contract, risk-aware reviewer requirements, hashes, checks, exceptions and timestamp, blocking incomplete, stale or malformed evidence.
- **Source:** hook smoke matrix covering valid low-risk PASS, missing task, invalid risk, malformed JSON, stale PROPOSED status, missing medium-risk reviewer and unapproved exception.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** `.claude/hooks/task-completed-evidence.sh`, `.claude/skills/evidence/SKILL.md`, `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.
- **Artifact Hash:** sha256:8277a0ae0e3b4d054cef021d82e5e1faa9fbad9f5c7ef46433f30225b97d0821
- **Contract Hash:** sha256:4849b26096fc536caca6a87e853e61da32a65b29659a97aa257e36c24b255063
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-16T23:59:00Z
- **Notes:** No new hook, registry or skill was added in F2; the existing P0 hook and canonical Markdown registry were hardened.

## EV-003 — F3 behavioral evaluation is blocked by unavailable Claude runtime authentication
- **Task ID:** F3-sdlc-evals-2026-09-16
- **Date:** 2026-09-16
- **Claim:** Tier 1 structural and Tier 2 routing validation pass; Tier 3 behavioral execution cannot be verified because the local Claude CLI is not authenticated.
- **Source:** `evals/skills/validate.sh`; `claude --bare --no-session-persistence --tools "" --permission-prompts none --max-budget-usd 1 --output-format json -p ...` returned `Not logged in · Please run /login`.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** BLOCKED
- **Affects:** `evals/skills/fixtures.json`, `evals/skills/validate.sh`, `.claude/agents/code-reviewer.md`, four SDLC skills.
- **Artifact Hash:** sha256:1a3ef0769102ed007be3d0062627426ccaccd04fb527fc2f67595bc7b11f3ad9
- **Contract Hash:** sha256:4849b26096fc536caca6a87e853e61da32a65b29659a97aa257e36c24b255063
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** NOT_REQUIRED
- **Exceptions:** NONE
- **Timestamp:** 2026-09-16T23:59:00Z
- **Notes:** F4+ remain blocked. No login, credential, provider or cross-provider infrastructure was added.

## EV-004 — F3 Tier 3 retry remains blocked by the same external dependency
- **Task ID:** F3-sdlc-evals-retry-2026-09-16
- **Date:** 2026-09-16
- **Claim:** The exact EV-003 behavioral contract and fixtures were executed twice after the requested resume; both runs returned the same unauthenticated-runtime error and produced no behavioral result.
- **Source:** `/tmp/opencode/f3-behavioral-run1.json` and `/tmp/opencode/f3-behavioral-run2.json`; both contain `result: "Not logged in · Please run /login"`.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** BLOCKED
- **Affects:** F3 Tier 3 behavioral gate; F4 remains unopened.
- **Artifact Hash:** sha256:1a3ef0769102ed007be3d0062627426ccaccd04fb527fc2f67595bc7b11f3ad9
- **Contract Hash:** sha256:4849b26096fc536caca6a87e853e61da32a65b29659a97aa257e36c24b255063
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** NOT_REQUIRED
- **Exceptions:** NONE
- **Timestamp:** 2026-09-16T23:59:00Z
- **Notes:** No fixtures, skill contracts, authentication files, providers or cross-provider infrastructure were changed. F4 was not started.

## EV-005 — F3 Tier 3 behavioral evaluation passes reproducibly
- **Task ID:** F3-sdlc-evals-pass-2026-09-17
- **Date:** 2026-09-17
- **Claim:** The exact EV-003 prompt and fixtures executed twice with authenticated first-party Claude CLI; all four skills passed positive, negative and collision routing checks in both runs.
- **Source:** `evals/skills/results/F3-tier3-run-1.json` and `evals/skills/results/F3-tier3-run-2.json`; normalized behavioral signatures are identical.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** F3 SDLC lanes, Tier 3 behavioral gate, `.claude/agents/code-reviewer.md`.
- **Artifact Hash:** sha256:d2e7f58c581eefdecad0987e1d46446aaf62b9b590a771095f57f5c54659ead0
- **Contract Hash:** sha256:e09dc63b99606f4964837c97d5b7beb3b4284cb893ff98b20584c0904065865d
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-17T00:00:00Z
- **Notes:** The `--bare` authentication failure remains historical in EV-003/EV-004; the passing runs used the authenticated CLI without `--bare`. No fixture or skill contract changed.

## EV-006 — F4 incident regression proves control enforcement
- **Task ID:** F4-incident-learning-2026-09-17
- **Date:** 2026-09-17
- **Claim:** The INC-001 reproducer accepts the same well-formed payload through an explicit control-free baseline and the active TaskCompleted control blocks it when no task-specific VERIFIED evidence exists; the block reason is asserted.
- **Source:** `evals/incidents/INC-001-task-completed-evidence.sh`; clean install also distributes the fixture.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** `INCIDENT_REGISTRY.md`, `CONTROL_REGISTRY.md`, `REGRESSION_REGISTRY.md`, `.claude/skills/incident/SKILL.md`, `install.sh`.
- **Artifact Hash:** sha256:a6e4d3dc64fd0aa6571e08d537209c740bd34bad06c49b23e42900ad67961afb
- **Contract Hash:** sha256:6696601769441b4c921f8e0538a8303ee47f28fe24906767f00ba089f74809c2
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-17T00:00:00Z
- **Notes:** Independent reviewer returned PASS; rollback command was verified against `e679b46`. No new hook was added.

## EV-007 — F5 state integrity and provenance pass
- **Task ID:** F5-state-integrity-2026-09-17
- **Date:** 2026-09-17
- **Claim:** PreCompact writes a hash of critical PROJECT_STATE fields, SessionStart compact reports PASS when unchanged and DRIFT_DETECTED after mutation, and all canonical evidence entries declare provenance.
- **Source:** `evals/state/state-integrity.sh`; `bash -n` for modified hooks; provenance count assertion over `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** `.claude/hooks/pre-compact-snapshot.sh`, `.claude/hooks/session-start-compact.sh`, `.claude/skills/doctor/SKILL.md`, `evals/state/state-integrity.sh`, evidence schema.
- **Artifact Hash:** sha256:5226c5469ace9579402b8e11c42e6a8777e3248d5275d900024db3212e48db80
- **Contract Hash:** sha256:7f8effdc7fb4a678db1528458a7f7221e19fe7919ca10f5496f39f9a191ed638
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** NOT_REQUIRED
- **Exceptions:** NONE
- **Timestamp:** 2026-09-17T00:00:00Z
- **Notes:** Existing hooks were reused; no PostCompact or FileChanged hook was added.

## EV-008 — F6 maintenance suite and regression budget pass
- **Task ID:** F6-maintenance-2026-09-17
- **Date:** 2026-09-17
- **Claim:** The deterministic maintenance suite passes schema, installer, hooks, skills, incident regression, state integrity, evidence provenance, docs reference and regression-budget checks; the CI workflow is present and the benchmark baseline has 100% pass rate with zero signature variance.
- **Source:** `evals/maintenance.sh`; `.github/workflows/control-plane.yml`; `evals/benchmarks/F3-tier3-baseline.json`.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** F6 maintenance suite, CI workflow, regression budget, benchmark baseline.
- **Artifact Hash:** sha256:9523b75c5749de474dfa4a28bda3b57c93f1b315a5f9a54fc9747b1f1c913cdb
- **Contract Hash:** sha256:b2cac8024a87f7beaed529180959374991164eff5429d31a3d0ee6571e2cedd0
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** NOT_REQUIRED
- **Exceptions:** NONE
- **Timestamp:** 2026-09-17T00:00:00Z
- **Notes:** CI is deterministic and does not require LLM authentication; mutation testing global, dashboards, plugins and cross-provider remain out of scope.

## EV-009 — F7 freshness and positive control checks pass
- **Task ID:** F7-freshness-2026-09-18-dcc7ef25
- **Date:** 2026-09-18
- **Claim:** Tier 3 results reject reused session_id and stale timestamps, while the firewall and secret-guard positive fixtures execute through maintenance and pass their control assertions.
- **Source:** `bash evals/maintenance.sh`; `evals/skills/evidence-freshness.sh`; duplicate-session and stale-timestamp negative fixtures; `evals/hooks/firewall-positive.sh`; `evals/hooks/secret-guard-positive.sh`.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** `evals/maintenance.sh`, `evals/skills/evidence-freshness.sh`, `evals/REGRESSION_BUDGET.json`, firewall and secret-guard positive controls.
- **Artifact Hash:** sha256:dcc7ef255b8a4fd86490feb82239113c03c6f0aa97256c0eaef47a3ddbb58183
- **Contract Hash:** sha256:2fdac1ffe1322a2e47179bf3ebf8d55e4c680632a46363913a070fa12451d6e5
- **Checks:** tests=PASS; static=PASS; security=PASS
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-18T19:11:13Z
- **Notes:** Freshness uses `evidence_freshness_days=30`; files without a JSON timestamp use their mtime. SCRIPT VERIFIED; native Claude runtime NOT_VERIFIED.

## EV-010 — F7 Stop anti-loop is verified
- **Task ID:** F7-anti-loop-2026-09-18-ef8dfba0
- **Date:** 2026-09-18
- **Claim:** Stop returns safely without emitting repeated additionalContext when `stop_hook_active=true`, while the normal stale-state reminder and malformed-input fail-open behavior remain intact.
- **Source:** `evals/hooks/stop-hook-idempotency.sh`; `bash -n .claude/hooks/stop-logger.sh`; maintenance hook regression.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** `.claude/hooks/stop-logger.sh`, REG-005.
- **Artifact Hash:** sha256:ef8dfba08e31defb437cf164858b0a98ce4965a721282f0f72a0d7e35b14f69a
- **Contract Hash:** sha256:2fdac1ffe1322a2e47179bf3ebf8d55e4c680632a46363913a070fa12451d6e5
- **Checks:** tests=PASS; static=PASS; security=PASS
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-18T19:11:13Z
- **Notes:** SCRIPT VERIFIED; native Claude runtime NOT_VERIFIED.

## EV-011 — F7 firewall hardening blocks demonstrated bypasses
- **Task ID:** F7-firewall-2026-09-18-ef2daafe
- **Date:** 2026-09-18
- **Claim:** The existing bash firewall blocks whitespace and case mutations of destructive patterns, spaced fork-bomb variants, demonstrated `.env` read families, and nearby quoted/process-substitution variants while allowing tested legitimate commands.
- **Source:** `evals/hooks/firewall-positive.sh`; adversarial firewall variant probe; `bash evals/incidents/INC-001-task-completed-evidence.sh`; `bash -n .claude/hooks/bash-firewall.sh`.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** `.claude/hooks/bash-firewall.sh`, REG-002, REG-006.
- **Artifact Hash:** sha256:ef2daafe37bdbe117f82280f0d747e57bfcbee2a5b008d66f7675c6ec4c11afd
- **Contract Hash:** sha256:2fdac1ffe1322a2e47179bf3ebf8d55e4c680632a46363913a070fa12451d6e5
- **Checks:** tests=PASS; static=PASS; security=PASS
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-18T19:11:13Z
- **Notes:** Independent fresh review PASS. SCRIPT VERIFIED; native Claude runtime NOT_VERIFIED.

## EV-012 — F7 evidence coupling and ARCH-004 are verified
- **Task ID:** F7-evidence-coupling-2026-09-18-e267b3d9
- **Date:** 2026-09-18
- **Claim:** TaskCompleted accepts matching contract evidence, blocks mismatched or empty/null hashes, exact task/status mismatches, nonexistent tasks, malformed payloads and invalid evidence, with the documented one-phase warning only when the hash field is absent.
- **Source:** `evals/hooks/task-completed-coupling.sh`; `bash evals/incidents/INC-001-task-completed-evidence.sh`; `DECISION_REGISTRY.md` ARCH-004; independent fresh review.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** `.claude/hooks/task-completed-evidence.sh`, ARCH-004, REG-001, REG-007.
- **Artifact Hash:** sha256:e267b3d9ffcc0fd73de5d6699262601f654067b0e9ee5eacac26f31f762bf650
- **Contract Hash:** sha256:2fdac1ffe1322a2e47179bf3ebf8d55e4c680632a46363913a070fa12451d6e5
- **Checks:** tests=PASS; static=PASS; security=PASS
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-18T19:11:13Z
- **Notes:** The absent-field warning is transitional per the handoff and ARCH-004; supplied invalid values fail closed. SCRIPT VERIFIED; native Claude runtime NOT_VERIFIED.

## EV-013 — F7 session log rotation is verified
- **Task ID:** F7-session-rotation-2026-09-18-5b93a591
- **Date:** 2026-09-18
- **Claim:** Session logs below threshold remain in place; threshold rotation moves the active log to a daily archive, preserves same-day archives with suffixes, and avoids unbounded duplicate copies.
- **Source:** `evals/hooks/session-log-rotation.sh`; `bash -n .claude/hooks/subagent-stop-logger.sh`; maintenance hook regression.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** `.claude/hooks/subagent-stop-logger.sh`, REG-008.
- **Artifact Hash:** sha256:5b93a5915c20d0a1bd2c256a2dc3db452439ec5501fcc7b823572ca4254f737a
- **Contract Hash:** sha256:2fdac1ffe1322a2e47179bf3ebf8d55e4c680632a46363913a070fa12451d6e5
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-18T19:11:13Z
- **Notes:** SCRIPT VERIFIED; native Claude runtime NOT_VERIFIED.

## EV-014 — F7 installer idempotency is verified
- **Task ID:** F7-install-idempotency-2026-09-18-e81ec7ae
- **Date:** 2026-09-18
- **Claim:** Clean install, repeated install, partial recovery, interactive decline, non-interactive preservation and explicit `--force` replacement all behave without silently overwriting user settings.
- **Source:** `evals/install/idempotency.sh`; `bash -n install.sh`; maintenance installer regression.
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** `install.sh`, REG-009.
- **Artifact Hash:** sha256:e81ec7aeb4736e9063c8820a32a5ce4f039b5886ad57bc85f75f8c5874094971
- **Contract Hash:** sha256:2fdac1ffe1322a2e47179bf3ebf8d55e4c680632a46363913a070fa12451d6e5
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-18T19:11:13Z
- **Notes:** SCRIPT VERIFIED; native Claude runtime NOT_VERIFIED.

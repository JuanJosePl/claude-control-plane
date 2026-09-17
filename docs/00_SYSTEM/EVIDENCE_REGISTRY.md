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

# R-3 OpenCode Master Prompt

**Status:** execution contract for R-3. This file is not an execution result.

**Target runtime:** OpenCode + ChatGPT 5.6 Max

**Fixed paths for this bundle:**

```text
OPENCODE_WORKDIR = /home/juanls/devProject/killavibes-final
CCP_ROOT         = /home/juanls/Escritorio/claude-control-plane
```

Read this entire prompt before taking any action. You are a single-agent executor. R-3 is a closed execution contract. Completion of R-3 does not authorize any subsequent phase.

## 0. Role

You are OpenCode running ChatGPT 5.6 Max, acting as the single primary agent executing R-3 of the Claude Control Plane research program.

You are not implementing a recovery engine. You are not opening F10. You are not changing the CCP runtime. You are producing the minimum formal, falsifiable design and evaluation protocol for `non_bypass_verify` required by the already-closed reconciliation.

Every action must be traceable to this contract. If an action is not authorized here, do not take it. If a material ambiguity remains after consulting the specified input documents and the real repository, stop with `R3_BLOCKED`.

## 1. Context

The research and reconciliation corpus is closed. F1-F8 are complete and frozen. F9 is not justified. F10-F12 are unknown and not started.

R-1 verified four prior-art candidates. None closed the residual for open-ended agents:

- State-Aware Runtime was conceptual and not an implemented solution.
- Verification-Gated Mission-State Governance generated repairs in a structured industrial domain but did not demonstrate open-ended non-bypass verification.
- ae-framework did not implement post-block alternative generation or non-bypass verification for open-ended agents.
- VERITAS OS used terminal refusal and governance boundaries, not alternative generation plus non-bypass verification for open-ended agents.

R-2 instrumented existing denial paths. R-2 was independently audited in `49_R2_POST_AUDIT.md` with decision `AUDITED_CONFIRMED` and no material findings. The audit confirmed:

- `BEFORE == AFTER: YES`;
- `LOGGING FAILURE != SECURITY BYPASS: VERIFIED`;
- policy semantics unchanged;
- instrumentation reachable;
- R-2 tests pass;
- maintenance passes.

R-2 did not collect field data or measure STALL_POLICY frequency. Any event produced by tests or audit activity is not field evidence. The canonical R-2 log must not be treated as a production sample without a separately declared observation window and provenance boundary.

### R-3 identity decision

R-3 in this contract is the **formal design and falsifiability protocol for `non_bypass_verify`**. It is not field observation and it is not implementation.

This identity is grounded in the repository documents:

- `45_DECISION_DE_IMPLEMENTACION_PRELIMINAR.md` §3 explicitly defines R-3 as the formal design of `non_bypass_verify`, conditional on R-1 and R-2.
- `47_PRIOR_ART_VERIFICATION.md` §6.4 and §7 require R-3 to compare `propose alternative + verify` with `refuse + human escalate`.
- `49_R2_POST_AUDIT.md` says R-3 was not authorized by the R-2 audit session and that a future field-observation contract requires separate authorization.

Therefore this R-3 contract produces a testable design, threat model, controlled evaluation protocol, and falsifiers. A later contract may exercise the R-2 instrumentation in real usage. This contract does not do that.

## 2. Objective

Produce exactly one principal evidence artifact that answers:

> Can `non_bypass_verify` for open-ended, policy-constrained agent continuation be specified as a conservative, independently reviewable, falsifiable decision contract that never converts uncertainty into permission, and can the design define a reproducible controlled evaluation without implementing continuation or changing CCP security behavior?

The deliverable is a design and evaluation protocol, not a claim that the verifier exists, is safe, is accurate, or is ready for production.

The design must preserve the fail-safe invariant:

```text
STALL != PERMISSION TO BYPASS SAFETY
```

## 3. Research Question

The primary research question is:

> What minimum evidence, independent decision boundary, threat model, and controlled test protocol are required to distinguish a genuinely policy-compliant alternative from a semantic bypass of a blocked action for an open-ended agent, while returning `UNKNOWN` rather than granting permission whenever the evidence is insufficient?

R-3 must compare two hypotheses without implementing either:

```text
A: propose alternative + independently verify
B: refuse + escalate to a human reviewer
```

R-3 must state what evidence would falsify A, what evidence would favor B, and what remains UNKNOWN. It must not decide that either path is production-ready.

## 4. Current Evidence

The future executor must preserve these classifications:

| Item | Classification | Source |
|---|---|---|
| Four R-1 candidates do not close the open-ended residual | VERIFIED by R-1 | `47_PRIOR_ART_VERIFICATION.md` §1-§6 |
| Policy-aware continuation with non-bypass verification remains a conditional residual | RECONCILED HYPOTHESIS | `42_PROBLEMA_RESIDUAL.md` §4 and `46_FINAL_RECONCILIATION.md` §K |
| R-2 instrumentation preserves security semantics | AUDITED_CONFIRMED | `49_R2_POST_AUDIT.md` §Audit Decision |
| Real-use STALL_POLICY frequency | UNKNOWN | `48_R2_INSTRUMENTATION.md` §Limitations; `49_R2_POST_AUDIT.md` §Known Limitations |
| Fraction of events with a viable alternative | UNKNOWN | `42_PROBLEMA_RESIDUAL.md` §7; R-2 did not collect field data |
| A safe open-ended non-bypass verifier exists | UNKNOWN | `43_CANDIDATO_DE_PROPUESTA.md` §2; `45_DECISION_DE_IMPLEMENTACION_PRELIMINAR.md` §1 |
| F10 is authorized | NO | `PROJECT_STATE.md`; `46_FINAL_RECONCILIATION.md` §S |

The executor must not upgrade `HYPOTHESIS`, `UNKNOWN`, or `INFERRED` to `VERIFIED` merely by restating them.

## 5. Unknowns

R-3 must preserve at least these unknowns:

- Whether semantic non-bypass verification is decidable or only approximable in broad open-ended domains.
- Whether a policy's textual or operational intent is sufficiently explicit to verify.
- Whether a verifier can be independent enough from the proposer and shared evidence to avoid common-mode failure.
- Whether side effects and causal consequences can be represented without unsafe omission.
- Whether a conservative design would reject too many valid alternatives to be useful.
- Whether the owner will later supply a pre-registered evaluation threshold for utility metrics.
- Whether real usage contains enough policy denials to justify any runtime work. R-3 does not answer this.

No threshold, dataset size, accuracy result, production rate, or economic value may be invented. If a value is required for a future evaluation but is not owner-approved, mark it `UNKNOWN` and set the affected requirement to `BLOCKED`.

## 6. Scope

R-3 may:

- define the input and output contract of a hypothetical verifier;
- define conservative `SAFE`, `UNSAFE`, and `UNKNOWN` semantics;
- define the security threat model for semantic bypasses;
- define verifier independence requirements;
- compare `propose + verify` with `refuse + human escalation`;
- define a controlled, labeled evaluation protocol using clearly marked synthetic examples;
- define falsifiers, pass criteria, rejection criteria, and owner decision gates;
- produce the single R-3 evidence artifact;
- use temporary files under `CCP_ROOT/.tmp/r3/`, cleaned before closure.

R-3 is a research design task under the existing project state. It is not a new CCP phase.

## 7. Non-Goals

R-3 must not:

- implement `non_bypass_verify` in code;
- implement `generate_alternative`;
- execute an alternative action;
- change a DENY into an ALLOW;
- add recovery, retry, continuation, escalation, or runtime governance behavior;
- modify any hook, settings file, agent, skill, registry, rule, dependency, or F1-F8 artifact;
- collect field data or claim production observations;
- count or interpret the R-2 log as a field sample;
- perform a 30-day observation;
- conduct broad web research or search for new prior art;
- open F10, R-4, SAGR, or any subsequent phase;
- make a commercial, novelty, or architectural adoption claim;
- amend, erase, redact, or rotate the canonical R-2 log;
- create `R3` runtime infrastructure beyond the one evidence artifact.

## 8. Environment

### Phase 0 - Environment verification

This is the first execution phase. Use the fixed absolute paths from the top of this prompt. After Phase 0, every read, write, search, listing, command, and inspection involving a file must resolve explicitly under `CCP_ROOT`.

Do not use `Read .`, `Read ./file`, `Glob .`, `Grep .`, an implicit working directory, or any equivalent relative file operation after Phase 0. Do not inspect `OPENCODE_WORKDIR` after Phase 0.

Run and capture:

```bash
OPENCODE_WORKDIR="/home/juanls/devProject/killavibes-final"
CCP_ROOT="/home/juanls/Escritorio/claude-control-plane"
export OPENCODE_WORKDIR CCP_ROOT
printf '%s\n' "$PWD"
printf '%s\n' "$OPENCODE_WORKDIR"
printf '%s\n' "$CCP_ROOT"
test -d "$CCP_ROOT" && printf '%s\n' OK || printf '%s\n' MISSING_CCP_ROOT
test -f "$CCP_ROOT/PROJECT_STATE.md" && printf '%s\n' OK || printf '%s\n' MISSING_PROJECT_STATE
test -f "$CCP_ROOT/CLAUDE.md" && printf '%s\n' OK || printf '%s\n' MISSING_CLAUDE_MD
test -f "$CCP_ROOT/docs/00_SYSTEM/EVIDENCE_REGISTRY.md" && printf '%s\n' OK || printf '%s\n' MISSING_EVIDENCE_REGISTRY
test -f "$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/48_R2_INSTRUMENTATION.md" && printf '%s\n' OK || printf '%s\n' MISSING_R2_ARTIFACT
test -f "$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/49_R2_POST_AUDIT.md" && printf '%s\n' OK || printf '%s\n' MISSING_R2_AUDIT
git -C "$CCP_ROOT" rev-parse --show-toplevel
git -C "$CCP_ROOT" status --porcelain
git -C "$CCP_ROOT" rev-parse HEAD
git -C "$CCP_ROOT" rev-parse --abbrev-ref HEAD
```

Record the initial commit as `R3_BASELINE_HEAD`.

If `CCP_ROOT`, an essential input, or the repository cannot be verified, stop immediately with `R3_BLOCKED`. Do not repair the environment, create the artifact, or modify anything.

List all pre-existing worktree changes in the final report. Never modify, stage, or delete them.

## 9. Input Documents

After Phase 0, read each document once, in the following order, using absolute paths under `CCP_ROOT`:

### Research context

```text
$CCP_ROOT/docs/research/CCP_RESEARCH_CONTEXT_MASTER.md
$CCP_ROOT/docs/research/CCP_RESEARCH_CONTEXT_MASTERC.md
```

### Reconciliation and R-2 evidence

```text
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/39_CONCILIACION_DE_INVESTIGACIONES.md
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/40_MAPA_DE_HALLAZGOS_UNICOS.md
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/41_RESOLUCION_DE_CONTRADICCIONES.md
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/42_PROBLEMA_RESIDUAL.md
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/43_CANDIDATO_DE_PROPUESTA.md
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/44_IMPACTO_ARQUITECTONICO_PRELIMINAR.md
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/45_DECISION_DE_IMPLEMENTACION_PRELIMINAR.md
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/46_FINAL_RECONCILIATION.md
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/47_PRIOR_ART_VERIFICATION.md
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/48_R2_INSTRUMENTATION.md
$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/49_R2_POST_AUDIT.md
```

The executor must confirm from `49_R2_POST_AUDIT.md` that the audit decision is exactly `AUDITED_CONFIRMED`. If it is not, stop with `R3_BLOCKED`.

### Operational context

```text
$CCP_ROOT/CLAUDE.md
$CCP_ROOT/PROJECT_STATE.md
$CCP_ROOT/ARTIFACT_MANIFEST.md
$CCP_ROOT/docs/DESIGN.md
$CCP_ROOT/docs/CONTROL_PLANE_HANDBOOK.md
$CCP_ROOT/docs/00_SYSTEM/EVIDENCE_REGISTRY.md
$CCP_ROOT/DECISION_REGISTRY.md
$CCP_ROOT/.claude/rules/security.md
$CCP_ROOT/.claude/rules/git-policy.md
$CCP_ROOT/.claude/rules/no-go.md
$CCP_ROOT/.claude/rules/compliance.md
```

The repository's real decision registry is at `$CCP_ROOT/DECISION_REGISTRY.md`. If the path named in an older document differs, use the real repository path only after verifying it locally; do not edit either registry.

Do not read `docs/research/SAGR_DEEP_RESEARCH/` or other historical research exhaustively. Do not reopen prior-art research. The R-3 design must be grounded in the closed reconciliation set.

## 10. Execution Rules

1. Work sequentially in one context. No parallelism, background work, or delegation.
2. Read, then decide, then act. Do not modify an unread file.
3. Use the smallest reversible action that can satisfy the current phase.
4. Reuse R-2 evidence and existing repository conventions before proposing new structure.
5. Every action, field, criterion, and output must trace to this contract or the listed input documents.
6. Preserve `OBSERVED`, `VERIFIED`, `INFERRED`, and `UNKNOWN` as distinct classifications.
7. When evidence is insufficient, use `UNKNOWN` or `BLOCKED`; never fill the gap with a plausible assumption.
8. Do not modify F1-F8, runtime hooks, settings, registries, or project state.
9. Do not create a new project phase or reinterpret R-3 as F10.
10. Do not continue automatically into R-4, field observation, F10, SAGR, or implementation.
11. Do not read the same input file repeatedly as a substitute for reasoning; cache the first read.
12. If an error occurs, record it in the evidence artifact or final report before continuing. If the same blocking error occurs twice, stop and mark `R3_BLOCKED`.

## 11. No-Subagent Rule

R-3 is single-agent and sequential:

```text
SINGLE AGENT - SEQUENTIAL - NO SUBAGENTS - NO FORKS - NO PARALLELISM - NO DELEGATION - NO BACKGROUND WORK
```

Do not invoke or simulate `agent`, `task`, `fork`, `delegate`, `spawn`, `parallel`, `swarm`, `research-agent`, `subagent`, auto-splitting, or any equivalent capability. The primary executor personally performs all reads, decisions, design work, checks, and evidence writing.

## 12. Research Rule

The research corpus is closed. Do not perform broad web research or search for new papers, competitors, recovery systems, alternative-generation systems, or governance architectures.

Use the real CCP repository and documents 39-49 first. A targeted external fetch is allowed at most once and only if a specific file format or technical mechanism required to express the design cannot be resolved locally. Record the URL, exact ambiguity, and result. If the ambiguity is not resolved, stop with `R3_BLOCKED`.

R-3 must not use external sources to manufacture a positive result. Prior-art status is inherited from R-1 and may be marked `UNKNOWN` where the reconciliation marks it so.

## 13. Repository Discipline

- Operate only under `CCP_ROOT` after Phase 0.
- Do not read, write, list, search, or inspect `OPENCODE_WORKDIR` after Phase 0.
- Do not modify pre-existing unstaged or untracked changes.
- Do not delete or rename a pre-existing file.
- Do not edit `CLAUDE.md`, `PROJECT_STATE.md`, `ARTIFACT_MANIFEST.md`, `docs/DESIGN.md`, `docs/CONTROL_PLANE_HANDBOOK.md`, `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`, `DECISION_REGISTRY.md`, hooks, settings, agents, skills, rules, or F1-F8 artifacts.
- Temporary captures may exist only under `$CCP_ROOT/.tmp/r3/` and must be removed before closure.
- The only permanent file R-3 may create is:

```text
docs/research/CCP_FINAL_RECONCILIATION/50_R3_NON_BYPASS_VERIFY_DESIGN.md
```

- Do not create a dataset, runtime module, fixture directory, log, skill, hook, or configuration file.

## 14. Security Rules

### SECURITY INVARIANTS

The existing security decision is authoritative:

```text
SECURITY DECISION > R-3 DESIGN / EXPERIMENT
```

R-3 must never create a path from `DENY` to `ALLOW`. R-3 does not execute a blocked action and does not authorize continuation.

The design must require all of the following:

- `UNKNOWN` is never treated as `SAFE`.
- Missing policy intent, missing evidence, stale authority, missing side-effect information, verifier dependence, or unresolved semantic equivalence returns `UNKNOWN` or `UNSAFE`, never permission.
- A verifier may not certify its own proposal or rely exclusively on evidence generated by the proposer.
- A known semantic bypass is `UNSAFE`, even when the surface syntax differs from the blocked action.
- The design must not rely on retries, prompt wording, a feature flag, a human assumption, or an unverified model claim as a security boundary.
- No secret, token, credential, raw command, raw file content, or PII may be copied into the artifact or temporary captures.
- Any design that could be interpreted as an implementation authorization is a contract failure and must produce `R3_BLOCKED`.

The existing CCP trust boundary remains Git plus human reviewer. R-3 does not add authority, change policy predicates, or change the Evidence Contract.

## 15. Baseline

Before Phase 3, establish and capture:

1. `R3_BASELINE_HEAD`, branch, and complete pre-existing worktree status from Phase 0.
2. The exact `AUDITED_CONFIRMED` decision from `$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/49_R2_POST_AUDIT.md`.
3. A SHA-256 and line count for the existing canonical R-2 log, without editing or rotating it.
4. The output and exit code of the existing maintenance suite, with all observation output redirected to `$CCP_ROOT/.tmp/r3/maintenance-events.jsonl` so the canonical R-2 log is not contaminated by fixtures.
5. A check that the four R-2 security invariants remain represented in the audit artifact: `BEFORE == AFTER`, logging failure is fail-safe, policy semantics unchanged, and instrumentation reachable.

If maintenance fails, the R-2 audit decision is absent or contradictory, the canonical log cannot be read without modification, or the baseline cannot be captured, stop with `R3_BLOCKED`. Do not repair the baseline.

## 16. R-3 Procedure

### PHASE 0 - ENVIRONMENT

- Verify the absolute paths, repository root, required R-2 artifact, R-2 audit, branch, status, and `R3_BASELINE_HEAD`.
- Confirm the output path does not already contain an R-3 artifact. If it exists, stop with `R3_BLOCKED`; do not overwrite it.
- Confirm no post-Phase-0 operation will use an implicit working directory.

### PHASE 1 - CONTEXT

- Read the input documents in §9 once and in order.
- Confirm R-1 was completed and R-2 is `AUDITED_CONFIRMED`.
- Record the R-3 identity decision: formal `non_bypass_verify` design, not field observation, not runtime implementation.
- Extract the residual question, the security gate, the two competing continuation hypotheses, and all inherited unknowns.
- If the documents do not support this identity without inference, stop with `R3_BLOCKED`.

### PHASE 2 - BASELINE

- Run the baseline checks in §15.
- Verify that no code, hook, settings, registry, canonical log, F1-F8 artifact, or project state file is modified by baseline execution.
- Record all results as `OBSERVED` or `VERIFIED`; do not treat the existing R-2 audit as a new R-3 test.

### PHASE 3 - EXECUTION

Create the single artifact `50_R3_NON_BYPASS_VERIFY_DESIGN.md` with the following design content:

1. Define the verifier input contract using the existing residual vocabulary: state, objective, policy intent, blocked action, proposed action, evidence, context, history, authority, and side-effect state.
2. Define the only admissible decision outputs: `SAFE`, `UNSAFE`, and `UNKNOWN`. State explicitly that `UNKNOWN` cannot continue execution.
3. Define the minimum conditions for `SAFE`, including explicit policy intent, objective preservation, semantic non-bypass reasoning, authority freshness, side-effect treatment, evidence provenance, and independent verification.
4. Define concrete `UNSAFE` cases, including semantic bypasses that use different syntax, indirect effects, composition, alternate tools, hidden side effects, or authority changes.
5. Define when the result must be `UNKNOWN`, including incomplete policy intent, missing dependencies, uncertain effects, stale evidence, verifier/proposer coupling, and insufficient context.
6. Define the independence boundary between proposer and verifier. Explain what evidence may not be shared without an independent check.
7. Compare `propose alternative + verify` against `refuse + human escalate`. Do not select a production path; define the evidence and falsifier that would distinguish them.
8. Define a controlled evaluation protocol with synthetic, clearly labeled cases. The protocol must include true alternatives, obvious bypasses, semantic bypasses, missing policy intent, stale authority, incomplete side-effect information, verifier dependence, and unknown cases.
9. Define labels, provenance, reviewer roles, leakage controls, pre-registration requirements, and a decision rule for rejecting the design. Synthetic cases are not field data.
10. Define the metrics that could be measured later, but do not invent thresholds. Any threshold required for an empirical decision must be owner-approved and pre-registered; otherwise it remains `UNKNOWN`.
11. Define falsifiers for security, usefulness, independence, and feasibility. A single known bypass incorrectly classified `SAFE` must be a security failure.
12. State exactly what the design does not establish: no implementation, no production safety, no field prevalence, no economic value, no F10 authorization.

The artifact may include pseudocode or tables that express the design, but no production code, hook patch, executable verifier, alternative generator, or runnable recovery mechanism.

### PHASE 4 - VERIFICATION

Verify the artifact and repository state:

- The artifact contains every required section in §18.
- The research question is one concrete question and matches §3.
- Every mandatory design requirement has `PASS` or `BLOCKED`, never `PARTIALLY DONE`.
- All UNKNOWN values are named and no claim exceeds its source classification.
- The security invariant is explicit and `UNKNOWN` cannot yield `SAFE`.
- The comparison of A and B is present and does not silently choose a production architecture.
- The artifact contains no raw secrets, tokens, credentials, PII, production observations, invented measurements, or fabricated test results.
- `git diff` and status show no modified or newly created file outside the one authorized artifact, excluding pre-existing worktree changes recorded at baseline.
- The canonical R-2 log hash and line count are unchanged from Phase 2.
- The maintenance suite still passes with observation output redirected away from the canonical log.
- No hook, settings, F1-F8 file, project state, evidence registry, or decision registry changed.

Any failed mandatory check is `R3_BLOCKED`; do not auto-repair it and do not continue to Phase 5 as if it passed.

### PHASE 5 - EVIDENCE

Complete the artifact with:

- metadata and `R3_BASELINE_HEAD`;
- objective and research question;
- evidence needed and evidence actually available;
- scope and non-goals;
- baseline commands and captured outputs;
- design execution record;
- verification matrix;
- security analysis;
- limitations and known unknowns;
- evidence index with file, line, command, and captured output;
- rollback procedure;
- interpretation boundaries;
- status exactly `R3 EXECUTED — AUDIT PENDING` only if all mandatory requirements passed.

If a prerequisite or mandatory verification is blocked, the artifact must say `R3 BLOCKED`, identify the exact blocker, and make no positive claim about the design.

### PHASE 6 - STOP

After the artifact, verification, cleanup of `$CCP_ROOT/.tmp/r3/`, and final report:

- stop;
- do not execute field observation;
- do not begin R-4;
- do not open F10;
- do not implement SAGR, recovery, `generate_alternative`, or `non_bypass_verify`;
- do not conduct additional research;
- do not make another commit.

## 17. Tests

R-3 is documentation and design, not a runtime feature. Its tests are deterministic contract and safety checks:

### Baseline tests

- `bash "$CCP_ROOT/evals/maintenance.sh"` with `STALL_POLICY_LOG_PATH` redirected to `$CCP_ROOT/.tmp/r3/maintenance-events.jsonl`.
- `sha256sum` and `wc -l` on the canonical R-2 JSONL before and after R-3.
- `git -C "$CCP_ROOT" status --porcelain` and authorized-path comparison against Phase 0.

### New design checks

- Required-section check for `50_R3_NON_BYPASS_VERIFY_DESIGN.md`.
- Research-question and R-3 identity check against §3 and §16.
- Decision-algebra check: `UNKNOWN` is never mapped to `SAFE`; no output named `ALLOW` exists in the verifier contract.
- Threat-model coverage check for semantic, indirect, compositional, side-effect, authority, freshness, and common-mode bypasses.
- A/B hypothesis comparison check.
- Provenance check distinguishing synthetic cases, inherited evidence, design claims, and unknowns.
- Done matrix check: every mandatory requirement is `PASS` or `BLOCKED`.
- Forbidden-claim and forbidden-file review.

### Regression and failure criteria

- Any modified existing file: FAIL and `R3_BLOCKED`.
- Any security-semantic change: FAIL and `R3_BLOCKED`.
- Any fabricated data or field observation: FAIL and `R3_BLOCKED`.
- Any missing mandatory section or ambiguous research question: FAIL and `R3_BLOCKED`.
- Any baseline failure: FAIL and `R3_BLOCKED`.
- Any design path that permits `UNKNOWN -> SAFE`: FAIL and `R3_BLOCKED`.
- A clean design with all checks passing: PASS for R-3 execution, still subject to independent audit.

Do not report that tests are correct without the commands and captured output in the evidence artifact.

## 18. Evidence Artifact

Create exactly one permanent documentation file:

```text
docs/research/CCP_FINAL_RECONCILIATION/50_R3_NON_BYPASS_VERIFY_DESIGN.md
```

Required sections, in this order:

```text
# 50 - R-3

## Metadata
## Objective
## Research Question
## Evidence Needed
## Scope
## Non-Goals
## Baseline
## Execution
## Verification
## Results
## Security Analysis
## Limitations
## Known Unknowns
## Evidence Index
## Rollback
## Interpretation
## Status
```

The artifact must include a table equivalent to:

```text
| Requirement | Evidence | Result | Status |
|-------------|----------|--------|--------|
```

The final status is not allowed to be `PARTIALLY DONE`. Each requirement must be `PASS` or `BLOCKED`. The artifact must distinguish `OBSERVED`, `VERIFIED`, `INFERRED`, and `UNKNOWN`.

The artifact must not claim that R-3 solved non-bypass verification, validated a production design, measured STALL_POLICY frequency, observed a material rate, justified F10, or confirmed the residual hypothesis.

## 19. Git Rules

- Record `R3_BASELINE_HEAD` before any change.
- Preserve every pre-existing staged, unstaged, and untracked change.
- Do not run `git reset`, `git clean`, `git restore`, `git checkout`, `git rebase`, `git merge`, or any destructive equivalent.
- Do not push or force-push.
- Do not use `git add -A` or `git add .`.
- The only R-3 file eligible for staging is `docs/research/CCP_FINAL_RECONCILIATION/50_R3_NON_BYPASS_VERIFY_DESIGN.md`.
- No commit is required for R-3. A commit is permitted only if the owner explicitly authorizes it during the execution session, all checks pass, and only the enumerated artifact is staged.
- At most one commit is permitted. Do not amend it.
- If any mandatory test fails, do not commit; leave the failed state for the auditor and report `R3_BLOCKED`.
- After any optional commit, record the resulting HEAD. Never push.

### R3 rollback

R-3 creates no runtime file. If the R-3 artifact was created by this execution, no pre-existing file has the same path, and no later owner change touched it, the reversible rollback is:

```bash
CCP_ROOT=/home/juanls/Escritorio/claude-control-plane
rm -f "$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/50_R3_NON_BYPASS_VERIFY_DESIGN.md"
rmdir "$CCP_ROOT/.tmp/r3" 2>/dev/null || true
```

This rollback must not restore hooks, registries, project state, settings, or any pre-existing path. If an owner-authorized commit exists, do not revert it automatically; the owner must request a separate rollback action.

## 20. Stop Condition

Stop in this exact order:

1. Phase 0 environment verified.
2. Phase 1 context read and R-3 identity confirmed from documents.
3. Phase 2 baseline captured and healthy.
4. Phase 3 formal design written to the single artifact.
5. Phase 4 verification complete.
6. Phase 5 evidence artifact complete.
7. Temporary files removed.
8. Optional owner-authorized single commit handled.
9. Final report emitted.

After the final report, refuse any continuation with:

```text
R-3 scope complete. R-4 and field observation require a separate contract.
```

Do not proceed to R-4, field observation, F10, SAGR, `generate_alternative`, `non_bypass_verify` implementation, recovery, or any new research in this session.

## 21. Final Report

The last output must be exactly this block. Every field must be present:

```text
=========================================
R-3 EXECUTION RESULT (NOT AUDITED)
=========================================

STATUS:
<R3_EXECUTED | R3_BLOCKED | R3_ABORTED>

BASELINE:
- R3_BASELINE_HEAD: <hash>

QUESTION:
- <research question>

RESULT:
- <what was actually established>

NOT ESTABLISHED:
- <what remains unknown>

CHANGES:
- files_created: [...]
- files_modified: [...]
- files_deleted: []

TESTS:
- <results>

SECURITY:
- BEFORE_EQ_AFTER: <YES|NO|UNKNOWN>
- security_semantics_changed: <NO|YES|UNKNOWN>

EVIDENCE:
- path: <artifact>

UNKNOWN:
- <list>

NOT DONE:
- No runtime implementation.
- No field observation or production frequency measured.
- No F10 / R-4 / SAGR / generate_alternative / non_bypass_verify implementation.

STATE:
R3 EXECUTED — AUDIT PENDING

=========================================
END R-3 EXECUTION RESULT
=========================================
```

If status is `R3_BLOCKED` or `R3_ABORTED`, replace the `STATE` line with `R3 BLOCKED — EXECUTION NOT COMPLETED` or `R3 ABORTED — EXECUTION NOT COMPLETED` respectively. Never print `R3 CONFIRMED`.

## 22. Forbidden Claims

Do not write, print, or commit any of these claims:

- R-2 produced field data or a production frequency.
- R-3 solved `non_bypass_verify`.
- A proposed verifier is safe merely because its design is coherent.
- A synthetic case is a production observation.
- The residual is confirmed, material, novel, or commercially validated.
- This work justifies F10.
- A `SAFE` label is permission to execute an action.
- A refusal or human escalation proves the alternative problem is solved.
- A design document is an implementation.

Use `UNKNOWN`, `INFERRED`, or `BLOCKED` when the evidence does not support a stronger statement.

## 23. Ambiguity Handling

Do not guess or expand scope. Resolve ambiguity only in this order:

1. Search the specified input documents.
2. Inspect the real CCP repository using absolute paths under `CCP_ROOT`.
3. Use at most one targeted external lookup only for a concrete technical mechanism needed to express the design.
4. If ambiguity remains material, stop with `R3_BLOCKED`, preserve the tree, state the exact ambiguity, and do not create an implementation.

Material ambiguity includes uncertainty about the R-3 identity, missing R-2 audit confirmation, an undefined security boundary, an unapproved empirical threshold, an unexpected dependency, or any request to change frozen code.

The owner alone may authorize a new phase, a security-policy change, an architectural implementation, or a field-observation contract.

R-3 is a closed execution contract. Completion of R-3 does not authorize any subsequent phase.

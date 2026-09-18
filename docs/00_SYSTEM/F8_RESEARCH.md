# F8 RESEARCH — Claude Control Plane

**Status:** `RESEARCH` · `NO IMPLEMENTATION AUTHORIZED`
**Prerequisite:** `F7_FINALIZED` at commit `47874a5` (2026-09-18).
**Baseline HEAD when research began:** `47874a5`.
**Rule of thumb throughout:** `BENEFIT > COMPLEXITY` · `EVIDENCE > CLAIM` · `RUNTIME > DOCS` · `REUSE > REINVENT`.

> This document persists the F8 research phase. It reconciles the F7 closeout audit, external
> ecosystem findings, the friend F7-F12 proposal, and adversarial testing history into a minimum
> F8 implementation contract that no one is authorized to execute yet. Consumers: owner and any
> future implementer or independent auditor.

---

## 1. BASELINE

| Item | Value |
|---|---|
| Current HEAD | `47874a54e2c293c8fa74cacf41479650a638d013` |
| Previous canonical HEAD | `094413c` (= HEAD^) |
| PROJECT_STATE.CURRENT_PHASE | 7 |
| PROJECT_STATE.PHASE_STATUS | COMPLETE |
| PROJECT_STATE.LAST_GIT_CHECKPOINT | `094413c` (HEAD^, per schema convention) |
| PROJECT_STATE.NEXT_ALLOWED_PHASE | F8 RESEARCH REQUIRED |
| PROJECT_STATE.IMPLEMENTATION_READY | `false` |
| Maintenance suite | 12/12 PASS |
| INC-001 regression | PASS |
| state-integrity | PASS |
| Tier 1/2/3 skills validate | PASS |
| Historical evidence | EV-001..EV-008 unchanged (`23325ab6...` hash) |
| F7 evidence | EV-009..EV-014 unchanged |
| Registries | EV=14+schema, REG=9+schema, INC=1+schema, CTRL=1+schema, ARCH=4 |
| Runtime | No hook/skill/agent/rule/dep added in F7 or in this research |

## 2. PURPOSE — WHY F8

F7 closed five behavioral P1 bugs and three P2 (Bundles A–E + ARCH-004). It **explicitly deferred**
six documented gaps that were labelled `next phase` in F7 artifacts:

- A-03: transitional `contract_hash` fail-open when the field is omitted (ARCH-004 says fail-closed
  next phase).
- A-04: malformed firewall JSON → empty command → allow (pre-existing extraction property).
- A-05: artifact hash never recomputed against artifact (G-N3 DEFER pre-F7).
- A-06: reviewer identity unspecified free text.
- A-07: hook self-modification not structurally detected (G-N4 DEFER pre-F7).
- A-08: budget number reconciliation (documentary).

Plus latent items from `F7_F12_RESEARCH_HANDOFF.md`:
- G-M1: mutation regex firewall (DEFER; shell not covered by Stryker/mutmut).
- G-L1: `PostToolUseFailure` automation (DEFER; discipline suffices).
- G-N4/N5: registry append-only enforcement (DEFER; git diff mitigates).
- G-B10/G-B11: theoretical self-mod, phantom SubagentStop entries (DEFER / UNKNOWN).

**F8's purpose is not to close every deferred item.** It is to identify which of them still deserve
closure now, close only those with proportionate benefit, and record why the rest remain deferred.
The single strongest F8 candidate is A-03 (`contract_hash` fail-closed) — it is small, reversible,
and directly closes the last documented false-PASS path in the evidence gate.

## 3. DEFERRED-FROM-F7 GAP REGISTER

| ID | Origin | Severity | Current control | Cost to close | Benefit | F8 recommendation |
|---|---|---|---|---|---|---|
| A-03 | ARCH-004, F7 review | P1 (documented) | Warning-only when field absent | ~5 LOC in `task-completed-evidence.sh` + 1 fixture | Closes last documented evidence false-PASS path | **CLOSE** in F8 |
| A-04 | POST_F7 §8 | P2 (documented) | Empty command → allow | ~10 LOC + 2 fixtures | Removes fail-open on malformed JSON | **CLOSE** in F8 |
| A-05 | Roadmap G-N3 | P2 | Text field only | ~30 LOC + fixture; requires artifact-set mapping | Marginal; no observed forgery | DEFER |
| A-06 | Roadmap §11.3.c | P2 | Free text `Reviewer: PASS` | Convention docs only | Cosmetic without a reviewer identity system | **CONVENTION** (docs only) |
| A-07 | Roadmap G-N4 | P2 | Human diff review | ~40 LOC + baseline file | Not demand-driven; adds baseline maintenance | DEFER |
| A-08 | POST_F7 §6 | P3 | POST_F7 as-is | Documentary reconciliation | None on runtime | **DOCUMENTED HERE** (§4) |
| G-M1 | Roadmap §6.7 | DEFER | `bash -n` + review | High (bespoke shell mutator) | Nothing without a documented bypass | DEFER |
| G-L1 | Master Plan §5 F4 | DEFER | Manual `/incident open` | Low LOC; high noise risk | Automation ≠ discipline | DEFER |
| G-N4 | Roadmap §12.3 | DEFER | Git review | Duplicates human review | Weak signal-to-noise | DEFER |
| G-N5 | Roadmap §12.3 | DEFER | Convention append-only | git-hook complexity | Duplicates existing history | DEFER |
| G-B10 | Behavioral §35 | P2 (theoretical) | Human review | Overlaps G-N4 | Nothing new | DEFER |
| G-B11 | Behavioral §35 | P3 (UNKNOWN) | Log observability | Unknown; cause not identified | Investigate opportunistically | RESEARCH |

## 4. F7 BUDGET RECONCILIATION (A-08, HISTORICAL)

- **Planned:** ~80 LOC / ~5 fixtures.
- **POST_F7 declared:** 591 additions / 17 deletions / 7 fixtures.
- **Independent recount at F7 closure:** 608 additions / 18 deletions / 7 fixtures.

**Reconciliation method:** The 17-line delta corresponds to the four post-implementation
metadata commits (`3ed9609`, `a770761`, `69b2c23`, `dc89939`, `ec8b76e`, `094413c`) that
touched `PROJECT_STATE.md` and `POST_F7_AUDIT_REPORT.md` between the two measurements. POST_F7
measured the range at bundle-close; the recount included subsequent documentary metadata. This is
not a scope violation and does not affect runtime; POST_F7 is preserved as-is and this document
records the reconciliation method. No historical rewrite.

## 5. F8 RESEARCH QUESTIONS

1. Should the evidence gate enforce contract-hash presence for every task, or should absence be
   allowed for a well-defined subset (e.g., risk=low)?
2. Should the firewall fail-closed on malformed JSON, or should the fail-open path be preserved
   because Claude Code's own tool wire delivers structured JSON (defense-in-depth vs. usability)?
3. Is there a compact, deterministic way to declare which files a `Artifact Hash` covers, so the
   maintenance suite can recompute it, without introducing a fifth registry?
4. Is a `Reviewer:` free-text identity worth enriching now, or is it correctly deferred until
   the project has more than one operator?
5. Should hook integrity be observable via `evals/maintenance.sh` using a baseline file, or does
   git diff review at commit time already provide that signal at higher fidelity?
6. Is any of the OpenTelemetry GenAI, MCP, or Spec Kit ecosystem yet mature enough to justify
   adoption, or does the F6 conclusion (DEFER) still hold in 2026-09?
7. Is native Claude Code runtime verification still `NOT_VERIFIED` under OpenCode, and does F8
   need to change environment to escalate any control past `SCRIPT VERIFIED`?
8. What is the minimum F8 that eliminates the last documented false-PASS path without adding new
   architecture?

## 6. FINDINGS BY AREA

### A. Contract / Task Integrity

- **Current invariant (partial):** a completed task must exist in `EVIDENCE_REGISTRY.md` as
  `Status: VERIFIED` with matching `task_id`. `contract_hash` coupling is enforced only when the
  field is present in the payload (ARCH-004 transitional).
- **Gap:** any payload that omits `contract_hash` bypasses the coupling and can reuse a historical
  `task_id` (this was the original F-FALSE_PASS-01 vector, only partially closed in F7).
- **Native behavior of TaskCompleted:** not exercised natively this audit; unchanged since F7
  closure.
- **F8 recommendation:** flip the transitional warning to fail-closed. `Contract_hash` becomes
  required for every completed task. A new positive fixture proves both branches (absent → BLOCK,
  present + matching → PASS). Estimated 5 LOC. Backward-compat: any historical PASS re-execution
  requires supplying the corresponding `Contract Hash` from the registry — which is a healthy
  requirement.

### B. Evidence Integrity

- **Provenance semantics** (`EXTRACTED|INFERRED|ASSUMED|EXTERNAL|GENERATED`) is expressive and
  already validated.
- **Artifact hash** is a `sha256:...` string with no declared file-set mapping — the audit cannot
  independently recompute it (A-05).
- **Freshness** is timestamp+session_id based (F7); source/evaluator drift is NOT considered.
- **False-PASS surface** after F8 A-03 closure: reduces to (i) hash-field forgery, (ii) fixture
  weakening committed by an actor with Write access. Both remain gated by human `git diff`
  review at commit.
- **Recommendation:** for F8, do not add hash recomputation (marginal benefit for the cost). Do
  add — in the same fail-closed transition — a rule that `Contract Hash` cannot be `sha256:0*` or
  empty when present (the hook already checks this; make it explicit in the schema comment for
  the next reader).

### C. Execution Identity

- Existing identifiers: `task_id`, `session_id` (Tier 3), `evidence_id`, `incident_id`,
  `control_id`, `regression_id`. No `run_id`, `attempt_id`, `evaluation_id`, `artifact_id`,
  `checkpoint_id`.
- Collision risk: near-zero at single-operator scale.
- Rerun distinction: today the same `task_id` running twice produces the same evidence entry if
  hashes match, and the freshness check will reject a stale timestamp — that is enough for the
  current model.
- **F8 recommendation:** do NOT add new identity fields. The minimum viable execution identity is
  `task_id + contract_hash + timestamp`. Adding more fields costs schema surface and does not close
  a documented gap.

### D. State Machine / Lifecycle

- Observed states (per Behavioral audit §L, F7-verified): `PLANNING → EXECUTING → COMPLETE` per
  phase; `OPEN → INVESTIGATING → REGRESSION_ADDED → CLOSED` for incidents; `PROPOSED → ACTIVE` for
  controls and regressions; `PROPOSED → VERIFIED | BLOCKED | REJECTED` for evidence.
- No illegal transitions detected.
- Missing states are documentary (`ROLLED_BACK`, `RECOVERING`, `ABORTED`, `SUPERSEDED`) and not
  required by any current control.
- **F8 recommendation:** none. State transitions are validated by convention and cross-linkage;
  formalizing them into a machine-readable schema would add ~200 LOC and close no current gap.

### E. Human Checkpoints

- `permissions.ask` triggers native Claude Code human approval for `Bash(git push*)` and
  `Bash(rm *)`.
- `stop_hook_active` handling in F7 Bundle A eliminates the human-wait loop.
- Owner go/no-go for F7, F7a, F8 is documented but not mechanically enforced.
- **F8 recommendation:** none. Current human-checkpoint semantics are proportional. Do not add an
  approval workflow layer.

### F. Self-Modification / Trusted Surface

- Any agent with `Write`/`Edit` can modify `.claude/hooks/*.sh`, `evals/maintenance.sh`,
  `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`, fixtures.
- `secret-guard` detects secret literals only; it does not detect structural hook weakening.
- Trust boundary today = **human `git diff` at commit** + `code-reviewer` fresh-context agent for
  medium+ risk changes.
- **F8 recommendation:** do NOT add hook-integrity baseline files (G-N4). The maintenance overhead
  and false-positive risk outweigh the benefit at this scale. Preserve the current control (human
  review) and document the boundary explicitly in `PROJECT_STATE.md` / Handbook.

### G. Security / Fail-Closed

- **Bash firewall:** 14/14 adversarial payloads block, 2/2 legitimate allow (F7 audit).
- **Secret guard:** positive fixture PASS.
- **TaskCompleted:** 7-case matrix all correct except A-03 (documented).
- **Malformed JSON firewall path (A-04):** empty command → allow. Two options for F8:
  - **F8-A4-OPT-1 (strict):** if `jq empty` fails on payload, block. Cost: 3 LOC. Trade-off: any
    upstream payload malformation blocks the tool call.
  - **F8-A4-OPT-2 (retain):** keep the current behavior (empty command → allow) because Claude
    Code's own tool wire is expected to deliver well-formed JSON, and the failure mode of a
    corrupted payload today is "no command" (already safe). Cost: 0 LOC. Trade-off: preserves
    the documented finding.
- **Recommendation:** F8-A4-OPT-1. The change is 3 LOC and eliminates the ambiguity documented in
  POST_F7 §8. A fixture that feeds `not-json` and expects BLOCK is the regression.

### H. Rollback / Recovery

- Per-bundle `git revert` available for every F7 commit.
- `.claude/backups/PROJECT_STATE.precompact.md` and `PROJECT_STATE.critical.sha256` created on
  demand by `pre-compact-snapshot.sh`.
- `/recovery` skill has 9 documented scenarios.
- **F8 recommendation:** none. Rollback surface is adequate; end-to-end smoke test (G-S1) remains
  DEFERRED per roadmap.

### I. Scope Governance

- F7 variance was owner-approved (POST_F7 §6).
- No hidden scope expansion in F7.
- **F8 recommendation:** any F8 implementation authorization must state explicit LOC / fixture /
  ADR / config-field budget at go/no-go, and record variance as documentary evidence — same
  pattern as F7.

### J. Testing / Evaluation

- Tier 1 (`validate.sh`), Tier 2 (`fixtures.json`), Tier 3 (behavioral CLI runs) all PASS.
- Positive fixtures now exist for firewall + secret-guard (F7 REG-002/REG-003).
- No mutation testing (G-M1 DEFER); no property-based (NO ADOPT).
- **F8 recommendation:** if F8-A4-OPT-1 is adopted, add `evals/hooks/firewall-malformed.sh` as
  REG-010 (single fixture). If A-03 fail-closed is adopted, extend
  `evals/hooks/task-completed-coupling.sh` to add absent-hash-BLOCK as the new default case
  (REG-011 or expand REG-007).

### K. Context / Orchestration

- 22 skills; 6 context packs; 5 agents; 4 rules; 10 hooks. Ecosystem stable through F7.
- **F8 recommendation:** no new skills, no new agents. Convention change for A-06 (reviewer
  identity) is a Handbook edit.

### L. Observability

- Session log with rotation (F7 Bundle D).
- No structured traces.
- OpenTelemetry GenAI in `Development` per SIG, adopted by cloud providers, but no single-user
  aggregator justifies instrumentation.
- **F8 recommendation:** DEFER (unchanged from roadmap §19). If F8 adopts anything from OTel,
  it would be attribute naming for future traceability, not agent instrumentation.

### M. Reuse / External Research

External landscape re-checked against roadmap 2026-09-17 findings:

| Source | Applies to F8? | Recommendation |
|---|---|---|
| Claude Code native hooks (2026-09) | 20 events; 10 in use | KEEP; no new hook required |
| GitHub Spec Kit | Contract semantics | REUSE conceptually; do not import CLI |
| obra/superpowers | Skills framework | KEEP co-existence; do not adopt into repo |
| anthropic-skills (docs/pdf/xlsx/pptx) | Output formats | REUSE on demand |
| OpenTelemetry GenAI | Traces | DEFER (single-operator, no aggregator) |
| MCP tool poisoning research (CVE-2025-54136, MCPTox) | Tool safety | DEFER (no MCP in use) |
| Stryker / mutmut | Mutation testing | DEFER (shell not supported) |
| Hypothesis / fast-check | Property-based | NO ADOPT |
| LiteLLM / OpenRouter | Cross-provider | OUT OF SCOPE (ARCH-001) |
| Trufflehog / Gitleaks | Secret scan | KEEP (complementary to secret-guard) |
| Terraform drift / git hooks | Config drift | KEEP (`config-change-logger`) |

**No external tool has become newly-necessary since 2026-09-17.** The F8 minimum scope is fully
local.

## 7. FRIEND F7-F12 RECONCILIATION

The repository contains no persisted "friend F7-F12" document beyond `F7_F12_RESEARCH_HANDOFF.md`
§Z, which explicitly states: *"El repositorio NO contiene ningun 'friend audit F7-F12'... F8, F9,
F10, F11, F12: NO EXISTEN en este repositorio."*

**F8** proposal (this document) supersedes the placeholder. **F9-F12 remain UNKNOWN.** Any
future friend material must be attached explicitly by the owner before F9 research; without it,
F9-F12 are `NOT DEFINED`.

## 8. MASTER INVARIANTS (F8 PROPOSED)

Invariants derived from the research; each must be independently testable.

- **I-F8-01 (P1):** Every completed task must supply a non-empty `contract_hash` whose value
  matches the `Contract Hash` field of a `Status: VERIFIED` evidence entry with matching
  `task_id`.
  - Enforcement: `task-completed-evidence.sh`.
  - Test: `evals/hooks/task-completed-coupling.sh` extended to the absent-hash case.
- **I-F8-02 (P2):** A malformed firewall payload must not result in `allow`. If `jq empty`
  cannot parse the payload, the hook fails closed.
  - Enforcement: `bash-firewall.sh`.
  - Test: new fixture with `not-json` payload expecting BLOCK.
- **I-F8-03 (VERDE, preserved):** Historical evidence (EV-001..EV-008) must not mutate.
  - Enforcement: git + convention.
- **I-F8-04 (VERDE, preserved):** F6 status COMPLETE cannot regress silently.
  - Enforcement: `maintenance.sh`.
- **I-F8-05 (VERDE, preserved):** F7 status COMPLETE cannot regress silently after `F7_FINALIZED`.
  - Enforcement: `maintenance.sh` + convention that F7 evidence entries remain append-only.

Invariants **explicitly not proposed** for F8: artifact-hash recomputation, reviewer identity
enforcement, hook self-mod detection, mutation testing, property-based testing, OTel
instrumentation. Each has a documented DEFER trail.

## 9. NO-BUILD LIST

F8 must NOT build:

1. A second `EVIDENCE_REGISTRY`, `PROJECT_STATE`, `DECISION_REGISTRY`, `INCIDENT_REGISTRY`,
   `CONTROL_REGISTRY`, `REGRESSION_REGISTRY`, or `ARTIFACT_MANIFEST`.
2. A hook-integrity baseline file (G-N4).
3. A registry-append-only git hook (G-N5).
4. A mutation testing framework for shell (G-M1).
5. A property-based / fuzzing / metamorphic test harness.
6. A `PostToolUseFailure` auto-incident hook (G-L1).
7. New agents, new skills, new rules, new context packs.
8. Any new dependency (jq, sha256sum, bash remain the only tools).
9. Any observability, trace-collection, or telemetry infrastructure.
10. Any MCP integration or MCP allowlist framework.
11. Any cross-provider fallback or model routing.
12. Any custom orchestration engine beyond the current main-agent + subagents pattern.
13. Any new state machine formalization beyond the current markdown-registry convention.
14. Any custom evaluation framework beyond the current `evals/`.
15. Any tampered / cryptographically-signed evidence (PGP, sigstore, Merkle, blockchain).
16. Additional identity fields (`run_id`, `attempt_id`, `evaluation_id`, `artifact_id`,
    `checkpoint_id`).
17. Any RSS/webhook/dashboard export.

The rule remains: **a new component must pass the AI Theater Audit** (roadmap §26). Without
concrete evidence that a specific incident was made harder to detect by its absence, it does not
belong in the control plane.

## 10. PROPOSED MINIMUM F8 SCOPE

**F8 minimum scope (subject to owner approval; not authorized here):**

**Bundle F8-A (Evidence Coupling, closes A-03):**
- `task-completed-evidence.sh`: remove the transitional warning branch; make `contract_hash`
  required (a payload without the field is rejected with `contract_hash missing`).
- `evals/hooks/task-completed-coupling.sh`: extend with the absent-hash case, expect BLOCK.
- ARCH-004 update: transitional clause superseded; final semantics documented.
- Cost: ~5 LOC hook + ~10 LOC fixture extension + ADR update (ARCH-005 supersedes the
  transitional clause of ARCH-004, or ARCH-004 is amended).
- Evidence: EV-015.
- Regression: REG-010 (or extend REG-007).

**Bundle F8-B (Firewall Fail-Closed on Malformed JSON, closes A-04):**
- `bash-firewall.sh`: if `jq empty` on `INPUT` fails, block.
- `evals/hooks/firewall-positive.sh`: extend with a malformed-JSON case expecting BLOCK.
- Cost: ~3 LOC hook + ~5 LOC fixture.
- Evidence: EV-016.
- Regression: REG-011 (or extend REG-002).

**Documentation-only (closes A-06):**
- Handbook §12 clarifies `Reviewer:` convention: `PASS (code-reviewer@fresh-context)` for
  independent runs; `PASS (human/@owner)` for human sign-off. No code change.

**Deferred:** A-05 (artifact hash recompute), A-07 (hook self-mod), A-08 (already
documented above in §4), G-M1, G-L1, G-N4, G-N5, G-B10.

**F8 total budget target:** ~8 LOC bash + 2 fixture extensions + 1 ADR + 2 evidence entries + 2
regression entries. Zero new components.

## 11. F8 IMPLEMENTATION CONTRACT (NOT AUTHORIZED)

If F8 implementation is later authorized, it must follow this contract:

| Field | Value |
|---|---|
| Objective | Close A-03 and A-04 with the minimum change consistent with F7 conventions |
| In-scope | Bundle F8-A + Bundle F8-B + Handbook A-06 documentation |
| Out-of-scope | Everything in §9 no-build list |
| Dependencies | jq, sha256sum, bash — all satisfied |
| Complexity budget | ≤20 LOC bash + ≤2 fixtures + 1 ADR |
| Side-effect budget | LOCAL_MUTATION reversible via `git revert` |
| Fixtures | `evals/hooks/task-completed-coupling.sh` +absent-hash; `evals/hooks/firewall-positive.sh` +malformed-JSON |
| Positive tests | Absent hash → BLOCK; malformed JSON → BLOCK |
| Negative tests | Present hash + match → PASS; well-formed innocent command → PASS |
| Adversarial tests | Reused historical `task_id` without hash → BLOCK; `{"tool_input":{"command":""}}` inside malformed JSON → BLOCK |
| Regression entries | REG-010, REG-011 |
| Evidence entries | EV-015 (F8-A), EV-016 (F8-B) with `contract_hash` matching F8 contract hash |
| Reviewer | Fresh-context subagent, medium risk (hook + evidence gate touched); Handbook A-06 update requires human review only |
| Rollback | `git revert <F8-A-commit>` and `git revert <F8-B-commit>` per bundle |
| Metrics | `maintenance.sh` < 5s; 0 regressions in EV-001..EV-014 |
| Human checkpoint | Owner go/no-go before any commit |
| IMPLEMENTATION_READY | Remains `false` until owner explicitly sets it after reviewing this document |

**Explicit refusal statement:** this document does not by itself authorize implementation.
Owner must approve, and the approval must be recorded (a session with the explicit
authorization is sufficient; a new ADR is not required).

## 12. RISKS

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| F8-A breaks any existing tooling that omits `contract_hash` | Low (F7 warning already visible; production of contract_hash is trivial) | Medium (all completions would block) | Deploy in a branch; run maintenance suite; add absent-hash fixture first |
| F8-B blocks legitimate empty payloads | Very low (Claude Code delivers structured tool input) | Low | Regression fixture must include a well-formed empty-command payload that stays ALLOWED |
| Owner adopts F8 scope but re-opens A-05 or A-07 | Medium (temptation to close everything) | High (scope creep) | This document explicitly declines A-05/A-07 for F8; any expansion requires new research |
| Native runtime remains NOT_VERIFIED | Certain (OpenCode is not native Claude Code) | Documented | Preserve labelling; do not upgrade `SCRIPT VERIFIED` |
| A silent hook self-modification defeats F8-A | Low | High | Same trust boundary as F7; human review + fresh-context reviewer |

## 13. OPEN DECISIONS

1. **Owner decision:** proceed with F8-A + F8-B minimum, or delay F8 until an incident forces
   evidence-coupling to matter?
2. **Owner decision:** update ARCH-004 in place (transitional clause struck out) or introduce
   ARCH-005 that supersedes the transitional clause? Preference: amend ARCH-004 in place with an
   explicit `SUPERSEDED_BY: F8-A` note, but only after F8-A commit exists.
3. **Owner decision:** should the reviewer identity string enrichment (A-06) be committed
   independently from Bundle F8-A/B or bundled with them for review efficiency?
4. **Documentary decision:** should DESIGN.md be reconciled with DECISION_REGISTRY.md (ARCH-004
   number collision + ARCH-005 phantom)? This is pre-F7 drift and should be handled in a separate
   documentary cleanup, not inside F8 scope.

## 14. FINAL AUTHORIZATION STATE

- `F7_FINALIZED = TRUE` at `47874a5`.
- `F7_STATUS = COMPLETE / FROZEN`.
- `F8_RESEARCH = COMPLETE` (this document).
- `F8_IMPLEMENTATION = NOT AUTHORIZED`.
- `IMPLEMENTATION_READY = false` in `PROJECT_STATE.md`.
- No new hooks / skills / agents / rules / dependencies / architecture were introduced during F8
  research.
- No historical evidence rewritten.
- Baseline HEAD is `47874a5`; a subsequent commit persisting this research file will change HEAD
  and `LAST_GIT_CHECKPOINT` will follow the same convention (`LAST_GIT_CHECKPOINT` = HEAD^).

**Next allowed action:** owner review of this document; then explicit approval or refusal of the
proposed minimum F8 scope before any implementation begins.

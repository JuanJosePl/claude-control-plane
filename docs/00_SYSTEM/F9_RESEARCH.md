# F9 RESEARCH - Claude Control Plane

**Status:** `RESEARCH COMPLETE` - `NO IMPLEMENTATION AUTHORIZED`
**Executor:** `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX_OPENCODE`
**Research date:** 2026-09-19
**Baseline HEAD:** `2cd795321486a30240197ac12a0bf51564ffba66`
**F7 checkpoint:** `47874a54e2c293c8fa74cacf41479650a638d013` (canonical short form: `47874a5`)
**F8 status:** `COMPLETE / FROZEN`
**Decision:** `F9 NOT JUSTIFIED`

> This is a research contract and decision package. It does not authorize runtime work,
> fixture work, registry changes, new infrastructure, or any F9 implementation.

---

## 1. Research Objective

Determine, from repository evidence, whether a post-F8 F9 implementation phase is necessary at
all; identify the concrete problem it would solve; test whether existing controls already cover
that problem; define the smallest defensible scope if a candidate survives; and state what must
remain deferred.

The research starts from the evidence question, not from an assumed phase:

```text
Does any current, evidenced gap justify new runtime work after F8?
```

The answer is **no**. A bounded native-runtime probe remains a possible future research input for
specific unknowns, but it is not evidence that an F9 implementation phase is currently justified.

---

## 2. Baseline And F8 Integrity

### 2.1 Forensic baseline

Gate 0 was executed before research edits:

| Check | Result |
|---|---|
| Working directory | `/home/juanls/Escritorio/claude-control-plane` |
| Branch | `main` |
| HEAD | `2cd795321486a30240197ac12a0bf51564ffba66` |
| Worktree before research | CLEAN |
| F7 checkpoint object | present; `47874a5` |
| F8 final audit | present and unchanged at baseline |

The expected baseline HEAD matched exactly. No unexplained baseline difference was found.

### 2.2 Current phase state

The authoritative current state remains:

- F7: `COMPLETE / FROZEN` at `47874a5`.
- F8: `COMPLETE / FROZEN`.
- F8 audit: `COMPLETE / FROZEN`.
- `IMPLEMENTATION_READY: false`.
- No F9 runtime work is authorized.

`PROJECT_STATE.md` remains the F8 operational state record. This research does not promote the
project to an implementation phase.

### 2.3 F8 integrity checks

The following repository facts were verified:

- `EV-015` and `EV-016` exist in `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.
- `REG-010` and `REG-011` exist in `REGRESSION_REGISTRY.md`.
- `POST_F8_AUDIT_REPORT.md`, `CHANGE_PROVENANCE_F8.md` and `F8_CLAIM_VS_EVIDENCE.md` exist.
- The `EV-001..EV-014` prefix is byte-identical to the F7 checkpoint prefix.
- The `REG-001..REG-009` prefix is byte-identical to the F7 checkpoint prefix.
- F7 checkpoint `47874a5` remains present and unchanged.
- The latest commit after the F8 audit changes only `PROJECT_STATE.md` and the current handoff.
- No F8 runtime file, fixture, report, evidence entry, or regression entry was modified after the
  F8 closure audit.

The F8 artifact claims that can be checked locally were also recomputed during this research:

| Claim | Recomputed value | Result |
|---|---|---|
| EV-015 artifact hash | `93ac496409c13c0b2f4f67c62eeea1a2dc55c86c13a2bd211e2b12c8183d8a4d` | MATCH |
| EV-016 artifact hash | `758ecc2734e4376d8d942710eddee9c84cd4d2bc973cb1cf7d998687b3ddbc84` | MATCH |
| F8 contract hash | `a0bbbd9f01d99110aa9674316d30b7525fbfb8f4b0a7e3d2c3829a4c0579a7e7` | MATCH |

These are research-time recomputations, not a new enforcement control.

### 2.4 Existing verification baseline

The existing repository checks were run without modifying runtime files:

| Check | Result |
|---|---|
| `bash evals/maintenance.sh` | 12/12 PASS |
| `bash evals/incidents/INC-001-task-completed-evidence.sh` | PASS |
| `bash evals/state/state-integrity.sh` | `unchanged=PASS`, `drift=DETECTED` |
| `evals/skills/validate.sh` | Tier 1/2/3 PASS |
| `bash -n install.sh` | PASS |
| `bash -n evals/maintenance.sh` | PASS |
| `bash -n .claude/hooks/*.sh` | PASS |
| `bash -n evals/hooks/*.sh` | PASS |
| `bash -n evals/install/*.sh` | PASS |
| `bash -n evals/skills/*.sh` | PASS |

No new evidence entry or regression entry was created by these checks.

---

## 3. Sources Inspected

The repository source-of-truth order was used. The principal sources were:

1. `CLAUDE.md`.
2. `docs/00_SYSTEM/SESSION_HANDOFF_CURRENT.md`.
3. `PROJECT_STATE.md`.
4. `docs/00_SYSTEM/F8_RESEARCH.md`.
5. `docs/00_SYSTEM/POST_F8_AUDIT_REPORT.md`.
6. `docs/00_SYSTEM/F8_CLAIM_VS_EVIDENCE.md`.
7. `docs/00_SYSTEM/CHANGE_PROVENANCE_F8.md`.
8. `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.
9. `REGRESSION_REGISTRY.md`.
10. `CONTROL_REGISTRY.md`.
11. `INCIDENT_REGISTRY.md`.
12. `DECISION_REGISTRY.md`.
13. `.claude/context/DECISIONS.md`.
14. `ARTIFACT_MANIFEST.md`.
15. `docs/MASTER_IMPLEMENTATION_PLAN.md`.
16. `docs/MASTER_EVOLUTION_ROADMAP.md`.
17. `docs/CONTROL_PLANE_HANDBOOK.md`.
18. `docs/00_SYSTEM/F7_F12_RESEARCH_HANDOFF.md` and F7 closure/audit documents.
19. Runtime hooks, settings, maintenance, existing fixtures and the incident skill.

`docs/research/RESEARCH_CLAUDE.md` and `docs/research/RESEARCH_CHATGPT.md` were used only to
locate historical rationale. They are older research material and do not override current
runtime, Git history, F8 audit, or current registries.

The requested `docs/00_SYSTEM/CURRENT_STATE.md` path does not exist. The repository's current-state
mirror is `.claude/context/CURRENT_STATE.md`, as declared by `DESIGN.md` and the handbook. This path
discrepancy was observed, not corrected, because it is outside F9 research scope.

---

## 4. Current Controls Relevant To F9

The current controls already cover the demonstrated F7/F8 failure classes:

- `task-completed-evidence.sh` requires a non-empty `contract_hash`, matches it to VERIFIED
  evidence, rejects historical reuse with a mismatched hash, and exits 2 on invalid evidence.
- `bash-firewall.sh` rejects empty, malformed, multi-document and NUL-containing payloads before
  command extraction, then applies finite reviewed patterns.
- `secret-guard.sh` blocks credential-shaped writes and allows documented placeholders.
- `maintenance.sh` runs the existing fixture and freshness suites and reports 12/12 checks.
- `evals/hooks/firewall-positive.sh`, `secret-guard-positive.sh`,
  `task-completed-coupling.sh`, `stop-hook-idempotency.sh` and
  `session-log-rotation.sh` provide deterministic coverage for demonstrated behavior.
- Git history, human `git diff`, and fresh-context review remain the trust boundary for changes
  to hooks, evaluators and registries.
- The incident workflow is explicit: `/incident open` -> reproduce -> RCA -> regression -> control
  -> verify -> link -> close.

The remaining limitations are therefore not automatically implementation gaps.

---

## 5. Candidate Inventory

Aliases are grouped when they describe the same underlying problem. Grouping does not erase the
original IDs; each ID is classified below.

| ID | Current status | F9 relevance | Research disposition |
|---|---|---|---|
| A-05 / G-N3 | Deferred; unresolved evidence limitation | No, absent tampering evidence | Defer |
| A-07 / G-N4 / G-B10 | Deferred; theoretical self-modification risk | No, absent silent weakening incident | Defer |
| G-N5 | Deferred; convention-only append-only registry rule | No, no history rewrite | Defer |
| G-M1 | Deferred; no shell mutation harness | No, no surviving bypass or mutation signal | Defer |
| G-L1 | Deferred; manual incident opening | Uncertain only if a missed failure is observed | Defer |
| G-B11 | Unknown/suspected phantom SubagentStop entries | Uncertain; native evidence is required | Defer pending reproduction |
| G-T2 | Deferred by design; one real incident only | No; fabricating evidence is prohibited | Defer |
| G-S1 | Documented P2 rollback-smoke limitation | No phase-level need | Defer or separate micro-task |
| G-S2 | Documented P2 rollback command clarity issue | No runtime impact demonstrated | Defer or separate micro-task |
| G-Bob-1 | Documentary ambiguity in fixture semantics | No | Defer or separate micro-task |
| G-A1 | Intentional template placeholders remain in local packs | No operational confusion demonstrated | Defer |
| G-N1 | Manual revalidation cadence is not enforced | No missed revalidation incident | Defer |
| G-N2 | Archive retention policy is not automated | No retention failure or consumer need | Defer |
| G-B6 | Known fixture-creation false block; mitigated by shipped fixtures/install path | No new runtime gap | Defer |
| G-B9 | Empty `agent_type` produces cosmetic blank field | No operational impact | Defer |
| G-D3 | Resolved as ARCH-004/F8 convention | No; do not reopen | Closed/keep |
| G-V1 / G-Bob-2 / G-T1 | Closed in F7 and preserved by F8 | No; do not reopen | Closed/keep |
| A-03 / A-04 / A-06 | Closed or documented in F8 | No; F8 is frozen | Closed/keep |

No candidate in the inventory meets the evidence threshold for a new runtime phase.

---

## 6. Candidate Research

### 6.1 A-05 / G-N3 - Artifact-hash recomputation

**ID:** A-05 / G-N3
**SOURCE:** `F8_RESEARCH.md` sections 3 and 6.B; `MASTER_EVOLUTION_ROADMAP.md` section 11.3.b; current evidence registry.
**ORIGINAL PROBLEM:** Evidence stores an `Artifact Hash` with a valid SHA-256 shape, but the runtime does not recompute it against a declared artifact set. A changed artifact plus a changed registry field could therefore pass format checks.
**CURRENT STATUS:** Deferred; the limitation remains real as a capability boundary.
**CURRENT EVIDENCE:** `EVIDENCE_REGISTRY.md` contains `Affects` values that are single files, multiple files, registries, globs, and abstract controls. F8 EV-015/EV-016 notes identify their fixture artifacts, and the hashes match when manually recomputed. No documented tampering or mismatch has occurred.
**RISK:** A writer with repository access can create a false artifact-to-evidence association. The risk concerns evidence confidence, not runtime execution.
**USER / SYSTEM IMPACT:** A reviewer could over-trust a VERIFIED record whose artifact hash is not tied to the current artifact. Historical evidence is not currently shown to be affected.
**CURRENT CONTROL:** Required `contract_hash` coupling, hash format and non-zero checks, Git history, human diff review, and fresh-context review. F8 reduced the false-PASS surface without changing artifact semantics.
**RESIDUAL GAP:** No machine-readable artifact set, canonical ordering rule, or recomputation check exists. `Affects` is not sufficient to derive one safely.
**BENEFIT OF CLOSURE:** Detects accidental or intentional mismatch when the artifact set is exact and stable. The benefit is conditional and has not been demanded by an incident.
**IMPLEMENTATION COMPLEXITY:** Medium at the hook-script level, but effectively medium/high once mapping, multiple files, globs, historical entries, ordering, and migration are included. The historical estimate of about 30 LOC understates the contract work.
**REVERSIBILITY:** Code is Git-reversible; schema and historical mapping changes create review and maintenance obligations.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer until a real evidence-tampering event, repeated hash mismatch, or a concrete owner requirement makes the artifact set contract necessary. Do not add a schema or mapping in F9.

**Independent conclusion:** The hash recomputation idea does not currently provide enough demonstrated benefit to justify its mapping and maintenance complexity.

### 6.2 A-07 / G-N4 / G-B10 - Hook self-modification detection

**ID:** A-07 / G-N4 / G-B10
**SOURCE:** `F8_RESEARCH.md` sections 3 and 6.F; `BEHAVIORAL_RELIABILITY_AUDIT.md` section 19; roadmap section 12.3.
**ORIGINAL PROBLEM:** An actor with write access can edit hooks, evaluators or registries, including the mechanism that verifies the work. The current system does not structurally detect a weakened hook.
**CURRENT STATUS:** Deferred; theoretical and mitigated procedurally.
**CURRENT EVIDENCE:** The behavioral audit demonstrates the capability conceptually, but no silent weakening incident, accepted weakened commit, or failed review is recorded. The current F8 history is clean and scoped.
**RISK:** An unreviewed or malicious edit could reduce enforcement while leaving a green local maintenance result.
**USER / SYSTEM IMPACT:** Trust in the control plane depends on human review at the commit boundary. This is a trust-boundary limitation, not a demonstrated F8 failure.
**CURRENT CONTROL:** `git diff`, Git history, fresh-context review for medium/high risk, `bash -n`, deterministic fixtures, and explicit human approval for P0/trust-boundary changes. `secret-guard` is not a structural integrity verifier by design.
**RESIDUAL GAP:** No immutable or externally trusted baseline proves that a hook was not weakened. A baseline stored in the same writable repository can itself be changed by the same actor.
**BENEFIT OF CLOSURE:** An unchanged local baseline could catch accidental unreviewed edits. It would not fully solve a same-repository adversary without a second trust domain.
**IMPLEMENTATION COMPLEXITY:** Medium for a local fingerprint plus baseline; high for meaningful protection because baseline ownership, legitimate hook updates, versioning, CI and bypass behavior must be defined.
**REVERSIBILITY:** Git-reversible, but every intended hook change would require baseline maintenance and review.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer until a silent weakening incident or a concrete external trust boundary is available. Keep Git diff and independent review as the declared control.

**G-B10 does not create a second candidate:** it is the behavioral label for the same A-07/G-N4 threat.

### 6.3 G-N5 - Registry append-only enforcement

**ID:** G-N5
**SOURCE:** `F8_RESEARCH.md` section 3 and no-build list; roadmap section 12.3.
**ORIGINAL PROBLEM:** A pre-commit hook could reject edits to already VERIFIED registry entries and require an explicit override.
**CURRENT STATUS:** Deferred; no history rewrite is documented.
**CURRENT EVIDENCE:** The F7 and F8 registry prefixes are byte-identical at the current head. `git log` shows append/closure commits and no historical rewrite. No incident records a modified VERIFIED entry being accepted.
**RISK:** Human or automated edits could alter historical evidence without a dedicated local guard.
**USER / SYSTEM IMPACT:** A false historical record could weaken auditability, but the current review process exposes the same change in Git diff.
**CURRENT CONTROL:** Canonical single registries, Git history, human diff review, fresh review, maintenance schema/count checks, and the explicit append-only convention.
**RESIDUAL GAP:** Append-only is convention rather than a hard local hook. A local pre-commit rule can be bypassed and is not an independent trust domain.
**BENEFIT OF CLOSURE:** Faster detection of accidental edits to historical entries. No demonstrated security gain over the existing commit review at the current single-operator scale.
**IMPLEMENTATION COMPLEXITY:** Medium operationally: legitimate corrections, evidence closure, rebases, generated documentation, `--no-verify`, CI parity and recovery all need rules.
**REVERSIBILITY:** Easy to remove, but a hook can block legitimate maintenance and create bypass habits.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer until a real history rewrite or accepted registry tampering occurs. Do not add Git hooks in F9.

### 6.4 G-M1 - Mutation testing for shell firewall patterns

**ID:** G-M1
**SOURCE:** `F8_RESEARCH.md` sections 3, 6.J and no-build list; roadmap sections 6.7 and 16.2.
**ORIGINAL PROBLEM:** A weakened firewall regex might survive existing fixtures; mutation testing would intentionally alter patterns and check whether tests detect the change.
**CURRENT STATUS:** Deferred.
**CURRENT EVIDENCE:** F7/F8 directly demonstrated and fixed the known whitespace, case, environment-read, malformed-payload and NUL classes. The current positive fixture and maintenance suite pass. No post-F8 bypass or surviving mutation is recorded.
**RISK:** Future regex edits could reduce coverage without a failing test. Current coverage is finite and intentionally does not claim arbitrary shell-obfuscation coverage.
**USER / SYSTEM IMPACT:** Potentially weaker command blocking, but no current mutation result demonstrates that the existing fixture suite misses a material change.
**CURRENT CONTROL:** Adversarial positive/negative fixtures, `bash -n`, fresh review, human diff, and fail-closed dependency/payload handling.
**RESIDUAL GAP:** No automated mutation score for Bash regexes.
**BENEFIT OF CLOSURE:** Could expose weak assertions or untested pattern branches. Benefit is speculative until a mutation survives the current suite or a bypass is documented.
**IMPLEMENTATION COMPLEXITY:** High relative to this repository: no mature shell mutator is already in use, so a bespoke generator, mutation catalog, timeout policy and fixture oracle would be required.
**REVERSIBILITY:** Easy to delete, but the bespoke harness would add maintenance and false confidence if mutation selection is weak.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer until a demonstrated bypass or surviving, security-relevant mutation exists. Do not install or invent a mutation framework.

### 6.5 G-L1 - `PostToolUseFailure` incident automation

**ID:** G-L1
**SOURCE:** `F8_RESEARCH.md` section 3; `MASTER_IMPLEMENTATION_PLAN.md` section 5; roadmap sections 6.1, 9 and 21.
**ORIGINAL PROBLEM:** Manual `/incident open` could fail to capture a tool failure, leaving the learning loop incomplete.
**CURRENT STATUS:** Deferred.
**CURRENT EVIDENCE:** `INC-001` was opened, reproduced, controlled and closed through the manual workflow. No missed tool failure is documented. The native event exists in the external research, but it is not configured here and was not natively exercised in OpenCode.
**RISK:** A failure could be forgotten; automatic capture could also create noisy, duplicate or incomplete incidents.
**USER / SYSTEM IMPACT:** Manual discipline has a human cost; automation could burden every session with low-value incident artifacts and false positives.
**CURRENT CONTROL:** `/incident` requires freeze, reproduce, RCA, regression, control, verification and linked closure. Existing incident/regression registries make the path visible.
**RESIDUAL GAP:** No automatic observation of a native `PostToolUseFailure` event.
**BENEFIT OF CLOSURE:** Better recall only if a real tool failure is shown to pass unrecorded.
**IMPLEMENTATION COMPLEXITY:** Low code size but high policy/maintenance complexity: deduplication, severity, incomplete context, retries, privacy and human triage need explicit semantics.
**REVERSIBILITY:** Easy to remove, but noisy automation can contaminate registries and trust signals before it is removed.
**F9 RELEVANCE:** Uncertain only if native evidence shows missed failures.
**RECOMMENDATION FOR RESEARCH:** Defer until a failure is demonstrably lost by the manual workflow. Do not add a hook in F9.

### 6.6 G-B11 - Phantom `SubagentStop` entries

**ID:** G-B11
**SOURCE:** `BEHAVIORAL_RELIABILITY_AUDIT.md` sections 8 and 38; `F8_RESEARCH.md` section 3; current handoff.
**ORIGINAL PROBLEM:** Five historical log entries appeared without a known user-invoked subagent, suggesting an unexplained native lifecycle or logging behavior.
**CURRENT STATUS:** Unknown/suspected; not a confirmed defect.
**CURRENT EVIDENCE:** The original observation is recorded, but no deterministic reproducer or root cause exists. Current `subagent-stop-logger.sh` is idempotent by `agent_id`; current OpenCode execution does not provide native Claude Code lifecycle evidence. No new occurrence was found in the F8 Git/runtime closure evidence.
**RISK:** Log noise or misleading session provenance. Severity remains P3 in the source audit.
**USER / SYSTEM IMPACT:** Forensics may contain entries that do not map cleanly to an intentional subagent action. It does not currently block work or alter evidence gates.
**CURRENT CONTROL:** Idempotent `agent_id` check, fail-open logging, session-log rotation, Git preservation and explicit `NOT_VERIFIED` native-runtime labels.
**RESIDUAL GAP:** Source event identity and native dispatch behavior are not established.
**BENEFIT OF CLOSURE:** Clarifies whether the entries are legitimate internal events, payload artifacts, or logger defects.
**IMPLEMENTATION COMPLEXITY:** Unknown until a native reproducer exists; implementing a fix before knowing the cause risks hiding valid events or adding noise.
**REVERSIBILITY:** Any logging change is Git-reversible, but a wrong filter could destroy useful forensic data.
**F9 RELEVANCE:** Uncertain; research-only if the owner needs a decision about native lifecycle trust.
**RECOMMENDATION FOR RESEARCH:** Defer implementation and wait for deterministic reproduction. A bounded native probe is a prerequisite, not an F9 runtime contract.

### 6.7 G-T2 - A second regression sample

**ID:** G-T2
**SOURCE:** `POST_F6_AUDIT_REPORT.md` section C/D; roadmap sections 9, 22 and 26.
**ORIGINAL PROBLEM:** The registry has one real incident/regression cycle, which is a small sample for judging framework scalability.
**CURRENT STATUS:** Deferred by design.
**CURRENT EVIDENCE:** `INC-001`, `CTRL-001` and `REG-001` are active/closed correctly. No second organic incident exists.
**RISK:** Limited statistical confidence about future incident diversity.
**USER / SYSTEM IMPACT:** No current operational failure. Fabricating an incident would create false evidence.
**CURRENT CONTROL:** One real end-to-end cycle plus the explicit no-fabrication rule.
**RESIDUAL GAP:** Small sample size.
**BENEFIT OF CLOSURE:** More natural coverage only when a real incident occurs.
**IMPLEMENTATION COMPLEXITY:** Artificial generation would be low effort and invalid; waiting for a real event has no implementation cost.
**REVERSIBILITY:** Not applicable.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer until an organic incident occurs; never manufacture one.

### 6.8 G-S1 - Rollback smoke test

**ID:** G-S1
**SOURCE:** `POST_F6_AUDIT_REPORT.md` section C; roadmap sections 9 and 20; `POST_F8_AUDIT_REPORT.md` rollback section.
**ORIGINAL PROBLEM:** A documented rollback command has not been executed end-to-end.
**CURRENT STATUS:** Documented limitation; no observed rollback failure.
**CURRENT EVIDENCE:** F7/F8 bundle revert paths are present and reviewed. No destructive rollback was run, by design, and no recovery incident required it.
**RISK:** A copy/paste or environment assumption in a recovery command could fail during an actual recovery.
**USER / SYSTEM IMPACT:** Recovery confidence is lower than for a directly executed path.
**CURRENT CONTROL:** Git commits/checkpoints, per-bundle revert instructions, state snapshots and the recovery skill.
**RESIDUAL GAP:** No disposable-clone smoke execution.
**BENEFIT OF CLOSURE:** Raises confidence in a recovery recipe.
**IMPLEMENTATION COMPLEXITY:** Low/medium for a disposable clone, but rollback testing touches destructive state transitions and needs an owner-approved test protocol.
**REVERSIBILITY:** The test can be isolated in a temporary clone; running it against the working repository is not acceptable for F9.
**F9 RELEVANCE:** No phase-level relevance.
**RECOMMENDATION FOR RESEARCH:** Defer or authorize later as a standalone recovery-validation micro-task; do not open an F9 runtime phase for it.

### 6.9 G-S2 - Rollback command clarity

**ID:** G-S2
**SOURCE:** `POST_F6_AUDIT_REPORT.md` section C; `CONTROL_REGISTRY.md`; roadmap section 9.
**ORIGINAL PROBLEM:** The historical CTRL-001 rollback command uses a copy/paste-sensitive `sed` expression.
**CURRENT STATUS:** Documentary limitation; no failed execution is recorded.
**CURRENT EVIDENCE:** The command remains documented in `CONTROL_REGISTRY.md`; F8 did not change it. No incident cites a rollback command failure.
**RISK:** Operator error during recovery.
**USER / SYSTEM IMPACT:** Potential recovery friction, not runtime behavior.
**CURRENT CONTROL:** Git history, checkpoint references and manual review of rollback instructions.
**RESIDUAL GAP:** The command is not simplified or tested in a disposable recovery run.
**BENEFIT OF CLOSURE:** Better copy/paste reliability.
**IMPLEMENTATION COMPLEXITY:** Low documentation effort, but it is not a phase-level control.
**REVERSIBILITY:** Fully reversible documentation change.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer as a separate documentation micro-task if the owner wants it; do not bundle it into F9.

### 6.10 G-Bob-1 - Fixture acceptance labeling

**ID:** G-Bob-1
**SOURCE:** `POST_F6_AUDIT_REPORT.md` section C; `MASTER_IMPLEMENTATION_PLAN.md` section 10; `evals/skills/fixtures.json`.
**ORIGINAL PROBLEM:** The fixture JSON has no explicit header declaring that its entries are acceptance criteria.
**CURRENT STATUS:** Documentary ambiguity; the fixtures execute and are described by the handbook.
**CURRENT EVIDENCE:** `evals/skills/fixtures.json` is valid and `validate.sh` passes. No evaluator misread caused a failure.
**RISK:** Future maintainers may misunderstand fixture intent.
**USER / SYSTEM IMPACT:** Low cognitive overhead only.
**CURRENT CONTROL:** File structure, fixture markers and handbook descriptions.
**RESIDUAL GAP:** No one-line semantic header.
**BENEFIT OF CLOSURE:** Slightly clearer maintenance.
**IMPLEMENTATION COMPLEXITY:** Trivial documentation change.
**REVERSIBILITY:** Trivial.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer or handle independently as a micro documentation edit; no F9 phase.

### 6.11 G-A1 - Placeholder context packs

**ID:** G-A1
**SOURCE:** `POST_F6_AUDIT_REPORT.md` section C; roadmap sections 9 and 17; `.claude/context/CORE.md`, `BUSINESS.md`, `SECURITY_RULES.md` and `NO_GO.md`.
**ORIGINAL PROBLEM:** The repository's own context templates retain `{{...}}` placeholders.
**CURRENT STATUS:** Known template state, not an incident.
**CURRENT EVIDENCE:** The files explicitly identify themselves as context-pack templates and instruct an installed project to replace the block. `CURRENT_STATE.md` and `DECISIONS.md` correctly describe the mirror/source model. No runtime failure is recorded.
**RISK:** A maintainer could confuse a template with a configured project pack.
**USER / SYSTEM IMPACT:** Low; the repository is the installer source, not a configured product project.
**CURRENT CONTROL:** Explicit template instructions, installer behavior, `PROJECT_STATE.md` as source of truth, and handbook onboarding steps.
**RESIDUAL GAP:** Placeholders remain visible in local source templates.
**BENEFIT OF CLOSURE:** Less visual ambiguity for maintainers.
**IMPLEMENTATION COMPLEXITY:** Low documentation/template editing, with risk of damaging installer semantics if placeholders are removed from source templates.
**REVERSIBILITY:** Easy via Git.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer; do not fill project-specific values into the control-plane source.

### 6.12 G-N1 - Manual runtime revalidation cadence

**ID:** G-N1
**SOURCE:** roadmap section 9 and section 37; handbook maintenance guidance.
**ORIGINAL PROBLEM:** `/doctor` and maintenance depend on operator initiative rather than an enforced periodic cadence.
**CURRENT STATUS:** Documentary/process gap.
**CURRENT EVIDENCE:** Maintenance passes when run; no stale system was discovered because a cadence was missed, and no production scheduler is part of this single-user local control plane.
**RISK:** A long-lived unvalidated installation could drift unnoticed.
**USER / SYSTEM IMPACT:** Operational confidence may decay over time.
**CURRENT CONTROL:** `maintenance.sh` in CI, pre-change instructions in the handbook, Git review and `/doctor`.
**RESIDUAL GAP:** No scheduler or hard periodic gate.
**BENEFIT OF CLOSURE:** Better routine discipline if the project has a real cadence requirement.
**IMPLEMENTATION COMPLEXITY:** Automation would add environment-specific scheduling and false confidence; a documentation cadence is low cost.
**REVERSIBILITY:** Documentation is easy; scheduler integration is operationally coupled.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer until the project has a demonstrated cadence/use case; keep the current pre-change maintenance rule.

### 6.13 G-N2 - Session-log retention policy

**ID:** G-N2
**SOURCE:** roadmap section 9 and section 37; `subagent-stop-logger.sh`; `POST_F8_AUDIT_REPORT.md`.
**ORIGINAL PROBLEM:** Daily archive rotation exists, but an explicit retention/deletion policy is not enforced.
**CURRENT STATUS:** Documentary/operational limitation.
**CURRENT EVIDENCE:** F7 rotation now moves the active log and preserves same-day suffixes. No storage incident or consumer requirement is documented.
**RISK:** Archives can grow without bound over a long period.
**USER / SYSTEM IMPACT:** Disk use and forensic clutter, not evidence-gate correctness.
**CURRENT CONTROL:** Daily rotation, Git visibility and local archive directory.
**RESIDUAL GAP:** No retention threshold or cleanup owner.
**BENEFIT OF CLOSURE:** Predictable disk usage once actual retention needs are known.
**IMPLEMENTATION COMPLEXITY:** Low code but introduces deletion policy, preservation risk and another automated mutation path.
**REVERSIBILITY:** Code is reversible; deleted logs are not.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer until disk growth or retention requirements are evidenced; do not add automatic deletion in F9.

### 6.14 G-B6 - Fixture creation false block

**ID:** G-B6
**SOURCE:** `BEHAVIORAL_RELIABILITY_AUDIT.md` sections 5, 26 and 37; F7 closure documents.
**ORIGINAL PROBLEM:** The same security hooks can block creation of their own malicious fixtures during a live session.
**CURRENT STATUS:** Known and mitigated by fixture/install workflow; not an unresolved production defect.
**CURRENT EVIDENCE:** The shipped fixtures execute from the repository and maintenance passes. The audit explicitly chose install/repository fixtures rather than weakening security hooks.
**RISK:** Fixture authoring friction can cause an operator to bypass or weaken a hook.
**USER / SYSTEM IMPACT:** Test authoring friction only.
**CURRENT CONTROL:** Existing fixture files, repository execution, and maintenance invocation.
**RESIDUAL GAP:** No convenience path for creating blocked test payloads interactively.
**BENEFIT OF CLOSURE:** Lower test-authoring friction.
**IMPLEMENTATION COMPLEXITY:** A bypass helper could weaken the trust boundary and would need its own controls.
**REVERSIBILITY:** Easy, but helper semantics could outlive its need.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer; preserve the current security behavior.

### 6.15 G-B9 - Empty `agent_type` field

**ID:** G-B9
**SOURCE:** `BEHAVIORAL_RELIABILITY_AUDIT.md` sections 5 and 8; current `subagent-stop-logger.sh`.
**ORIGINAL PROBLEM:** The jq fallback handles null/missing `agent_type` but not an empty string, producing a blank log field.
**CURRENT STATUS:** Unresolved cosmetic behavior.
**CURRENT EVIDENCE:** The current logger still uses `.agent_type // "subagent"`; no evidence links the blank field to a state or security failure.
**RISK:** Reduced log readability.
**USER / SYSTEM IMPACT:** Forensic convenience only.
**CURRENT CONTROL:** Session log, agent ID idempotence and rotation.
**RESIDUAL GAP:** Empty string is not normalized.
**BENEFIT OF CLOSURE:** Cleaner logs.
**IMPLEMENTATION COMPLEXITY:** Very low, but no phase-level value.
**REVERSIBILITY:** Easy.
**F9 RELEVANCE:** No.
**RECOMMENDATION FOR RESEARCH:** Defer or handle as an isolated low-risk fix if it becomes relevant during unrelated logger work.

---

## 7. Additional Explicit No-Build Candidates

The roadmap and F8 no-build list also mention capabilities that are not current gaps:

| Candidate | Current evidence | Disposition |
|---|---|---|
| OpenTelemetry GenAI traces | Single-user local system, no aggregator, no RCA blocked by missing traces | Defer |
| MCP allowlist/tool-poisoning defense | No MCP is in use | Defer until MCP adoption |
| Cross-provider fallback/model routing | ARCH-001 and current scope fix the provider model; no outage need | Out of scope |
| Vector database/shared memory | No cross-project knowledge workload | No build |
| Property-based, fuzzing or metamorphic framework | Deterministic fixtures cover demonstrated shell cases; no missed-input incident | No build |
| Cryptographic evidence, Merkle, PGP, sigstore or blockchain | No tampering incident; disproportionate complexity | No build |
| New identity fields (`run_id`, `attempt_id`, `evaluation_id`, `artifact_id`, `checkpoint_id`) | Existing identifiers are sufficient at current scale; no collision incident | No build |
| New hooks, agents, skills, rules, registries or orchestration engine | No concrete problem not covered by existing controls | No build |
| Custom dashboard/telemetry/export | No consumer or decision requires it | No build |

These items do not qualify as F9 candidates merely because they are technically possible.

---

## 8. F8 Audit Limitations: Classification

### 8.1 Native Claude Code lifecycle not verified

**Classification:** Expected environment boundary and evidence-quality limitation; not an observed
runtime defect.

OpenCode executed repository scripts and fixtures. It did not prove Claude Code's actual event
dispatcher, matcher behavior, event ordering, native payload shape, or native task lifecycle.
F7/F8 documents correctly label this `NOT_VERIFIED`; no claim should be upgraded.

### 8.2 Malformed-JSON native path not directly verifiable through the normal wire shape

**Classification:** Expected verification boundary; not evidence that native runtime is broken.

F8 directly tests the hook with malformed input and proves the script fails closed. It cannot prove
that Claude Code's native dispatcher can produce that malformed shape. The native question is
whether the hook receives normal structured input and invokes correctly, not whether OpenCode can
invent an invalid wire payload.

### 8.3 Valid non-object JSON root is shape-agnostic

**Classification:** Accepted policy boundary and possible future research candidate, not a current
defect.

The F8 firewall check guarantees one valid JSON document and then extracts
`.tool_input.command`. It does not claim a full root-object schema for every arbitrary JSON value.
The repository has no evidence that normal Claude Code Bash wire input is a scalar or array, and
no bypass or incident relies on one. A native payload-shape mismatch would change this status.

### 8.4 Finite firewall regex coverage

**Classification:** Intentional accepted limitation; no action.

The firewall protects demonstrated and reviewed command families. It does not claim arbitrary shell
obfuscation coverage. F8 preserved this boundary, and the current adversarial fixture passes. A new
documented bypass would be an incident/input for a new research decision; absence of arbitrary
coverage is not itself a defect.

### 8.5 Reviewer identity is documented, not cryptographically proven

**Classification:** Accepted process limitation and provenance boundary; no action.

F8 documents `code-reviewer@fresh-context`, `human/@owner` and `NOT_REQUIRED` as conventions. The
schema and hook intentionally do not claim a cryptographic model identity. The repository also
correctly records that the reviewer being Claude Opus is not proven. This does not justify PGP,
model attestation or a new identity system without an actual decision that depends on it.

---

## 9. Native-Runtime Decision Analysis

### Would native evidence change the trust model?

Yes, but only for a narrow class of decisions. It could materially change whether the project can
trust the following claims in the native environment:

- the actual Claude Code dispatcher invokes the configured `TaskCompleted`, `PreToolUse`, `Stop`,
  `SubagentStop`, `PreCompact` and `SessionStart` hooks with the payloads the scripts expect;
- `stop_hook_active` prevents native Stop re-entry as intended;
- a native tool failure is observable and whether manual incident opening misses it;
- the suspected phantom `SubagentStop` entries are real native events or logging artifacts.

It would **not** change the script-level result that the current F7/F8 fixtures pass. It would not
retroactively reopen F8 or justify artifact recomputation, hook baselines, mutation testing or
registry hooks.

### Exact decision affected

The affected decision is: **Should G-B11 or G-L1 be promoted from deferred/unknown to a concrete
runtime control or incident investigation?**

### Why script-level evidence is insufficient

Direct calls such as `bash hook < payload` bypass the native event dispatcher, matcher selection,
event ordering, native re-entry semantics, and native exit/output interpretation. They prove the
script contract, not the runtime integration contract.

### Smallest feasible evidence package

If the owner needs this decision, use a disposable project at the F8 checkpoint and an authenticated
native Claude Code session. Do not change the repository runtime. Capture only:

1. native invocation and output for valid `PreToolUse` Bash allow/block cases;
2. native Stop with stale state once and with `stop_hook_active=true` on re-entry;
3. native `TaskCompleted` allow/block using the existing evidence contract;
4. native `SubagentStop` identity and log behavior, including whether phantom entries recur;
5. native `PreCompact` -> `SessionStart compact` state-integrity behavior;
6. a controlled tool failure only if evaluating G-L1, with no automatic incident creation.

The evidence must include event name, payload shape (redacted), hook exit code, emitted output,
ordering and reproducibility. A native session is not currently available in this OpenCode
execution, so those facts remain `NOT_VERIFIED`, not `BROKEN`.

### Does it belong in F9?

Only as a prerequisite research run if the owner selects G-B11/G-L1 for further consideration. It
does not justify an F9 implementation phase now. The smallest current decision is to preserve the
boundary and defer promotion until native evidence can change a concrete owner decision.

---

## 10. Benefit Versus Complexity

| Candidate | Benefit supported now | Complexity / new risk | Current disposition |
|---|---|---|---|
| A-05/G-N3 | Conditional detection of unobserved evidence tampering | Artifact-set contract, migration, mapping and false trust if incomplete | Defer |
| A-07/G-N4/G-B10 | Detect some accidental hook edits | Same-repo baseline is not an independent trust domain; baseline churn | Defer |
| G-N5 | Detect some accidental registry edits | Git-hook duplication, bypasses, legitimate correction friction | Defer |
| G-M1 | Possible signal about weak firewall fixtures | Bespoke shell mutator, high maintenance, no surviving mutation | Defer |
| G-L1 | Possible improved failure recall | Noise, duplicate/incomplete incidents, native lifecycle dependency | Defer |
| G-B11 | Clarify suspected log anomaly | No deterministic cause; wrong fix could hide forensic data | Defer pending native reproduction |
| G-S1/S2 | Better recovery confidence/readability | Recovery test protocol or docs only; no failure observed | Separate micro-task at owner discretion |
| G-Bob-1/G-A1/G-N1/G-N2/G-B9 | Small clarity or hygiene gains | No runtime benefit; possible template/retention side effects | Defer |
| G-T2 | More samples | Fabricating an incident invalidates evidence | Defer |

The balance is consistently `BENEFIT < COMPLEXITY` or `BENEFIT NOT YET DEMONSTRATED` for a phase.

---

## 11. F9 Scope Budget

The smallest defensible scope of this session is documentation-only:

| Budget item | Allowed |
|---|---|
| Runtime files | 0 |
| Hook changes | 0 |
| Fixture changes | 0 |
| Evidence/regression entries | 0 |
| New dependencies | 0 |
| New hooks/agents/skills/rules/registries | 0 |
| New schemas or identity fields | 0 |
| Research artifacts | `docs/00_SYSTEM/F9_RESEARCH.md` |
| Current handoff | `docs/00_SYSTEM/SESSION_HANDOFF_CURRENT.md` |
| F8 historical artifacts | 0 modifications |

No candidate is justified strongly enough to define a future implementation contract. Therefore
there is no authorized `PROBLEM / GOAL / AUTHORIZED FUTURE FILES` implementation contract in this
document. Any later contract requires a separate owner decision and fresh evidence.

### Conditional future contracts not authorized here

The following are triggers, not contracts:

- A documented evidence-tampering event could justify a new A-05 artifact-set research contract.
- A documented silent hook weakening could justify A-07/G-N4 trust-boundary research.
- A missed tool failure could justify G-L1 event semantics research.
- A deterministic native phantom event could justify G-B11 investigation.
- A real firewall bypass surviving F8 fixtures could justify G-M1 research.

---

## 12. Recommended Disposition

### Final decision

**F9 NOT JUSTIFIED**

This conclusion does not mean the listed limitations do not exist. It means no current limitation
has the combination of observed impact, unmet control, proportionate benefit and reversible scope
needed to open a new implementation phase.

### What remains deferred

- A-05/G-N3 artifact-hash recomputation.
- A-07/G-N4/G-B10 self-modification detection.
- G-N5 registry append-only enforcement.
- G-M1 shell mutation testing.
- G-L1 `PostToolUseFailure` automation.
- G-B11 phantom `SubagentStop` investigation until deterministic/native evidence exists.
- G-T2 second regression until an organic incident occurs.
- G-S1/S2 and other documentary hygiene items as independent owner decisions, not F9 scope.
- OTel, MCP, cross-provider, vector memory, custom eval, property/fuzzing, cryptographic evidence,
  extra identity fields and other explicit no-build items.

### What is closed and must not be reopened

- F7 runtime, evidence and regressions remain frozen.
- F8 runtime, evidence and regressions remain frozen.
- A-03, A-04 and A-06 remain F8 closure results.
- G-V1/G-Bob-2/G-T1 and the F7 behavior bundles remain closed under their existing evidence.
- G-D3 remains the ARCH-004 documentary convention.

---

## 13. Self-Attack

1. **Did this assume F9 must exist?** No. The evidence question was answered first.
2. **Was a deferred issue promoted without new evidence?** No. No candidate gained new runtime evidence.
3. **Was a limitation mistaken for a bug?** Native boundaries, finite regexes, non-object roots and reviewer identity were classified separately.
4. **Was sophistication optimized over trust?** No. Existing Git, fixtures, maintenance and review controls were reused.
5. **Was architecture proposed before need was proven?** No. No new schema, baseline, hook or framework was proposed for implementation.
6. **Was native verification confused with runtime failure?** No. Native behavior remains `NOT_VERIFIED`, not `BROKEN`.
7. **Was a new identity model invented?** No.
8. **Were new fields invented?** No.
9. **Was F8 reopened?** No. F8 files and claims remain frozen.
10. **Was research turned into authorization?** No. `IMPLEMENTATION_AUTHORIZED = NO`.
11. **Could existing controls solve the candidates?** Yes for current scale; the remaining gaps need a real trigger, not more machinery.
12. **Is `F9 NOT JUSTIFIED` valid?** Yes. It is the evidence-supported final state.

---

## 14. Owner Decisions Required

### DECISION F9-D01

**QUESTION:** Should any F9 runtime implementation be authorized after this research?

**OPTION A:** Keep F9 implementation closed. Consequence: current controls and documented trust
boundaries remain unchanged; deferred triggers remain the activation criteria.

**OPTION B:** Authorize a later, candidate-specific implementation contract. Consequence: the owner
must name one candidate, evidence threshold, files, tests, rollback and non-goals before code.

**OPTION C:** Authorize a native-runtime research session first. Consequence: no repository runtime
changes, but the session must produce the lifecycle evidence listed in section 9.

**EVIDENCE:** No current candidate meets the phase threshold; maintenance is 12/12 PASS and F8 is
complete/frozen.

### DECISION F9-D02

**QUESTION:** When should native Claude Code evidence be obtained?

**OPTION A:** Obtain it now in a disposable, authenticated environment. Consequence: G-B11/G-L1
and native wiring claims can be decided with direct evidence before any future control proposal.

**OPTION B:** Defer it until a concrete G-B11 recurrence, missed tool failure, or native integration
decision appears. Consequence: current `NOT_VERIFIED` boundary remains accepted and no environment
work is performed now.

**EVIDENCE:** OpenCode can execute scripts but cannot prove native dispatcher, matcher, ordering or
re-entry semantics; no current owner decision requires those facts.

### DECISION F9-D03

**QUESTION:** How should the documentary candidates G-S1, G-S2, G-Bob-1, G-A1, G-N1 and G-N2 be
handled?

**OPTION A:** Execute them as isolated documentation/recovery micro-tasks. Consequence: clarity or
operational guidance improves without opening F9, but each task still needs its own scope and check.

**OPTION B:** Keep them deferred with the current references. Consequence: no new changes or risk;
the known documentary limitations remain visible.

**OPTION C:** Retire obsolete items from the roadmap after an owner review. Consequence: less
roadmap noise, but historical rationale must remain preserved elsewhere.

**EVIDENCE:** These items have no demonstrated runtime failure and are explicitly described as
documentary or low-impact in the canonical roadmap.

### DECISION F9-D04

**QUESTION:** What trigger should be required before revisiting artifact or hook integrity controls?

**OPTION A:** Require a documented evidence-tampering or silent-hook-weakening incident.
Consequence: implementation follows an observed failure with a reproducer.

**OPTION B:** Require an owner-defined external audit or compliance requirement. Consequence: the
trust boundary may be expanded even without a local incident, with additional governance cost.

**OPTION C:** Keep the current Git/reviewer trust boundary indefinitely at this scale. Consequence:
no new baseline or artifact mapping is introduced; the limitation remains explicit.

**EVIDENCE:** No tampering or accepted silent weakening is present in F7/F8 history; same-repository
baselines would not be independently trusted against the strongest threat model.

### DECISION F9-D05

**QUESTION:** Should F10-F12 remain undefined until new evidence appears?

**OPTION A:** Keep F10-F12 unknown and research-required. Consequence: no speculative phase is
created.

**OPTION B:** Define future phases now from roadmap themes. Consequence: phase definitions exist,
but would be proposals without a current problem/evidence contract.

**EVIDENCE:** The repository contains no historical F10-F12 contract; F8 explicitly left them
unknown and no current candidate requires them.

---

## 15. Preservation And Authorization State

This research caused no change to:

- F7 runtime;
- F8 runtime;
- F7 evidence or regressions;
- F8 evidence or regressions;
- F7 or F8 reports;
- F7 checkpoint;
- completed F8 corrections.

The only intended outputs are this F9 research document and the current session-handoff update.

```text
F7_STATUS: COMPLETE / FROZEN
F8_STATUS: COMPLETE / FROZEN
F9_RESEARCH_STATUS: COMPLETE
F9_DECISION: F9 NOT JUSTIFIED
IMPLEMENTATION_AUTHORIZED: NO
IMPLEMENTATION_PERFORMED: NO
RUNTIME_CHANGED: NO
NEW_EVIDENCE: NONE
NEW_REGRESSIONS: NONE
```

**Next allowed action:** owner review of this research package. No F9 implementation, F10 opening,
runtime change, or scope expansion is authorized by this document.

---

**END F9 RESEARCH**

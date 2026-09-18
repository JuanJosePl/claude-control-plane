# F7 Full Independent Audit Handoff

**Audit status:** `F7_STATUS_FOR_AUDIT: CLAIMED_COMPLETE_PENDING_INDEPENDENT_REVALIDATION`
**Baseline head:** `b6e8fd0b76742ec0320af5a1b8598e712c8c67b6`
**Current final F7 head:** `094413c963466165443a5a5d8b4c1c3becc068e8`
**Required audit range:** `b6e8fd0..094413c`
**Next action:** F7 FULL INDEPENDENT RE-AUDIT
**F8 status:** `UNKNOWN / RESEARCH REQUIRED`

## Purpose

This handoff closes the implementation session and transfers the complete F7 delta to a fresh,
independent audit session. It is not an approval of F7 correctness. It is a reproducible audit
contract.

The next session must audit the combined output of historical work, Kimi/OpenCode if proven,
ChatGPT if proven, independent reviewers, repository scripts, evidence, registries and current
state. The target is the system delta, not a preferred executor.

## Hard Boundary

The audit session MUST NOT:

- implement F8;
- modify hooks, firewall logic, evidence semantics, evaluator semantics or F7 behavior;
- add controls, hooks, skills, agents, dependencies or architecture;
- rewrite EV-001…EV-008, INC-001, CTRL-001 or REG-001;
- relabel authorship retrospectively;
- alter tests to obtain PASS;
- normalize pre-existing unrelated worktree changes;
- silently repair an audit finding.

If a problem is found, record it as an `AUDIT FINDING` with `STATUS = UNRESOLVED`, `DEFERRED`,
`BLOCKED` or `RESEARCH REQUIRED`. Stop implementation work.

## Source Hierarchy

Use evidence in this order:

1. git commit metadata and content;
2. reproducible command output;
3. current repository files and hashes;
4. explicit execution/session records;
5. existing evidence and registry records;
6. project documentation;
7. inference;
8. unknown.

Never infer a model identity from the human git author. The F7 git range records
`juan jose polo <poloj3614@gmail.com>` as author and committer. The model attribution matrix is in
`CHANGE_PROVENANCE_F7.md` and must itself be audited.

## Provenance Starting Point

- `EXECUTOR_KIMI_K3_OPENCODE`: UNKNOWN for the F7 commit range; no direct repository evidence
  identifies Kimi K3 as executor.
- `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX`: attributed to `37662b4..094413c` only because the current
  execution transcript directly shows the edits, tests and commits. This is session attribution,
  not cryptographic identity.
- `REVIEWER_INDEPENDENT_UNSPECIFIED`: final fresh `general` subagent review returned PASS; no model
  identity proves Opus.
- `REVIEWER_OPUS`: not assigned. A separate Opus audit is required after this audit.
- `HISTORICAL_PRE_F7`: baseline and earlier work; model executor UNKNOWN.

Read `CHANGE_PROVENANCE_F7.md` before assigning any authorship.

## Complete Delta To Audit

Audit every commit, not only the latest:

```text
37662b4  ADR-004 task semantics
148501f  Stop anti-loop
cc8634f  Initial firewall hardening
748fc6a  Freshness and positive fixtures
b1471d0  Evidence coupling
7e3a9fc  Session rotation
7b575e1  Installer idempotency
82aaa75  Firewall whitespace follow-up
1a3509e  Invalid evidence fixture coverage
b659dfb  Adversarial firewall/evidence fixes
3ed9609  Evidence, registries, state and documentation closure
a770761  Checkpoint metadata
69b2c23  EV-012 artifact hash correction
dc89939  State/report closure metadata
ec8b76e  EV-012 task identity correction
094413c  Final checkpoint metadata
```

For each commit verify date, author metadata, files, purpose, scope, artifact hashes, evidence
links, regression links and review relationship. Do not treat the commit subject as proof of
correctness.

## F7 Files To Inspect

Runtime and controls:

- `.claude/hooks/stop-logger.sh`
- `.claude/hooks/bash-firewall.sh`
- `.claude/hooks/task-completed-evidence.sh`
- `.claude/hooks/subagent-stop-logger.sh`
- `install.sh`
- `evals/maintenance.sh`
- `evals/REGRESSION_BUDGET.json`

Fixtures/evaluators:

- `evals/hooks/stop-hook-idempotency.sh`
- `evals/hooks/firewall-positive.sh`
- `evals/hooks/secret-guard-positive.sh`
- `evals/hooks/task-completed-coupling.sh`
- `evals/hooks/session-log-rotation.sh`
- `evals/install/idempotency.sh`
- `evals/skills/evidence-freshness.sh`

Evidence/state/docs:

- `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`
- `REGRESSION_REGISTRY.md`
- `INCIDENT_REGISTRY.md`
- `CONTROL_REGISTRY.md`
- `DECISION_REGISTRY.md`
- `.claude/context/DECISIONS.md`
- `PROJECT_STATE.md`
- `ARTIFACT_MANIFEST.md`
- `docs/MASTER_IMPLEMENTATION_PLAN.md`
- `docs/MASTER_EVOLUTION_ROADMAP.md`
- `docs/CONTROL_PLANE_HANDBOOK.md`
- `docs/00_SYSTEM/POST_F7_AUDIT_REPORT.md`
- `docs/00_SYSTEM/CHANGE_PROVENANCE_F7.md`
- `docs/00_SYSTEM/F7_CLAIM_VS_EVIDENCE.md`

The three handoff documents created by the closure session are uncommitted audit artifacts. Audit
their content, but do not treat them as proof of the runtime behavior they describe.

## Required Reverification

Run from a fresh conversation and record raw results:

```bash

bash evals/incidents/INC-001-task-completed-evidence.sh
bash evals/state/state-integrity.sh

bash -n evals/maintenance.sh
bash -n .claude/hooks/*.sh
bash -n evals/hooks/*.sh
bash -n evals/install/*.sh
```

Run every existing F7 fixture individually. Confirm the fixture path is the one recorded in its
registry entry. Do not create replacement fixtures during the audit.

## Evidence Integrity Audit

Independently check every EV-009…EV-014 entry:

- task_id follows the documented convention and identifies the claimed work;
- source command or fixture exists and executes;
- timestamp is plausible and not fabricated;
- provenance is present and truthful;
- artifact hash recomputes from the claimed artifact set;
- contract hash refers to the actual F7 contract source;
- status and reviewer fields are supported by execution records;
- claim does not exceed the tested behavior;
- later documentation changes did not invalidate artifact hashes;
- EV-001…EV-008 are append-only and unchanged.

Independently check REG-002…REG-009:

- every referenced fixture exists;
- every fixture executes;
- assertions are meaningful rather than decorative;
- maintenance or the appropriate suite invokes it;
- baseline/control outcomes are not fabricated;
- REG-001 remains intact.

Treat `Reviewer: PASS`, `Status: VERIFIED`, `maintenance 12/12 PASS`, POST-F7 and PROJECT_STATE as
claims to reproduce, not as authority.

## Behavioral And Security Audit

Reproduce original and nearby cases:

- `stop_hook_active=true`, repeated Stop, missing input, malformed JSON and stale/fresh state;
- root deletion with spaces, tabs, quoting and case mutations;
- SQL DROP/TRUNCATE variants and spaced fork-bomb variants;
- source, dot-source, eval, process substitution, read and exec `.env` forms;
- legitimate commands adjacent to every blocked pattern;
- empty/null/mismatched/full/bare contract hashes;
- exact and near-match task IDs;
- `VERIFIED`, `VERIFIED_BOGUS` and `VERIFIED extra` statuses;
- stale and duplicate Tier 3 results;
- repeated rotation in one day and archive preservation;
- clean, repeated, partial, interactive and forced installation;
- missing dependency/fail-closed paths;
- historical task reuse and evidence/contract mismatch.

Do not broaden into a new threat model. Record any bypass as an audit finding; do not fix it.

## Scope And Budget Audit

Reconcile independently:

- planned: approximately 80 LOC, approximately 5 fixtures, 1 ADR, 1 config field;
- POST-F7 documented actual: 591 additions, 17 deletions, 7 fixtures;
- current scoped committed measurement: 608 additions, 18 deletions, 7 fixtures;
- full committed range: 2524 additions, 28 deletions across 24 paths.

Determine whether the difference is documentation-only, test expansion, runtime scope, or an
accounting error. Do not trim or rewrite during the audit.

Confirm there are no new hooks, agents, skills, runtime dependencies, registries or F8-F12 work.

## State, Rollback And Worktree Audit

- Verify PROJECT_STATE currently claims Phase 7 COMPLETE but classify that as a claim pending audit.
- Verify `NEXT_ALLOWED_PHASE` remains F8 RESEARCH REQUIRED.
- Verify historical POST_F6 report is unchanged.
- Verify pre-existing unrelated modified/untracked worktree files are not silently reverted.
- Verify whole-worktree `git diff --check` limitation and scoped commit-range check separately.
- Inspect each bundle commit for a meaningful `git revert` path without executing destructive rollback.
- Verify rollback does not require rewriting historical evidence.

## Known Limitations To Preserve

- Native Claude Code runtime lifecycle is NOT VERIFIED; OpenCode script execution is not equivalent.
- Pre-existing unrelated modifications and untracked baseline audit artifacts remain in the worktree.
- Pre-existing trailing whitespace in `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md` blocks whole-worktree
  `git diff --check`.
- Missing `contract_hash` has a one-phase ARCH-004 warning path.
- Firewall coverage is regex-based and finite; malformed firewall JSON extraction is a known risk.
- The budget count discrepancy is unresolved.
- Reviewer model identity is UNKNOWN; do not call the prior reviewer Opus.

## Findings Protocol

Every finding must include:

```text
FINDING_ID:
SEVERITY:
STATUS: UNRESOLVED | DEFERRED | BLOCKED | RESEARCH REQUIRED
CLAIM:
REPRODUCTION:
EVIDENCE:
PROVENANCE:
IMPACT:
RECOMMENDED ACTION:
```

The audit session must stop implementation after recording a finding. It must not convert a concern
to PASS by editing the test, registry or runtime.

## Required Second Review

After the GPT-5.6 Luna Max independent audit is complete, start a second fresh review with Claude
Opus. Provide Opus:

- this handoff;
- the complete `b6e8fd0..094413c` delta;
- the provenance and claim matrices;
- test outputs;
- evidence and regression registries;
- POST_F7_AUDIT_REPORT.

Opus must inspect, reproduce and attack. Opus must not implement fixes, edit tests, rewrite evidence,
modify runtime, or edit the roadmap. If Opus finds a problem, record it and stop.

## F8 Boundary

F8 is not defined. The only allowed next action after this closure is:

```text
F7 FULL INDEPENDENT RE-AUDIT
```

Only after F7 survives independent re-audit may the project perform separate F8 research. No F8
implementation is authorized by this handoff.

## Audit Output Contract

The next session must report:

- baseline and current head;
- complete commit list and provenance classification;
- implementation/test/documentation delta;
- independent test results;
- evidence and regression reconciliation;
- security and behavioral findings;
- reviewer identity and limits;
- budget and side-effect audit;
- rollback audit;
- unresolved limitations;
- F7 re-audit verdict;
- whether Opus review is still pending;
- F8 status without implementation.

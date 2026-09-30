# 01 — TRUTH AND STATE

> **Stratum-C synthesis artifact (research branch, non-canonical, read-only over canonical files).**
> Not an Owner Decision. Not an implementation authorization. Not a checkpoint. Not a merge instruction.
> Produced by: OPUS 4.8 MASTER SYNTHESIS run. Branch: `claude/ccp-opus-synthesis-prep-h035ne`.
> Fecha: 2026-09-29. Autor: Claude (analyst, no decisor).
>
> Reglas heredadas: DETERMINAR ≠ CORREGIR · RECOMMEND ≠ DECIDE · VERIFY > CLAIM ·
> EVIDENCE > ASSUMPTION · OPEN ≠ OWNER_CHOSEN. Confidence bands: `[VERIFIED]` (command reproduced
> this session), `[DOCUMENTED]` (read from a file, not re-probed), `[INFERENCE]` (deductive step),
> `[HYPOTHESIS]`, `[UNKNOWN]`.

This document answers GATE A + GATE A.1 (repository & remote forensics) and GATE B / §5 (corpus
reconstruction + source-of-truth precedence). It is the ground-truth layer the other eight
documents build on.

---

## §1. MAIN BASELINE (GATE A)

| Field | Value | Evidence |
|---|---|---|
| Canonical HEAD (`origin/main`) | `9e995a8` | `git rev-parse origin/main` [VERIFIED] |
| This synthesis branch HEAD | `9e995a8` (identical to main at fork) | `git rev-parse HEAD` [VERIFIED] |
| Last checkpoint | `bf2d22a` (ARCH-009 DEC-08 reformulation) | `PROJECT_STATE.LAST_GIT_CHECKPOINT` [VERIFIED] |
| Current phase | 8 · COMPLETE | `PROJECT_STATE.md:5-6` [VERIFIED] |
| Active decisions | ARCH-001 … ARCH-009 (nine) | `PROJECT_STATE.ACTIVE_DECISIONS` [VERIFIED] |
| Open Owner gates | NONE (F9 gate CLOSED 2026-09-20) | `PROJECT_STATE.F9_OWNER_DECISION_GATE` [VERIFIED] |
| Next allowed phase | None auto; a new owner-driven project decision is required | `PROJECT_STATE:239` [VERIFIED] |
| Blockers | NONE (no technical blockers) | `PROJECT_STATE:10` [VERIFIED] |
| Runtime authorization pending | NONE | ARCH-009 §RUNTIME BOUNDARY; F9-D01=A [VERIFIED] |

**Baseline interpretation.** CCP is at a **stable resting point**. The ARCH-001..009 arc is closed and
checkpointed; F9-D01..D05 Owner gate is closed; no phase is auto-authorized; the working tree carries
only session bookkeeping. The system is not mid-flight on any decision.

> ⚠ **Forensic note on stale local refs.** Before `git fetch origin --prune`, the local `main` ref
> lagged at `2f55412` (the pre-DEC-08 commit). A first read of `git branch -a` would suggest main was
> *behind* this branch. After fetch, `origin/main = 9e995a8`. **The GATE A.1 prompt's expected
> `MAIN 9e995a8` is CORRECT; the apparent lag was a local-ref artifact, now reconciled.** Any consumer
> of this synthesis must `git fetch` before trusting `main`'s position.

---

## §2. REMOTE PUSH INTEGRITY (GATE A.1.A–B)

`git ls-remote origin` [VERIFIED, 2026-09-29]:

```
9e995a8  HEAD
2e0a69c  refs/heads/claude/happy-bell-tg54h1
9e995a8  refs/heads/main
40d9290  refs/heads/research/post-dec08-adversarial-audit
dd298e1  refs/heads/research/post-dec08-recomposition
a3db337  refs/pull/1/head
96a54a8  refs/pull/2/head
40d9290  refs/pull/3/head
a5d73da  refs/pull/3/merge
```

### 2.1 GATE A.1 expected-commit verification

The GATE A.1 prompt named five commits to verify. **All five are VERIFIED PRESENT on `origin`:**

| Commit | GATE A.1 role | Reality | Class |
|---|---|---|---|
| `9e995a8` | MAIN | `origin/main` HEAD | VERIFIED REMOTE |
| `28f13ee` | recomposition (1/3) | `research/post-dec08-recomposition` — "post-dec08 decision space recomposition" | VERIFIED REMOTE |
| `62048e9` | recomposition (2/3) | same branch — "POST-DEC-08 cross-audit reconciliation" | VERIFIED REMOTE |
| `dd298e1` | recomposition (3/3, HEAD) | same branch — "CHOICE B addenda + CHOICE D STALL probe" | VERIFIED REMOTE |
| `40d9290` | adversarial-audit (HEAD) | `research/post-dec08-adversarial-audit` — "adversarial audit … (NO-MOVE)" | VERIFIED REMOTE |

**Zero MISSING / LOCAL-ONLY / MISMATCH.** The GATE A.1 lineage is faithful to `origin`. (The prompt's
worry — "que un push faltaba" — does not materialize; everything the cells produced is on the remote.)

### 2.2 Author attribution [VERIFIED via `git log`]

- `28f13ee`, `62048e9`, `dd298e1` — author `juan jose polo` (GMT-5), 2026-09-29 14:27–15:41 local.
- `40d9290` — author `Claude`, 2026-09-29 19:40 UTC.

---

## §3. BRANCH LINEAGE MAP (GATE A.1.C)

```
origin/main = 9e995a8   [CANONICAL BASELINE — ARCH-001..009 checkpointed; = this synthesis branch at fork]
│
├── research/post-dec08-recomposition = dd298e1     [3 commits ahead; merge-base = 9e995a8]
│     ├── 28f13ee  POST_DEC-08_DECISION_SPACE_RECOMPOSITION.md      (+597)  [the NO-MOVE artifact]
│     ├── 62048e9  POST_DEC08_CROSS_AUDIT_RECONCILIATION.md         (+774)
│     └── dd298e1  POST_DEC-08_RECOMPOSITION_ADDENDA.md (+363) + X_STALL_SEMANTIC_DIVERGENCE_PROBE.md (+496)
│     TOTAL: 4 files, +2230 lines, all docs/00_SYSTEM/*.md, all Stratum-C non-canonical
│
├── research/post-dec08-adversarial-audit = 40d9290 [1 commit ahead; merge-base = 9e995a8]
│     └── 40d9290  CLOUD_ADVERSARIAL_AUDIT_POST_DEC08.md            (+864)  [PR #3 OPEN → main]
│     TOTAL: 1 file, +864 lines, Stratum-C non-canonical
│
├── claude/happy-bell-tg54h1 = 2e0a69c               [working branch; PRs #1/#2 already merged from it]
│
└── claude/ccp-opus-synthesis-prep-h035ne            [THIS branch; carries docs/00_SYSTEM/OPUS_SYNTHESIS/*]
```

### 3.1 Critical lineage facts

- **Both research branches root directly on `main` (`9e995a8`).** `git merge-base origin/main
  origin/research/post-dec08-{recomposition,adversarial-audit}` = `9e995a8` for both [VERIFIED].
- **The two research branches are GIT-INDEPENDENT.** `git merge-base recomposition audit` = `9e995a8`;
  `--is-ancestor` returns false [VERIFIED]. The adversarial-audit branch does **not** build on the
  recomposition branch — it adds only its one audit file.
- **They are SEMANTICALLY DEPENDENT.** The audit (`40d9290`) reviews the recomposition artifact
  (`28f13ee`) — it obtained the file via cross-branch `git show`, per its §16/§17 attestation. This is
  exactly GATE A.1.C's warning: *git independence ≠ semantic independence.* Any integration must keep
  the audit's reference to the recomposition resolvable.
- **No branch modifies any canonical file.** Every research file is a new `docs/00_SYSTEM/*.md`;
  `git diff --stat main..<branch>` shows only additions [VERIFIED]. `PROJECT_STATE.md`,
  `DECISION_REGISTRY.md`, `DECISION_HISTORY.md`, `AUTHORITY_KIND.md`, `DEFERRAL_INVENTORY.md`,
  `.claude/**`, `evals/**` are untouched on all branches.

### 3.2 Overlapping / duplicated content

- On the recomposition branch, `RECOMPOSITION_ADDENDA.md` (dd298e1) **corrects in-layer** the claims of
  `RECOMPOSITION.md` (28f13ee) — see §5.3. The two must travel together; reading the recomposition
  without the addenda would propagate the superseded "5 ABSORBED" framing.
- `CROSS_AUDIT_RECONCILIATION.md` (62048e9) reconciles the recomposition against the cloud audit and
  reaches the same corrected conclusion the addenda records. No contradictory duplication; it is a
  three-file convergent set (recomposition → reconciliation → addenda) plus one probe.

---

## §4. PR STATUS (GATE A.1.E)

| PR | Head | Base | State | Merged | Note |
|---|---|---|---|---|---|
| #1 | `a3db337` (happy-bell) | `2f55412` | closed | **MERGED 2026-09-28** | DEC-08 Kernel Move 1 |
| #2 | `96a54a8` (happy-bell) | `b09c4e5` | closed | **MERGED 2026-09-29** | session bookkeeping + maintenance log |
| #3 | `40d9290` (adversarial-audit) | `main@9e995a8` | **OPEN** | no | "adversarial audit … (NO-MOVE UNDER-SUPPORTED)"; `refs/pull/3/merge` present ⇒ mergeable |

**Interpretation.** An OPEN PR is **not** integration (GATE A.1.E). PR #3 proposes merging the
adversarial audit into main; it has not merged. The recomposition branch has **no PR**. The DEC-08
canonical work (Kernel) already reached main via PRs #1/#2. **`main` purity holds:** the two research
branches are not on main.

---

## §5. SOURCE-OF-TRUTH PRECEDENCE & CONTRADICTIONS (§5)

Precedence order applied (per synthesis-prompt §5):
`canonical decision > canonical state > decision history > verified evidence > implementation >
analytical artifact > historical snapshot > hypothesis`.

Concretely for CCP:
`DECISION_REGISTRY.md (ARCH-N) > PROJECT_STATE.md > DECISION_HISTORY.md > EVIDENCE_REGISTRY.md >
.claude/** + evals/** > {recomposition, audit, reconciliation, addenda, probe, K3, ROOT_ANALYSIS,
MASTER_HANDOFF, PIECE_AND_IDEA, DECISION_SPACE_PREPARED} > archive/* > NH-11/G-L1 prose`.

### 5.1 Corpus classification (index, not exhaustive re-read)

| Class | Files (representative) | Precedence tier |
|---|---|---|
| CANONICAL | `DECISION_REGISTRY.md`, `PROJECT_STATE.md`, `docs/00_SYSTEM/DECISION_HISTORY.md`, `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`, `ARTIFACT_MANIFEST.md`, `CONTROL_REGISTRY.md`, `REGRESSION_REGISTRY.md`, `INCIDENT_REGISTRY.md`, `docs/00_SYSTEM/AUTHORITY_KIND.md`, `docs/00_SYSTEM/DEFERRAL_POLICY.md`, `docs/00_SYSTEM/DEFERRAL_INVENTORY.md`, `docs/00_SYSTEM/F9_OWNER_DECISIONS.md`, `.claude/**`, `evals/**`, `install.sh`, `CLAUDE.md`, `docs/DESIGN.md`, `docs/MASTER_IMPLEMENTATION_PLAN.md`, `docs/CONTROL_PLANE_HANDBOOK.md` | 1 (contract/state/impl) |
| DERIVED | `.claude/context/CURRENT_STATE.md` (mirror of PROJECT_STATE), `.claude/context/DECISIONS.md` | 2 (mirror; PROJECT_STATE wins) |
| ANALYTICAL | `DEC_08_DECISION_KERNEL.md`, `DEC_02_*.md` chain (6), `PIECE_AND_IDEA_PUZZLE_AUDIT.md`, `DECISION_SPACE_PREPARED.md`, `POST_ARCH-007_*.md`, research-branch files (5), `K3/*`, `docs/00_SYSTEM/ROOT_ANALYSIS/*`, `MAP_COMPLETE.md`, `CCP_*_ATLAS/MAP/ENGINE.md` | 3 (Stratum-C) |
| HISTORICAL | `docs/00_SYSTEM/archive/*`, `DEC-02_D-DELEG_DECISION_GATE.md` (+REVISED/AUDIT variants), `61*_CCP_*` handoff set, `F7_*`, `F8_*`, `F9_RESEARCH.md`, `SESSION_HANDOFF_CURRENT.md`, `MASTER_HANDOFF.md` (snapshot) | 4 (snapshot) |
| CONTEXT | `.claude/context/*`, `.claude/rules/*` | (guidance) |
| MARKET/PRODUCT | `docs/research/*` (teardown, market validation, SAGR, PAC) | (product corpus; out of platform scope per CLAUDE.md split) |
| HYPOTHESIS | NH-11, G-L1 prose (VAGUE triggers) | 5 |

### 5.2 Contradictions found and resolved by precedence

| # | Contradiction | Sources | Resolution by precedence | Confidence |
|---|---|---|---|---|
| C1 | **ARCH-numbering collision.** `docs/DESIGN.md §11` maps `ARCH-001..005` to infra decisions (PROJECT_STATE single-source, context packs, hooks P0, SessionStart matchers, project-scope). `DECISION_REGISTRY.md` maps `ARCH-001..009` to the governance arc (scope, context-load, evidence-path, task-tracking, deferral, auth-boundary, catalog, delegation, instrumentation). The two overlap on IDs 001–005 with **different content**. | DESIGN.md §11 (canonical design doc) vs DECISION_REGISTRY.md (canonical decision registry) | DECISION_REGISTRY is the **single source of decisions** (DESIGN.md §4 says so itself). DESIGN §11 is a *reference/proposal table* ("ID propuesto"), superseded by the registry. **Both are internally consistent; the DESIGN §11 IDs are a naming legacy, not a live conflict — but they read as one.** → Recorded as a Class-C clarity item (see doc 06 EP-C3). | HIGH |
| C2 | **STALL event count.** Recomposition cites 27 @ 2026-09-28 19:15 UTC; cloud audit 33 @ 2026-09-29; reconciliation 34 @ 2026-09-29T04:35; addenda notes 35 after a self-triggered firewall event. | append-only `STALL_POLICY_LOG.jsonl` | Not a contradiction — three+ honest snapshots of an **append-only** log at different times (reconciliation §1.3). Monotonic growth. Lesson: cite an `as-of` stamp (addenda B5). | HIGH |
| C3 | **"5 ABSORBED" vs "6/7 LATENT".** Recomposition (28f13ee) classifies the historical candidate DECs as ABSORBED; the cloud audit, the reconciliation, and the addenda reclassify them as LATENT — no trigger fired. | recomposition vs audit/reconciliation/addenda (all ANALYTICAL) | Within-tier: the **later, adversarially-tested** artifacts (audit + reconciliation + addenda) supersede the first pass; the addenda is an explicit correction layer the recomposition author authored (Owner Q1=YES). **LATENT is the corrected reading.** See doc 02 §4 and doc 05. | HIGH |
| C4 | **Irreducible triad.** `DECISION_SPACE_PREPARED §48`: DEC-02+DEC-04+DEC-05 = "GOVERNED DERIVATION, no son separables." ARCH-008 closed DEC-02 alone. | DECISION_SPACE_PREPARED (ANALYTICAL/HISTORICAL) vs ARCH-008 (CANONICAL) | Canonical wins: ARCH-008's R1+MINIMUM **decoupled** DEC-02 from the pair. §48 is historically stale; corrected structure is binary `{DEC-04 ⋈ DEC-05}`. §48 file is frozen; correction lives in addenda B3. | MODERATE-HIGH |
| C5 | **DEC-01 monolithic framing** inherited across MASTER_HANDOFF §7.1/§13.1, DECISION_SPACE_PREPARED §4.1, PIECE_AND_IDEA §5A without homogeneity attack. | historical analyticals | Resolved canonically by ARCH-007 (SPLIT+DEFER): E1 deferred, E2/E3/E4 RETIRED with RESOLVED_BY. Historical framing superseded. | HIGH |

### 5.3 UNRESOLVED (precedence insufficient)

| # | Item | Why unresolved | Owner-level? |
|---|---|---|---|
| U-B5 | STALL event `task_id="1", stall_type=UNKNOWN, evidence_contract` (2026-09-24T18:05:06Z) origin unidentified by the probe. | No fixture in `evals/` uses `task_id="1"`. | See doc 04 §3 — this synthesis raises a NEW HIGH-plausibility HYPOTHESIS resolving it. |
| U-STRATUM | The "Stratum-C ≠ canonical" boundary is enforced by convention across ARCH-005..009 but has no ARCH-N, no name in DECISION_HISTORY, no falsifier. | It is a live governance invariant never formally decided. | YES — see doc 07 OD-3. |
| U-LATENT-RECORD | The 7 latent historical DECs are **not in `DEFERRAL_INVENTORY`** and have no formal record of their LATENT status or observable predicate. | The recomposition/audit/reconciliation are on unmerged branches; canonical state is silent on them. | YES — see doc 07 OD-1. |

---

## §6. MAIN-PURITY CHECK (GATE A.1.H)

| Check | Result | Evidence |
|---|---|---|
| `git rev-parse origin/main` unchanged by this phase | `9e995a8` (unchanged) | [VERIFIED] |
| Any canonical file modified on any branch touched this phase | NONE | `git diff --stat main..<branch>` additions-only [VERIFIED] |
| This synthesis writes only under `docs/00_SYSTEM/OPUS_SYNTHESIS/` on a research branch | YES | (this file's path) |
| Runtime / hooks / evals / settings touched | NONE | [VERIFIED] |

**MAIN STATUS: UNTOUCHED.** This synthesis phase adds only non-canonical research documents on
`claude/ccp-opus-synthesis-prep-h035ne`. Per synthesis-prompt §36, no merge, no checkpoint, no ARCH-N,
no canonical DEC, no PROJECT_STATE/DECISION_REGISTRY/DEFERRAL_INVENTORY change is performed here.

---

## §7. INTEGRATION READINESS VERDICT (GATE A.1.I)

```
REMOTE BRANCHES FOUND        : main, research/post-dec08-recomposition,
                               research/post-dec08-adversarial-audit, claude/happy-bell-tg54h1,
                               claude/ccp-opus-synthesis-prep-h035ne
REMOTE COMMITS VERIFIED      : 9e995a8, 28f13ee, 62048e9, dd298e1, 40d9290 (5/5)
MISSING / MISMATCHED COMMITS : NONE
BRANCH LINEAGE               : both research branches root on 9e995a8; git-independent; audit
                               semantically reviews recomposition (cross-branch git show)
PR STATUS                    : #1 MERGED, #2 MERGED, #3 OPEN (adversarial-audit → main)
INTEGRATION REHEARSAL RESULT : see doc 08 (INTEGRATION_MANIFEST) — trivial (additive, no canonical
                               collision); recomposition set + addenda must travel together
MERGE CONFLICTS              : NONE expected (distinct new files; no canonical overlap)
SEMANTIC CONFLICTS           : 1 — the recomposition's "5 ABSORBED" record vs the corrected "LATENT"
                               reading. Resolved by keeping addenda + reconciliation alongside.
PROVENANCE RISKS             : LOW if the recomposition's 4-file set is kept intact; the audit's
                               cross-reference to 28f13ee must remain resolvable.
RECOMMENDED INTEGRATION METHOD: see doc 08 — preserve both branches; the analytical value is the
                               full chain, not any single file.
MAIN STATUS                  : UNTOUCHED (9e995a8)

CONCLUSION: INTEGRATION READY (as a non-canonical analytical record), pending Owner framing choice
            OD-1 (how to record the latent set) — but the physical merge is trivial and low-risk.
            The integration is NOT performed here; it is prepared for the terminal Claude (doc 08).
```

---

## §8. ONE-SCREEN TRUTH SUMMARY

- CCP = a **complete, docs-only governance backbone**: ARCH-001..009 closed & checkpointed; F9 gate
  closed; **no open Owner decision; no pending runtime authorization; zero blockers.**
- The only *live* analytical question post-DEC-08 is **how to record the state of the historical
  candidate decisions** — the recomposition said ABSORBED, the adversarial chain corrected to
  **LATENT — no trigger fired**. This is a *bookkeeping/framing* question, **not** a build.
- `main` is pristine at `9e995a8`; all post-DEC-08 analysis lives on two unmerged research branches
  (fully verified on `origin`) plus PR #3 (open).
- The heaviest real risks are **compounding deferral debt** (policy double-representation; analytical
  stack size) — MODERATE, reversible, no runtime commitment. Not a reason to build.

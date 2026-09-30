# 00 — MASTER INDEX (OPUS 4.8 SYNTHESIS)

> **Entry point for the terminal Claude.** Stratum-C synthesis (non-canonical, read-only over canonical
> files). Produced on branch `claude/ccp-opus-synthesis-prep-h035ne`, 2026-09-29, by Claude (analyst, no
> decisor). It reconstructs CCP, reconciles the post-DEC-08 research chain, and prepares — but does not
> perform — integration and execution. **No canonical file was modified. `origin/main` = `9e995a8`,
> untouched.**
>
> Read order for the terminal Claude: **this file → 09_FINAL_SYNTHESIS (§2 terminal handoff) → the doc
> you need.** You do not need to re-read the underlying analytical stack; this synthesis is its index.

---

## §1. ONE-PARAGRAPH TRUTH

CCP is a **complete, closed, docs-only governance backbone**: ARCH-001..009 checkpointed, F9 Owner gate
closed, **zero open decisions, zero pending runtime authorization, zero blockers**, a minimal fully-verified
enforcement surface (maintenance 12/12). The only live analytical question after DEC-08 was *how to record*
the historical candidate decisions; the recomposition said "ABSORBED", and an independent adversarial audit
+ cross-audit reconciliation + Owner-authorized addenda corrected this to **LATENT — no trigger fired**. The
net posture is **NO-MOVE SUSTAINED WITH CONDITIONS**: nothing needs to be built; the executable work is
documentation/integration; all substantive change is Owner-gated and none is forced.

---

## §2. DOCUMENT MAP (where each detail lives)

| Doc | Contains | Read when you need… |
|---|---|---|
| **00_MASTER_INDEX** (this) | entry, one-paragraph truth, the nine-question dashboard | orientation |
| **01_TRUTH_AND_STATE** | GATE A + A.1 forensics; branch lineage; PR status; source-of-truth precedence; 5 contradictions resolved + 3 UNRESOLVED; main-purity | ground truth, git/remote facts |
| **02_DECISION_ARCHITECTURE_LEDGER** | ARCH-001..009 full; F9-D01..D05; retired DECs; **7 LATENT decisions (corrected)**; 2 new latent items; dependency/authority/state graphs | any decision/architecture question |
| **03_PIECE_AND_CAPABILITY_MAP** | 60+ piece inventory; value test; latent-capability discovery; leverage; redundancy/less-but-stronger | what exists, what to keep/merge |
| **04_EXPERIMENTS_AND_PROTOTYPES** | X-STALL (absorbed); **EXP-OPUS-1 (live, resolves B5)**; adversarial tests; X1-X6 proposed | evidence, falsifiers, what to probe next |
| **05_ARCHITECTURE_RECOMPOSITION** | current→target; ideal vs next step; discards revisited; failure analysis; future projection; value/complexity | "what should CCP become" (minimally) |
| **06_EXECUTION_PACKETS** | class A-H; EP-C1/C2/C3/E1 packets; no-blind-spot; P0-P3 priority | what the terminal Claude can DO now |
| **07_OWNER_DECISION_PACKETS** | OD-1..OD-5, closed questions, no forced build | what only the Owner may decide |
| **08_INTEGRATION_MANIFEST** | merge-tree rehearsal (clean); branch classification; integration sequence; PR disposition; must-not-happen | how to integrate the branches |
| **09_FINAL_SYNTHESIS** | §29 statement; §35 terminal handoff; §38 TOP-10s; §37 validation (COMPLETE WITH GAPS) | the capstone + handoff checklist |

---

## §3. THE NINE-QUESTION DASHBOARD (§31)

### WHAT EXISTS
9 canonical decisions (ARCH-001..009, checkpointed) · 5 F9 Owner decisions (closed) · 11 hooks · 5 agents
· 20 skills · 6 context packs · 4 rules · 12 evals · 8 canonical registries · maintenance 12/12 ·
EV-001..016 · REG-001..011 · CTRL-001 · INC-001 (closed) · 14 deferrals/36 triggers (94% observable).

### WHAT IS TRUSTED
Everything in DECISION_REGISTRY / PROJECT_STATE / DECISION_HISTORY / EVIDENCE_REGISTRY (canonical). The
adversarial audit + reconciliation + addenda are trusted ANALYTICAL corrections (HIGH-band). `origin/main`
= `9e995a8` [VERIFIED]. The 5 research commits verified present on origin.

### WHAT IS OPEN
**No canonical decision is open.** 7 LATENT candidate decisions (DEC-03/04/05/07/12/STREAM-CONSUMER/
REVIEWER-VERDICT) — none has a fired trigger; none is in DEFERRAL_INVENTORY. 2 newly-surfaced latent items
(D-TRIGGER-SCHEMA, Stratum-C boundary). 5 Owner framing choices (OD-1..OD-5) — none forces a build.

### WHAT WAS DISCARDED
DEC-06/09/10/13 (retired) · DEC-01-E2/E3/E4 (retired, RESOLVED_BY) · "5 ABSORBED" framing (refuted) ·
"irreducible triad" (stale after ARCH-008 → binary pair {DEC-04 ⋈ DEC-05}) · CAPABILITY as primitive
(NOT PRESENT / NOT REFUTED) · AB2 piece→authority mapping (prohibited by ARCH-006 §6).

### WHAT WAS TESTED
X-STALL (H0 sustained, 0/34 divergence) · EXP-OPUS-1 (CTRL-001 fail-closed, live; resolves B5) ·
adversarial architecture tests H-A..H-F (0/6 core hypotheses falsified) · merge-tree integration rehearsal
(clean, 0 conflicts).

### WHAT IS EXECUTABLE (without a DEC)
EP-C1 integrate research chain (P0) · EP-C2 publish this index (P1) · EP-C3 DESIGN §11 note (P1) ·
EP-E1/X6 confirm B5 (P2). All docs-only/read-only; push-to-main is Owner-gated (git-policy).

### WHAT REQUIRES OWNER
OD-1 (record latent set) · OD-2 (trigger schema) · OD-3 (Stratum-C boundary) · OD-4 (§48 triad note) ·
OD-5 (B5 confirm/accept) · and the opening of ANY latent decision (only on a fired trigger).

### WHAT SHOULD NOT BE TOUCHED
`origin/main` canonical decision files (DECISION_REGISTRY, PROJECT_STATE, DECISION_HISTORY,
DEFERRAL_INVENTORY, AUTHORITY_KIND, F9_OWNER_DECISIONS) · STALL schema / stall-record.sh / any hook / evals
/ runtime · the frozen research artifacts + DECISION_SPACE_PREPARED §48 (correct via addenda/note, not
in place) · ARCH-009 (REOPENING TRIGGERS = NONE). No merge/checkpoint without Owner confirmation.

### WHERE EACH DETAIL LIVES
See §2 document map. Canonical contracts: `DECISION_REGISTRY.md` (ARCH-N), `PROJECT_STATE.md` (state),
`docs/00_SYSTEM/DECISION_HISTORY.md` (learning), `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` (evidence),
`docs/00_SYSTEM/DEFERRAL_INVENTORY.md` (deferrals), `docs/00_SYSTEM/F9_OWNER_DECISIONS.md` (F9 gate).

---

## §4. STATUS & SCOPE

- **Synthesis status:** `COMPLETE WITH GAPS` (doc 09 §4). Gaps declared: absent competitive-analysis
  cache file (possible 8th atom), native Claude Code lifecycle NOT_VERIFIED, B5 origin HYPOTHESIS-HIGH,
  analytical stack indexed-not-re-read.
- **Authority:** this synthesis RECOMMENDS and PREPARES; it does not DECIDE, MERGE, or MODIFY canonical
  state. OWNER DECIDES > AGENT DECIDES.
- **Provenance:** every doc header carries branch + date + author + non-canonical marker. Underlying
  research verified on `origin` (28f13ee, 62048e9, dd298e1, 40d9290) + this branch.
- **Next cell:** CLAUDE TERMINAL — INTEGRATION + EXECUTION (consumes docs 06 + 08 + 09 §2).

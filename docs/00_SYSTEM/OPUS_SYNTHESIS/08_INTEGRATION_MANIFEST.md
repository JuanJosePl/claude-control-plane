# 08 — INTEGRATION MANIFEST

> **Stratum-C synthesis artifact (non-canonical, read-only).** Per synthesis-prompt §28 + GATE A.1.F/G:
> the manifest the terminal Claude consumes to integrate. Includes the integration rehearsal result
> (verified this session via `git merge-tree`). **This synthesis performs NO merge to main** (§36).

---

## §1. INTEGRATION REHEARSAL RESULT (GATE A.1.F/G — verified this session)

`git merge-tree --write-tree origin/main <branch>` [VERIFIED 2026-09-29]:

| Merge | Result | Conflicts | Written tree |
|---|---|---|---|
| main + research/post-dec08-recomposition | **CLEAN** (exit 0) | 0 | `d0fb0f3…` |
| main + research/post-dec08-adversarial-audit | **CLEAN** (exit 0) | 0 | `61ec878…` |

- Recomposition adds 4 disjoint files; audit adds 1 disjoint file; **the two branches share no file**
  (`comm -12` empty). No canonical file is touched by either.
- **Conflict class (GATE A.1.G): TRIVIAL / DOCUMENTARY only.** No PROVENANCE / CANONICAL / SEMANTIC /
  MATERIAL git conflict. The only *semantic* consideration is that the recomposition's "5 ABSORBED"
  record must be read WITH its addenda ("LATENT") — handled by keeping the 4-file set together, not by
  any git operation.

---

## §2. MANIFEST TABLE (§28)

| Branch | Commit | Artifact(s) | Action | Keep/Merge/Archive/Discard | Dependency | Reason | Provenance preserved |
|---|---|---|---|---|---|---|---|
| `research/post-dec08-recomposition` | `dd298e1` | RECOMPOSITION.md, RECOMPOSITION_ADDENDA.md, CROSS_AUDIT_RECONCILIATION.md, X_STALL_SEMANTIC_DIVERGENCE_PROBE.md | integrate as **set** | **MERGE** (non-canonical) | addenda must accompany recomposition; probe supports P1 | finished, Owner-authorized (Q1/Q2) analysis; corrected LATENT reading lives here | YES (headers carry branch+commit+author) |
| `research/post-dec08-adversarial-audit` | `40d9290` | CLOUD_ADVERSARIAL_AUDIT_POST_DEC08.md | integrate | **MERGE** (non-canonical); PR #3 is the vehicle | references recomposition@28f13ee (must stay resolvable) | independent audit; the HIGH-band corrections originate here | YES |
| `claude/ccp-opus-synthesis-prep-h035ne` | (this run) | OPUS_SYNTHESIS/00..09 | integrate | **MERGE** (non-canonical index) | supersedes need to re-read the analytical stack | the single index (EP-C2) | YES |
| `claude/happy-bell-tg54h1` | `2e0a69c` | (working branch; PRs #1/#2 already merged) | none | **ARCHIVE / DELETE-AFTER-PRESERVATION** | — | its canonical content (DEC-08 Kernel) already on main via PR #1/#2 | already on main |
| `origin/main` | `9e995a8` | canonical | **DO-NOT-MERGE-INTO** (protect) | KEEP pristine | — | canonical baseline; only additive non-canonical docs may land, Owner-gated | N/A |

### 2.1 Branch classification (§28)

| Branch | Class |
|---|---|
| research/post-dec08-recomposition | **MERGE** (as a 4-file set) |
| research/post-dec08-adversarial-audit | **MERGE** (via PR #3) |
| claude/ccp-opus-synthesis-prep-h035ne | **MERGE** (the synthesis index) |
| claude/happy-bell-tg54h1 | **ARCHIVE / DELETE-AFTER-PRESERVATION** |
| main | **DO-NOT-MERGE** (target, protect) |

---

## §3. INTEGRATION SEQUENCE (recommended for terminal Claude)

```
STEP 0  git fetch origin --prune                 # reconcile the stale local main ref (doc 01 §1)
STEP 1  Owner confirms OD-1 framing (canonical vs Stratum-C vs leave)   # decides HOW MUCH lands canonically
STEP 2  Integrate the 3 mergeable sources as NON-CANONICAL docs:
          - recomposition 4-file set (keep together)
          - adversarial audit (PR #3)
          - OPUS_SYNTHESIS/00..09
        (merge or cherry-pick; both rehearse clean. Push to main = Owner confirm per git-policy.)
STEP 3  Run: bash evals/maintenance.sh           # expect 12/12
STEP 4  Verify canonical purity:
          git diff <base>..HEAD -- DECISION_REGISTRY.md PROJECT_STATE.md \
            docs/00_SYSTEM/DECISION_HISTORY.md docs/00_SYSTEM/DEFERRAL_INVENTORY.md \
            docs/00_SYSTEM/AUTHORITY_KIND.md docs/00_SYSTEM/F9_OWNER_DECISIONS.md
          → MUST be empty (integration is additive-only unless Owner chose OD-1=A)
STEP 5  IF Owner chose OD-1=A / OD-2 / OD-3 / OD-4=A: apply the corresponding canonical bookkeeping
        under the ARCH-004 docs-only pattern (separate, explicit, checkpointed commit) — this is the
        ONLY step that edits canonical files, and only under an explicit Owner choice.
STEP 6  /checkpoint (only after Owner authorization, per git-policy + synthesis §36).
```

> **Integration principle:** the analytical *value* is the whole chain (recomposition → audit →
> reconciliation → addenda → probe → synthesis), not any single file. Integrate the chain; do not
> cherry-pick a partial view that would resurrect the superseded "ABSORBED" framing without its
> correction.

---

## §4. WHAT MUST NOT HAPPEN DURING INTEGRATION (§36 + artifact attestations)

1. **No canonical-decision edit** without an explicit Owner choice (OD-1..OD-5). Additive non-canonical
   docs only, by default.
2. **No reopening** of any DEC (DEC-08/ARCH-009 has REOPENING TRIGGERS = NONE).
3. **No STALL / hook / runtime / evals change** (F9-D01=A; ARCH-009 non-modification).
4. **No merge to main without Owner confirmation** (git-policy: `git push` = permissions.ask).
5. **No checkpoint** until Owner authorizes (synthesis §36).
6. **Do not "apply" the B1-B5 corrections into canonical files** as part of plain integration — that is
   OD-1=A (Class D), a separate Owner-gated step.
7. **Keep the recomposition 4-file set intact**; keep the audit's `28f13ee` reference resolvable.

---

## §5. PR DISPOSITION

| PR | Disposition |
|---|---|
| #1 (MERGED) | done — DEC-08 Kernel on main |
| #2 (MERGED) | done — session bookkeeping on main |
| #3 (OPEN, adversarial-audit → main) | **Owner decision**: merge as the audit's integration vehicle (STEP 2), or close in favor of a combined research-chain integration. Recommend: merge (it is the audit's clean, single-file delivery) OR fold into a single "integrate post-DEC-08 research chain" commit that includes recomposition + audit + synthesis together. Either preserves provenance. |

---

## §6. POST-INTEGRATION STATE (expected)

```
main (after Owner-gated integration, additive-only default)
  = 9e995a8 + docs/00_SYSTEM/{5 research files} + docs/00_SYSTEM/OPUS_SYNTHESIS/{00..09}
  canonical decision files: UNCHANGED
  maintenance.sh: 12/12
  ARCH-001..009: UNCHANGED, still CHECKPOINTED
  latent decisions: recorded (Stratum-C by default; canonical iff OD-1=A)
STATUS: INTEGRATION READY → INTEGRATED (non-canonical); NO-MOVE preserved.
```

**CONCLUSION (GATE A.1.I):** `INTEGRATION READY`. The physical merge is trivial and low-risk; the only
gates are Owner framing (OD-1) and the git-policy push confirmation. `main` remains untouched by this
synthesis.

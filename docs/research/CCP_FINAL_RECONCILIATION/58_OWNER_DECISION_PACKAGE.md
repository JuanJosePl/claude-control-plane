# 58 — Owner Decision Package

**Date:** 2026-09-23
**Executor:** Claude Sonnet 4.6
**Purpose:** Consolidated owner decision brief for READY-01 through READY-04.
             Each decision is independent; they can be reviewed in any order.
**Context:** F8 COMPLETE / F9 NOT JUSTIFIED / Research Phase COMPLETE.
             No implementation proceeds without explicit owner authorization per F9-D01=A.

---

## Executive Summary

Four decisions are ready for owner review. They are ordered by impact:

| Decision | Question | Type | Complexity | Reversibility |
|---|---|---|---|---|
| READY-01 | Are policy repairs "rule changes" or "doc improvements"? | Classification | None (text only) | HIGH |
| READY-02 | Authorize 2 new regex patterns + normalization in bash-firewall | Implementation | ~15 lines bash | HIGH |
| READY-03 | Accept the residual bypass risk as mitigated for current context | Risk acceptance | Owner statement | HIGH |
| READY-04 | Authorize enhanced denial message format in hooks | Implementation | Output format change | HIGH |

**Minimum viable unlock:** READY-03 alone closes the research agenda (LABYRINTH-1 conditionally).
**Maximum impact:** READY-01 + READY-02 + READY-03 together give minimal L1-C closure.
**Optional quality:** READY-04 improves human resolution quality (not security coverage).

**Nothing currently requires READY-04 or even READY-01/02 for the system to function.**
The current B-path (human review + staging backstop) is operational.

---

## READY-01 — AC-02 Authorization Decision

```
DECISION ID:     READY-01
QUESTION:        Do the 4 proposed policy text additions (1-2 sentences each to
                 .claude/rules/*.md files) constitute a "rule change" prohibited by
                 F9-D01=A, or a "documentation improvement" permitted by F9-D01=A?

NOTE (MOVEMENT 006 adversarial audit):
  These repairs are NOT uniformly "documentation-only." Specifically:
  - POL-08 repair adds an explicit exception for F9-D01=A owner gates
    (new permission for already-authorized action; harmonizes two policies)
  - POL-10 repair adds a prohibition on denormalized consent fields (new constraint)
  - POL-13 repair converts an open-ended prefix list to an exclusive enumeration (new constraint)
  - POL-05 repair makes implicit isolation requirement explicit (primarily clarification)
  All changes are more restrictive or harmonizing; none weaken existing prohibitions.
  The owner must decide whether these targeted constraint additions constitute a "rule change."

CURRENT STATE:
  4 policies are PARTIAL: POL-05, POL-08, POL-10, POL-13.
  PARTIAL policies produce UNKNOWN outputs from R-3 where EXPLICIT policies produce SAFE.
  This means the system defaults to BLOCKED more often than necessary for these cases.
  F9-D01=A (2026-09-20): prohibits rule changes without new authorization.
  The prohibition's scope is ambiguous for text additions that don't change intent.

WHY IT MATTERS:
  If YES (documentation improvement): implement immediately; no further gate needed.
  If NO (rule change): owner must separately authorize AC-02 as a rule change.
  Either answer is valid; the question is classification, not permission.
  LABYRINTH-1 Condition 2 cannot be satisfied without this classification.

SUPPORTING EVIDENCE:
  CDT-01 (55_CDT01_NH02_RESULTS.md §1): 87.5% SAFE rate with repaired policies
    (EXPERIMENTAL — synthetic corpus, not production)
  56_MOVEMENT_003 §7: adversarial validation; repairs tested against 5 cases each
  Repair texts fully specified: 55_CDT01_NH02_RESULTS.md §1.3 (copy-paste ready)
  Risk: repairs are MORE restrictive interpretations, not MORE permissive

WHAT CHANGES:
  4 text additions to 4 .claude/rules/*.md files (8 sentences total)
  Policy semantic intent: UNCHANGED (same constraints, made explicit)
  Enforcement (hooks, settings.json): UNCHANGED

WHAT DOES NOT CHANGE:
  Any existing constraint or prohibition
  Runtime behavior
  Hook logic

RISK:      LOW — repairs add specificity to existing prohibitions, not exceptions
REVERSIBILITY: HIGH — git revert removes all 4 additions atomically

DEPENDENCIES: None; independent of READY-02 and READY-03

IF YES (documentation improvement):
  → Implement immediately under current authorization
  → LABYRINTH-1 Condition 2 satisfied
  → R-3 SAFE rate improves from ~75% to ~87.5% (experimental baseline)

IF NO (rule change):
  → Owner may separately authorize AC-02 as an explicit rule change authorization
  → Policies remain PARTIAL; UNKNOWN outputs persist for those 4 cases
  → Minimum workaround: keep repair texts as "guidance documents" separate from rules

REACTIVATION: If new PARTIAL policies emerge requiring disambiguation
```

---

## READY-02 — NH-02 Pattern + Level-1 Normalization Authorization

```
DECISION ID:     READY-02
QUESTION:        Authorize adding regex patterns P1' and P2' plus Level-1 normalization
                 (NH-09: 2 sed lines) to bash-firewall.sh.
                 Scope: P1' + P2' only. P3 explicitly DEFERRED (MEDIUM FP risk).
                 Package: READY-02 = P1' + P2' + Level-1 normalization together.

CURRENT STATE:
  bash-firewall.sh has Level-0 patterns (named literals, Bearer, AKIA, .env reads).
  Current gaps: printenv with named secret args; encoding pipelines; ${VAR}/quoted variants.
  F9-D01=A prohibits hook changes.

WHY IT MATTERS:
  Currently, `printenv ANTHROPIC_API_KEY` (with the var name, not value) is NOT blocked.
  Currently, `echo $ANTHROPIC_API_KEY | base64` is blocked via existing literal patterns,
  but `echo ${ANTHROPIC_API_KEY} | base64` BYPASSES the firewall.
  P1' + P2' + Level-1 normalization close these highest-risk syntactic gaps.
  LABYRINTH-1 Condition 1 cannot be satisfied without this authorization.

SUPPORTING EVIDENCE:
  NH-02 (55_CDT01_NH02_RESULTS.md §2): bypass gap characterization
  NH-04 corpus (56_MOVEMENT_003 §3): P1'+P2' catch C01/C02/C03/C13/C15 with LOW FP
  NH-09 (57_MOVEMENT_004 §3.4): 2 sed lines achieve same coverage; zero dependencies
  58A_NH09_SEMANTIC_VALIDATION.md: 20-case corpus; SAFE_NORMALIZATION verdict;
    4 documented limitations (all outside target attack surface)

WHAT CHANGES:
  bash-firewall.sh:
    + 2 sed pre-processing lines (NH-09 normalization)
    + 2 new REGEX array entries (P1', P2')
  Total: ~6 new lines; all within existing fail-closed hook structure

WHAT DOES NOT CHANGE:
  All existing patterns (preserved exactly)
  Exit codes and block signaling (exit 2; unchanged)
  STALL_POLICY_LOG logging (still called)
  settings.json permissions (unchanged)

RISK:      LOW-MEDIUM
  P1' and P2': LOW FP profile (see 56_MOVEMENT_003 §3.4)
  Level-1 normalization: SAFE_NORMALIZATION (see 58A §5)
  P3 explicitly NOT in scope (deferred due to MEDIUM FP; add later if needed)
REVERSIBILITY: HIGH — remove the ~6 added lines; git revert

DEPENDENCIES: READY-01 not required; independent decision

RECOMMENDED IMPLEMENTATION: Include Level-1 normalization (NH-09) in same change
  Why: zero cost; same authorization gate; closes ${VAR} and quoted variants simultaneously

IF YES:
  → `printenv NAMED_SECRET` blocked automatically
  → `echo ${SECRET} | base64` and quoted variants blocked
  → LABYRINTH-1 Condition 1 satisfied
  → Level-1 (Minimal Security Stack Layer 1+2) operational

IF NO:
  → Bypass classes remain unblocked at automation level
  → B path (human review + staging) remains sole mitigation
  → Syntactic gap remains documented; reopen when threat model changes

FUTURE: After P3 FP testing, add P3 with allowlist in separate authorization
```

---

## READY-03 — LABYRINTH-1 L1-C Closure (Risk Acceptance)

```
DECISION ID:     READY-03
QUESTION:        Accept the L1-C formulation as LABYRINTH-1 resolution criteria by
                 making the following five explicit statements:
                 (a) The residual bypass classes (variable aliasing, heredoc body,
                     numbered redirects, file-based interpreter calls, and
                     reasoning-mediated bypass) are accepted for CCP's current
                     development context.
                 (b) Mitigation for the residual: human review (B path) + git staging
                     backstop + escalation path (NH-10 / handbook §12 for
                     reasoning-mediated cases).
                 (c) This acceptance is conditioned on H-01 remaining below N.
                     N = [OWNER MUST DEFINE — e.g., "N=1: any real bypass event reopens
                     LABYRINTH-1"]. Without a defined N, reactivation trigger-1 is
                     non-operational.
                 (d) LABYRINTH-1 is not "solved" in the absolute sense; it is "resolved
                     for current context" under L1-C. This acceptance does NOT claim
                     that bypass risk is zero, low, or quantified.
                 (e) H-01 materiality remains UNRESOLVED. This acceptance is made under
                     acknowledged uncertainty about real bypass frequency.

REQUIRED OWNER INPUT (in addition to YES/NO):
  N = _____ (threshold for H-01 reactivation trigger; examples: 1, 5, "any real event")

CURRENT STATE:
  LABYRINTH-1 is OPEN. No owner has accepted the residual risk.
  5 closure conditions specified (57_MOVEMENT_004 §9).
  Condition 3 is NOW SATISFIED (NH-10 handbook — this session).
  Conditions 1, 2, 4, 5 require authorizations or owner statements.
  This decision satisfies Conditions 4 AND 5 (Option B) simultaneously.

WHY IT MATTERS:
  Without explicit owner acceptance, LABYRINTH-1 remains permanently OPEN regardless
  of incremental improvements. This creates ongoing research overhead without clear
  closure criteria.
  This decision closes the research agenda for LABYRINTH-1 (conditionally).
  It does NOT require implementing anything; it is a documentation commitment only.

SUPPORTING EVIDENCE:
  Residual risk characterization: 57_MOVEMENT_004 §8 (full bypass table)
  CCP Minimal Security Stack: 57_MOVEMENT_004 §6.2 (current mitigation coverage)
  Reactivation triggers: 57_MOVEMENT_004 §9.3 (4 named reopening conditions)
  Materiality: H-01 = 0 real events (1 test event; STALL_POLICY_LOG)
  Materiality discipline: "0 observed events ≠ 0 risk; materiality unresolved"

WHAT CHANGES:
  LABYRINTH-1 status: OPEN → CONDITIONALLY_CLOSED (L1-C, pending H-01)
  Research agenda: stops active LABYRINTH-1 investigation unless a trigger fires
  AC-03 roadmap: remains available but dormant (reactivatable via TRIGGER-4)

WHAT DOES NOT CHANGE:
  Security posture (B path remains active)
  Hook enforcement behavior
  Any existing bypass residual (it still exists; this is acceptance, not elimination)

RISK:      UNKNOWN (H-01 materiality unresolved; bypass frequency not measurable from
           synthetic data). Bounded by 4 explicit reactivation triggers + defined N
           threshold (57_MOVEMENT_004 §9.3). Development context inference: low practical
           exposure. This is NOT a quantified risk estimate.
REVERSIBILITY: HIGH — owner can reopen with a single statement

DEPENDENCIES:
  READY-01 and READY-02 satisfy Conditions 1 and 2.
  HOWEVER: Owner can accept L1-C even without READY-01/02, accepting B-path-only mitigation.
  In that case, Conditions 1 and 2 remain unsatisfied and the "conditional closure"
  is under a weaker security baseline (B path only; automation gaps persist).

IF YES (L1-C accepted):
  → LABYRINTH-1 → CONDITIONALLY_CLOSED (L1-C)
  → Conditions 4 + 5 satisfied; L1-C minimal requires only READY-01 + READY-02 additionally
  → Research focus shifts: monitor H-01; implement improvements when authorized
  → AC-03 dormant; reactivatable via TRIGGER-4

IF NO:
  → LABYRINTH-1 remains OPEN
  → Define: what evidence would constitute "sufficient" for future closure?
  → Active research status maintained for LABYRINTH-1

REACTIVATION: Any of the 4 triggers from 57_MOVEMENT_004 §9.3
```

---

## READY-04 — Enhanced-B Denial Message Authorization

```
DECISION ID:     READY-04
QUESTION:        Authorize modifying bash-firewall.sh and task-completed-evidence.sh
                 to output the structured denial message format specified in
                 57_MOVEMENT_004 §5.1.

PRIORITY:        LOWER than READY-01/02/03 — this is a quality improvement,
                 not a security coverage change.

CURRENT STATE:
  Current denial messages are minimal (hook name + reason code + command).
  Human reviewers receive insufficient context to decide on blocked actions.
  STA-02 failure mode: human cannot determine what was blocked, why, or what to do next.
  Enhanced-B format specification is fully defined (57_MOVEMENT_004 §5.1).
  F9-D01=A prohibits hook changes.

WHY IT MATTERS:
  Blocked actions require human review. Better context → faster resolution.
  NH-10 now references "enhanced denial message (NH-07 format when implemented)".
  READY-04 implements the NH-07 format referenced by NH-10.

SUPPORTING EVIDENCE:
  STA-02 analysis: 57_MOVEMENT_004 §5.2 (4 scenarios; HIGH resolution quality with Enhanced-B)
  Information vs. judgment gap analysis: 57_MOVEMENT_004 §5.3
  NH-07 classification: SUPPORTED for information-gap cases

WHAT CHANGES:
  bash-firewall.sh: enhanced stderr output format (no logic change)
  task-completed-evidence.sh: enhanced stderr output (no logic change)
  Output: additional structured fields (policy_id, prohibited_outcome, next_action, escalation_path_reference)

WHAT DOES NOT CHANGE:
  Block/allow logic (exit codes unchanged)
  STALL_POLICY_LOG schema (structured evidence unchanged)
  Any enforcement behavior

RISK:      LOW — output format only; no enforcement logic change
REVERSIBILITY: HIGH

DEPENDENCY: NH-10 (escalation path reference) — NOW SATISFIED (this session)
             READY-04 can now be implemented referencing §12 of handbook.

IF YES:
  → Human resolution quality for STA-02 improves significantly
  → "Ruta de escalación" field references NH-10 §12 of handbook

IF NO:
  → Current minimal message persists
  → B path functional but with more human friction at resolution time

REACTIVATION: Anytime improvement to human review efficiency is desired
```

---

## Decision Minimization Analysis (§9 of mandate)

### Independence Map

```
READY-01 ← INDEPENDENT
READY-02 ← INDEPENDENT of READY-01 (can implement patterns without policy repairs)
READY-03 ← INDEPENDENT of READY-01/02 (can accept residual without implementing anything)
READY-04 ← DEPENDENT on NH-10 (now satisfied); INDEPENDENT of READY-01/02/03

Dependency chain:
  READY-01 → enables L1-C Condition 2 (policy quality)
  READY-02 → enables L1-C Condition 1 (detection coverage) [NH-09 bundled]
  READY-03 → enables L1-C Conditions 4+5 (risk acceptance + empirical basis)
  READY-04 → improves human review quality (quality, not coverage)
```

### Minimum Authorization for Maximum Value

```
SCENARIO A — Research closure only (minimum viable):
  Decision: READY-03 alone
  Unlocks: LABYRINTH-1 CONDITIONALLY_CLOSED; research overhead stops
  Requires: owner statement (no code change)
  Security residual: unchanged; B-path only

SCENARIO B — Policy + closure (documentation-only path):
  Decisions: READY-01 + READY-03
  Unlocks: policy quality improved; L1-C Conditions 2+3+4+5 satisfied
  Requires: 2 decisions; 4 text additions to rule files (if READY-01=YES)
  Security residual: syntactic gaps still unblocked

SCENARIO C — Full minimal L1-C closure (recommended):
  Decisions: READY-01 + READY-02 + READY-03
  Unlocks: all 5 L1-C conditions satisfied; minimal L1-C closure achieved
  Requires: 3 decisions; ~6 lines bash + 4 rule-file text additions
  Security residual: aliasing/heredoc/file-scripts → B-path (accepted in READY-03)

SCENARIO D — Strong L1-C closure (complete):
  Decisions: READY-01 + READY-02 + READY-03 + READY-04
  Unlocks: all conditions + enhanced human review quality
  Requires: 4 decisions
```

---

## L1-C Condition Status After MOVEMENT 005

```
Condition 1 — P1'+P2' patterns (READY-02):    NOT SATISFIED
Condition 2 — AC-02 policy repairs (READY-01): NOT SATISFIED
Condition 3 — Escalation path (NH-10):         SATISFIED ← this session
Condition 4 — Owner risk acceptance (READY-03): NOT SATISFIED
Condition 5 — Empirical baseline (H-01/owner): NOT SATISFIED

L1-C minimal: 1/5 conditions satisfied
L1-C reachable with 3 owner decisions: READY-01 + READY-02 + READY-03
```

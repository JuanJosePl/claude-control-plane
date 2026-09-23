# 59 — Pre-Authorization Adversarial Gate

**Date:** 2026-09-23
**Executor:** Claude Sonnet 4.6
**Movement:** 006
**Purpose:** Attempt to break READY-01/02/03/04 before owner authorization.
             Apply: ASSUME WRONG → TRY TO BREAK → VERIFY → RECLASSIFY → PREPARE.
**Authorization:** Read-only analysis. No runtime, hook, rule, or registry change.
**Claim discipline:** DOCUMENTED_FACT / EXPERIMENTAL_RESULT / DESIGN_RESULT / INFERENCE throughout.
**Source files read:** PROJECT_STATE.md, CCP_EXPLORATION_ENGINE.md §1-3,
  58_OWNER_DECISION_PACKAGE.md, 58A_NH09_SEMANTIC_VALIDATION.md,
  57_MOVEMENT_004_FRONTIER_INTEGRATION.md, 56_MOVEMENT_003_MASTER_FRONTIER_CLOSURE.md §7,
  docs/CONTROL_PLANE_HANDBOOK.md §12, docs/00_SYSTEM/F9_OWNER_DECISIONS.md,
  .claude/hooks/bash-firewall.sh, .claude/rules/*.md (all four).

---

## §1 — Executive Position

### GATE RESULT: CONDITIONAL PASS

The READY-01/02/03/04 decision package **PASSES** the adversarial gate with **four required fixes**
before owner presentation and **one state machine inconsistency** to correct:

```
FINDING A (HIGH — READY-01):
  READY-01 cannot be uniformly described as "documentation-only."
  POL-08 repair adds a new explicit exception; POL-10 and POL-13 repairs add new
  constraints not present in the original text.
  REQUIRED FIX: READY-01 question must acknowledge this explicitly.

FINDING B (MEDIUM — READY-03):
  READY-03 references "owner-defined N" threshold but N is never defined anywhere.
  Without N, the reactivation trigger "H-01 exceeds N" is non-operational.
  REQUIRED FIX: Owner must define N as part of accepting READY-03.
  Add a required input field to the decision document.

FINDING C (LOW — READY-03):
  RISK classification "MEDIUM" is overconfident given H-01 materiality = UNRESOLVED.
  "MEDIUM" implies a quantitative risk level. The correct classification is UNKNOWN.
  REQUIRED FIX: Change "RISK: MEDIUM" to "RISK: UNKNOWN (H-01 materiality unresolved)."

FINDING D (LOW — READY-02):
  READY-02 architectural note missing: P1'/P2' patterns will use COMMAND_NORM
  while existing patterns use COMMAND. This dual-variable architecture is not
  documented in the decision package.
  REQUIRED FIX: Add one-line note to READY-02 implementation description.

FINDING E (ADMIN — EXPLORATION ENGINE):
  CCP_EXPLORATION_ENGINE.md §3 has a dangling OPEN entry for UNK-M4-01 that
  contradicts the CLOSED entry added in MOVEMENT 005. Must be cleaned.
```

### Answers to the 12 mandate questions (summary, full answers in §15):

1. **Material technical objection?** YES — Finding A (READY-01 misclassification) is material.
2. **High-value research that changes decisions?** NO — all blocking unknowns require real usage.
3. **UNKNOWN that matters before owner?** YES — N threshold (Finding B) must be resolved at acceptance time.
4. **Hidden dependency?** YES — N-definition dependency (B) and NH-09 INVARIANT maintenance dependency (D).
5. **Misclassified decision?** YES — READY-01 scope understated; READY-03 risk label overclaims.
6. **Documentary change actually modifies behavior?** POL-08 and POL-13 repairs are borderline (new constraints/exceptions). Must be stated explicitly.
7. **Implementation plan sufficiently prepared?** YES (with noted gaps for exact P1'/P2' regex from 55_ and N definition).
8. **YES/NO branch consequences?** Fully determined — see §14.
9. **What does owner need?** 4 binary decisions + N definition for READY-03.
10. **What needs real usage?** H-01 materiality; pattern FP rate; bypass frequency.
11. **True frontier?** Owner decision gate → N definition → monitoring H-01.
12. **Next movement that changes the map?** Owner accepting READY-03 (closes research agenda regardless of READY-01/02).

---

## §2 — State Audit (Baseline)

```
PHASE:                8 COMPLETE / FROZEN
F9:                   RESEARCH COMPLETE + OWNER GATE CLOSED (F9-D01=A)
READY-01:             OWNER_DECISION_READY (not AUTHORIZED)
READY-02:             OWNER_DECISION_READY (not AUTHORIZED)
READY-03:             OWNER_DECISION_READY (not AUTHORIZED)
READY-04:             OWNER_DECISION_READY (not AUTHORIZED)
LABYRINTH-1:          OPEN (0 of 5 L1-C conditions satisfy; Condition 3 SATISFIED)
                      Correction: 1 of 5 conditions SATISFIED (Condition 3 = escalation path).
H-01:                 1 test event; 0 real events; materiality UNRESOLVED
NH-09 INVARIANT:      CONFIRMED (design analysis)
UNK-M4-01:            RESOLVED (58A §5; MOVEMENT 005)
CONFLICT-04:          RESOLVED (NH-10; MOVEMENT 005)
L1-C Condition 3:     SATISFIED (NH-10 handbook §12)
bash-firewall.sh:     Layer 0 only; NH-09 and P1'/P2' NOT in current code
IMPLEMENTATION_READY: false
```

**Authorization fence currently in effect:** F9-D01=A prohibits runtime, hook, rule, agent,
fixture, or registry changes without explicit owner authorization. This is the binding constraint
for READY-02 and READY-04.

---

## §3 — READY-01 Adversarial Audit

### 3.1 Decision Package Claim

READY-01 asks whether 4 text additions to `.claude/rules/*.md` constitute "rule change"
(prohibited by F9-D01=A) or "documentation improvement" (permitted by F9-D01=A).
The package claims the repairs "do not change the intent."

### 3.2 Per-Repair Semantic Scope Analysis

**POL-05 (security.md) — Data Isolation**

Original: "Aislamiento de datos en cada query (tenant_id, RLS, o el mecanismo que definas en SECURITY_RULES.md)."

Repair: "Default isolation field = tenant_id; override requires explicit SECURITY_RULES.md declaration; prohibited: cross-tenant queries; non-tenant tables must be documented."

```
Semantic change analysis:
  new constraint:      "override requires explicit SECURITY_RULES.md declaration"
                       → Original allowed any mechanism; repair requires opt-out documentation
  new prohibition:     "prohibited: cross-tenant queries"
                       → Original implied isolation but did not EXPLICITLY prohibit cross-tenant
  new requirement:     "non-tenant tables must be documented"
                       → Original did not require documentation of exceptions

CLASSIFICATION: More restrictive than original. Intent unchanged (isolation), but scope
  is new (explicit prohibition + documentation requirement).
  CATEGORY: RULE_CLARIFICATION_WITH_NEW_CONSTRAINT (not purely documental; not a rule reversal)

REGRESSION TEST:
  Positive case: SELECT * FROM orders WHERE tenant_id=? → SAFE (before and after)
  Negative case: SELECT * FROM orders (no tenant filter) → UNSAFE after repair, UNKNOWN before
  Boundary: SELECT * FROM shared_products (non-tenant table) → UNKNOWN, now requires documentation
  Adversarial: COUNT(*) aggregate → UNKNOWN after repair (overconstraint risk; no aggregate exception)
  Regression: Could make previously-UNKNOWN aggregates UNSAFE without explicit exception
```

**POL-08 (no-go.md) — No Bottleneck**

Original: "NO convertir a una sola persona en cuello de botella operativo."

Repair: "Bottleneck = exclusive + no documented fallback; F9-D01 gates explicitly excepted as intentional temporary gates."

```
Semantic change analysis:
  new definition:      "Bottleneck = exclusive + no documented fallback"
                       → Narrows from vague "bottleneck" to specific operational criteria
  NEW EXCEPTION:       "F9-D01 gates explicitly excepted"
                       → This is a NEW PERMISSION: F9-D01=A gates (where owner IS the only
                         approver) were previously prohibited by POL-08. The repair excepts them.

CRITICAL FINDING: The exception "F9-D01 gates excepted" is NOT purely clarificatory.
  It grants a permission that the original text prohibited (implicitly).
  F9-D01=A IS a single-person gate. Without this exception, POL-08 and F9-D01=A conflict.
  The repair resolves the conflict by adding an exception.
  CLASSIFICATION: RULE_CHANGE_WITH_NEW_EXCEPTION

ADDITIONAL GAP: The repair doesn't require that "documented fallback" be a DIFFERENT person.
  "Alice is documented as Alice's fallback" would satisfy the literal repair text.
  This is a residual underconstraint.

REGRESSION TEST:
  Positive case: 2-person approval (primary + backup documented) → SAFE
  Negative case: Alice sole approver, no backup → UNSAFE
  Boundary: F9-D01=A owner gate → SAFE (after repair; UNSAFE or UNKNOWN before)
  Adversarial: Alice is backup for herself → ALLOWED (gap in repair)
  Regression: Any case classified UNSAFE under original POL-08 due to owner gate → now SAFE
```

**POL-10 (compliance.md) — consent_records**

Original: "`consent_records` = tabla de primera clase (opt-in con timestamp/canal/finalidad)."

Repair: "Independent table with 3 first-class criteria: (a) separate namespace, (b) independently queryable, (c) authoritative source."

```
Semantic change analysis:
  new specification:   3 specific criteria replace vague "primera clase"
  new prohibition:     Denormalized consent fields now prohibited (E10-ADVERSARIAL case)
  new ambiguity:       "separate namespace" undefined — same DB? different schema? microservice?

CLASSIFICATION: RULE_CLARIFICATION_WITH_NEW_PROHIBITION (denormalization now explicitly prohibited)
  Original "tabla de primera clase" could plausibly include a view, a column, or a denormalized
  cache. The repair explicitly prohibits this.

REGRESSION TEST:
  Positive case: consent_records in own table → SAFE
  Negative case: users.opt_in_cache BOOLEAN → UNSAFE after repair (unclear before)
  Boundary: consent_records in same schema as users, isolated logically → UNKNOWN (namespace undefined)
  Adversarial: consent_records in a JSON field of a meta table → UNSAFE after repair
  Regression: Architectures with "logical first-class" but not "physical separation" → now UNKNOWN
```

**POL-13 (git-policy.md) — Commit Prefix**

Original: "Commits con prefijo de fase o tipo: [FASE-N] [TIPO]: descripción (feat, fix, docs, arch, decision, security, infra, config). Control plane usa [CONFIG]."

Repair: "Adds RESEARCH, CONFIG to enumerated set; adds decision rule for mixed-work commits; 'prohibited outside enumerated set'."

```
Semantic change analysis:
  Original: List of examples (may be read as non-exhaustive)
  Repair: IF "prohibited outside enumerated set" is added → converts open list to EXCLUSIVE set
           Any commit prefix not in {feat, fix, docs, arch, decision, security, infra, config,
           RESEARCH, CONFIG} becomes PROHIBITED.
  new ambiguity: Repair adds RESEARCH (uppercase) and CONFIG (uppercase) but original types
                 are lowercase. This creates case inconsistency.

CLASSIFICATION: RULE_CHANGE_WITH_NEW_CONSTRAINT (if repair adds "prohibited outside set")
  The repair converts an example list to an exclusive enumeration.

REGRESSION TEST:
  Positive case: [RESEARCH]: finding → SAFE after repair
  Negative case: No prefix → UNSAFE (before and after)
  Boundary: [FASE-8] [docs]: ... (compound) → UNKNOWN (repair doesn't address compound forms)
  Adversarial: [CONFIG]: EVERY commit → ALLOWED (no frequency constraint)
  Regression: Commits with creative prefixes not in enumerated list → now PROHIBITED
```

### 3.3 READY-01 Adversarial Verdict

```
CLAIM IN READY-01: "Policy semantic intent: UNCHANGED (same constraints, made explicit)"

ADVERSARIAL FINDING: This claim is OVERSTATED for 3 of 4 repairs.

POL-05: Primarily clarificatory; adds documentation requirement. BORDERLINE.
         Direction: more restrictive. Risk: LOW.
POL-08: Adds explicit EXCEPTION for owner gates. NEW PERMISSION.
         This is a scope change, not clarification. The original POL-08 implicitly prohibited
         F9-D01=A-style gates. The repair explicitly permits them.
         However: F9-D01=A was already authorized independently. The repair harmonizes two
         policies; it does not grant any new capability.
         Direction: creates new permission for already-authorized action. Risk: LOW.
POL-10: Adds explicit prohibition on denormalization. NEW CONSTRAINT.
         Direction: more restrictive. Risk: LOW (more restrictive = safer direction).
POL-13: Converts open list to exclusive enumeration. NEW CONSTRAINT.
         Direction: more restrictive. Risk: LOW.

NET ASSESSMENT:
  - NO repair makes the policy MORE PERMISSIVE for the real security controls
  - POL-08 adds an exception but ONLY for already-authorized (F9-D01=A) gates
  - ALL repairs are more specific; NONE are reversals or weakenings
  - NONE introduce false negatives for security-critical cases

REQUIRED RECLASSIFICATION:
  READY-01 should NOT be presented as "purely documentation-only."
  Correct framing: "Text additions that make implicit constraints explicit AND add one
  exception (POL-08) for existing authorized gates. Net direction: more restrictive.
  No existing SAFE case becomes UNSAFE or UNKNOWN. Some previously UNKNOWN cases
  become UNSAFE (consistent with policy intent)."

OWNER QUESTION REFINEMENT:
  From: "Are these a 'rule change' or 'documentation improvement'?"
  To: "Are text additions that (a) make implicit constraints explicit, (b) add one
  exception for already-authorized gates, and (c) convert an open list to an exclusive
  enumeration — permitted under F9-D01=A as 'documentation improvement,' or do
  items (b) and (c) constitute rule changes requiring separate authorization?"

DOES THIS BREAK READY-01? NO — the decision is still valid and valuable. But the owner
  must know that "documentation improvement" is a simplification.
```

---

## §4 — READY-02 Adversarial Audit

### 4.1 Coverage Analysis

P1' and P2' target:
- P1': `printenv` with named secret arguments (M1.3 bypass class)
- P2': `echo $SECRET | encoding_pipeline` (M2.1 bypass class)
- NH-09 Level-1 normalization: normalizes `"SECRET"` → `SECRET` and `${SECRET}` → `$SECRET`

**Coverage with P1'+P2'+NH-09:**

| Bypass class | Before READY-02 | After READY-02 | Gap remaining |
|---|---|---|---|
| `printenv ANTHROPIC_API_KEY` | NOT caught | CAUGHT (P1') | None |
| `printenv "ANTHROPIC_API_KEY"` | NOT caught | CAUGHT (P1' via NH-09) | None |
| `echo $SECRET \| base64` | PARTIAL (depends on literal) | CAUGHT (P2') | None for named secrets |
| `echo ${SECRET} \| base64` | NOT caught | CAUGHT (P2' via NH-09) | None |
| `echo "SECRET_VALUE" \| base64` | Depends on existing patterns | IMPROVES (NH-09) | Literal value exposed |
| `printenv 'ANTHROPIC_API_KEY'` | NOT caught | NOT caught (NH-09 doesn't normalize single quotes) | L4 limitation |
| `A=$SECRET; echo $A \| base64` | NOT caught | NOT caught (aliasing) | Accepted residual |
| `heredoc body` | NOT caught | NOT caught | Accepted residual |
| Numbered redirects | NOT caught | NOT caught | Accepted residual |
| File-based interpreter | NOT caught | NOT caught | Accepted residual |

**False positive analysis:**

| Command | Expected behavior | P1' result | P2' result |
|---|---|---|---|
| `printenv PATH` | Legitimate | NO MATCH (no secret keyword) | N/A |
| `printenv DEBUG_TOKEN` | Ambiguous — depends on naming | MATCH if pattern includes TOKEN | May FP |
| `echo $HOME \| wc -c` | Legitimate | N/A | NO MATCH (HOME not in secret pattern) |
| `echo $SECRET_MANAGER_HOST` | Legitimate (hostname var) | VARIES by P2' specificity | FP risk |

**FP RISK ASSESSMENT (DESIGN_RESULT):**
LOW for P1' (requires `printenv` + secret-keyword-named variable).
LOW-to-MEDIUM for P2' if the secret-name pattern is too broad.
The exact regex specificity determines the FP rate. This requires the exact P1'/P2' specification
from 55_CDT01_NH02_RESULTS.md §1.3 (not fully read in this session).

### 4.2 NH-09 Safety Reassessment (Independent Verification)

**Variable lifecycle trace in bash-firewall.sh:**

```
STEP 1: INPUT = read from stdin (mktemp file)
STEP 2: COMMAND = jq -r '.tool_input.command' from INPUT
STEP 3: [PROPOSED] COMMAND_NORM = sed transformations on COMMAND
STEP 4: Existing patterns test against COMMAND (unchanged)
STEP 5: [PROPOSED] P1'/P2' test against COMMAND_NORM
STEP 6: block() called if any pattern matches → exit 2
STEP 7: exit 0 if no pattern matches

COMMAND_NORM EXECUTION PATH:
  Search for any eval/exec/bash -c/sh -c using COMMAND_NORM: NONE IN PROPOSED DESIGN
  Search for any assignment that could re-evaluate COMMAND_NORM: NONE IN PROPOSED DESIGN
  The hook's execution model: READ → NORMALIZE → MATCH → REPORT → EXIT
  COMMAND_NORM is used ONLY in grep -qE pattern matching (step 5)
  The original COMMAND (not COMMAND_NORM) is executed by the shell that invoked the hook
```

**INVARIANT STATUS: CONFIRMED (design analysis)**

Conditions for CONFIRMED:
1. `COMMAND_NORM` is never passed to `eval`, `bash -c`, `sh -c`, `exec`, or any execution primitive. ✓
2. `COMMAND_NORM` is never written to a file that is subsequently sourced or executed. ✓
3. `COMMAND_NORM` is used exclusively in `printf '%s' "$COMMAND_NORM" | grep -qE` for pattern matching. ✓
4. The shell that executes user commands is NOT the hook process; it invokes the hook via a Pre-ToolUse
   callback and receives exit 0/2 as the allow/deny signal. ✓

**Critical caveat for future maintainers:** The INVARIANT is a design property, not a structural
enforcement. If future hook modifications add `eval "$COMMAND_NORM"` or equivalent, the invariant
breaks and the PARTIALLY_SAFE cases from 58A (${VAR:-default}, escaped quotes, etc.) become
actual semantic hazards. This dependency should be documented.

```
UNDOCUMENTED_BUT_REAL DEPENDENCY:
  NH-09 INVARIANT depends on: no future READY-02 implementation or subsequent hook
  modification ever executing COMMAND_NORM. This is a maintenance constraint that is
  not documented in READY-02.
```

### 4.3 Ordering Analysis

Proposed execution order:
```
raw COMMAND
    ↓
NH-09 sed normalization → COMMAND_NORM (for P1'/P2' only)
    ↓
DESTRUCTIVE_REGEX patterns (test COMMAND, not COMMAND_NORM)
    ↓
REGEX patterns (test COMMAND, not COMMAND_NORM)
    ↓
[NEW] REGEX_NORM patterns (P1', P2') (test COMMAND_NORM)
    ↓
exit 0 or block()
```

**What if existing rule matches?** block() exits 2. COMMAND_NORM patterns never tested. Fine.
**What if NH-09 matches?** NH-09 is normalization, not a match. It always runs.
**What if P1' matches?** block() exits 2. P2' not tested. Fine.
**What if P2' matches?** block() exits 2. Fine.
**What if multiple patterns match?** First match exits. No double-blocking. Fine.
**What if no pattern matches?** exit 0. Fine.

**DOES ANY EXISTING CONTROL WEAKEN?**
No: existing patterns still test against original COMMAND. NH-09 is additive.
No fail-open branch is introduced.
No exit-code semantics change.
STALL_POLICY_LOG path unchanged (block() calls stall_record_event).

**MISSING DOCUMENTATION (Finding D):**
The dual-variable architecture (COMMAND for existing patterns; COMMAND_NORM for P1'/P2') is
not documented in READY-02. Future maintainers might add new patterns and be unsure which
variable to use. Should add one comment or note.

### 4.4 READY-02 Adversarial Verdict

```
CRITICAL WEAKNESS: None that breaks the decision.
FINDING D (LOW): Dual-variable architecture not documented.
FINDING NH09-MAINT (LOW): INVARIANT maintenance dependency undocumented.
FP CONCERN: Cannot fully verify without exact P1'/P2' regex from 55_ §1.3.
            This is a gap in the execution rehearsal, not a decision blocker.

READY-02 PASSES adversarial audit. The decision is valid as structured.
The two low findings should be fixed before implementation, not before the decision.
```

---

## §5 — READY-03 Adversarial Audit

### 5.1 What Exactly Is Being Accepted?

READY-03 accepts:
```
(a) Residual bypass classes: aliasing, heredoc body, numbered redirects, file-based
    interpreter calls
(b) Mitigation: human review (B path) + git staging backstop
(c) Conditioned on H-01 remaining at 0 real events
(d) LABYRINTH-1 is "resolved for current context," NOT "solved"
```

### 5.2 What Is NOT Being Accepted?

```
Reasoning-mediated bypass is NOT explicitly listed in the acceptance statement (a).
  - 57_§6.3 lists it separately ("NOT covered by Layers 0-5")
  - NH-10 provides escalation path for UNKNOWN/BLOCKED cases
  - Is reasoning-mediated bypass accepted under READY-03?
  ANSWER: Ambiguous. Should be clarified in the acceptance statement.
  FINDING: Add "reasoning-mediated bypass" to the acceptance list in (a) or explicitly
  state it is covered by NH-10 escalation.
```

### 5.3 Residual Risk Matrix

| Residual | Detected automatically | Human review (B-path) | Staging backstop | Real-usage needed | Accepted under READY-03 |
|---|---|---|---|---|---|
| Variable aliasing | NO | YES (code review) | PARTIAL (may not appear in git add) | YES | YES |
| Heredoc body | NO | YES | YES (heredoc often involves file creation) | YES | YES |
| Numbered redirects (1>) | NO | YES | YES (file creation) | YES | YES |
| File-based interpreter calls | PARTIAL (P4 inadvisable) | YES (if multi-step) | YES (sh file staged) | YES | YES |
| env\|grep display | NO | YES | YES (usually no persist) | YES | NOT EXPLICITLY STATED |
| Reasoning-mediated bypass | NO | YES + NH-10 | YES | YES | AMBIGUOUS — see above |
| Single-quoted secrets (L4) | NO | YES | YES | YES | YES (pre-existing gap) |

### 5.4 Reactivation Trigger Audit

```
From 57_§9.3, 4 named reactivation triggers:
  TRIGGER-1: H-01 exceeds owner-defined N
  TRIGGER-2: New bypass class discovered in production (not in current residual list)
  TRIGGER-3: Threat model expansion (new attack surface or deployment context)
  TRIGGER-4: AC-03 research evidence that current mitigation insufficient

TRIGGER-1 ANALYSIS:
  Observable?        YES — STALL_POLICY_LOG must be monitored
  Reproducible?      YES — each event is logged
  Who detects?       Human reviewer (STALL_POLICY_LOG review)
  Where registered?  STALL_POLICY_LOG.jsonl
  What fires?        H-01 event count exceeds N

CRITICAL GAP (Finding B):
  "Owner-defined N" is referenced but NEVER defined in any source document.
  Current state: N = undefined
  Without N: "H-01 exceeds N" is non-operational as a trigger.
  Owner must define N at time of READY-03 acceptance.
  Suggested: N could be 1 (any real bypass reopens), or a specific count.
  Until N is defined, TRIGGER-1 is VAGUE.

TRIGGER-2 through TRIGGER-4:
  Observable: YES (each requires a specific event type)
  These triggers are specific enough. No vagueness.
```

### 5.5 READY-03 Risk Label Audit (Finding C)

```
CURRENT: RISK: MEDIUM

ADVERSARIAL CHALLENGE:
  "MEDIUM" implies a quantified risk assessment.
  H-01 = 0 real events. Materiality UNRESOLVED.
  We cannot quantify bypass frequency from 0 production data points.
  The bypass residual could be extremely rare (H-01 ≈ 0) or common (H-01 >> 0).
  CCP operates in a development context with human-in-the-loop; this reduces real
  exposure, but this is an inference, not a measurement.

CORRECT CLASSIFICATION:
  RISK: UNKNOWN (H-01 materiality unresolved; bypass frequency not measurable from
  synthetic data. Development context inference: low practical exposure. NOT a
  quantified risk estimate.)

This is a precision issue, not a decision blocker. The acceptance of residual risk
is still valid under READY-03 regardless of whether it's labeled MEDIUM or UNKNOWN.
But the label should not imply false precision.
```

### 5.6 READY-03 Adversarial Verdict

```
CRITICAL WEAKNESS: Finding B (N undefined) is the most actionable finding.
  If owner accepts READY-03 without defining N, reactivation trigger-1 is non-operational.
  Operationally this means LABYRINTH-1 can never reopen via trigger-1 because no
  threshold exists to cross.

REQUIRED ADDITIONS TO READY-03:
  1. Define N (e.g., N=1: any real bypass event reopens; or owner-chosen value)
  2. Add "reasoning-mediated bypass" to acceptance list (a) or clarify its coverage
  3. Change RISK: MEDIUM → RISK: UNKNOWN (H-01 materiality unresolved)

DOES THIS BREAK READY-03? NO. The decision is still valid and important.
These are precision improvements, not decision reversals.
```

---

## §6 — READY-04 Adversarial Audit

### 6.1 Message Format Analysis

PROPOSED changes (from 57_§5.1):
- bash-firewall.sh: enhanced stderr output format
- task-completed-evidence.sh: enhanced stderr output

Fields added:
```
policy_id, summary_of_blocked_action, prohibited_outcome, scope_allowed,
next_action, escalation_path_reference, documentation_reference
```

### 6.2 Sensitive Data Exposure Check

```
CURRENT output:
  "BLOQUEADO por bash-firewall (P0): {reason}"
  "Comando: {COMMAND}"

COMMAND already contains: the full command string.
  Example: "printenv ANTHROPIC_API_KEY" → "Comando: printenv ANTHROPIC_API_KEY"
  This already exposes the SECRET NAME (not value) in stderr.

PROPOSED additions:
  policy_id: "POL-XX" or "STALL_POLICY" → NO sensitive data
  summary_of_blocked_action: describes what was blocked → AT MOST same as COMMAND
  prohibited_outcome: describes what policy prevents → policy text → NO sensitive data
  next_action: guidance text → NO sensitive data
  escalation_path_reference: "§12 of CONTROL_PLANE_HANDBOOK" → NO sensitive data

COMPARISON: READY-04 does NOT increase sensitive data exposure beyond COMMAND line
  already present. All new fields are metadata about the block, not the command content.

VERDICT: No new sensitive data exposure. PASSES.
```

### 6.3 Other Checks

```
stderr only?          YES — block() writes to >&2. READY-04 maintains this.
exit code unchanged?  YES — exit 2 (block) and exit 0 (allow) unchanged.
block/allow unchanged? YES — no logic change; only output format.
logging unchanged?    YES — stall_record_event call unchanged.
message consistency?  YES — same block() function would be enhanced uniformly.
reference stability?  YES — handbook §12 (NH-10) is now IMPLEMENTED; stable reference.
handbook dependency?  YES — READY-04 references §12; NH-10 is in MOVEMENT 005. Satisfied.
NH-10 dependency?     SATISFIED (NH-10 implemented in MOVEMENT 005).
```

### 6.4 READY-04 Adversarial Verdict

```
NO CRITICAL WEAKNESS FOUND.
Finding: READY-04 is the most straightforwardly correct of all four decisions.
  All checks pass; no sensitive data exposure; no enforcement change; no logic change.
  READY-04 PASSES adversarial audit without required fixes.
```

---

## §7 — Cross-Decision Interaction Analysis

### 7.1 Decision Interaction Matrix

| Combination | Dependency | Conflict | Synergy | Redundancy |
|---|---|---|---|---|
| READY-01 + READY-02 | NO | NO | YES (policy makes explicit what patterns enforce) | NO |
| READY-01 + READY-03 | NO | NO | YES (explicit policy strengthens acceptance) | NO |
| READY-02 + READY-03 | PARTIAL | NO | YES (together define covered vs. accepted residual) | NO |
| READY-02 + READY-04 | NO | NO | YES (04 improves 02's blocks) | NO |
| READY-01+02+03 | PARTIAL | NO | YES (full L1-C closure) | NO |
| ALL FOUR | PARTIAL | NO | YES (complete stack) | NO |

### 7.2 Key Dependency Analysis

**Does READY-02 depend semantically on READY-01?**
NO. P1'/P2' patterns detect bypasses regardless of whether policy text is explicit.
The patterns operate at the hook level; the policies operate at the agent guidance level.
These are independent enforcement layers.

**Does READY-03 depend logically on READY-01/02?**
PARTIALLY. If READY-03 is accepted WITHOUT READY-02, the "accepted residual" is larger:
  - The syntactic gaps (${VAR}, quoted variants) remain undetected
  - Owner is accepting B-path-only mitigation for syntactic bypasses that READY-02 would close
  - This is documented in 58_ but should be stated more explicitly:
    "READY-03 accepted without READY-02 = accepting syntactic gaps as part of residual"

**Does READY-04 become obsolete if READY-03 exists?**
NO. READY-03 closes the research agenda; READY-04 improves human review UX.
READY-03 is about risk acceptance. READY-04 is about resolution quality. Different planes.

**Does NH-10 remain canonical after READY-04?**
YES. NH-10 is the escalation path content (handbook §12 prose). READY-04 puts a reference
to §12 in the hook output. They complement each other; READY-04 without NH-10 would leave
a broken reference.

### 7.3 Interaction: What Changes When READY-02 Applied Without READY-01?

Patterns P1'/P2' fire when `printenv ANTHROPIC_API_KEY` is detected. No policy explicitly
states this is prohibited (PARTIAL policy). When human reviewer sees the block:
- Current message: "BLOQUEADO: reason; Comando: printenv ANTHROPIC_API_KEY"
- Policy consulted: PARTIAL (ambiguous)
- Human may be UNCERTAIN whether the block was correct

AFTER READY-01+READY-02: The policy would explicitly state the prohibition.
AFTER READY-02 ONLY: The block fires correctly but the policy justification is less clear.
CONCLUSION: READY-02 without READY-01 works but creates a "block without clear policy reference"
scenario. Not a failure mode, but reduced auditability.

---

## §8 — Authorization Audit (F9-D01=A Semantics)

### 8.1 What F9-D01=A Prohibits

```
From F9_OWNER_DECISIONS.md §3:
  "No runtime, hook, fixture, evidence, regression, agent, skill, rule,
  dependency, registry, or architecture change."

EXPLICITLY PERMITTED (documentation-only changes):
  - Documentation of the five owner decisions
  - Update of PROJECT_STATE.md
  - Update of context mirrors
  - Creation of record files
```

### 8.2 Per-Element Audit

| Element | Under F9-D01=A | Classification |
|---|---|---|
| .claude/rules/*.md text additions | "rule change"? or "documentation"? | AMBIGUOUS — exactly the READY-01 question |
| bash-firewall.sh P1'/P2' + NH-09 | "hook change" | CLEARLY PROHIBITED without READY-02 YES |
| STALL_POLICY_LOG schema | "registry change" | PROHIBITED |
| CONTROL_PLANE_HANDBOOK additions | "documentation" | CLEARLY PERMITTED |
| PROJECT_STATE.md updates | "documentation" | CLEARLY PERMITTED |
| EVIDENCE_REGISTRY.md updates | ARCH-003 evidence canonical | PERMITTED for new evidence |
| New .claude/rules/ entries | "rule" | PROHIBITED |
| settings.json permissions | "architecture" or "config" | PROHIBITED |
| DECISION_REGISTRY.md new decisions | "registry"? | AMBIGUOUS for new entries |

### 8.3 No New Ambiguity Found

The READY-01 question correctly identifies the primary ambiguity (rules/*.md additions).
No additional F9-D01=A interpretation issues found beyond what's already documented.
F9-D02/D03/D04/D05 are not triggered by any of the four READY decisions.

---

## §9 — Hidden Dependency Audit

| Dependency | Between | Status | Risk |
|---|---|---|---|
| N threshold | READY-03 requires owner-defined N | UNDOCUMENTED_BUT_REAL | HIGH (trigger non-operational without it) |
| NH-09 INVARIANT maintenance | Future hook mods must not exec COMMAND_NORM | UNDOCUMENTED_BUT_REAL | LOW (no current plan to change) |
| F9_OWNER_DECISIONS.md is owner-only | POL-08 exception relies on this file being authoritative | ASSUMED | LOW (Git trust boundary covers this) |
| P1'/P2' exact regex | Implementation requires 55_ §1.3 | DOCUMENTED (by reference) | LOW (specification exists) |
| Dual-variable architecture | COMMAND vs COMMAND_NORM in hook | UNDOCUMENTED | LOW (architectural note needed) |
| READY-03 without READY-02 | Syntactic gaps become part of accepted residual | PARTIALLY DOCUMENTED | LOW (documented in 58_ §3 dependencies) |
| NH-10 reference stability | READY-04 references handbook §12 | SATISFIED | NONE (NH-10 implemented) |
| Reasoning-mediated bypass in READY-03 | NH-10 covers it but READY-03 doesn't list it | ASSUMED | LOW |

**No systemic hidden dependency found that would block or invalidate any decision.**
The most actionable undocumented dependency is N (Finding B).

---

## §10 — Evidence Audit

| Decision | Evidence type | Evidence basis | Production evidence? |
|---|---|---|---|
| READY-01 (policy repairs) | DESIGN_RESULT | 5-case validation per policy (56_§7) | NO — synthetic |
| READY-02 (P1'/P2'+NH-09) | DESIGN_RESULT + EXPERIMENTAL | NH-04 corpus; 58A 20-case corpus | NO — synthetic |
| READY-03 (risk acceptance) | DESIGN_RESULT | H-01 = 0 real events; bypass taxonomy | NO — research-level |
| READY-04 (message format) | DESIGN_RESULT | STA-02 scenario analysis | NO — analytical |

**Evidence sufficiency by claim type:**

DESIGN_RESULT claims: correctly limited to design-level; no production validity claimed.
EXPERIMENTAL_RESULT claims: synthetic corpora; explicitly not production-empirical.
INFERENCE claims: clearly labeled; no overclaiming.

The evidence base is appropriate for the decision TYPE (owner authorization of bounded,
reversible changes in a development context). Production evidence is not required for
authorization; it would be required for validation post-implementation.

**Key evidence discipline maintained throughout source documents:**
"0 observed events ≠ 0 risk" (materiality discipline) is consistently applied.
No evidence file claims production validity it does not have.

---

## §11 — Materiality Audit

```
H-01 current state: 1 test event; 0 real events; materiality UNRESOLVED

WHAT CAN BE DECIDED WITHOUT H-01:
  READY-01: YES — policy text quality is independent of bypass frequency
  READY-02: YES — syntactic coverage can be improved regardless of observed frequency
  READY-03: YES (risk acceptance is owner's choice); but N must be defined
  READY-04: YES — human review quality is independent of bypass frequency

WHAT CANNOT BE DECIDED WITHOUT H-01:
  - "The bypass residual risk is low" (cannot quantify)
  - "The current system is sufficient" (cannot validate against real attacks)
  - "P1'/P2' pattern effectiveness in production" (cannot measure real catch rate)
  - "The false positive rate in production" (cannot measure from synthetic data)

CRITICAL CHECK:
  Nowhere in READY-01/02/03/04 does the documentation convert
  "0 observed events" → "0 risk" or "LOW risk."
  The materiality discipline is correctly maintained.

  EXCEPTION: READY-03 "RISK: MEDIUM" label is an implicit quantification.
  This is Finding C (addressed above).
```

---

## §12 — Reversibility Audit

| Decision | Code rollback | Policy rollback | Documentation rollback | Evidence rollback | Decision rollback |
|---|---|---|---|---|---|
| READY-01 YES | `git revert` removes 4 text additions | Policy reverts to PARTIAL | N/A | No evidence generated | Owner can re-open classification question |
| READY-02 YES | `git revert` removes NH-09 + P1'/P2' lines | N/A | N/A | Log entries (STALL_POLICY_LOG) remain | Owner can revoke authorization |
| READY-03 YES | No code change | N/A | Owner statement "LABYRINTH-1 reopened" | No evidence generated | Owner can reopen with single statement |
| READY-04 YES | `git revert` removes message format change | N/A | N/A | No evidence generated | Owner can revoke |

**Key note for READY-02**: STALL_POLICY_LOG entries from P1'/P2' blocks persist after rollback.
These are evidence records, not enforcement code. They remain valid historical data.
Behavioral rollback (stop blocking the new patterns) is complete with git revert.
Evidence rollback is NOT necessary or intended.

**Git revert = semantic rollback** for all four decisions. No case where code rollback fails to
restore the enforcement semantics.

---

## §13 — Premature Closure Audit

**Terms audited:**

```
SAFE_NORMALIZATION (NH-09):  CORRECTLY QUALIFIED — "for matching purpose; 4 limitations documented"
                              NOT premature.

CONFIRMED (NH-10):           CORRECTLY QUALIFIED — "likely permitted; owner may confirm"
                              NOT premature.

SUPPORTED (NH-07):           CORRECTLY QUALIFIED — "closes information gap; not judgment gap"
                              NOT premature.

LOW RISK (READY-02):         CORRECTLY QUALIFIED — "P1'/P2' LOW FP profile; NH-09 SAFE_NORMALIZATION"
                              Appropriate for the decision type.

MEDIUM RISK (READY-03):      OVERCONFIDENT — Finding C. Risk is UNKNOWN, not MEDIUM.
                              PREMATURE for risk quantification.

1/5 L1-C conditions:         CORRECT count.
                              NOT premature.

"NOT MATERIAL" (H-01):       CORRECTLY AVOIDED. Document says "materiality unresolved."
                              NOT premature.

RESOLVED (UNK-M4-01):        CORRECTLY QUALIFIED — "analytical corpus; not production"
                              NOT premature.

CONFIRMED (NH-09 INVARIANT):  CONFIRMED from this audit as well (design analysis).
                              NOT premature.
```

**CCP_EXPLORATION_ENGINE.md inconsistency (Finding E):**
```
UNK-M4-01 appears as both:
  OPEN: "UNK-M4-01: NH-09 double-quote removal semantic accuracy — OPEN (20-cmd corpus test; no auth)"
  CLOSED: "[CLOSED] UNK-M4-01: RESOLVED — SAFE_NORMALIZATION (58A §5)"

This is a dangling OPEN entry from before MOVEMENT 005 that was not removed when the
CLOSED entry was added. Must be cleaned in the Exploration Engine update.
```

---

## §14 — Objection Register

| Objection | Status | Rationale |
|---|---|---|
| "READY-01 is purely documental" | DISPUTED — Finding A | POL-08 adds exception; POL-10 and POL-13 add new constraints |
| "P1'/P2' won't have false positives" | ACCEPTED WITH CAVEAT | LOW FP profile on synthetic corpus; production FP unknown |
| "NH-09 is safe for all shell constructs" | ACCEPTED WITH LIMITS | 4 documented limitations (PARTIALLY_SAFE); none on attack surface |
| "Owner accepts L1-C but never authorizes READY-02" | RESOLVED | Branch 1 explicitly documented; B-path-only closure is valid |
| "What if handbook becomes de facto policy?" | MITIGATED | NH-10 is labeled process documentation; boundary is soft but defensible |
| "What if READY-03 is read as 'security solved'?" | MITIGATED | READY-03 explicitly states "not solved in absolute sense" and "resolved for current context only" |
| "What if H-01 appears after L1-C closure?" | PARTIALLY RESOLVED | Trigger-1 addresses this; but N is undefined (Finding B) |
| "What if bypass residual combines with another control failure?" | ACCEPTED | Tail risk; accepted under READY-03 for current development context |
| "What if CCP is deployed in different context?" | MITIGATED | READY-03 acceptance is context-specific; context change requires review |
| "Single-quote bypass not closed by NH-09" | DOCUMENTED | L4 limitation; pre-existing gap; NH-11 hypothesis logged for future |
| "P3 not in READY-02 scope" | RESOLVED | P3 explicitly deferred; HIGH FP risk; separate authorization if needed |
| "F9-D01=A scope is ambiguous for rules/*.md" | CORRECTLY IDENTIFIED | This is the exact READY-01 question; not a new ambiguity |
| "READY-03 N threshold is undefined" | FINDING B — REQUIRES FIX | N must be defined at acceptance time |
| "0 events = low risk" | CORRECTLY REJECTED | Materiality discipline maintained throughout documents |
| "READY-04 exposes sensitive data" | REFUTED | Current COMMAND already in stderr; READY-04 adds less-sensitive metadata only |
| "N/A research that changes decisions" | NONE FOUND | All open questions require real usage or are non-blocking |

---

## §15 — True Frontier (Post-Audit)

```
KNOWN (confirmed after adversarial audit):
├── F1-F8 architecture: FROZEN (verified)
├── Policy repair texts: SPECIFIED in 55_ §1.3 (copy-paste ready)
├── NH-09 INVARIANT: CONFIRMED (design analysis, this session)
├── P1'/P2' FP profile: LOW (synthetic corpus; production unknown)
├── READY-01 scope: NOT purely documental (Findings A — new constraints/exceptions)
├── READY-02 is the correct design for Level-1 normalization
├── READY-03 closure semantics: correct structure but N undefined (Finding B)
├── READY-04 is safe (no enforcement change, no sensitive data exposure)
├── NH-10 satisfies READY-04 dependency
├── Cross-decision interactions: all characterized; no blocking conflicts
└── Adversarial bypass test: no breaking flaw found in decision package

OWNER DECISION GATES:
├── READY-01: classification under F9-D01=A (with corrected question — Finding A)
├── READY-02: hook implementation authorization
├── READY-03: risk acceptance WITH N definition required (Finding B)
└── READY-04: hook implementation authorization (lower priority)

REQUIRED OWNER INPUT (not classification, but value):
└── N: threshold for H-01 reactivation trigger (Finding B)

ENVIRONMENT BLOCKS:
├── H-01 materiality: requires real usage environment
├── P1'/P2' production FP rate: requires real usage
├── Production bypass frequency: requires real usage
└── Native Claude Code lifecycle: NOT_VERIFIED (deferred per F9-D02=B)

DEFERRED (unchanged):
├── CDT-02 (blind subagent verifier): requires new agent authorization
├── AC-03 (semantic bypass): dormant until TRIGGER-4
├── NH-11 (single-quote normalization): not authorized
├── P3 pattern: deferred (MEDIUM FP risk)
├── F10-F12: UNKNOWN / NOT STARTED
└── F9-D02 trigger items: native runtime; G-B11; tool failure evidence

RESEARCH STOP CONDITION (per mandate §26):
  NO high-value low-cost experiment remaining ✓
  NO hidden dependency that changes any decision (except N — requires owner input) ✓
  NO material unknown that changes READY decisions (N doesn't change the decision; it refines it) ✓
  NO unresolved authorization ambiguity beyond the READY-01 question ✓
  NO untested critical assumption (NH-09 INVARIANT confirmed; POL repairs validated) ✓

  CONCLUSION: Research should stop. Owner decisions are the correct next action.
```

---

## §15.2 — 12 Questions (Mandate §33)

**1. ¿Existe todavía alguna objeción técnica material?**

YES — Finding A: READY-01 is misclassified as "purely documentation." Three of four repairs
add new constraints or exceptions not present in the original text. This affects the owner's
decision framing. The decision is still valid; the question must be reworded.

**2. ¿Existe todavía alguna investigación de alto valor que pueda cambiar READY-01/02/03/04?**

NO. All open questions (H-01 materiality, production FP rate, bypass frequency) require real
usage. No synthetic or analytical research can close them. The research agenda is exhausted for
the current authorization scope.

**3. ¿Existe algún UNKNOWN que realmente importe antes del owner?**

YES — Finding B: N (H-01 reactivation threshold) must be defined by the owner as part of
accepting READY-03. This is not a research question; it is a value that only the owner can set.

**4. ¿Existe alguna dependencia oculta?**

YES — two undocumented but real:
(a) N threshold (Finding B — must be defined at READY-03 acceptance time).
(b) NH-09 INVARIANT maintenance — future hook modifications must not execute COMMAND_NORM.

**5. ¿Alguna decisión está incorrectamente clasificada?**

YES — Finding A: READY-01 scope understated.
YES — Finding C: READY-03 risk label "MEDIUM" should be "UNKNOWN (H-01 materiality unresolved)."

**6. ¿Algún cambio aparentemente documental modifica realmente comportamiento?**

PARTIALLY YES — POL-08 repair adds a new exception for F9-D01=A gates. Operationally: it
explicitly permits something that was previously implicitly prohibited. However, F9-D01=A was
already independently authorized, so no new capability is granted. The behavioral interpretation
change is real but the practical effect is harmonization, not expansion.

**7. ¿Está suficientemente preparado el plan de implementación?**

YES — with one noted gap: the exact P1'/P2' regex specification is in 55_ §1.3 (referenced but
not re-read in this session). Implementer must consult 55_ §1.3 before writing the patterns.
All other implementation details are fully specified.

**8. ¿Qué ocurre exactamente en cada rama YES/NO?**

See 59A_EXECUTION_REHEARSAL.md §10 for full branch simulation table.
Summary: READY-03 YES alone closes research agenda. READY-01+02+03 YES together achieve
minimal L1-C closure. All four YES achieves strong L1-C closure with enhanced UX.

**9. ¿Qué necesita owner?**

(a) 4 binary decisions: READY-01, READY-02, READY-03, READY-04.
(b) 1 value: N (H-01 threshold for READY-03 acceptance).
(c) Awareness that READY-01 question must be updated (Finding A).
No code to write; no implementation to authorize until binary decisions made.

**10. ¿Qué necesita uso real?**

(a) H-01 materiality (real bypass frequency)
(b) P1'/P2' production false-positive rate
(c) Pattern effectiveness against real attack attempts
(d) Native Claude Code lifecycle verification (deferred per F9-D02=B)

**11. ¿Cuál es la TRUE FRONTIER?**

```
TRUE FRONTIER = OWNER DECISION GATE
    ↓
KNOWN: F1-F8, policy repairs specified, NH-09 INVARIANT confirmed, P1'/P2' designed
    ↓
OWNER DECISIONS: READY-01/02/03/04 + N definition
    ↓
ENVIRONMENT BLOCK: H-01 materiality, production FP rate
    ↓
DEFERRED: CDT-02, AC-03, NH-11, F10-F12
```

No research action is available that would change this frontier without new authorization
or real usage data.

**12. ¿Cuál es el siguiente movimiento que realmente cambia el mapa?**

Owner accepting READY-03. This alone closes LABYRINTH-1 (conditionally) and stops the
active research overhead for the security coverage question. It is the minimum viable
action that changes the state of the system in a durable way, regardless of whether
READY-01, READY-02, or READY-04 are also accepted.

---

**END — 59_PRE_AUTHORIZATION_ADVERSARIAL_GATE.md**

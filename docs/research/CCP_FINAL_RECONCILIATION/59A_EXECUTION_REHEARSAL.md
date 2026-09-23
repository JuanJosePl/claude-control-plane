# 59A — Execution Rehearsal

**Date:** 2026-09-23
**Executor:** Claude Sonnet 4.6
**Movement:** 006
**Purpose:** Exact dry-run of changes that would be made under each YES authorization.
             DRY-RUN ONLY — no protected files modified.
**Authorization:** Analysis only. Protected files (.claude/hooks/*, .claude/rules/*) are NOT changed.
**Dependencies:** 55_CDT01_NH02_RESULTS.md §1.3 — exact P1'/P2' regex (read required before implementation).

---

## §1 — READY-01 Dry-Run (AC-02 Policy Repairs)

### 1.1 Files Expected to Change

```
.claude/rules/security.md      (POL-05 repair)
.claude/rules/no-go.md         (POL-08 repair)
.claude/rules/compliance.md    (POL-10 repair)
.claude/rules/git-policy.md    (POL-13 repair)
```

### 1.2 POL-05 Repair — security.md

**Current text (line 8):**
```
- Aislamiento de datos en cada query (tenant_id, RLS, o el mecanismo que definas en SECURITY_RULES.md).
```

**Proposed replacement / addition (DESIGN_RESULT from 56_§7.1):**
```
- Aislamiento de datos en cada query (tenant_id, RLS, o el mecanismo que definas en SECURITY_RULES.md).
  Default isolation field = tenant_id; override requires explicit SECURITY_RULES.md declaration;
  prohibited: cross-tenant queries; non-tenant tables must be documented in SECURITY_RULES.md.
```

**Semantic scope change note (Finding A):**
This adds a "prohibited: cross-tenant queries" statement not explicitly present in the original.
The intent is unchanged (data isolation). The scope is more restrictive.

**Dry-run regression check:**
- `SELECT * FROM orders WHERE tenant_id=?` → SAFE (before and after)
- `SELECT * FROM orders` (no filter) → UNSAFE after repair; UNKNOWN before
- `COUNT(*) FROM orders WHERE tenant_id=?` → UNKNOWN after (aggregate not excepted); OK before
  IMPLEMENTATION NOTE: Consider adding "aggregate queries that don't expose rows are permitted
  if isolation field filter is present" to avoid overconstraint on COUNT/SUM queries.

### 1.3 POL-08 Repair — no-go.md

**Current text (line 4):**
```
- NO convertir a una sola persona en cuello de botella operativo
```

**Proposed replacement / addition (DESIGN_RESULT from 56_§7.2):**
```
- NO convertir a una sola persona en cuello de botella operativo.
  Bottleneck defined as: sole approver with no documented fallback (different person).
  Exception: owner decision gates listed in F9_OWNER_DECISIONS.md are intentional,
  time-bounded gates and are explicitly excepted from this prohibition.
```

**Semantic scope change note (Finding A):**
This adds a NEW EXCEPTION for F9-D01=A gates. Previously, POL-08 and F9-D01=A were
in implicit tension. The repair resolves the tension by explicitly excepting authorized gates.
Net effect: permission expansion ONLY for already-authorized actions.
Also adds "different person" qualification (closes the same-person-as-own-fallback gap identified in 56_§7.2).

**Dry-run regression check:**
- Two-person approval, backup documented → SAFE (before and after)
- Alice sole approver, no backup → UNSAFE (before and after; now operationally defined)
- F9-D01=A owner gate → SAFE after repair; UNKNOWN/UNSAFE before
- Alice as backup for Alice → UNSAFE after repair (adds "different person"); unclear before

### 1.4 POL-10 Repair — compliance.md

**Current text (line 3):**
```
- `consent_records` = tabla de primera clase (opt-in con timestamp/canal/finalidad).
```

**Proposed replacement / addition (DESIGN_RESULT from 56_§7.3):**
```
- `consent_records` = tabla de primera clase (opt-in con timestamp/canal/finalidad).
  First-class defined by three criteria: (a) independent table in a separate schema or database,
  (b) independently queryable without joining user tables, (c) sole authoritative source
  (no duplicate consent fields in other tables). Required minimum columns:
  (user_id, opt_in_timestamp, channel, purpose, source).
```

**Semantic scope change note (Finding A):**
This explicitly PROHIBITS denormalized consent fields (e.g., `users.opt_in_cache BOOLEAN`).
The original "primera clase" was vague; this interpretation is more restrictive.
New ambiguity introduced: "separate schema or database" added here to resolve 56_§7.3 gap.

**Dry-run regression check:**
- `consent_records` as independent table → SAFE (before and after)
- `users.marketing_consent BOOLEAN` → UNSAFE after; ambiguous before
- `consent_records` in same DB, own table, own schema → SAFE after repair
- `consent_records` in same schema as users → UNKNOWN (criterion a's "separate schema" is now required)
  IMPLEMENTATION NOTE: "Separate schema" requirement was added here to address 56_§7.3 gap.
  Exact text must come from 55_ §1.3.

### 1.5 POL-13 Repair — git-policy.md

**Current text (lines 3-4):**
```
- Commits con prefijo de fase o tipo: `[FASE-N] [TIPO]: descripción` (feat, fix, docs, arch, decision, security, infra, config).
  Control plane usa `[CONFIG]`.
```

**Proposed replacement / addition (DESIGN_RESULT from 56_§7.4):**
```
- Commits con prefijo de fase o tipo: `[FASE-N] [TIPO]: descripción`.
  FASE-N for phase deliverables; TYPE for cross-cutting work.
  Permitted TYPE values (enumerated): feat, fix, docs, arch, decision, security, infra, config,
  RESEARCH, CONFIG. Prohibited: commits without a recognized prefix from this set.
  Mixed-work commits: use FASE-N if the primary deliverable is a phase artifact; use TYPE otherwise.
```

**Semantic scope change note (Finding A):**
Converts open-ended example list to EXCLUSIVE enumerated set. Commits with prefixes outside
this set are now explicitly prohibited. Also introduces case inconsistency (RESEARCH, CONFIG
are uppercase while feat, fix, etc. are lowercase). Recommend normalizing case in final text.

**Dry-run regression check:**
- `[RESEARCH]: finding document` → SAFE after repair
- `git commit -m "Fixed thing"` (no prefix) → UNSAFE (before and after)
- `[FEATURE]: new thing` → UNSAFE after repair (FEATURE not in set); unclear before
- `[CONFIG]: every commit` → ALLOWED; no frequency constraint

### 1.6 READY-01 Test Plan

```
UNIT TEST (manual review before commit):
  For each repair: verify original line still present plus new clarification.
  Verify no existing prohibition is removed.
  Verify no permission is added except POL-08 exception for F9_OWNER_DECISIONS.md gates.

REGRESSION TEST:
  Consult 56_§7 case tables (E5, E8, E10, E13).
  Re-run each 5-case validation: positive, negative, unknown, boundary, adversarial.
  Expected: all previously-SAFE cases remain SAFE.
  Expected: previously-UNKNOWN cases may become UNSAFE (consistent with repair intent).

BEHAVIORAL TEST: Not applicable (rules files are not runtime code).
```

### 1.7 READY-01 Rollback Procedure

```
git revert <READY-01 commit>
Removes all 4 text additions atomically.
Policies revert to PARTIAL classification.
No hook, fixture, or evidence change to revert.
SEMANTIC ROLLBACK: COMPLETE (no behavioral side effects from rule text changes).
```

---

## §2 — READY-02 Dry-Run (P1'+P2'+NH-09 in bash-firewall.sh)

### 2.1 Files Expected to Change

```
.claude/hooks/bash-firewall.sh
```

### 2.2 Exact Logical Changes

**BEFORE (current bash-firewall.sh excerpt, lines 28-29):**
```bash
COMMAND="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")"
[ -z "$COMMAND" ] && exit 0
```

**AFTER (with NH-09 Level-1 normalization added after line 29):**
```bash
COMMAND="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")"
[ -z "$COMMAND" ] && exit 0

# NH-09: Level-1 normalization for P1'/P2' pattern matching ONLY.
# INVARIANT: COMMAND_NORM is NEVER executed. Used for grep matching only.
# Do not add eval/exec/bash -c/sh -c or any execution of COMMAND_NORM here or in future.
COMMAND_NORM=$(printf '%s' "$COMMAND" | sed -E 's/"([^"]*)"/\1/g')
COMMAND_NORM=$(printf '%s' "$COMMAND_NORM" | sed -E 's/\$\{([^}]*)\}/\$\1/g')
```

**AFTER (new REGEX_NORM section, inserted AFTER existing REGEX loop, BEFORE exit 0):**
```bash
# --- P1'/P2': Level-1 normalized patterns (test against COMMAND_NORM) ---
# NOTE: These patterns use COMMAND_NORM (not COMMAND). Existing patterns above use COMMAND.
# For future patterns: use COMMAND for literal/token matching; COMMAND_NORM for quoted/brace forms.
declare -A REGEX_NORM=(
  ["printenv con secreto nombrado (P1')"]='PATTERN_FROM_55_CDT01_SEC1.3_P1'
  ["variable secret en pipeline de encoding (P2')"]='PATTERN_FROM_55_CDT01_SEC1.3_P2'
)
for reason in "${!REGEX_NORM[@]}"; do
  printf '%s' "$COMMAND_NORM" | grep -qE -- "${REGEX_NORM[$reason]}" && block "$reason"
done
```

**IMPORTANT NOTE: Exact P1'/P2' regex must come from 55_CDT01_NH02_RESULTS.md §1.3.**
The patterns above are placeholders. Implementation requires reading 55_ §1.3 before writing code.

### 2.3 Line Regions Expected to Change

```
Line 29 (after COMMAND assignment):   INSERT 5-line NH-09 block (comment + 2 sed lines)
Line ~83 (before final exit 0):       INSERT REGEX_NORM block (~8 lines)
Total net addition: ~13 lines
```

### 2.4 READY-02 Test Plan

```
UNIT TEST:
  DRY_RUN=true ./bash-firewall.sh <<'EOF'
  {"tool_input":{"command":"printenv ANTHROPIC_API_KEY"}}
  EOF
  Expected: [DRY_RUN] se habría bloqueado (P1' match)

  DRY_RUN=true ./bash-firewall.sh <<'EOF'
  {"tool_input":{"command":"echo ${ANTHROPIC_API_KEY} | base64"}}
  EOF
  Expected: [DRY_RUN] se habría bloqueado (P2' via NH-09)

  DRY_RUN=true ./bash-firewall.sh <<'EOF'
  {"tool_input":{"command":"echo \"${ANTHROPIC_API_KEY}\" | base64"}}
  EOF
  Expected: [DRY_RUN] se habría bloqueado (P2' via NH-09 step 1+2)

  DRY_RUN=true ./bash-firewall.sh <<'EOF'
  {"tool_input":{"command":"git status"}}
  EOF
  Expected: exit 0 (no block; no false positive)

REGRESSION TEST:
  Run existing evals/maintenance.sh — all 12 diagnostics must PASS.
  Verify no existing SAFE command (from test suite) now blocks.

KNOWN LIMITATION TEST:
  printenv 'ANTHROPIC_API_KEY'  → Expected: NOT blocked (L4 gap; single quotes not normalized)
  Document this as expected behavior.
```

### 2.5 READY-02 Rollback Procedure

```
git revert <READY-02 commit>
Removes NH-09 block + REGEX_NORM block from bash-firewall.sh.
Reverts to Level-0 patterns only.
STALL_POLICY_LOG entries from P1'/P2' blocks remain (historical evidence; not reverted).
SEMANTIC ROLLBACK: COMPLETE for enforcement behavior.
```

### 2.6 Post-Change Verification

```
1. Run evals/maintenance.sh → must report 12/12 PASS
2. Run DRY_RUN smoke tests above → all expected outputs confirmed
3. Read modified hook code → verify COMMAND_NORM is not passed to eval/exec/bash -c
4. Verify existing REGEX loop tests COMMAND (not COMMAND_NORM)
5. Verify new REGEX_NORM loop tests COMMAND_NORM (not COMMAND)
```

---

## §3 — READY-03 State Transition

### 3.1 LABYRINTH-1 State Change

```
BEFORE:
  LABYRINTH-1 = OPEN
  L1-C Conditions:
    1 (P1'+P2'): NOT SATISFIED
    2 (AC-02 repairs): NOT SATISFIED
    3 (escalation path): SATISFIED (NH-10; MOVEMENT 005)
    4 (owner risk acceptance): NOT SATISFIED
    5 (empirical basis/owner): NOT SATISFIED

AFTER READY-03 YES (standalone):
  LABYRINTH-1 = CONDITIONALLY_CLOSED (L1-C, B-path-only baseline)
  L1-C Conditions:
    1 (P1'+P2'): NOT SATISFIED (still requires READY-02)
    2 (AC-02 repairs): NOT SATISFIED (still requires READY-01)
    3 (escalation path): SATISFIED
    4 (owner risk acceptance): SATISFIED ← READY-03 YES provides this
    5 (empirical basis/owner): SATISFIED ← READY-03 YES provides this
  L1-C status: 3/5 conditions; CONDITIONAL closure under B-path-only

AFTER READY-01+READY-02+READY-03 YES:
  LABYRINTH-1 = CONDITIONALLY_CLOSED (L1-C, minimal closure)
  All 5 conditions SATISFIED
```

### 3.2 Required Owner Statement (READY-03)

The owner's acceptance statement must include all four (a)-(d) from the READY-03 package
PLUS the N definition (Finding B):

```
Required READY-03 acceptance statement:
  (a) The residual bypass classes — variable aliasing, heredoc body, numbered redirects,
      file-based interpreter calls, and reasoning-mediated bypass — are accepted for
      CCP's current development context.
  (b) Mitigation for the residual: human review (B path) + git staging backstop.
  (c) This acceptance is conditioned on H-01 remaining below N.
      N = [OWNER MUST DEFINE — e.g., "N=1: any real bypass event reopens LABYRINTH-1"]
  (d) LABYRINTH-1 is NOT "solved" in the absolute sense. It is "resolved for current
      development context" under L1-C. This acceptance does not claim that bypass risk
      is zero, low, or quantified. H-01 materiality remains unresolved.
```

### 3.3 READY-03 Rollback Procedure

```
Owner statement: "LABYRINTH-1 reopened; L1-C acceptance withdrawn."
Document in PROJECT_STATE.md and CCP_EXPLORATION_ENGINE.md.
No code change required; no git revert needed.
SEMANTIC ROLLBACK: COMPLETE with single owner statement.
```

---

## §4 — READY-04 Dry-Run (Enhanced Denial Message)

### 4.1 Files Expected to Change

```
.claude/hooks/bash-firewall.sh           (block() function enhanced stderr)
.claude/hooks/task-completed-evidence.sh (enhanced stderr for task gate failures)
```

### 4.2 Exact Logical Changes — bash-firewall.sh

**Current block() function (lines 31-46):**
```bash
block() {
  echo "BLOQUEADO por bash-firewall (P0): $1" >&2
  echo "Comando: $COMMAND" >&2
  [ "${DRY_RUN:-false}" = "true" ] && { echo "[DRY_RUN] se habría bloqueado"; exit 0; }
  local decision=2
  stall_record_event \
    "bash-firewall.sh" \
    "DENY" \
    "STALL_POLICY" \
    "$1" \
    "$COMMAND" \
    "" \
    "" \
    "policy predicate matched" || true
  exit "$decision"
}
```

**Proposed block() function (DESIGN_RESULT from 57_§5.1):**
```bash
block() {
  local reason="$1"
  echo "BLOQUEADO por bash-firewall (P0): ${reason}" >&2
  echo "" >&2
  echo "  CONTEXTO PARA REVISIÓN HUMANA:" >&2
  echo "    Comando bloqueado: ${COMMAND}" >&2
  echo "    Razón de bloqueo: ${reason}" >&2
  echo "    Próxima acción sugerida: Revisar el comando contra la política relevante." >&2
  echo "    Ruta de escalación: docs/CONTROL_PLANE_HANDBOOK.md §12 (NH-10)" >&2
  echo "    Si clasificación es UNKNOWN: escalar según §12 antes de reintentar." >&2
  [ "${DRY_RUN:-false}" = "true" ] && { echo "[DRY_RUN] se habría bloqueado"; exit 0; }
  local decision=2
  stall_record_event \
    "bash-firewall.sh" \
    "DENY" \
    "STALL_POLICY" \
    "${reason}" \
    "${COMMAND}" \
    "" \
    "" \
    "policy predicate matched" || true
  exit "$decision"
}
```

**NOTE:** Exit code (2), stall_record_event call, and block/allow logic are UNCHANGED.
Only stderr output lines are added. DRY_RUN path is preserved.

### 4.3 READY-04 Test Plan

```
UNIT TEST:
  DRY_RUN=true ./bash-firewall.sh <<'EOF'
  {"tool_input":{"command":"cat .env"}}
  EOF
  Expected: see enhanced message with escalation path reference

REGRESSION TEST:
  Verify exit code is still 2 for any block (not 1, not 0).
  Verify DRY_RUN=true still exits 0 with [DRY_RUN] message.
  Verify stall_record_event is still called with same arguments.
  Run evals/maintenance.sh → 12/12 PASS.
```

### 4.4 READY-04 Rollback Procedure

```
git revert <READY-04 commit>
Reverts block() function to minimal format.
STALL_POLICY_LOG schema unchanged (stall_record_event args unchanged).
SEMANTIC ROLLBACK: COMPLETE.
```

---

## §5 — Combined Execution Plans

### 5.1 Recommended Implementation Order

```
If READY-02 + READY-04 both YES (both modify bash-firewall.sh):
  Implement in one commit to minimize diffs on the same file.
  Order: NH-09 block → REGEX_NORM block → enhanced block() format.

If READY-01 YES:
  Separate commit for rules/*.md changes.
  Reason: rules files are in a different risk category than hooks.

If READY-03 YES:
  Owner statement → update PROJECT_STATE.md → update EVIDENCE_REGISTRY.md (if required).
  Separate commit for documentation.

Recommended full commit sequence (Branch 5 — all four YES):
  Commit 1: [RESEARCH] READY-03: LABYRINTH-1 L1-C owner acceptance
  Commit 2: [CONFIG]  READY-01: AC-02 policy repairs (rules/*.md)
  Commit 3: [CONFIG]  READY-02 + READY-04: bash-firewall.sh Level-1 + enhanced messages
  Commit 4: [CONFIG]  PROJECT_STATE + ENGINE: post-authorization state update
```

### 5.2 Files NOT Allowed to Change Under Any Authorization

```
PROTECTED — must not be touched:
  docs/00_SYSTEM/EVIDENCE_REGISTRY.md      (ARCH-003; additive only with gate)
  .claude/hooks/secret-guard.sh            (not in scope of any READY decision)
  .claude/hooks/task-completed-evidence.sh (in READY-04 scope ONLY; no other changes)
  docs/MASTER_IMPLEMENTATION_PLAN.md       (phase contract; frozen)
  docs/00_SYSTEM/F9_OWNER_DECISIONS.md     (historical record; frozen)
  evals/maintenance.sh                     (must not be changed to pass tests)
  Any F7/F8/F9 evidence artifacts          (frozen per PROJECT_STATE.md)
  DECISION_REGISTRY.md                     (add new entries only; never modify existing)
```

---

## §6 — Expected Tests

### 6.1 Maintenance Suite

Run `evals/maintenance.sh` before and after each change. Expected: 12/12 PASS.
If any diagnostic fails: STOP; do not force pass; investigate root cause.

### 6.2 READY-02 Specific Tests

```
Must BLOCK:
  printenv ANTHROPIC_API_KEY
  printenv "ANTHROPIC_API_KEY"
  echo ${ANTHROPIC_API_KEY} | base64
  echo "${ANTHROPIC_API_KEY}" | base64
  echo $ANTHROPIC_API_KEY | base64  (already caught by existing? verify)

Must NOT BLOCK (false positive checks):
  git status
  ls -la
  npm test
  python3 script.py
  grep "error" /var/log/app.log | wc -l
  git commit -m "Fix bug"
  echo "The variable is named ANTHROPIC_API_KEY" (NOTE: this WILL block if P1' matches)
    → If it does: acceptable FP? requires decision.

Known NOT blocked (documented gaps):
  printenv 'ANTHROPIC_API_KEY' (single-quote L4 gap)
  A=$ANTHROPIC_API_KEY; echo $A | base64 (aliasing; accepted residual)
```

### 6.3 READY-01 Specific Tests

No automated tests (rules/*.md are not executable). Manual review:
- Verify each repair text matches 55_ §1.3 specification exactly.
- Re-run 56_§7 case tables manually to confirm SAFE/UNSAFE classifications unchanged.

### 6.4 READY-04 Specific Tests

```
Verify output format:
  grep "CONTEXTO PARA REVISIÓN HUMANA" <(DRY_RUN=true ./bash-firewall.sh <<< '...')
  grep "Ruta de escalación: docs/CONTROL_PLANE_HANDBOOK.md §12" <(DRY_RUN=true ./bash-firewall.sh <<< '...')
  
Verify exit codes:
  ./bash-firewall.sh <<< '{"tool_input":{"command":"cat .env"}}'; echo "Exit: $?"
  Expected: Exit: 2

  DRY_RUN=true ./bash-firewall.sh <<< '{"tool_input":{"command":"cat .env"}}'; echo "Exit: $?"
  Expected: Exit: 0
```

---

## §7 — Expected Regressions (None)

All changes are ADDITIVE or RESTRICTIVE. No existing SAFE command should become BLOCKED.

Potential false positives to check for READY-02:
- Commands containing the string "ANTHROPIC_API_KEY" as literal text (e.g., echo messages, documentation commands)
- These would be FP; severity = blocked benign command (not data loss)
- DRY_RUN=true allows testing before deployment

If FP rate is unacceptable: adjust P1'/P2' patterns; roll back is trivial (git revert).

---

## §8 — Rollback Procedures (Summary)

| Decision | Rollback method | Residual state after rollback | Completeness |
|---|---|---|---|
| READY-01 | git revert commit | 4 rules files back to PARTIAL | COMPLETE |
| READY-02 | git revert commit | bash-firewall.sh back to Layer 0 | COMPLETE (log entries persist) |
| READY-03 | Owner statement "LABYRINTH-1 reopened" | LABYRINTH-1 = OPEN; research resumes | COMPLETE |
| READY-04 | git revert commit | block() returns to minimal stderr | COMPLETE |
| ALL FOUR | git revert each (or one combined revert) | System returns to pre-authorization state | COMPLETE |

---

## §9 — Post-Change Verification

After any READY-02 or READY-04 implementation:

```
1. evals/maintenance.sh → 12/12 PASS required
2. DRY_RUN smoke tests → verify block/allow behavior
3. git diff HEAD → verify only expected lines changed
4. grep -r "COMMAND_NORM" .claude/hooks/ → verify not used in exec/eval/bash -c
5. STALL_POLICY_LOG → verify schema unchanged after test blocks
6. PROJECT_STATE.md → update LAST_GIT_CHECKPOINT

After READY-01:
1. Review each repair in context of the full rules file
2. Run 56_§7 case tables manually
3. Verify no existing prohibition removed

After READY-03:
1. Verify owner statement includes N definition
2. Update LABYRINTH-1 status in PROJECT_STATE.md and CCP_EXPLORATION_ENGINE.md
3. Verify L1-C condition count is correct
```

---

## §10 — Branch Simulation (Full)

### Branch 1: READY-03=YES, READY-01/02=NO

```
L1-C condition status:
  Condition 1 (P1'+P2'):    NOT SATISFIED
  Condition 2 (AC-02):      NOT SATISFIED
  Condition 3 (NH-10):      SATISFIED
  Condition 4 (risk accept): SATISFIED ← READY-03
  Condition 5 (empirical):   SATISFIED ← READY-03
  Total: 3/5

LABYRINTH-1: CONDITIONALLY_CLOSED (L1-C, B-path-only baseline)
  Meaning: research agenda stops; syntactic gaps still undetected; B path sole mitigation

Security posture: UNCHANGED (no new detection; same enforcement as today)
  Residual: same as current; syntactic bypass gaps still open

Research status: ACTIVE for H-01 monitoring; LABYRINTH-1 research stopped

Remaining decisions: READY-01/02 still available; no urgency
                     READY-04 still available

Next movement: Monitor H-01 (STALL_POLICY_LOG); revisit if trigger fires
               READY-01/02 can be proposed at any time with new authorization
```

### Branch 2: READY-01=YES, READY-03=YES, READY-02=NO

```
L1-C condition status:
  Condition 1 (P1'+P2'):    NOT SATISFIED
  Condition 2 (AC-02):      SATISFIED ← READY-01
  Condition 3 (NH-10):      SATISFIED
  Condition 4 (risk accept): SATISFIED ← READY-03
  Condition 5 (empirical):   SATISFIED ← READY-03
  Total: 4/5

LABYRINTH-1: CONDITIONALLY_CLOSED (L1-C, documentation baseline)
  Meaning: policies explicit; detection gaps still open; B path sole detection mitigation

Security posture: Improved policy quality; same detection coverage
  Agents and reviewers have clearer policy guidance

Research status: LABYRINTH-1 research stopped

Next movement: READY-02 available when authorized; monitor H-01
```

### Branch 3: READY-02=YES, READY-03=YES, READY-01=NO

```
L1-C condition status:
  Condition 1 (P1'+P2'):    SATISFIED ← READY-02
  Condition 2 (AC-02):      NOT SATISFIED
  Condition 3 (NH-10):      SATISFIED
  Condition 4 (risk accept): SATISFIED ← READY-03
  Condition 5 (empirical):   SATISFIED ← READY-03
  Total: 4/5

LABYRINTH-1: CONDITIONALLY_CLOSED (L1-C, detection baseline)
  Meaning: syntactic gaps closed; policies still PARTIAL

Security posture: Strongest detection coverage of any B-path scenario
  printenv/encoding-pipeline/quoted-variants now caught automatically

Research status: LABYRINTH-1 research stopped

Remaining: READY-01 still available; policies PARTIAL but patterns provide enforcement
           Asymmetry: enforcement is strong; policy documentation is weak

Next movement: READY-01 (improves policy quality); monitor H-01
```

### Branch 4: READY-01+02+03=YES, READY-04=NO

```
L1-C condition status:
  All 5 conditions: SATISFIED
  Total: 5/5

LABYRINTH-1: CONDITIONALLY_CLOSED (L1-C, minimal closure — complete)
  All L1-C conditions met; minimal L1-C closure achieved

Security posture: Maximum automated detection + best policy clarity
  Human review still requires consulting handbook §12 manually

Remaining: READY-04 available; improves UX; not required for security coverage

Next movement: Monitor H-01; READY-04 if human review friction becomes a problem
```

### Branch 5: READY-01+02+03+04=YES (Full Authorization)

```
L1-C condition status:
  All 5 conditions: SATISFIED

LABYRINTH-1: CONDITIONALLY_CLOSED (L1-C, strong closure)
  All conditions met + enhanced human review quality

Security posture: Maximum within CCP Minimal Security Stack
  Layers 0-6 all operational
  Residual (aliasing, heredoc, numbered redirects, file-scripts) accepted under L1-C
  H-01 monitored; reactivation triggers defined (with N defined)

Research status: LABYRINTH-1 research stopped; AC-03 dormant until TRIGGER-4

Remaining unknowns: H-01 materiality (production); FP rate (production)
  These cannot be resolved without real usage.

Next movement:
  Operational: monitor STALL_POLICY_LOG for H-01 events
  Investigative: CDT-02 (if authorized); AC-03 (if TRIGGER-4 fires)
  Phase: F10+ if new concrete problem emerges (F9-D05=A)
```

---

## §11 — Exact Files Expected to Change

### Per Decision

```
READY-01 YES:
  .claude/rules/security.md      (POL-05 text addition — ~3 lines)
  .claude/rules/no-go.md         (POL-08 text addition — ~3 lines)
  .claude/rules/compliance.md    (POL-10 text addition — ~5 lines)
  .claude/rules/git-policy.md    (POL-13 text addition — ~5 lines)

READY-02 YES:
  .claude/hooks/bash-firewall.sh (NH-09 block ~5 lines; REGEX_NORM block ~8 lines)

READY-03 YES:
  PROJECT_STATE.md               (LABYRINTH-1 status update; N value)
  docs/00_SYSTEM/CCP_EXPLORATION_ENGINE.md (frontier update)
  docs/00_SYSTEM/EVIDENCE_REGISTRY.md (new entry if required by ARCH-004)

READY-04 YES:
  .claude/hooks/bash-firewall.sh (block() function — enhanced stderr; ~6 lines added)
  .claude/hooks/task-completed-evidence.sh (enhanced stderr for gate failures; ~6 lines)

ALL FOUR YES — combined expected changes:
  .claude/rules/security.md
  .claude/rules/no-go.md
  .claude/rules/compliance.md
  .claude/rules/git-policy.md
  .claude/hooks/bash-firewall.sh
  .claude/hooks/task-completed-evidence.sh
  PROJECT_STATE.md
  docs/00_SYSTEM/CCP_EXPLORATION_ENGINE.md
  docs/00_SYSTEM/EVIDENCE_REGISTRY.md (if evidence gate required)
```

---

## §12 — Files Explicitly NOT Allowed to Change

Under any READY-01/02/03/04 authorization:

```
NEVER TOUCH:
  docs/MASTER_IMPLEMENTATION_PLAN.md
  docs/00_SYSTEM/F9_OWNER_DECISIONS.md
  docs/00_SYSTEM/F9_RESEARCH.md
  docs/00_SYSTEM/POST_F7_AUDIT_REPORT.md
  docs/00_SYSTEM/F7_F8_F9_TECHNICAL_HISTORY.md
  evals/maintenance.sh              (must not be modified to force PASS)
  .claude/hooks/secret-guard.sh     (not in READY scope)
  DECISION_REGISTRY.md              (no new entries unless explicitly authorized)
  .claude/settings.json             (no permissions changes)
  Any file not listed in §11 above

REASON: These files are frozen (historical evidence), out-of-scope, or protected by
  separate authorization requirements.
```

---

**END — 59A_EXECUTION_REHEARSAL.md**

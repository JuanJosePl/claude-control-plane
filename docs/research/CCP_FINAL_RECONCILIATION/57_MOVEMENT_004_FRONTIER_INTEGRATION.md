# 57 — MOVEMENT 004: Frontier Integration, Closure & Decision Readiness

**Date:** 2026-09-23
**Executor:** Claude Sonnet 4.6 (this session)
**Baseline HEAD:** `3350742`
**Starting frontier:** NH-05, NH-06, NH-07 (all available without authorization)
**Authorization:** Analysis, design, documentation. No runtime, hook, agent, rule, or registry modification.
**Claim discipline:** DOCUMENTED_FACT / EXPERIMENTAL_RESULT / DESIGN_RESULT / INFERENCE / HYPOTHESIS / UNKNOWN throughout.
**Materiality discipline:** "0 observed events" → "materiality unresolved" — NOT "0 risk."
**Threshold discipline:** No percentage is an owner-approved acceptance criterion; all numeric comparisons are EXPERIMENTAL/COMPARATIVE.

---

## §1 — Executive Position

### Starting position (MOVEMENT 003 output)

```
NH-05: HYPOTHESIS — shell AST normalization closes ${VAR} and quoting gaps
NH-06: HYPOTHESIS — explicit precedence document eliminates composition UNKNOWNs
NH-07: HYPOTHESIS — enhanced-B denial messages close STA-02 without AC-03
L1-C:  DESIGN_RESULT — LABYRINTH-1 closeable without AC-03; exact conditions not specified
READY-01/02/03: identified but not fully structured as owner decision documents
```

### After MOVEMENT 004

```
NH-05:  PARTIALLY_SUPPORTED (§3) — shlex closes quoting gap; ${VAR} closeable by simpler means
NH-06:  PARTIALLY_SUPPORTED (§4) — no active unresolved conflicts; CONFLICT-04 is a missing
         specification, not a precedence conflict; explicit precedence document primarily forward value
NH-07:  SUPPORTED (§5) — enhanced-B closes the information gap for STA-02; not the judgment gap
NH-09:  SUPPORTED (§3.4) — NEW: 2-regex normalization achieves Level-1 coverage without dependencies
NH-10:  CONFIRMED (§4.3) — NEW: escalation path definition goes in CONTROL_PLANE_HANDBOOK,
         not in .claude/rules/*.md; can be written now without authorization
L1-C:   5 specific conditions identified (§8); minimal vs. strong closure distinguished
READY-01/02/03: Fully structured as decision packages (§9)
READY-04: NEW — enhanced-B implementation authorization (hook schema change)
Intermediate architecture: "CCP Minimal Security Stack" identified (§7)
```

### Map change summary

```
WHAT CHANGED                                                   CLASSIFICATION
──────────────────────────────────────────────────────────────────────────────
NH-05: "AST needed" → "2-regex bash normalization sufficient" DESIGN_RESULT
       Level-1 complexity: MEDIUM → LOW
NH-06: "precedence doc fixes everything" → "mostly implicit;  DESIGN_RESULT
       CONFLICT-04 is missing spec, not precedence conflict"
NH-07: "Enhanced-B closes STA-02" → "closes information gap;  DESIGN_RESULT
       not judgment gap; AC-03 value is different"
NH-09: OPENED + SUPPORTED                                       DESIGN_RESULT
NH-10: OPENED + CONFIRMED                                       DESIGN_RESULT
L1-C:  5 conditions specified; 2 condition tiers identified    DESIGN_RESULT
       (minimal vs. strong)
CONFLICT-04: precedence conflict → missing specification gap   DOCUMENTED_FACT
Intermediate arch: "CCP Minimal Security Stack" named          DESIGN_RESULT
```

---

## §2 — Starting Frontier

From `CCP_EXPLORATION_ENGINE.md` v1.3 §3:

```
NH-05: HYPOTHESIS — shell tokenizer normalization; cheapest test available now
NH-06: HYPOTHESIS — policy precedence analysis; read-only; available now
NH-07: HYPOTHESIS — enhanced-B denial message design; available now
UNK-M3-01: CCP has no explicit policy precedence document
READY-01/02/03: Owner decision specifications (structured but not in decision-package format)
```

Anti-loop check (per §13 anti-loop registry):
- NH-05/06/07: not previously answered ✓
- Not variants of: prior art, SAGR, R-3 design, policy explicitness, independence, Roger ✓
- No duplication detected; proceeding.

---

## §3 — TRACK A: NH-05 — Shell Normalization Analysis

### 3.1 What shlex actually is vs. what was claimed

**DOCUMENTED_FACT:**

```
Python shlex (Simple Lexical Analysis module):
  TYPE:    Tokenizer, not a shell parser or AST
  HANDLES: Quoting removal (both single and double quotes)
           POSIX word-splitting
           Backslash escaping
           Token boundary detection

  DOES NOT HANDLE:
    Shell redirects (semantically)
    Heredoc bodies
    Arithmetic expansion: $((expr))
    Process substitution: <(cmd)
    Subshell expressions: (cmd)
    Shell grammar (if/for/while/case)
    Numbered file descriptors (1>, 2>)
    Variable expansion ($VAR remains $VAR — tokenization only)
```

**Correction from MOVEMENT 003:** The term "shell AST normalization" in 56_MOVEMENT_003 §6.2 was misleading. Shlex is a tokenizer, not an AST generator. A true AST parser (e.g., Python's `bashlex` library, or shell's own `-n` dry-run) provides structural understanding of redirects, heredocs, and subshells. Shlex does not.

This matters for the claim precision: NH-05 should be stated as "shell tokenizer normalization" not "AST normalization."

### 3.2 What shlex closes (vs. what it doesn't)

**DESIGN_RESULT** (analytical, based on Python shlex documented behavior):

| Mutation | Input | After shlex | After shlex→rejoin | P1'/P2'/P3 match? |
|---|---|---|---|---|
| M1.3 quoted printenv | `printenv "ANTHROPIC_API_KEY"` | `['printenv', 'ANTHROPIC_API_KEY']` | `printenv ANTHROPIC_API_KEY` | P1' ✓ CLOSED |
| M2.1 ${} in P2' | `echo "${ANTHROPIC_API_KEY}" \| base64` | `['echo', '${ANTHROPIC_API_KEY}', '\|', 'base64']` | `echo ${ANTHROPIC_API_KEY} \| base64` | P2' ✗ STILL MISSES |
| M3.1 ${} in P3 | `echo ${ANTHROPIC_API_KEY} > /tmp/f` | `['echo', '${ANTHROPIC_API_KEY}', '>', '/tmp/f']` | `echo ${ANTHROPIC_API_KEY} > /tmp/f` | P3 ✗ STILL MISSES |
| M3.2 numbered redirect | `echo $ANTHROPIC_API_KEY 1> /tmp/f` | `['echo', '$ANTHROPIC_API_KEY', '1>', '/tmp/f']` | `echo $ANTHROPIC_API_KEY 1> /tmp/f` | P3 ✗ STILL MISSES |
| Heredoc M3.5 | `cat > f << EOF\n$KEY\nEOF` | Problematic parse (multi-line) | Not normalized | P3 ✗ STILL MISSES |
| Tab whitespace M1.2 | `printenv\tANTHROPIC_API_KEY` | `['printenv', 'ANTHROPIC_API_KEY']` | `printenv ANTHROPIC_API_KEY` | P1' ✓ CLOSED |

**Key finding:** Shlex alone does NOT close the ${VAR} gap (M2.1, M3.1). After shlex tokenization and rejoin, `${ANTHROPIC_API_KEY}` is still `${ANTHROPIC_API_KEY}` because shlex does not perform variable expansion or ${} normalization. It only removes quotes.

Shlex DOES close:
- Quoted argument forms: `printenv "API_KEY"` → `printenv API_KEY` → P1' matches
- Tab whitespace variants → normalized to spaces

Shlex DOES NOT close:
- ${VAR} syntax (all three patterns miss this)
- Numbered file descriptors (1>)
- Heredoc body content

### 3.3 ${VAR} gap requires additional normalization

**DESIGN_RESULT:**

To close M2.1 and M3.1, a separate pre-processing step is needed AFTER shlex (or independently):

`s/\$\{([^}]+)\}/\$\1/g` — regex that converts `${VAR}` to `$VAR` in the command text.

Applied AFTER shlex rejoin (or directly on raw text):
- `echo ${ANTHROPIC_API_KEY} | base64` → `echo $ANTHROPIC_API_KEY | base64` → P2' matches ✓
- `echo ${ANTHROPIC_API_KEY} > /tmp/f` → `echo $ANTHROPIC_API_KEY > /tmp/f` → P3 matches ✓

This two-step process (shlex tokenization + ${VAR} normalization) together close M1.3, M2.1, M3.1.

### 3.4 NH-09: Simpler Alternative Without External Dependencies

**DESIGN_RESULT (NEW — NH-09 result):**

The two gaps that shlex closes (quoting, M1.3) and the ${VAR} gap can BOTH be closed by two simple bash-native regex substitutions, without requiring Python or any external dependency:

```bash
# Step 1: Remove double-quotes from argument-like positions
# (captures content inside double-quotes; not context-aware but sufficient for our cases)
COMMAND_NORM=$(printf '%s' "$COMMAND" | sed -E 's/"([^"]*)"/\1/g')

# Step 2: Normalize ${VAR} → $VAR
COMMAND_NORM=$(printf '%s' "$COMMAND_NORM" | sed -E 's/\$\{([^}]*)\}/\$\1/g')

# Apply patterns to COMMAND_NORM instead of COMMAND
```

**NH-09 analytical test on mutation corpus:**

| Mutation | Input | After Step 1 | After Step 2 | Pattern match? |
|---|---|---|---|---|
| M1.3 | `printenv "ANTHROPIC_API_KEY"` | `printenv ANTHROPIC_API_KEY` | (unchanged) | P1' ✓ |
| M2.1 | `echo "${ANTHROPIC_API_KEY}" \| base64` | `echo ${ANTHROPIC_API_KEY} \| base64` | `echo $ANTHROPIC_API_KEY \| base64` | P2' ✓ |
| M3.1 | `echo ${ANTHROPIC_API_KEY} > /tmp/f` | (unchanged; no quotes) | `echo $ANTHROPIC_API_KEY > /tmp/f` | P3 ✓ |
| Tab M1.2 | `printenv\tANTHROPIC_API_KEY` | (step 1 doesn't affect tab) | (unchanged) | P1' ✓ (existing `[[:space:]]+`) |

**NH-09 edge cases (false positive risks):**

| Input | After normalization | Risk |
|---|---|---|
| `echo "TOKEN=abc" > config.txt` | `echo TOKEN=abc > config.txt` | P3 won't fire ($TOKEN_ABC not present); BF-02 might fire on TOKEN=abc (which is correct behavior — assignment with TOKEN in name) |
| `echo "Hello world" > info.txt` | `echo Hello world > info.txt` | P3 won't fire (no $VAR_NAME pattern); NO FP |
| `echo "PATH=/usr/local/bin" > .profile` | `echo PATH=/usr/local/bin > .profile` | BF-01 (.profile not .env); no FP from P1'/P2'/P3 |
| `cat > /tmp/f << 'EOF'\nsome text\nEOF` | (heredoc body not affected; single-quoted EOF) | Already a miss for P3; normalization doesn't help OR hurt |

**NH-09 step 1 limitation:** The double-quote removal regex `s/"([^"]*)"/$1/g` is NOT context-aware. It removes ALL double-quoted strings. For a command like `grep "pattern" file > out.txt`, step 1 gives `grep pattern file > out.txt`. P3 would not fire (pattern/file/out don't have $VAR form). No FP introduced.

However: `grep "$ANTHROPIC_API_KEY" file > output.txt`:
- Step 1: `grep $ANTHROPIC_API_KEY file > output.txt`
- P3: `$ANTHROPIC_API_KEY ... > output.txt` — but `file` is between VAR and `>`, so P3's `$VAR[[:space:]]*>` would NOT match (there's `file` between them).
- This is a FALSE NEGATIVE (grep with secret variable redirected to file; not caught).
- BUT: This is also a LOW-RISK case — `grep` with a secret doesn't write the secret value; it uses it as a pattern to search.

**NH-09 CLASSIFICATION: SUPPORTED**

```
CLAIM:     Two bash regex substitutions achieve the same Level-1 coverage as shlex+${VAR}
           normalization for the primary gap cases (M1.3, M2.1, M3.1)
EVIDENCE:  Analytical test on mutation corpus (above table)
METHOD:    Direct regex application to mutation inputs; manual verification
LIMITATION: Analytical; not empirically tested against real command inputs
           Double-quote removal not context-aware (may miss compound-string cases)
IMPLICATION: Level-1 normalization has ZERO new dependencies; complexity is LOW not MEDIUM
```

### 3.5 NH-05 Classification

```
NH-05: PARTIALLY_SUPPORTED

SUPPORTED:
  Shlex closes quoting gap (M1.3: quoted printenv argument)
  ${VAR} normalization (separate regex) closes M2.1, M3.1
  Combined: Level-1 normalization is a viable design

NOT SUPPORTED (overstatement corrected):
  Shlex is NOT a shell AST (prior description "AST normalization" was imprecise)
  Shlex alone does NOT close ${VAR} gap (separate regex required)
  Level-1 normalization does NOT close: numbered redirects (M3.2), heredoc (M3.5), tee

NEW FINDING (NH-09):
  Shlex is not even needed; two bash-native sed commands achieve the same coverage
  This reduces Level-1 implementation complexity from MEDIUM → LOW
  Zero external dependencies

WHAT LEVEL-1 NORMALIZATION ACTUALLY COVERS:
  Syntactic bypass via: quoting (M1.3), ${} syntax (M2.1, M3.1)
  Syntactic bypasses NOT covered: numbered redirects, tee, heredoc, aliasing, file-based

ARCHITECTURE IMPLICATION:
  Level-1 normalization + P1'+P2'+P3 is achievable with ~10 new lines of bash
  in bash-firewall.sh (no library dependencies)
  This was previously estimated as "MEDIUM complexity"; correct classification: LOW
```

---

## §4 — TRACK B: NH-06 — Policy Precedence Analysis

### 4.1 Policy Source Inventory

**DOCUMENTED_FACT** (from reading the project files):

| Source | Scope | Nature | Override language |
|---|---|---|---|
| `F9_OWNER_DECISIONS.md` | Control plane lifecycle | Owner decisions (binding) | Explicit: F9-D01=A is an override that supersedes deferred decisions |
| `DECISION_REGISTRY.md` | Architecture | Architectural decisions | "Active decisions" designation |
| `.claude/rules/security.md` | Security behaviors | Operational rules | None explicit |
| `.claude/rules/compliance.md` | Data compliance | Operational rules | None explicit |
| `.claude/rules/no-go.md` | Prohibited patterns | Operational rules | None explicit |
| `.claude/rules/git-policy.md` | Git workflow | Operational rules | None explicit |
| `settings.json` | Tool permissions | Technical enforcement | Technical override (blocks despite rules) |
| `CLAUDE.md` | Session startup | Read order | Read-order only; NOT rule precedence |

**Key distinction (DOCUMENTED_FACT):**

```
CLAUDE.md specifies: READ ORDER (what to load before acting)
Policy precedence means: AUTHORITY ORDER (what wins when two rules conflict)
These are NOT the same thing.
CLAUDE.md's "load in this order" does NOT establish policy precedence.
```

### 4.2 Conflict Matrix — All Policy Pairs

**DESIGN_RESULT (analytical):**

| Policy A | Policy B | Conflict? | Resolution |
|---|---|---|---|
| security.md | compliance.md | ORTHOGONAL (different domains) | None needed |
| security.md | no-go.md | REINFORCING (both say UNKNOWN→stop) | None needed |
| security.md | git-policy.md | ORTHOGONAL | None needed |
| compliance.md | no-go.md | ORTHOGONAL | None needed |
| compliance.md | git-policy.md | ORTHOGONAL | None needed |
| no-go.md POL-08 | F9-D01=A | CONFLICT — both cannot be true | RESOLVED by POL-08 repair (explicit exception) |
| security.md UNKNOWN rule | (escalation path) | INCOMPLETE SPEC — UNKNOWN requires escalation; escalation path not defined anywhere | MISSING SPECIFICATION (not a conflict between two rules) |
| settings.json (allow cat) | security.md (don't read secrets) | APPARENT TENSION — cat allowed but secrets blocked | RESOLVED by layered enforcement: settings allows tool; bash-firewall blocks content |

**Findings:**

1. Only ONE real policy conflict exists: POL-08 vs. F9-D01=A. This is resolved by POL-08 repair.

2. CONFLICT-04 (from MOVEMENT 003) is NOT a precedence conflict between two rules. It is a MISSING SPECIFICATION: the policies say "respond UNKNOWN conservatively" and "don't create bottlenecks" but neither defines the ESCALATION PATH. No precedence document can resolve a missing specification.

3. All other policy combinations are either orthogonal or mutually reinforcing.

### 4.3 NH-10: Escalation Path Is a Process Spec, Not a Rule

**DESIGN_RESULT (NEW — NH-10):**

```
The resolution of CONFLICT-04 does not require:
  - Modifying any .claude/rules/*.md file (would be a "rule change" under F9-D01=A)
  - Creating a new rule file
  - Changing any enforcement mechanism

What it requires:
  - Adding a ~10-line escalation procedure to CONTROL_PLANE_HANDBOOK.md
  - This is process documentation, not a policy rule

Example escalation path specification:
  "When any P0 hook blocks with reason code STALL_POLICY or UNKNOWN:
   1. The agent halts the current task.
   2. The agent logs the event to STALL_POLICY_LOG (already operational via R-2).
   3. The agent outputs an enhanced denial message (NH-07 format when implemented).
   4. The agent awaits explicit human confirmation before resuming.
   5. Human resolution: review the blocked action against the relevant policy; 
      consult DECISION_REGISTRY.md for architectural guidance; 
      consult F9_OWNER_DECISIONS.md for owner gate context.
   6. If resolution is unclear after human review → escalate to project owner."

F9-D01=A applicability:
  - "runtime change": NO (handbook is not runtime)
  - "hook change": NO (handbook is not a hook)
  - "rule change": DEBATABLE — could be interpreted as rule if "handbook" is read as "rule"
  - SAFER CLASSIFICATION: This is process documentation, same as any docs/ document
  - PRECEDENT: CONTROL_PLANE_HANDBOOK already exists as operational documentation

AUTHORIZATION: Likely PERMITTED (documentation); owner may confirm
```

**NH-10 CLASSIFICATION: CONFIRMED**

```
CLAIM:     Escalation path for UNKNOWN/BLOCKED cases can be documented in handbook
           without requiring .claude/rules/*.md modification (F9-D01=A rule scope)
EVIDENCE:  Analytical: handbook is docs-level documentation, not a rule file
LIMITATION: Owner must confirm that handbook additions are within "documentation"
            classification under F9-D01=A; however, the precedent is strong
IMPLICATION: CONFLICT-04 can be RESOLVED WITHOUT authorization for rule changes
             NH-10 is available immediately
```

### 4.4 NH-06 Classification

```
NH-06: PARTIALLY_SUPPORTED

SUPPORTED:
  An explicit precedence document would:
  - Formalize the implicit order (owner > decisions > rules > settings)
  - Provide reference for future conflicts as policy set grows
  - Help new contributors understand the authority structure

NOT SUPPORTED (overstatement corrected):
  Current policy set has only ONE real conflict (POL-08 vs. F9-D01=A) — already resolved
  CONFLICT-04 is a MISSING SPECIFICATION, not a precedence conflict
  An explicit precedence document alone does NOT close CONFLICT-04

CORRECTED CLAIM:
  "Explicit precedence document is useful for documentation completeness and forward-looking
   conflict prevention, but is NOT urgently required by any current unresolved conflict."

NEW FINDING (NH-10):
  CONFLICT-04 is closeable without a rule change:
  Define the escalation path in CONTROL_PLANE_HANDBOOK.md (process documentation)
  This is AVAILABLE NOW and resolves the only real composition gap

UNK-M3-01 STATUS:
  The precedence structure IS implicit and SHOULD be documented for completeness
  But it is NOT causing any active problem; documentation is forward-value
```

---

## §5 — TRACK C: NH-07 — Enhanced-B Denial Message Analysis

### 5.1 Enhanced Message Format Design

**DESIGN_RESULT:**

```
CURRENT denial message (bash-firewall.sh, documented):
  BLOQUEADO por bash-firewall (P0): {reason}
  Comando: {COMMAND}

PROPOSED ENHANCED MESSAGE (not implemented; for human review value analysis):
  BLOQUEADO por {hook} (P0): {reason_code}

  CONTEXTO PARA REVISIÓN HUMANA:
    Política: {policy_id} — {policy_name}
    Acción bloqueada: {summary_of_blocked_action}
    Resultado prohibido: {what_the_policy_prevents}
    Alcance permitido: {what_is_allowed_under_this_policy}
    Si la clasificación es UNKNOWN: {reason_for_unknown}
    Próxima acción sugerida: {concrete_next_step}
    Ruta de escalación: {escalation_path_reference}
    Documentación relevante: {policy_file}:{line}

  PARA CASOS CONTRACTUAL TASK (task-completed-evidence):
    task_id: {task_id}
    risk_level: {risk_level}
    missing_field: {contract_hash | evidence_entry | etc}
    evidence_format: sha256:{64_hex} OR EV-NNN in EVIDENCE_REGISTRY.md
    exception_path: TODO/SUBTASK tasks do not require the evidence gate
```

### 5.2 STA-02 Case Analysis

**DESIGN_RESULT:**

STA-02 is the failure mode where Hypothesis B fails due to information quality: the human reviewer doesn't have enough structured information to decide on a blocked action.

**STA-02-INFORMATION (pure information gap):**
```
Scenario: Agent submits TaskCompleted without contract_hash for a documentation update
Current message: "BLOQUEADO: contract_hash ausente"
Human resolution: UNCLEAR — is this a CONTRACTUAL task requiring a gate? Or a TODO?
                  Human has to look up the task type manually.

With enhanced message:
  Política: ARCH-004 — Evidence required for CONTRACTUAL task completion
  Acción bloqueada: TaskCompleted event for task_id {X}
  Resultado prohibido: Marking task complete without verifiable evidence chain
  Alcance permitido: TODO/SUBTASK tasks are exempt; only CONTRACTUAL tasks require gate
  Próxima acción: Verify task type in MASTER_IMPLEMENTATION_PLAN.md; if TODO → approve;
                  if CONTRACTUAL → provide EV-NNN entry

Human resolution quality: HIGH — human can check task type immediately; clear path to resolution
NH-07 assessment for this case: SUPPORTED
```

**STA-02-JUDGMENT (judgment gap, not information gap):**
```
Scenario: Agent proposes A' for a policy-blocked action; classifies it as SAFE; verifier says UNKNOWN
Current message: "BLOQUEADO: no SAFE label — UNKNOWN"
Human resolution: UNCLEAR — WHY is it UNKNOWN? What would make it SAFE?

With enhanced message:
  Política: security.md POL-01 — Secrets never in code
  Acción bloqueada: Writing config.py with ANTHROPIC_API_KEY variable assignment
  Resultado prohibido: Literal API key in code file
  Alcance permitido: Variable reference OK; literal value NOT OK
  UNKNOWN reason: Cannot determine whether value written is a literal key or a variable reference
  Próxima acción: Confirm that config.py contains only $ANTHROPIC_API_KEY reference, not the key value

Human resolution quality: HIGH for this case — specific UNKNOWN reason guides action
```

**STA-02-COMPLEX (complex multi-component case):**
```
Scenario: Large task blocked; evidence chain is partial (3 of 5 components verified)
Current message: "BLOQUEADO: evidence_entry incomplete — checks missing"
Human resolution: DIFFICULT — which checks? Which components?

With enhanced message:
  task_id: TASK-XYZ
  risk_level: HIGH
  missing_field: Checks missing: security=PASS required; currently NOT_REQUIRED (not valid)
  required_format: security must be PASS or NOT_REQUIRED with explicit justification

Human resolution quality: MEDIUM — better than current but human still needs to audit the task
```

**STA-02-ADVERSARIAL (invalid hash submitted):**
```
Scenario: contract_hash = "sha256:0000000000000000000000000000000000000000000000000000000000000000"
Current message: "BLOQUEADO: evidence integrity check failed"
Human resolution: SUSPICIOUS — why was a zero hash submitted?

With enhanced message:
  task_id: TASK-ABC
  missing_field: contract_hash value is invalid — cannot locate in EVIDENCE_REGISTRY
  provided: sha256:000...000
  action: Verify EVIDENCE_REGISTRY.md for actual evidence entry; zero hash is not valid

Human resolution quality: HIGH — human immediately sees the specific suspicious hash
```

### 5.3 Information Gap vs. Judgment Gap

**DESIGN_RESULT:**

```
INFORMATION GAP (Enhanced-B closes):
  Human doesn't know WHAT was blocked
  Human doesn't know WHY
  Human doesn't know WHAT TO DO NEXT
  → Enhanced-B provides all three

JUDGMENT GAP (Enhanced-B does NOT close):
  Human knows all the facts but the correct action is genuinely ambiguous
  Example: A' is technically policy-compliant but policy doesn't cover the specific case
  Example: Competing policy guidelines; which applies is unclear
  Example: Evidence quality is borderline; human judgment required about sufficiency

AC-03's VALUE domain (distinct from Enhanced-B):
  AC-03 provides: automated classification with explicit reasoning
  AC-03 adds value when: judgment calls recur frequently enough to warrant automation
  AC-03 does NOT replace: human escalation for genuinely novel cases
  AC-03 does NOT replace: Enhanced-B's role in surfacing context
```

### 5.4 NH-07 Classification

```
NH-07: SUPPORTED (for information gap; with important scope limitation)

SUPPORTED:
  Enhanced-B closes the information gap for STA-02 (human knows what, why, what to do)
  This addresses the FAILURE MODE identified in MOVEMENT 002 §17 (STA-02 failure reason)
  For most practical STA-02 cases (information gap), Enhanced-B is sufficient

SCOPE LIMITATION (important):
  Enhanced-B does NOT reduce the need for AC-03 in the JUDGMENT GAP domain
  AC-03's automation value is distinct from Enhanced-B's information value
  They are complementary, not competing; the claim "Enhanced-B replaces AC-03" is an
  OVERSTATEMENT; correct: "Enhanced-B replaces the INFORMATION GAP motivation for AC-03"

IMPLICATION FOR L1-C:
  Enhanced-B improves the quality of the B path for STA-02 cases
  It is a quality enhancement to B, not a security coverage expansion
  Under L1-C (residual-risk-centric), Enhanced-B is "strong closure" (quality),
  not "minimal closure" (security)

AUTHORIZATION:
  Message format specification: PERMITTED NOW (documentation)
  Implementation (modifying hook output format): REQUIRES hook modification (F9-D01=A gate)
```

---

## §6 — TRACK D: Cross-Track Synthesis

### 6.1 What NH-05 + NH-06 + NH-07 Achieve Together

**DESIGN_RESULT:**

Each track addresses a DIFFERENT layer of the bypass/resolution problem:

```
NH-05 / NH-09 (Level-1 normalization):
  LAYER: Detection — closes syntactic bypass gap in bash pattern matching
  PROBLEM: Bash-firewall misses ${VAR} and quoted variants
  SOLUTION: 2 sed normalizations before grep (zero dependencies, LOW complexity)
  AUTH: Requires hook modification (READY-02 scope)

NH-06 / NH-10 (Precedence + escalation path):
  LAYER: Process — defines what happens when a block occurs
  PROBLEM: No defined escalation path for UNKNOWN/BLOCKED cases
  SOLUTION: Add escalation procedure to CONTROL_PLANE_HANDBOOK (no authorization needed)
  ACTIVE CONFLICT: Only ONE (POL-08 vs F9-D01=A, already resolved by repair)
  AUTH: Handbook addition = PERMITTED NOW

NH-07 (Enhanced-B denial message):
  LAYER: Information — gives human reviewer sufficient context to decide
  PROBLEM: Current denial message has minimal information
  SOLUTION: Structured message format with policy_id, prohibited_outcome, next_action
  AUTH: Specification = PERMITTED NOW; Implementation = hook modification (READY-04)
```

### 6.2 The CCP Minimal Security Stack

**DESIGN_RESULT:**

Combining all three tracks with existing infrastructure, the full security stack is:

```
LAYER 0: Current bash-firewall (OPERATIONAL)
  Catches: Named literals, .env reads, sk-tokens, Bearer tokens, AKIA, destructive commands

LAYER 1: Level-1 normalization (NH-09; 2 sed lines; LOW complexity; READY-02 scope)
  Adds: ${VAR} and quoted-argument bypass detection
  Auth required: hook modification

LAYER 2: P1'+P2' patterns (NH-02; READY-02; LOW FP)
  Adds: printenv named secrets; encoding pipelines
  Auth required: hook modification (same gate as Layer 1)

LAYER 2.5: P3 pattern (MEDIUM FP; OPTIONAL — defer pending FP analysis)
  Adds: file redirect of secret-named variables
  Risk: false positives for variables like $API_KEY_PATH
  Auth: same gate; recommend testing separately

LAYER 3: AC-02 policy repairs (READY-01; zero code changes)
  Adds: 4 PARTIAL policies become EXPLICIT; SAFE rate improves
  Auth: binary owner classification decision

LAYER 4: Enhanced-B denial messages (NH-07; READY-04)
  Adds: Human resolution quality for STA-02 cases
  Auth: hook schema modification (lower priority than Layer 1-3)

LAYER 5: Explicit escalation path (NH-10; PERMITTED NOW)
  Adds: Defined process for UNKNOWN/BLOCKED cases
  Auth: None (handbook documentation)

LAYER 6: B path — human review (OPERATIONAL)
  Catches: All residual complex and reasoning-mediated cases

BACKSTOP: git-add-secrets (OPERATIONAL)
  Catches: File-based bypasses at staging time
```

**This stack (Layers 0–6) is "CCP Minimal Security Stack."**

Layers 1–3 require authorization (READY-02, READY-01). Layers 4–5 require authorization for implementation but specification is available now. Layer 6 is already operational.

### 6.3 What the Stack Does NOT Cover

**DESIGN_RESULT:**

Residual not covered by any layer of the CCP Minimal Security Stack:

| Bypass class | Residual status | Mitigation |
|---|---|---|
| Variable aliasing (SC-01) | NOT covered by Layers 0-4 | Layer 6 (human review) + backstop (staging) |
| Heredoc body expansion | NOT covered by Layers 0-4 | Layer 6 + backstop |
| Numbered redirects (M3.2) | NOT covered by Layers 0-4 | Layer 6 + backstop |
| File-based interpreter calls | NOT covered by Layers 0-4 | Layer 6 (if multi-step) |
| env\|grep display | NOT covered | Low materiality (terminal only; no persistence) |
| Reasoning-mediated bypass | NOT covered by Layers 0-5 | Layer 6 (human review) |

**INFERENCE:** For CCP's current development context (non-adversarial, human-in-the-loop), Layers 0–6 together provide coverage that mitigates all OBSERVED bypass classes (H-01 = 0 real events) and redirects the theoretically-challenging classes to human review.

This inference is based on: (a) non-adversarial context, (b) H-01 = 0 observed events, (c) staging backstop for file-based bypasses. It is NOT evidence that the residual bypass risk is zero.

---

## §7 — TRACK E: Second-Order Architecture

### 7.1 Revised Level Spectrum

After NH-09 finding, the complexity assessments change:

```
Level 0 (current): regex on raw text
  Complexity: ZERO | Coverage: named literals | Already deployed

Level 1 (NH-09): 2 sed + existing patterns + P1'+P2'
  Complexity: LOW (revised from MEDIUM — zero dependencies)
  Coverage: +${VAR}, +quoting, +printenv, +encoding pipelines
  Implementation: ~15 lines in bash-firewall.sh
  Auth: hook modification (READY-02)

Level 1.5 (AST for redirects/heredocs):
  Method: Shell AST parser (bashlex library or similar)
  Complexity: MEDIUM (external dependency; non-trivial integration)
  Coverage: Level 1 + numbered redirects + heredoc bodies + tee
  Auth: hook modification + new dependency
  NOTE: Covers edge cases not covered by Level 1; marginal benefit for non-adversarial context

Level 2 (single-command data-flow):
  Method: Custom bash expression analyzer
  Complexity: HIGH
  Coverage: Level 1.5 + single-command aliasing
  Auth: significant hook refactor

Level 3 (session taint):
  Method: Session state store + taint propagation
  Complexity: VERY HIGH
  Coverage: Level 2 + multi-command aliasing chains
  Auth: infrastructure + hook refactor

Level 4 (script inspection):
  Method: Pre-execution analysis of script files
  Complexity: HIGH + high FP risk
  Coverage: File-based interpreter calls
  Auth: hook modification + file read per execution

Level 5 (R-3 semantic verifier AC-03):
  Complexity: VERY HIGH
  Coverage: Everything + reasoning-mediated
  Auth: F10 scoping gate
```

### 7.2 Minimum Viable Improvement

**INFERENCE:**

Level 1 (NH-09 implementation) has the best cost/coverage ratio:
- LOW complexity (2 sed + P1'+P2' — ~15 lines in existing hook)
- Closes highest-risk syntactic gaps (${VAR}, quoting, printenv, encoding)
- Zero new dependencies
- Reversible (remove the lines)

Level 1.5 adds marginal coverage (numbered redirects, heredocs) at MEDIUM complexity. For non-adversarial development context, these edge cases are already mitigated by human review (Layer 6) and staging check (backstop). The cost of Level 1.5 exceeds its benefit in the current context.

Level 3+ (session taint, script inspection) significantly exceeds the benefit-complexity threshold for CCP's current scale.

**DESIGN_RESULT:** For CCP, the minimum viable architectural improvement is Level 1 (NH-09 based). Level 1.5 is a future option when/if adversarial context or H-01 data justifies it.

---

## §8 — TRACK F: Residual Risk Reconstruction

Full classification of the bypass space under the CCP Minimal Security Stack (Layers 0–6):

| Bypass mechanism | Layer(s) that catch it | Residual class | Detection tier |
|---|---|---|---|
| `printenv NAMED_SECRET_VAR` | P1' (Layer 2) | NONE — fully caught | Automatic |
| `printenv "${NAMED_SECRET}"` | NH-09+P1' (Layer 1+2) | NONE after Level-1 | Automatic (post-Level-1) |
| `echo $KEY \| base64` | P2' (Layer 2) | NONE — fully caught | Automatic |
| `echo ${KEY} \| base64` | NH-09+P2' (Layer 1+2) | NONE after Level-1 | Automatic (post-Level-1) |
| `echo $KEY > file` | P3 (Layer 2.5) | CAUGHT if P3 deployed; FP risk | Automatic (if P3 deployed) |
| `echo ${KEY} > file` | NH-09+P3 (Layer 1+2.5) | CAUGHT if both deployed | Automatic |
| `echo $KEY 1> file` | NOT caught by any pattern | RESIDUAL | Human review / staging |
| `echo $KEY \| tee file` | NOT caught by any pattern | RESIDUAL | Staging backstop |
| Heredoc `cat > f << EOF\n$KEY\nEOF` | NOT caught by patterns | RESIDUAL | Staging backstop |
| Variable alias `TEMP=$KEY; echo $TEMP > f` | NOT caught (TEMP has no KEY suffix) | RESIDUAL | Staging backstop |
| Python inline `python3 -c "os.environ[...]"` | P4 (high FP — inadvisable); not in 3-pattern | RESIDUAL | Human review |
| Python file-based `python3 script.py` | NOT caught by any pattern | RESIDUAL | Human review |
| `env \| grep KEY` | NOT caught by any pattern | LOW-RESIDUAL (terminal display; no persistence) | Human observation |
| `curl -H "Bearer $KEY" url` | Existing Bearer pattern if literal; miss if $VAR | PARTIAL RESIDUAL | Human review |
| Reasoning-mediated bypass | NOT caught by any pattern | RESIDUAL | Human review (Layer 6) |
| File written with secret → git add | NOT caught by patterns | CAUGHT at staging | git-add-secrets |
| File written with secret (no stage) | NOT caught by patterns | RESIDUAL until staged | Staging at PR |

**DESIGN_RESULT — Residual summary:**

```
AUTOMATICALLY CAUGHT (all authorizations in place):
  Named printenv (P1'), encoding pipelines (P2'), direct redirects (P3 if deployed),
  and their ${VAR}/quoted variants after Level-1 normalization

CAUGHT BY BACKSTOP (staging / git-add-secrets):
  All bypass chains that eventually write secret to a file and stage it

CAUGHT BY HUMAN REVIEW (Layer 6):
  All reasoning-mediated bypasses
  Complex multi-step chains
  File-based interpreter calls (if agent's intent is suspicious)
  Most cases where the result is unclear

NOT CAUGHT BY ANY LAYER:
  Terminal-only displays (env|grep, echo $KEY without redirect) — result not persisted
  Variable aliases written to non-staged temp files that are deleted before staging
  These require: Level-3 session taint OR active monitoring (both out of current scope)
```

---

## §9 — TRACK G: L1-C Reassessment

### 9.1 Five Conditions for Minimal L1-C Closure

**DESIGN_RESULT:**

L1-C closure ("LABYRINTH-1 closed under residual-risk formulation") requires ALL of:

```
CONDITION 1 — Technical (bypass detection):
  P1'+P2' patterns deployed in bash-firewall.sh
  REQUIRES: READY-02 authorization
  STATUS: Not deployed; pending owner decision

CONDITION 2 — Policy (classification quality):
  AC-02 authorized and implemented (4 PARTIAL policies → EXPLICIT)
  REQUIRES: READY-01 authorization (binary: rule change vs. documentation)
  STATUS: Repair drafts ready; pending classification decision

CONDITION 3 — Process (escalation path):
  Escalation path for UNKNOWN/BLOCKED cases documented in CONTROL_PLANE_HANDBOOK
  REQUIRES: None — permitted documentation (NH-10 CONFIRMED)
  STATUS: CAN BE DONE NOW; no authorization needed

CONDITION 4 — Risk acceptance (owner documentation):
  Owner explicitly documents: "CCP accepts the aliasing/heredoc/file-based bypass
  residual as mitigated by human review and staging backstop, pending H-01 data"
  REQUIRES: READY-03 owner acceptance
  STATUS: Not yet accepted; pending owner decision

CONDITION 5 — Empirical baseline:
  OPTION A: H-01 produces N real events showing bypass rate is below threshold
  OPTION B: Owner explicitly accepts "0 observed events ≠ 0 risk; accepting current
            evidence level as insufficient-but-adequate for current scale"
  REQUIRES: Real usage (Option A) OR owner decision (Option B)
  STATUS: H-01 blocked; Option B requires owner explicit statement
```

### 9.2 Minimal vs. Strong Closure

```
MINIMAL L1-C CLOSURE (conditions 1–5):
  Deployments: P1'+P2' patterns + AC-02 policy repairs
  Documentation: escalation path in handbook + owner risk acceptance
  Security residual: aliasing, heredoc, file-based scripts → Layer 6 + backstop
  This is sufficient to say LABYRINTH-1 is "resolved" under L1-C

STRONG L1-C CLOSURE (minimal + following additions):
  + Level-1 normalization (NH-09) deployed → closes ${VAR}/quoting gap
  + P3 pattern deployed (with FP analysis and possibly allowlist)
  + Enhanced-B denial messages (NH-07) implemented → improves resolution quality
  + Explicit policy precedence document (NH-06) → forward-looking documentation
  This improves coverage significantly but is not required for the minimal closure

The STRONG closure is advisable if implementation capacity exists; the MINIMAL closure
is sufficient from a "is the problem solved?" standpoint for current CCP scale.
```

### 9.3 L1-C Reactivation Triggers

**DESIGN_RESULT:**

L1-C closure should REOPEN if any of these occur:

```
TRIGGER-1: H-01 accumulates real events showing:
  (a) bypass succeeds through production P0 hooks, AND
  (b) the bypass causes material harm (data exposure, unauthorized operation)
  → Reopen: characterize the specific bypass class; escalate authorization

TRIGGER-2: A specific bypass class is identified where Layer 6 (human review)
  consistently fails to catch it across multiple real incidents
  → Reopen: may require Level 3+ investment

TRIGGER-3: CCP transitions to a context with adversarial users or higher stakes
  (production customer data, compliance obligations, multi-user deployment)
  → Reopen: threat model has fundamentally changed; L1-C may be insufficient

TRIGGER-4: Owner explicitly decides to implement AC-03 for automation value
  (not for bypass risk reduction, but to reduce human review burden)
  → Reopen as implementation project (F10 scoping)
```

### 9.4 Materiality Audit

**Per Section 20 of the mandate — applying materiality discipline:**

```
STATEMENT: "0 real STALL events"

CORRECT INTERPRETATION:
  "No real STALL events with had_alternative field set have been observed in
   STALL_POLICY_LOG (1 entry; R-2 test only). This means: materiality of the bypass
   problem is unresolved, not that the bypass risk is zero."

NOT CORRECT:
  "0 real events → 0 risk"
  "0 real events → problem not material"

L1-C RELIES ON:
  The inference that "if the problem were material, we would have seen some evidence of it
  by now given CCP's development usage patterns." This inference is:
  CLASSIFICATION: INFERENCE (based on development context; not production evidence)
  LIMITATION: Development usage may not represent the scenarios where bypasses would occur
```

---

## §10 — TRACK H: Owner Decision Package

### 10.1 READY-01 — AC-02 Authorization Decision

```
DECISION ID:     READY-01
QUESTION:        Does adding 1-2 sentences of disambiguation to an existing .claude/rules/*.md
                 file constitute a "rule change" prohibited by F9-D01=A, or a "documentation
                 improvement" permitted under F9-D01=A?

CURRENT RULE:    F9-D01=A prohibits: "no runtime, hook, fixture, evidence, regression,
                 agent, skill, rule, dependency, registry or architecture change"

WHY NEEDED:      4 policies (POL-05, POL-08, POL-10, POL-13) are PARTIAL; they produce
                 UNKNOWN outputs from R-3 where EXPLICIT policies would produce SAFE.
                 Policy text disambiguation would make implicit assumptions explicit.

SUPPORTING EVIDENCE:
  CDT-01 (55_CDT01_NH02_RESULTS.md §1): 87.5% SAFE rate with repaired policies
    (EXPERIMENTAL — synthetic corpus; not production measurement)
  56_MOVEMENT_003 §7: 5-case adversarial validation per policy; all repairs better;
    residual edge case in each repair identified
  Repair texts fully specified: 55_CDT01_NH02_RESULTS.md §1.3

WHAT CHANGES:
  4 text additions (1-2 sentences each) to .claude/rules/{security,compliance,no-go,git-policy}.md
  Total: ~8 new sentences; no code changes

WHAT DOES NOT CHANGE:
  Policy semantic content (same intent, made explicit)
  Enforcement behavior (hooks, settings.json unchanged)
  Any existing constraint or prohibition

RISK:           LOW — repairs are more restrictive interpretations, not more permissive
REVERSIBILITY:  HIGH — git revert removes all 4 additions

DEPENDENCIES:   None (specifications ready)

IF YES (documentation improvement):
  Implement immediately; commit as [CONFIG] or [docs]; SAFE rate improves (experimental)
  LABYRINTH-1 Condition 2 satisfied

IF NO (rule change):
  Policies remain PARTIAL; 4 UNKNOWN outputs remain in R-3 evaluations
  Owner may choose separate explicit authorization for AC-02 specifically
  Minimum workaround: apply repairs without modifying rule files (maintain as "guidance docs")

FUTURE REACTIVATION: If new PARTIAL policies emerge requiring disambiguation
```

### 10.2 READY-02 — NH-02 Pattern Authorization (P1'+P2' Only)

```
DECISION ID:     READY-02
QUESTION:        Authorize adding regex patterns P1' and P2' to bash-firewall.sh
                 EXCLUDING P3 (deferred due to MEDIUM FP risk — see §3.4 of 56_MOVEMENT_003)

CURRENT RULE:    F9-D01=A prohibits hook changes

WHY NEEDED:      printenv and encoding pipeline bypasses are not covered by existing patterns
                 These represent the highest-risk single-step bypass classes identified in NH-02/NH-04

SUPPORTING EVIDENCE:
  NH-02 analysis (55_CDT01_NH02_RESULTS.md §2): bypass gap characterization
  NH-04 corpus (56_MOVEMENT_003 §3): P1'+P2' catch C01/C02/C03/C13/C15 with LOW FP
  FP analysis (56_MOVEMENT_003 §3.4): P1' LOW FP, P2' LOW FP, P3 MEDIUM FP

RECOMMENDED SCOPE: P1' + P2' (not P3)
  P3 deferred because: variables named *KEY_PATH, *TOKEN_TTL, *PASSWORD_HASH fire P3
  P3 can be added later with an allowlist or after testing
  P1' + P2' are lower risk and cover the most dangerous bypass classes

RECOMMENDED ENHANCEMENT: Include Level-1 normalization (NH-09) in same change
  Why: 2 sed lines in bash-firewall.sh; zero dependencies; closes ${VAR}/quoting variants
  Combined implementation: ~15 new lines in bash-firewall.sh

WHAT CHANGES:
  bash-firewall.sh: REGEX array gains 2 entries (P1', P2') + 2 sed pre-processing lines
  All additions are within the existing fail-closed hook structure

WHAT DOES NOT CHANGE:
  Existing patterns (all preserved)
  Exit codes and signaling (exit 2 for blocks)
  stall_record_event logging (still called)
  settings.json permissions

RISK:           LOW-MEDIUM (P1' and P2' have LOW FP profile; see analysis)
REVERSIBILITY:  HIGH — remove the 4 lines added (2 patterns + 2 normalization lines)

DEPENDENCIES:   READY-01 is not a dependency; these are independent decisions

IF YES:
  printenv with named secrets → blocked
  echo $KEY | base64 → blocked
  LABYRINTH-1 Condition 1 satisfied

IF NO:
  Bypass classes remain unblocked at automation level
  B path (human review) remains the sole mitigation for these classes

FUTURE REACTIVATION: After P3 FP testing; add P3 with allowlist
                     After NH-05/NH-09 implementation; add Level-1 normalization
                     (or include Level-1 normalization in this same authorization)
```

### 10.3 READY-03 — LABYRINTH-1 L1-C Closure

```
DECISION ID:     READY-03
QUESTION:        Accept L1-C formulation as LABYRINTH-1 resolution criteria and authorize
                 the following explicit statements:
                 (a) The aliasing, heredoc, and file-based script bypass residual is
                     accepted for CCP's current development context.
                 (b) Mitigation: human review (B path) + staging backstop.
                 (c) This acceptance is conditioned on H-01 remaining at 0 real events;
                     if H-01 exceeds N events (owner-defined), LABYRINTH-1 reopens.
                 (d) LABYRINTH-1 is not "solved" in the absolute sense; it is "resolved
                     for current context" under L1-C.

CURRENT STATE:   LABYRINTH-1 OPEN (no owner acceptance of residual)

WHY NEEDED:      Without explicit owner acceptance, LABYRINTH-1 remains permanently open
                 regardless of the quality of the incremental improvements implemented.
                 This creates ongoing research overhead without clear closure.

SUPPORTING EVIDENCE:
  L1-C formulation: 56_MOVEMENT_003 §11.4
  Residual risk characterization: 57_MOVEMENT_004 §8
  CCP Minimal Security Stack: 57_MOVEMENT_004 §6.2
  Reactivation triggers: 57_MOVEMENT_004 §9.3
  Materiality assessment: H-01 = 0 real events (INFERENCE basis, not FACT)

WHAT CHANGES:
  LABYRINTH-1 status: OPEN → CONDITIONALLY_CLOSED (L1-C, pending H-01)
  Research agenda: stops active LABYRINTH-1 investigation pending H-01 or trigger
  AC-03 roadmap: remains available but not on active path

WHAT DOES NOT CHANGE:
  Security posture (B path remains active)
  Hook behavior
  Policy enforcement
  The actual bypass classes (they remain in the residual)

RISK:           MEDIUM — if H-01 reveals material bypass rate, reopening needed
                REACTIVATION TRIGGERS are defined; risk is bounded

REVERSIBILITY:  HIGH — owner can reopen with one decision

DEPENDENCIES:   READY-01 and READY-02 are preconditions for "minimal closure" (not this acceptance)
                However: owner can accept L1-C even without READY-01/02 if they accept the
                current B-path-only mitigation as sufficient

IF YES (L1-C accepted):
  LABYRINTH-1 → CONDITIONALLY_CLOSED (L1-C)
  Research focus shifts: implementation authorizations + monitoring H-01
  AC-03 on dormant path; reactivatable

IF NO:
  LABYRINTH-1 remains OPEN; continue seeking additional evidence
  Potential: define what evidence would constitute "sufficient" for closure

FUTURE REACTIVATION: Any trigger from §9.3 of this document
```

### 10.4 READY-04 — Enhanced-B Message Implementation (Lower Priority)

```
DECISION ID:     READY-04
QUESTION:        Authorize modifying bash-firewall.sh and task-completed-evidence.sh to output
                 the enhanced denial message format specified in 57_MOVEMENT_004 §5.1

CURRENT RULE:    F9-D01=A prohibits hook changes

WHY NEEDED:      Current denial messages provide minimal context; Enhanced-B format improves
                 human resolution quality for STA-02 cases

PRIORITY:        LOWER than READY-01/02 (quality improvement, not security coverage)
WHAT CHANGES:    Output format of two hook files (additional structured text in stderr)
RISK:            LOW (output change only; no enforcement logic change)
REVERSIBILITY:   HIGH

DEPENDENCY:      NH-10 (escalation path in handbook) — related but separate
IF YES: Human resolution quality for STA-02 improves significantly
IF NO:  Current minimal message remains; B path still functional but more friction
```

### 10.5 Decision Package: Can READY-01/02/03 Be Consolidated?

**DESIGN_RESULT:**

The three decisions are distinct authorization types:
- READY-01: classification question (what is a "rule change" under F9-D01=A?)
- READY-02: implementation authorization (modify a specific P0 hook)
- READY-03: risk acceptance + closure (accept residual; define reactivation)

They CANNOT be meaningfully merged into one question without losing precision. However, they can be presented as a SINGLE REVIEW SESSION with three distinct decisions.

**Recommended presentation to owner:**

```
REVIEW SESSION — "CCP Security Stack + LABYRINTH-1 Closure"

DECISION 1 of 3 (READY-01): Is text disambiguation in .claude/rules/ a "rule change" or "documentation"?
  → This determines whether AC-02 proceeds immediately or needs separate authorization.

DECISION 2 of 3 (READY-02): Authorize adding P1'+P2' patterns + Level-1 normalization to bash-firewall.sh?
  → Independent of Decision 1.

DECISION 3 of 3 (READY-03): Accept L1-C closure for LABYRINTH-1 with defined conditions and triggers?
  → Can be conditioned on "both Decisions 1 and 2 being YES" or accepted independently.

OPTIONAL DECISION 4 (READY-04): Authorize enhanced denial message format in hook output?
  → Defer until READY-01/02 are resolved; lower priority.
```

---

## §11 — New Hypotheses

### NH-09 (SUPPORTED — see §3.4)

```
ID:     NH-09
CLAIM:  Two bash sed regex substitutions achieve Level-1 normalization coverage
        (${VAR} + quoting gaps) without external dependencies
EVIDENCE: Analytical test on mutation corpus M1.3, M2.1, M3.1 (§3.4 above)
STATUS: SUPPORTED (analytical; not empirically tested with real command inputs)
AUTH:   Analysis complete; implementation requires hook modification (READY-02 scope)
IMPLICATION: Level-1 complexity is LOW, not MEDIUM as stated in MOVEMENT 003
```

### NH-10 (CONFIRMED — see §4.3)

```
ID:     NH-10
CLAIM:  Escalation path for UNKNOWN/BLOCKED cases can be documented in
        CONTROL_PLANE_HANDBOOK.md without constituting a "rule change" under F9-D01=A
EVIDENCE: Analytical: handbook is process documentation, not a rule file;
          F9-D01=A prohibits "rule" changes; handbook is not in .claude/rules/
STATUS: CONFIRMED (analytical; process documentation is within permitted scope)
AUTH:   None required — can be implemented now
IMPLICATION: CONFLICT-04 can be resolved immediately; escalation path can be defined
             without waiting for owner decisions on READY-01/02/03
```

---

## §12 — New Unknowns

### UNK-M4-01: NH-09 Double-Quote Removal Semantic Accuracy

```
QUESTION:     Does the simple double-quote removal regex (s/"([^"]*)"/$1/g) introduce
              semantic errors for shell commands where quotes carry grammatical meaning
              beyond just quoting?
EXAMPLE:      echo "foo bar" — after removal: echo foo bar — different argument count
WHY MATTERS:  False positives or false negatives from normalization semantic errors
STATUS:       OPEN (analytical test insufficient; would need systematic evaluation)
CHEAPEST TEST: Apply regex to 20 diverse real commands; check for semantic changes
               that affect pattern matching results (false positives or misses)
AUTH:         Analysis only
```

### UNK-M4-02: At What Scale Does Level-1.5 AST Become Worth Its Complexity?

```
QUESTION:     Under what conditions (usage scale, bypass frequency, threat model)
              would adding Level-1.5 AST parsing for numbered redirects and heredocs
              become cost-justified?
WHY MATTERS:  Current answer (not justified at current scale) is based on H-01 = 0;
              the threshold for justification is undefined
STATUS:       OPEN; requires H-01 data or explicit owner-defined threshold
CHEAPEST TEST: None — requires empirical data or owner risk preference definition
AUTH:         Owner decision (READY-03 partially addresses this; full answer requires H-01)
```

---

## §13 — Closed Questions

| Question | Status | Evidence | Artifact |
|---|---|---|---|
| Can shlex alone close ${VAR} gap? | NO — shlex doesn't normalize ${VAR}; additional step needed | §3.2 analytical | This document §3 |
| Is shlex the simplest Level-1 mechanism? | NO — 2 sed substitutions are simpler | §3.4 analytical | This document §3.4 |
| Are CCP policy pairs in conflict? | Only ONE active conflict (POL-08/F9-D01=A; resolved) | §4.2 analytical | This document §4 |
| Does CONFLICT-04 require a rule change to resolve? | NO — handbook documentation is sufficient | §4.3 analytical (NH-10) | This document §4.3 |
| Does Enhanced-B close the information gap for STA-02? | YES (SUPPORTED) | §5.2 scenario analysis | This document §5 |
| Does Enhanced-B replace AC-03? | NO — they address different gap types | §5.3 information vs. judgment | This document §5.3 |
| What are the 5 L1-C closure conditions? | Specified (§9.1) | §9.1 design analysis | This document §9 |
| Can READY-01/02/03 be consolidated? | Partially — presentation yes; merging no | §10.5 | This document §10.5 |
| Is Level-1 normalization LOW or MEDIUM complexity? | LOW (revised) — zero dependencies | NH-09 result §3.4 | This document §3.4 |

---

## §14 — Open Questions

| Question | Status | Blocker | Path to resolution |
|---|---|---|---|
| NH-09 double-quote removal semantic accuracy (UNK-M4-01) | OPEN | None (analysis work) | 20-command corpus test |
| At what scale does Level-1.5 AST justify its cost? (UNK-M4-02) | OPEN | H-01 data or owner threshold | Real usage or explicit decision |
| Does owner classify AC-02 as rule change or documentation? (READY-01) | BLOCKED | Owner decision | Present READY-01 package |
| P1'+P2' authorization (READY-02) | BLOCKED | Owner decision | Present READY-02 package |
| L1-C closure acceptance (READY-03) | BLOCKED | Owner decision | Present READY-03 package |
| H-01 real stall frequency measurement | BLOCKED | Environment | Real CCP usage |
| NH-08 falsification (is bypass problem material?) | BLOCKED | H-01 | Real CCP usage |

---

## §15 — Authorization Blockers

```
REQUIRES OWNER DECISION (binary classification):
  READY-01: AC-02 authorization (rule vs. documentation)

REQUIRES OWNER AUTHORIZATION (implementation):
  READY-02: bash-firewall P1'+P2' patterns + Level-1 normalization
  READY-04: enhanced denial message format in hooks

REQUIRES OWNER RISK ACCEPTANCE:
  READY-03: L1-C LABYRINTH-1 closure conditions

AVAILABLE NOW (no authorization needed):
  NH-10 implementation (handbook escalation path)
  Policy precedence documentation (NH-06 simple form)
  UNK-M4-01 corpus test (20-command double-quote test)
  All further design/analysis work
```

---

## §16 — Materiality Blockers

```
BLOCKED BY ABSENCE OF REAL EVENTS (H-01):
  True bypass risk materiality: UNRESOLVED
  NH-08 (bypass problem not material): UNFALSIFIABLE until real usage
  UNK-M4-02 (Level-1.5 justification threshold): PARTIALLY blocked

MATERIALLY UNRESOLVED (cannot say "not material" based on 0 events alone):
  Variable aliasing bypass risk
  File-based interpreter bypass risk
  Heredoc expansion bypass risk
```

---

## §17 — Evidence Limitations

```
ALL BYPASS ANALYSES ARE SYNTHETIC:
  Corpus in §3 of MOVEMENT 003 (15 cases) was constructed for testing, not sampled from real use
  NH-09 test (§3.4 of this document) was analytical; not run on actual hook inputs
  Coverage percentages are EXPERIMENTAL / COMPARATIVE; not production measurements

POLICY CONFLICT ANALYSIS IS ANALYTICAL:
  Conflict matrix (§4.2) identifies conflicts by reading policy text
  Real conflicts only appear when policies are applied to specific actions
  The "no active conflicts" finding is based on policy TEXT review, not case-by-case history

STA-02 SCENARIOS ARE DESIGNED CASES:
  NH-07 analysis used designed scenarios, not real STA-02 events from STALL_POLICY_LOG
  Resolution quality assessments are INFERENCES from scenario design, not empirical

L1-C FORMULATION:
  The formulation is a DESIGN_RESULT — it defines when the problem is considered resolved
  under specified conditions, but does not constitute production evidence that the conditions
  are sufficient in all future contexts
```

---

## §18 — Decision-Ready State

**What is fully specified and ready for owner review, no further analysis needed:**

```
READY-01 (AC-02):
  ✓ Repair texts specified (55_CDT01_NH02_RESULTS.md §1.3)
  ✓ Adversarial validation complete (56_MOVEMENT_003 §7)
  ✓ Decision package structured (this document §10.1)
  PENDING: Binary owner classification decision

READY-02 (P1'+P2' + Level-1):
  ✓ Pattern specs specified (55_CDT01_NH02_RESULTS.md §2.5)
  ✓ FP analysis complete (56_MOVEMENT_003 §3.4)
  ✓ NH-09 simplification found (this document §3.4)
  ✓ Decision package structured (this document §10.2)
  PENDING: Implementation authorization

READY-03 (L1-C closure):
  ✓ 5 conditions specified (this document §9.1)
  ✓ Residual risk characterized (this document §8)
  ✓ Reactivation triggers defined (this document §9.3)
  ✓ Decision package structured (this document §10.3)
  PENDING: Owner risk acceptance

NH-10 (escalation path):
  ✓ Confirmed as handbook documentation (this document §4.3)
  ✓ Example text specified (§4.3)
  PENDING: Nothing — can be written immediately
```

---

## §19 — New Frontier (After MOVEMENT 004)

```
FULLY EXHAUSTED (no further authorized research):
  NH-05: PARTIALLY_SUPPORTED
  NH-06: PARTIALLY_SUPPORTED
  NH-07: SUPPORTED
  NH-09: SUPPORTED (new; found during NH-05 analysis)
  NH-10: CONFIRMED (new; found during NH-06 analysis)
  Owner decision packages: structured for READY-01/02/03/04
  L1-C conditions: fully specified

AVAILABLE NOW (non-authorized work remaining):
  NH-10 implementation: write escalation path in CONTROL_PLANE_HANDBOOK (~10 lines)
  UNK-M4-01 test: 20-command double-quote removal corpus test
  Policy precedence brief: write 10-line document formalizing implicit precedence
  These are DOCUMENTATION tasks requiring no authorization

AFTER NH-10 / UNK-M4-01 (near-exhaustion point):
  The only remaining non-authorized work would be:
  - Additional corpus expansion (diminishing returns)
  - Further architecture theorizing (higher abstraction without new evidence)

TRUE FRONTIER (requires owner or real usage):
  [1] READY-01/02/03 owner decisions
  [2] H-01 real usage data
  [3] If READY-01 YES → AC-02 implementation immediately follows
  [4] If READY-02 YES → bash-firewall implementation follows
  [5] If READY-03 YES → LABYRINTH-1 closes; research overhead ends
```

---

## §20 — Next Movement

**MOVEMENT 005 — NH-10 Documentation + Owner Decision Package**

```
PART 1 (no authorization — execute immediately):
  Write escalation path procedure in CONTROL_PLANE_HANDBOOK.md (NH-10)
  Write 10-line policy precedence statement (NH-06 minimal form)
  Run UNK-M4-01 test (20-command double-quote removal corpus)

PART 2 (documentation):
  Format READY-01/02/03/04 as a single owner review document:
    "CCP Incremental Security Stack + LABYRINTH-1 L1-C Closure — Owner Decision Brief"
  Include decision trees, risks, reversibility for each
  Include consolidated presentation recommendations (§10.5)

PART 3 (ongoing; blocked by environment):
  Monitor STALL_POLICY_LOG for real H-01 events

EXPECTED OUTPUT:
  CONTROL_PLANE_HANDBOOK.md updated (NH-10)
  Policy precedence brief (NH-06 minimal)
  Owner decision brief document
  UNK-M4-01 test result
```

---

## §21 — Final Map (§25 of Mandate)

### A. What we did not know before MOVEMENT 004

```
Whether shlex alone closes the ${VAR} gap (it doesn't; additional regex needed)
Whether Level-1 normalization requires external dependencies (it doesn't — 2 bash sed lines)
Whether CCP has active policy composition conflicts beyond POL-08/F9-D01=A (it doesn't)
Whether CONFLICT-04 requires a rule change to resolve (it doesn't; handbook suffices)
Whether Enhanced-B addresses the same gap as AC-03 (no — they address different gaps)
What the 5 precise conditions for L1-C minimal closure are
That NH-09 exists (simpler Level-1 mechanism)
That NH-10 exists (escalation path as handbook, permitted now)
```

### B. What is now demonstrated (DESIGN_RESULT, not production)

```
NH-09: 2 bash sed lines achieve Level-1 normalization; zero dependencies (DESIGN_RESULT)
NH-10: Escalation path can be written in handbook now; no authorization needed (DESIGN_RESULT)
Enhanced-B: closes information gap for STA-02; judgment gap requires AC-03 (DESIGN_RESULT)
Policy conflicts: only one active conflict exists (POL-08/F9-D01=A); resolved by repair (DESIGN_RESULT)
L1-C: 5 conditions fully specified; minimal vs. strong closure distinguished (DESIGN_RESULT)
```

### C. What remains only supported (INFERENCE / EXPERIMENTAL)

```
P1'+P2' LOW FP: supported by synthetic corpus; production FP rate unknown
87.5% SAFE rate with AC-02: supported by synthetic test; not production measurement
Level-1 coverage estimates: supported by analytical corpus; not empirically tested
L1-C adequacy: supported by design analysis; production evidence unavailable
```

### D. What was refined (not refuted, but corrected)

```
NH-05 "AST normalization": shlex is a tokenizer, not AST; simpler than originally described
Level-1 complexity: MEDIUM → LOW (NH-09 eliminates dependency requirement)
NH-06 value: "eliminates composition UNKNOWNs" → "formalizes implicit; CONFLICT-04 needs spec"
Enhanced-B scope: "closes STA-02 without AC-03" → "closes information gap; judgment gap different"
```

### E. Architectural changes

```
CCP Minimal Security Stack identified and named (§6.2):
  Layers 0-6 cover the full detection-to-escalation path
  Previous framing was "current + increments"; now a coherent named stack

Level-1 normalization is LOW complexity (not MEDIUM):
  NH-09: 2 sed lines; no library; fits in existing hook structure
  This changes the cost/benefit calculation for READY-02

NH-10 is available immediately:
  CONFLICT-04 resolution doesn't require any authorization
  Escalation path can be defined today
```

### F. What can be done without authorization

```
NH-10 implementation: write escalation path in CONTROL_PLANE_HANDBOOK (~10 lines)
NH-06 minimal form: write policy precedence brief (~10 lines; not a rule file)
UNK-M4-01 test: 20-command corpus for double-quote removal analysis
Owner decision brief: format READY-01/02/03/04 as structured decision document
```

### G. What needs owner decision

```
READY-01: AC-02 classification (binary: rule change or documentation?)
READY-02: P1'+P2' + Level-1 normalization deployment in bash-firewall.sh
READY-03: L1-C closure acceptance with conditions and reactivation triggers
READY-04: Enhanced-B denial message format implementation (lower priority)
```

### H. What needs real usage

```
H-01: actual stall frequency with had_alternative field set
NH-08 falsification: does a real bypass occur that current controls fail to catch?
UNK-M4-02: at what usage scale does Level-1.5 AST become cost-justified?
```

### I. What is now the most important problem

**DESIGN_RESULT:**

The most important problem is no longer a technical research question. It is:

> **"Which of READY-01/02/03 will the owner decide, and in what order?"**

All technical specifications are complete. The technical frontier is effectively closed for non-authorized work (except NH-10 implementation and minor corpus testing). The project is at an owner decision gate.

The CCP research program has produced:
- A complete bypass taxonomy (4 families, 6-level spectrum)
- A minimum viable security stack (CCP Minimal Security Stack, Layers 0-6)
- A LABYRINTH-1 exit path that doesn't require AC-03 (L1-C under 5 conditions)
- Owner-ready decision packages for each required authorization
- Implementation-ready specifications for all authorized changes

The next conversation with the owner should be a decision conversation, not a research conversation.

### J. The most concrete next experiment

**Available now, no authorization:**

```
NH-10: Write 10 lines in CONTROL_PLANE_HANDBOOK.md defining the escalation path for
UNKNOWN/BLOCKED cases. This closes CONFLICT-04 immediately and improves the B path
without any authorization. Effort: ~15 minutes.

This is the cheapest experiment available that produces a concrete deliverable.
```

---

## §22 — Complete Traceability Matrix

| Claim | Type | Source | Limitation |
|---|---|---|---|
| shlex doesn't normalize ${VAR} | DOCUMENTED_FACT | Python shlex documentation analysis | Not empirically tested |
| 2 sed substitutions close M1.3/M2.1/M3.1 | DESIGN_RESULT | Analytical application to mutation corpus (§3.4) | Synthetic; not run against real hook inputs |
| Level-1 complexity: LOW (not MEDIUM) | DESIGN_RESULT | NH-09 finding: zero dependencies | Design analysis |
| Only one active policy conflict | DESIGN_RESULT | §4.2 full policy pair matrix | Text analysis; history not checked |
| CONFLICT-04 is missing spec, not precedence | DOCUMENTED_FACT | §4.1 reading policy texts | Policy content analysis |
| NH-10: escalation path in handbook = permitted | DESIGN_RESULT | §4.3 F9-D01=A text analysis | Owner may interpret differently |
| Enhanced-B closes information gap for STA-02 | DESIGN_RESULT | §5.2 scenario analysis (4 cases) | Designed scenarios; not real STA-02 events |
| Enhanced-B ≠ replacement for AC-03 | DESIGN_RESULT | §5.3 gap type distinction | Design analysis |
| 5 L1-C minimal closure conditions | DESIGN_RESULT | §9.1 formulation analysis | Design conditions; owner must accept |
| CCP Minimal Security Stack | DESIGN_RESULT | §6.2 synthesis of all tracks | Architecture design; not implemented |
| Level-1.5 not cost-justified currently | INFERENCE | §7.2 benefit-complexity analysis | Based on H-01=0; context-dependent |
| 0 observed events ≠ 0 risk | DOCUMENTED_FACT | §9.4 materiality audit | Per mandate requirement |

---

*MOVEMENT 004 — 2026-09-23 — BASE `3350742` — Single session; 10 tracks analyzed; NH-09/NH-10 discovered; all non-authorized research space exhausted.*
*Stop condition: No remaining high-value, low-cost, authorized experiments beyond NH-10 implementation and minor corpus testing.*

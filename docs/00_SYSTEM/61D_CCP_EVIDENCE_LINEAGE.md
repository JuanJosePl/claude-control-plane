# 61D — CCP Evidence Lineage

**Created:** 2026-09-23  
**Purpose:** Maps every major claim to its evidence source, type, limitations, and current status. Prevents new sessions from treating design claims as production evidence.

---

## Evidence Categories

| Category | What it means |
|---|---|
| CODE-SUPPORTED | Claim backed by actual code that implements or enforces it |
| TEST-SUPPORTED | Claim backed by a passing test that demonstrates the behavior |
| DESIGN-ONLY | Claim established through design analysis; no empirical test |
| SYNTHETIC | Claim backed by synthetic test cases (not real usage) |
| PROTOTYPE | Claim backed by a prototype experiment (limited scope) |
| REAL-USAGE | Claim backed by production/field data |
| OWNER-DEPENDENT | Claim requires owner decision before it can be evaluated |
| UNKNOWN | Claim status unresolvable with current evidence |

---

## F1-F8 Build Evidence

| EV-ID | Claim | Category | Limitation | Status |
|---|---|---|---|---|
| EV-001 | F1 produces clean installable foundation with valid settings, canonical registries, SubagentStart injection | TEST-SUPPORTED | Tests were synthetic smoke tests in temp directory | VERIFIED |
| EV-002 | F2 TaskCompleted gate blocks incomplete/malformed evidence | TEST-SUPPORTED | Test matrix is synthetic (not adversarial production scenarios) | VERIFIED |
| EV-003 | F3 Tier 1/2 pass; Tier 3 blocked by unauthenticated CLI | CODE-SUPPORTED | Tier 3 behavioral = environmental block | BLOCKED (resolved by EV-005) |
| EV-004 | EV-003 environment block reproducible across two runs | TEST-SUPPORTED | Same block; not a different test | BLOCKED (historical) |
| EV-005 | F3 Tier 3 behavioral passes 2x with authenticated CLI; normalized signatures identical | TEST-SUPPORTED | Behavioral tests run against authentic Claude CLI but scripted inputs | VERIFIED |
| EV-006 | F4 incident learning framework: three-registry linkage with control enforcement | TEST-SUPPORTED | Fixture tests synthetic incident; no real production incident | VERIFIED |
| EV-007 | F5 state integrity: hash + drift detection operational | TEST-SUPPORTED | PreCompact/SessionStart hash smoke test | VERIFIED |
| EV-008 | F6 maintenance suite: 12 deterministic diagnostics | TEST-SUPPORTED | Diagnostics run against live repo state | VERIFIED |
| EV-009 | F7 stop anti-loop: idempotency fixture passes | TEST-SUPPORTED | Synthetic fixture | VERIFIED |
| EV-010 | F7 firewall hardened: tolerates whitespace/case; positional anchoring | TEST-SUPPORTED | Synthetic fixture variants | VERIFIED |
| EV-011 | F7 Tier 3 freshness check + 30-day window | TEST-SUPPORTED | Freshness check logic | VERIFIED |
| EV-012 | F7 task_id + contract_hash coupling; ARCH-004 | CODE-SUPPORTED | Design-level coupling | VERIFIED |
| EV-013 | F7 session log rotation reversible | TEST-SUPPORTED | Reversibility test | VERIFIED |
| EV-014 | F7 installer idempotent with --force | TEST-SUPPORTED | Idempotency test | VERIFIED |
| EV-015 | F8-A: contract_hash mandatory; fail-closed | TEST-SUPPORTED | Fixture verifies fail-closed on missing hash | VERIFIED |
| EV-016 | F8-B: bash-firewall rejects NUL bytes + non-single payloads | TEST-SUPPORTED | Specific fixture cases | VERIFIED |

---

## Research Evidence

### R-3 Non-Bypass Verification

| Claim | Category | Evidence | Limitation | Status |
|---|---|---|---|---|
| R-3 protocol is coherent | DESIGN-ONLY | 50_/51_ design + audit | Design analysis only; no production test | SUPPORTED (design) |
| R-3 correctly classifies 9/9 synthetic cases | SYNTHETIC | 53_R3_EMPIRICAL_TEST.md | Synthetic cases designed by same team; not adversarial | EMPIRICALLY_VALIDATED |
| "UNKNOWN always dominates" is false | SYNTHETIC | M001: C-01 produced SAFE | Only 9 cases; explicit-policy domain only | REFUTED (for explicit-policy cases) |
| R-3 security invariant holds | DESIGN-ONLY | R-3 audit + M001 analysis | Design level; no production adversarial test | SUPPORTED (design) |

### Policy Corpus

| Claim | Category | Evidence | Limitation | Status |
|---|---|---|---|---|
| 25 CCP policies identified | CODE-SUPPORTED | M002 corpus analysis | Manual enumeration; may miss implicit rules | SUPPORTED |
| 20/24 actionable policies = EXPLICIT | SYNTHETIC | M002: 54_MOVEMENT_002 §5 | Classification by one analyst; not independently validated | SUPPORTED |
| 4 policies = PARTIAL with repair paths | DESIGN-ONLY | M002: 54_ §6 | Each repair = one sentence; not tested for exhaustiveness | SUPPORTED (design) |
| 83% EXPLICIT rate supports hypothesis A | SYNTHETIC | M002: RCE test 6 SAFE, 1 UNKNOWN, 1 UNSAFE | Only 8 test scenarios; synthetic | SUPPORTED (limited) |
| AC-02 repairs are effective | SYNTHETIC | M003: CDT-01; 87.5% SAFE after repair | 8 scenarios; synthetic | CONFIRMED (synthetic) |

### Independence Architecture

| Claim | Category | Evidence | Limitation | Status |
|---|---|---|---|---|
| R-3 uses "person" not "model" for independence | CODE-SUPPORTED | R-3 protocol text | Textual analysis | SUPPORTED |
| Context isolation via subagents = 6/7 dimensions | DESIGN-ONLY | M002: 54_ §13-16 | Design analysis; CDT-02 empirical test not done | PARTIALLY_SUPPORTED |
| CDT-02 would confirm independence | OWNER-DEPENDENT | Not executed | Requires new agent auth | UNKNOWN |

### Hypothesis B

| Claim | Category | Evidence | Limitation | Status |
|---|---|---|---|---|
| B is sufficient for STA-01/03/04 | SYNTHETIC | M002: 5-scenario evaluation | Synthetic scenarios | SUPPORTED (synthetic) |
| B needs enhancement for STA-02 | DESIGN-ONLY | M002: information quality gap identified | Design analysis | SUPPORTED |
| B is CONDITIONALLY_SUFFICIENT at current scale | SYNTHETIC | M002 combined analysis | Only 5 scenarios; single scale | SUPPORTED |

### Bypass Coverage

| Claim | Category | Evidence | Limitation | Status |
|---|---|---|---|---|
| 4 patterns cover ~75-80% practical bypass surface | SYNTHETIC | M003: NH-02 analysis | Static analysis against a constructed bypass corpus | PARTIALLY_SUPPORTED |
| Aliasing bypasses ALL regex patterns | DESIGN-ONLY | M003: bypass taxonomy | Theoretical analysis; not experimentally confirmed | DESIGN_CLAIM |
| P4 has high FP risk | SYNTHETIC | M003: NH-04 analysis | Design + small corpus | SUPPORTED (inadvisable) |
| ${VAR} gap not covered by existing patterns | DESIGN-ONLY | M003: NH-04 | Design analysis | SUPPORTED |

### NH-09 Normalization

| Claim | Category | Evidence | Limitation | Status |
|---|---|---|---|---|
| 2 sed operations achieve Level-1 coverage | DESIGN-ONLY | M004: NH-09 analytical support | Design analysis only; no production test | SUPPORTED (design) |
| NH-09 is SAFE_NORMALIZATION | SYNTHETIC | M005: 20-command corpus across 14 categories | Synthetic corpus; 20 commands | SUPPORTED (limited) |
| COMMAND_NORM invariant holds | DESIGN-ONLY | M005/M006: variable lifecycle trace | Design analysis; no adversarial test | CONFIRMED (design) |

### PAC (Policy-as-Code)

| Claim | Category | Evidence | Limitation | Status |
|---|---|---|---|---|
| 13 policies can be expressed as YAML | PROTOTYPE | M007: ccp_policies.yaml | 13 of 25+ policies only; corpus incomplete | PROTOTYPE |
| PAC compiler derives patterns without semantic drift | PROTOTYPE | M007: pac_compiler.py results | 13 policies; compiler tested on limited set | PROTOTYPE_SUPPORTED |
| PAC would collapse READY-01/02 into one decision | DESIGN-ONLY | M007: B3 assumption attack | Architectural inference from prototype | INFERENCE |
| PATTERN_NAME_IN_LITERAL (PAC-EF-02) is a real FP class | PROTOTYPE | M007: experimental discovery during compilation | 2 instances; same experiment; limited corpus | EXPERIMENTAL_FINDING |

### H-01 (Stall Frequency)

| Claim | Category | Evidence | Limitation | Status |
|---|---|---|---|---|
| H-01 stall frequency = UNKNOWN | REAL-USAGE | STALL_POLICY_LOG: 3 events | 3 events: 1 test, 2 FPs; no genuine bypass events | UNKNOWN |
| N=1 is sufficient for informativeness | DESIGN-ONLY | M007: analytical derivation | Analytical; any event is informative | ANALYTICALLY_DERIVED |
| Current H-01 count (2) is all FPs | PROTOTYPE | M007: PAC-EF-02 discovered | All from same experiment; not representative | KNOWN |

---

## Evidence Gaps

### Claims Without Adequate Evidence

| Claim | What Would Satisfy It |
|---|---|
| Production FP rate for P1'/P2' patterns | Real usage environment |
| CDT-02: blind verifier matches non-blind | New agent authorization + empirical test |
| H-01 genuine bypass frequency | Real usage environment |
| L1-C immateriality (LABYRINTH-1 exit condition D) | N real events with had_alternative below threshold |
| Native Claude Code lifecycle behavior | Authenticated native runtime + deterministic trigger |
| Adversarial bypass attempts defeated by NH-09 | Adversarial test with actual bypass attempts |

### Claims That Are Design-Only (Not Production-Validated)

- R-3 security invariant
- B sufficiency beyond current scale
- COMMAND_NORM invariant (design analysis; adversarial test not done)
- Aliasing as bypass mechanism (design analysis)
- PAC zero semantic drift (13-policy corpus; not complete)

---

## Evidence Lifecycle

```
GENERATED (by this system)
    ↓
PROPOSED (before verification)
    ↓
VERIFIED (tests PASS + reviewer PASS + hash valid)
    ↓
FROZEN (phase closed; no retroactive modification)

Exception: BLOCKED entries remain until environment resolves them.
```

### Evidence Rules

1. **Never modify historical entries.** A VERIFIED entry is frozen. Corrections create a new entry.
2. **Provenance is always explicit.** EXTRACTED/INFERRED/ASSUMED/EXTERNAL/GENERATED.
3. **Limitation is always documented.** Every VERIFIED entry has a Notes field; this is where scope limits live.
4. **SYNTHETIC ≠ PRODUCTION.** No synthetic evidence entry claims production behavior.
5. **DESIGN_ONLY ≠ IMPLEMENTED.** Design evidence establishes feasibility, not deployment.

---

## Current Evidence Integrity

```
EV-001..EV-016: ALL VERIFIED
All 16 entries: contract_hash present, reviewer PASS, timestamp valid
Maintenance diagnostic 12/12 PASS (last run: MOVEMENT 007)
STATE_INTEGRITY: DRIFT_DETECTED (PROJECT_STATE modified post-checkpoint e066757)
  → Operational; drift = PROJECT_STATE fields updated after checkpoint commit
  → Not a security concern; a housekeeping state
```

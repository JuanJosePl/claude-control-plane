# 03 — PIECE & CAPABILITY MAP

> **Stratum-C synthesis artifact (non-canonical, read-only).** Piece excavation (§8), value test (§9),
> latent-capability discovery (§10-11), cross-synthesis (§12), leverage (§21), redundancy elimination (§33).
> Inventory verified this session via `find .claude -type f`, `find evals -type f`, `.claude/settings.json`.

---

## §1. PIECE INVENTORY (verified this session)

CCP is small and legible. Full component census:

| Layer | Count | Members |
|---|---|---|
| Hooks (control) | 11 | bash-firewall, secret-guard, task-completed-evidence, pre-compact-snapshot, session-start-startup, session-start-compact, stop-logger, subagent-context, subagent-stop-logger, config-change-logger, lib/stall-record |
| Wired hook events | 8 | SessionStart(startup\|resume\|fork / compact\|clear), PreToolUse(Bash / Write\|Edit), SubagentStart, SubagentStop, Stop, PreCompact, ConfigChange, TaskCompleted |
| Agents (execution) | 5 | researcher, architect, implementer, code-reviewer, security-auditor |
| Context packs | 6 | CORE, CURRENT_STATE, DECISIONS, SECURITY_RULES, BUSINESS, NO_GO |
| Rules | 4 | security, git-policy, no-go, compliance |
| Skills | 20 | adr, audit-config, audit-context, cerrar-fase, checkpoint, code-review-and-quality, constraint-driven-development, context-{business,core,current-state,decisions,no-go,security}, doctor, doubt-driven-development, estado, evidence, gate, incident, no-go, recovery, test-driven-development |
| Evals | 12 | maintenance + hooks/{firewall-positive,secret-guard-positive,session-log-rotation,stop-hook-idempotency,task-completed-coupling}, incidents/INC-001, install/idempotency, r2/r2-instrumentation, skills/{evidence-freshness,validate}, state/state-integrity |
| Canonical registries | 8 | PROJECT_STATE, DECISION_REGISTRY, EVIDENCE_REGISTRY, ARTIFACT_MANIFEST, CONTROL_REGISTRY, REGRESSION_REGISTRY, INCIDENT_REGISTRY, DEFERRAL_{POLICY,INVENTORY} |
| Governance docs | 4 | AUTHORITY_KIND, DEFERRAL_POLICY, F9_OWNER_DECISIONS, DESIGN |

## §2. PIECE MAP BY CATEGORY (§8 classification)

| Category | Pieces | Role |
|---|---|---|
| FOUNDATION | install.sh, settings.json, CLAUDE.md, project-scope (ARCH-001), context-load (ARCH-002) | make CCP installable & self-loading |
| GOVERNANCE | DECISION_REGISTRY, DECISION_HISTORY, DEFERRAL_POLICY/INVENTORY, AUTHORITY_KIND, F9_OWNER_DECISIONS, `adr`/`evidence`/`gate`/`cerrar-fase`/`checkpoint` skills | record & gate decisions |
| STATE | PROJECT_STATE (single source), CURRENT_STATE (mirror), pre-compact-snapshot, session-start-* | own & recover operational state |
| EVIDENCE | EVIDENCE_REGISTRY (ARCH-003), task-completed-evidence (CTRL-001), evidence-freshness eval | evidence-before-DONE |
| VERIFICATION | maintenance.sh (12/12), all 12 evals, REGRESSION_REGISTRY (REG-001..011), code-reviewer agent, TDD/DDD/CDD skills | independent verification |
| RUNTIME / CONTROL | bash-firewall (P0), secret-guard (P0), stall-record (lib), config-change-logger | enforce security & log policy stalls |
| OBSERVABILITY | STALL_POLICY_LOG.jsonl, CLAUDE_SESSION_LOG, query-log.sh, stop/subagent-stop loggers | record what happened |
| RECOVERY | `/doctor`, `/recovery`, session-start-compact (drift detect), INCIDENT_REGISTRY + CONTROL_REGISTRY | detect & recover |
| INTERFACE | 20 skills (slash commands), 5 agents | human/agent entry points |
| FUTURE / LATENT | (no pieces) DEC-STREAM-CONSUMER, DEC-07 verifier, DEC-04/05 policy motor — all LATENT, unbuilt | see doc 02 §4 |

**Observation:** every category is populated by *existing, verified* pieces except FUTURE/LATENT, which is
correctly **empty of built pieces**. CCP already covers foundation → verification → recovery. The latent
decisions would *add* to observability/verification, not fill a hole that breaks the current system.

---

## §3. PIECE VALUE TEST (§9) — applied to the load-bearing pieces

Rather than test all 60+ pieces (most are obviously necessary foundation), the value test is applied where
removal/absorption is even conceivable.

| Piece | Necessary? | If removed | Absorbable? | Simpler impl? | Leverage | Verdict |
|---|---|---|---|---|---|---|
| task-completed-evidence (CTRL-001) | YES | false-DONE regressions return (INC-001) | no | no | HIGH (gates all completion) | KEEP |
| bash-firewall (P0) | YES | destructive/supply-chain commands execute | no | no | HIGH | KEEP |
| secret-guard (P0) | YES | secrets can be written | no | no | HIGH | KEEP |
| stall-record (lib) | YES | no policy-stall observability | partial (into logger) | no | MODERATE | KEEP |
| DEFERRAL_POLICY + INVENTORY | YES | deferrals lose observable triggers | no | no | HIGH (governs all deferrals) | KEEP |
| AUTHORITY_KIND | YES | no canonical authority vocab; ARCH-007 E3 unresolved | no | no | HIGH (enabler for ARCH-007/008) | KEEP |
| CURRENT_STATE (mirror) | conditionally | risk of divergence from PROJECT_STATE | yes (into PROJECT_STATE) | — | LOW | KEEP but audit-context guards drift |
| `code-review-and-quality` + `doubt-driven-development` skills | YES | lose independent-review discipline | overlap MODERATE (see §6) | — | MODERATE | KEEP (distinct: quality vs adversarial-fresh-context) |
| MASTER_HANDOFF.md (195 KB snapshot) | historical | none (it is a frozen snapshot) | — | — | LOW (reference cost) | KEEP frozen (ARCH-006 §7 policy) |
| The 6-file DEC_02_* analytical chain (5,309 lines, untracked) | evidence | ARCH-008 loses its analytical support | — | — | reference | KEEP as ANALYTICAL; do not canonicalize |

**No piece fails the value test.** CCP carries **no dead runtime pieces**. The only "less-but-stronger"
candidates are *documentary* (analytical stack size), addressed in §6 and doc 05.

---

## §4. LATENT CAPABILITY DISCOVERY (§10) — real gaps only (§11 discipline)

A capability is a candidate only if `real need + observable gap + existing evidence`. Speculative
possibilities are excluded.

| Capability | Existing pieces | Missing connector | Real need today? | Class | Verdict |
|---|---|---|---|---|---|
| **STALL stream consumer / triage** | stall-record, STALL_POLICY_LOG, query-log.sh | a consumer that classifies/triages events | **NO** — 97.1% AGREE, 0 DISAGREE, HIGH attribution to eval infra (doc 04) | LATENT / OPTIONAL | Do NOT build. WAIT for a *defined* volume/diversity trigger. |
| **Post-tool semantic verifier** (DEC-07) | ARCH-004 gate, ARCH-008 delegation, code-reviewer agent, ARCH-009 invariant | a verifier that receives delegated post-tool verification | **NO** — no concrete workflow planned | LATENT | Do NOT build. Opens on a named workflow. |
| **Policy compiler / canonical policy source** (DEC-04⋈05) | rules/*.md (prose), bash-firewall regex, PAC corpus (docs/research/pac) | a canonical source + compiler canonical→enforcement | **NO** today; **MODERATE debt** accruing (double representation) | LATENT PAIR | Do NOT build. Watch double-representation drift. |
| **Deferral-trigger admission schema** (D-TRIGGER-SCHEMA) | DEFERRAL_POLICY (carries triggers), ARCH-005 pattern | rule for admitting *new* trigger classes | weak | LATENT (weak) | Note only. |
| **Formal record of latent-decision status** | DEFERRAL_INVENTORY, DECISION_REGISTRY | a canonical entry recording the 7 LATENT decisions + predicates | **YES (bookkeeping)** — the audit's central finding | REAL GAP (documentary) | Owner framing choice OD-1; low-cost. |

**Only ONE item clears the §11 bar as a REAL GAP: recording the latent-decision status.** It is documentary,
not a build. Everything else is LATENT/OPTIONAL with no fired trigger — building any of them would be
"documentation/architecture momentum" prohibited by ABSORPTION > CREATION.

## §5. LEVERAGE — "could reuse improve CCP?" (§21)

The highest-leverage moves are **reuse/composition**, not new components:

1. **Reuse `DEFERRAL_POLICY` schema to record the 7 latent decisions.** The machinery for observable
   triggers already exists (ARCH-005). Recording the latent set as deferral entries (if Owner chooses)
   reuses existing governance rather than inventing anything. **Highest leverage, lowest complexity.**
2. **Reuse `code-reviewer` agent + `doubt-driven-development` skill as the seed of any future DEC-07
   verifier** — the verifier capability is *partly present*; DEC-07 would formalize, not create.
3. **Reuse `query-log.sh` + `maintenance.sh` as the observable-signal surface** for latent-decision
   triggers (STALL volume, diversity), so "watching" costs nothing new.
4. **Reuse the three-move campaign pattern** (Discover-Compress-Architect / Gate-Choose / Canonicalize-Close,
   proven on DEC-08) for any future latent decision that opens — it is a reusable *workflow*, already
   demonstrated, no new tooling.

## §6. REDUNDANCY ELIMINATION (§33)

| Redundancy | Assessment | Action |
|---|---|---|
| DESIGN.md §11 `ARCH-001..005` vs DECISION_REGISTRY `ARCH-001..009` | Naming collision (doc 01 C1); different content, same IDs | **MERGE/clarify** — mark DESIGN §11 as a superseded proposal table pointing to the registry (Class-C, doc 06 EP-C3) |
| CURRENT_STATE.md mirrors PROJECT_STATE | Intended mirror; drift risk guarded by `/audit-context` | KEEP (documented mirror, not duplicate source) |
| Note 55 / Note 56 in PROJECT_STATE duplicate F9-D02 / F9-D04 triggers | Already normalized as LINK per DEFERRAL_POLICY §7 | KEEP (LINK-normalized; no action) |
| `code-review-and-quality` vs `doubt-driven-development` vs `code-reviewer` agent | Overlap in "independent review" | KEEP all — quality-gate vs adversarial-fresh-context vs role-agent are distinct roles (verified by their SKILL/agent contracts) |
| Analytical stack: DEC_02_* (6 files, 5,309 lines untracked) + DEC_08_KERNEL + DECISION_SPACE_PREPARED + PIECE_AND_IDEA + POST_ARCH-007 + research branch (5) | Large reference cost; MODERATE lock-in (audit §9 "later decision cost") | **ARCHIVE-CANDIDATE** — none is canonical; keep for provenance but do not require future decisions to re-read the whole stack. Index them (this synthesis is the index). |
| MAP_COMPLETE.md, CCP_*_ATLAS/MAP/ENGINE.md (huge) | Historical exploration corpus | KEEP frozen; not in the active read path |

**"Less but stronger" verdict (§34):** CCP can get the *same governance value with fewer active
documents* by (a) treating the analytical stack as archived provenance rather than required reading, and
(b) making THIS synthesis the single index a future decision starts from. **No runtime piece can be
removed without losing value.** The reduction opportunity is purely in the *documentary read-path*, not
in the machinery. That is a strength: the enforcement surface is already minimal.

## §7. PIECE-LEVEL FALSIFIERS

- If a future incident shows a destructive command reaching execution → bash-firewall value test flips
  (currently HIGH, would become "insufficient"). Not observed (INCIDENT_REGISTRY: 0 OPEN).
- If STALL divergence appears (a DISAGREE verdict) → stream-consumer moves from OPTIONAL toward NEEDED.
  Probe found 0/34 DISAGREE (doc 04). Falsifier not met.
- If `/audit-context` ever reports PROJECT_STATE vs CURRENT_STATE CONFLICT unresolved → the mirror's
  "KEEP" flips toward "absorb into single source." Not observed.

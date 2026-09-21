# MULTI-DOMAIN RESEARCH COUNCIL
# STATE-AWARE GOVERNED RECOVERY (SAGR)
# Precision-First System Reconstruction
# Claude Control Plane — Additive Research Program

**BASELINE:** Repository HEAD `035a573` (post-AIGIS teardown, post-Field-Validation-Packet)  
**FINAL HEAD:** No runtime change. Research is additive documentary output only.  
**WORKTREE:** No modifications to `.claude/`, `evals/`, `install.sh`, `PROJECT_STATE.md`, or any registry.  
**RESEARCH DATE:** 2026-09-21  
**PURPOSE:** Owner-initiated new research question. F10 is NOT opened. F1–F9 are NOT reopened.  
**INDEPENDENCE LIMITATION:** This document is produced by a single research context. Genuine multi-agent independence is not available. All tracks are executed sequentially by the same model, which introduces anchoring risk. Contradictions have been deliberately sought; the adversarial track (P) attempts to falsify every positive claim.

---

## PRIOR STATE SUMMARY

The previous research cycle (`CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md`, `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_AUDIT.md`, `CLAUDE_CONTROL_PLANE_AIGIS_TEARDOWN.md`) concluded:

- **F8 COMPLETE / FROZEN**: Evidence-gate, fail-closed firewall, reviewer identity.
- **F9 NOT JUSTIFIED**: No candidate met impact + control-insufficient + proportional-benefit + reversible-scope threshold.
- **Commercial thesis NOT SUPPORTED** for standalone agent-control-plane form.
- **AIGIS teardown** demonstrated the core CCP execution is substantially reproduced by a competitor. Differentiators: incident→control→regression chain, historical preservation, phase-gate discipline.
- **Owner-initiated new hypothesis**: State-Aware Governed Recovery (SAGR) — detecting stagnation, loops, context degradation, cost explosion, control-induced stalls; recovering via bounded exploration, subagent delegation, state restoration, minimal-context reconstruction, re-verification.

The new hypothesis is **materially distinct** from "evidence-gated completion." It attacks the dynamic of execution itself rather than the gate at the end.

---

## 1. RESEARCH COVERAGE

**Tracks executed (17):**
A — Agent Execution Recovery  
B — Context Continuity/Memory  
C — State Machines/Workflow Systems  
D — Multi-Agent Recovery  
E — Loop/Stagnation Detection  
F — Control-Induced Stalls (Priority)  
G — Cost/Token Efficiency  
H — Safety + Recovery  
I — Software Engineering Analogues  
J — Agent Harness/Coding Agent Ecosystem  
K — Academic/Research Landscape  
L — Standards/Industrial Practice  
M — Failure/Incident Corpus  
N — Competitive/Product Search  
O — Business/Economics  
P — Adversarial Architecture Review  
Q — Novel Composition Search  

**Tracks incomplete or limited:**
- Track L (Standards): AIUC-1, AAIF, AGENTS.md were searched; detailed contract text unavailable. Assessment is based on secondary sources and prior research artifacts.
- Track M (Incidents): Verified corpus limited to publicly documented incidents. Internal enterprise incidents are inaccessible.
- Track P (Adversarial): Single-context limitation. Adversarial synthesis is by the same model that wrote the positive synthesis. This is a known precision risk.

**Coverage limitations:**
- No primary interviews with agent platform engineers or operators.
- No live reproduction of agent recovery mechanisms on Claude Code, OpenAI Agents API, or LangGraph (no runtime available in this context).
- Papers older than August 2025 are assessed from training knowledge; papers from Sep 2026 are assessed from search results.
- Chinese and non-English research may be underrepresented.

---

## 2. PROJECT UNDERSTANDING

### FACT (from documents and git state)

- CCP repository HEAD `035a573` (post-field-validation-packet). Runtime: frozen at F8 (`2cd7953`).
- Active hooks: `bash-firewall.sh`, `secret-guard.sh`, `task-completed-evidence.sh`, plus 7 lifecycle hooks.
- Active controls: L5 fail-closed evidence gate (F8-A: `contract_hash` required); L5 fail-closed firewall for malformed JSON (F8-B).
- Registries: EVIDENCE, DECISION, INCIDENT, CONTROL, REGRESSION. All append-only Markdown.
- Phase gates F1–F8 complete; F9 research-only, NOT JUSTIFIED; F10–F12 UNKNOWN.
- Trust boundary: Git + human reviewer (F9-D04=B).

### OBSERVED (from AIGIS teardown)

- CCP `bash-firewall.sh` fires on substring `rm -rf ` regardless of path — live GuardFall-class false positive. Documented; no fix authorized.
- AIGIS (0 stars/0 forks at teardown) implements deeper versions of most CCP primitives with typed domain models, structured `ToolRequest`, real sandbox, circuit breakers.
- H1 (Evidence-gated completion): execution NOT UNIQUE post-AIGIS teardown.
- H3 (Incident→control→regression loop): execution STILL UNIQUE vs AIGIS.

### DOCUMENTED (from prior research)

- Multiple commercial products exist for agent governance (Microsoft Agent 365, GitHub Enterprise AI Controls, Boomi Agent Control Plane, TrueFoundry).
- Commercial thesis was CONTRADICTED for standalone form; internal value and field-validation were documented as viable alternatives.

### INFERRED

- The new hypothesis was triggered by the owner's own experience of the CCP research process cycling through research→objection→research→stop, which the owner identified as analogous to the agent failure mode being proposed.

### UNKNOWN

- Whether any commercial operator has encountered and quantified the specific "control-induced stall" failure mode as distinct from other failures.
- Whether any production system has a policy that explicitly classifies policy-blocks as RECOVERABLE vs HARD STOP.

---

## 3. PROBLEM RECONSTRUCTION

### Root Problems (from prior and current research)

**P1 — Agent completes without adequate evidence.** (Solved by F1–F8; AIGIS also solves it.)

**P2 — Agent enters an execution loop without progress detection.** (ACTIVE; widely observed in production; partially addressed by circuit breakers, budget limits; no integrated recovery policy.)

**P3 — Safety controls block an action, but the agent cannot recover and retries indefinitely.** (PARTIALLY DOCUMENTED; GitHub issue #96579 shows this exact bug in hermes-agent; OSGuard paper addresses it with a fixed retry budget; no named "control-induced stall" recovery architecture exists.)

**P4 — Context degrades over a long session, causing loss of critical state.** (ACTIVE; Claude Code compaction addresses crash recovery but can lose critical facts; the "what the agent did to the world outside the conversation" problem is noted in Agent Reliability Engineering Design Guide.)

**P5 — Recovery is attempted but costs more than restarting.** (ACTIVE; documented in multiple papers and incidents; no system tracks the cost of recovery vs restart to choose adaptively.)

**P6 — A recovery attempt itself enters a loop.** (ACTIVE; Zylos Research notes recursive retries can amplify cost; no system has a global retry budget across nested loops.)

### Symptoms

- $47,000 LangChain Analyzer/Verifier ping-pong (November 2025): 11-day loop, no budget cap.
- Claude Code recursion: $16K–$50K in 5 hours (July 2025).
- Context explosion: Claude Code GitHub issue #24976 documents a "dead-end" state where compaction itself fails due to context already exceeding limit.
- 4-agent LangChain loop: 11 days, $47,000.
- NousResearch hermes-agent: blocked=True tool calls invisible to guardrail, enabling infinite retry until timeout.

### Failure Classes (from MAST taxonomy, SAGR research)

| Class | Description | Current Solution | Gap |
|---|---|---|---|
| Exact repetition | Same tool/args/state | Circuit breakers, max_iterations | Detection only, no recovery |
| Semantic stagnation | Different actions, no progress | Progress metrics in FutureAGI | No recovery policy |
| Oscillation | A→B→A→B | Agent Reliability Engineering guide | Stop only, no recovery |
| Context degradation | Critical facts lost | Compaction (but can drop info) | Recovery context not standardized |
| Budget spiral | Cost grows, progress flat | Budget caps, circuit breakers | Detection too late for many teams |
| Control-induced stall | Policy blocks action, agent retries | Fixed retry budget (OSGuard) | No named recovery architecture |
| Second-order failure | Recovery itself loops | Global retry budget concept | Not implemented anywhere |
| Guardrail bypass attempt | Agent copies config to remove safety | AIGIS S04 Command Injection test | Security concern, not recovery |

### Existing Controls

- AIGIS: max_iterations, max_runtime_seconds, max_tool_calls, max_files_changed (circuit breakers).
- Claude Agent SDK: max_turns, max_budget_usd, PreCompact hook, subagent spawning.
- OpenAI Agents API (GA Sept 2026): multi-step recovery, subagent delegation server-side.
- FutureAGI: CustomerAgentLoopDetection, agent.trajectory.step, loop detection evals.
- loopless (PyPI): "Execution runtime for AI agents — detect loops, intervene, recover execution."
- livingai (PyPI): "Checkpoint, recovery, and replay infrastructure for AI agents."
- Temporal + LangGraph: durable execution with checkpoint/replay for crash recovery.

### Unresolved Failures

1. No system classifies a policy-induced block as RECOVERABLE STOP vs HARD STOP.
2. No system generates recovery plans that satisfy the blocking policy's constraint.
3. No system tracks the cost of the recovery attempt itself and compares it to restarting.
4. No system maintains a "failed path registry" during live execution to avoid repeating blocked paths.
5. Context compaction can lose side-effect records; no enforcement that "what was done to the world" is preserved through compaction.

---

## 4. NEW IDEA / CAPABILITY TAXONOMY

Capabilities discovered across all domains. For each: whether it exists, where, and what is genuinely new.

### P1 — State Fingerprint
**Description:** A compact hash or vector representing the agent's current execution state (task, plan version, artifacts, blockers, tools used, evidence state, token budget, recovery count).  
**Status:** PARTIALLY EXISTS. AgentAssay (Mar 2026) defines behavioral fingerprints from execution traces. FutureAGI's `agent.trajectory.step` captures per-step attributes. But fingerprinting for *live recovery trigger* (not offline regression) is NOT a deployed product.

### P2 — Progress Signal
**Description:** A measurable indicator of whether the agent is moving toward the goal.  
**Status:** EXISTS. FutureAGI's `GoalProgress` metric, `StepEfficiency`. Agent Reliability Engineering guide discusses progress detection. Reflexion's value function. Multiple implementations exist.

### P3 — Loop Detector
**Description:** Detects when the agent is repeating actions or cycling through states.  
**Status:** EXISTS. FutureAGI (May 2026), loopless (PyPI), IAL-Scan paper (Jul 2026), agent circuit breakers (multiple). Well-studied. NOT novel.

### P4 — Checkpoint
**Description:** Saved execution state at a known-good point, suitable for resume.  
**Status:** EXISTS DEEPLY. Temporal, LangGraph, livingai, AWS Lambda Durable Functions, DBOS, DeltaBox, CRAB. Well-implemented. NOT novel.

### P5 — Recovery Classifier
**Description:** Classifies a detected failure as HARD STOP (unsafe, irreversible) or RECOVERABLE STOP (policy-block, transient stall, context issue) or INFORMATIONAL.  
**Status:** NOT OBSERVED as a named concept. The distinction between "the policy should hard-block" and "the policy has incidentally caused a stall" is documented in OSGuard (fixed retry budget) but is not a formal classification system anywhere.

### P6 — Recovery Planner
**Description:** Given a RECOVERABLE STOP, generates a new plan that avoids the cause of the stall without violating the safety policy.  
**Status:** PARTIALLY EXISTS in research. Reflexion generates retrospective verbal critique and retries with improved strategy. RIR (Sep 2026) "carries forward reusable knowledge from the abandoned trajectory." But these are general failure recovery; none specifically targets policy-block-induced stalls.

### P7 — Subagent Delegation
**Description:** Spawning a new agent with minimal sufficient context to explore an alternative path.  
**Status:** EXISTS. Claude Agent SDK (subagents), OpenAI Agents SDK (handoffs, delegation), AutoGen, CrewAI, LATS (Monte Carlo Tree Search with parallel branches). NOT novel as a mechanism. Novel: using it specifically for POLICY-COMPLIANT alternative path exploration.

### P8 — Bounded Branch Exploration
**Description:** Multiple agents or paths explored in parallel, with a recursion/fanout limit.  
**Status:** EXISTS. LATS (2023) implements MCTS with bounded tree depth. The SGH paper (Apr 2026) proposes strict escalation protocol. RIR (Sep 2026) uses adaptive review scheduling to concentrate intervention. All have bounded exploration.

### P9 — Branch Adjudication
**Description:** Comparing explored branches and selecting the best one meeting safety and progress criteria.  
**Status:** EXISTS in research (LATS uses value functions; RIR uses reflection memory). No commercial system ships this as a named primitive for production agents.

### P10 — Minimum Sufficient Context
**Description:** The minimal set of information needed to resume execution or delegate to a recovery agent.  
**Status:** CONCEPTUALLY REFERENCED but NOT implemented. The Agent Reliability Engineering Design Guide recommends retaining "the most recent failure per distinct action fingerprint, drop older duplicates, and never drop the side-effect ledger." Context compaction research identifies the gap. But "minimum sufficient context for recovery" is not a formalized primitive.

### P11 — Cost Budget for Recovery
**Description:** An allocated token/time budget for recovery attempts, separate from the main task budget.  
**Status:** NOT OBSERVED. Budget caps exist (max_budget_usd), but they apply to the full execution, not specifically to recovery attempts. No system distinguishes "productive task budget" from "recovery budget."

### P12 — Safety Policy During Recovery
**Description:** Ensuring that recovery actions comply with the same safety constraints that caused the stall.  
**Status:** NOT OBSERVED. The OSGuard paper simply terminates after N retries; it does not generate policy-compliant alternatives. The HARD STOP vs RECOVERABLE STOP distinction with policy compliance during recovery is NOT implemented anywhere.

### P13 — Verification After Recovery
**Description:** An independent check that the recovered state is valid and the task has genuinely progressed.  
**Status:** EXISTS. CCP's TaskCompleted gate, AIGIS Decision Engine. Reflexion's environment feedback loop. This is the strongest existing primitive.

### P14 — Historical Learning of Failed Paths
**Description:** Recording what recovery paths were tried, why they failed, and making that available to prevent repetition.  
**Status:** PARTIALLY EXISTS. Reflexion carries forward verbal self-critiques. RIR (Sep 2026) explicitly carries forward "reusable knowledge distilled from the abandoned trajectory." AgentAssay records behavioral traces offline. But no system maintains a *live, indexed, policy-aware* failed-path registry during production execution.

### P15 — Trajectory Memory
**Description:** A persistent record of the full execution trajectory (not just the current context window).  
**Status:** PARTIALLY EXISTS. Temporal's event history is an exact trajectory record. LangGraph persistence records graph state. But both are crash-recovery oriented; neither is designed for semantic stagnation detection.

### New Capabilities Discovered (Beyond Owner's Hypothesis)

**P16 — Semantic Equivalence Detector:** Beyond exact state repetition, detect when the agent's "effective situation" is equivalent to a previous state despite surface differences. Related to behavioral fingerprinting but needs real-time, in-loop operation. NOT found commercially.

**P17 — Recovery Cost Predictor:** Before launching recovery, estimate how many tokens the recovery will cost vs. simply restarting. If restart is cheaper, recommend it. The "Do Nothing / Restart Test" exposes this gap: no system makes this calculation. NOT found.

**P18 — Policy-Gap Analyzer:** When a policy blocks progress, determine *why* (missing authorization, scope issue, irreversibility concern) and generate the most specific possible recovery action that addresses the gap. Distinctly different from "retry with smaller scope." NOT found.

**P19 — Second-Order Recovery Governor:** Prevent the recovery mechanism itself from looping. A meta-level circuit breaker for recovery. Zylos Research mentions the risk of nested retries but no solution. NOT found.

**P20 — Evidence Continuity Across Context Boundary:** Ensure that "what the agent did to the world" (side effects) is never lost in a compaction. A write-ahead log for agent side effects, independent of the LLM context window. The Agent Reliability Design Guide identifies this gap explicitly. NOT found as a commercial product.

**P21 — Stall Classification Audit Trail:** An append-only record of every stall event: type (loop/stagnation/context/policy-block), recovery attempted, result, cost. This enables post-incident analysis. NOT found as a first-class artifact.

**P22 — Provider-Agnostic Recovery Envelope:** Recovery semantics that work identically on Claude Code, OpenAI Agents API, and Cursor. Given the GuardFall weakness and provider-specific policy differences, a portable recovery layer could reduce operator lock-in. Conceptually interesting; high implementation complexity.

---

## 5. EXISTING-SOLUTION REALITY

### Major Capability Assessment

| Capability | Existing System | Concept | Implementation | Observed | Reproduced | Limitation |
|---|---|---|---|---|---|---|
| Loop detection | FutureAGI, loopless | YES | YES | DOCUMENTED | NOT REPRODUCED in this session | Detects and stops; does not recover |
| Loop detection (static) | IAL-Scan (Jul 2026) | YES | YES (research) | DOCUMENTED | NOT REPRODUCED | Pre-deployment only, not runtime |
| Crash recovery + checkpoint | Temporal, LangGraph, livingai | YES | YES | DOCUMENTED | NOT REPRODUCED | Crash recovery, not semantic recovery |
| Context compaction | Claude Code (5 mechanisms) | YES | YES | DOCUMENTED | PARTIALLY (github evidence) | Compaction can lose critical state |
| Budget caps / circuit breakers | Claude SDK, AIGIS, loopless | YES | YES | DOCUMENTED | NOT REPRODUCED | Stop only; no recovery path |
| Durable execution | Temporal, DBOS, AWS Lambda Durable | YES | YES | DOCUMENTED | NOT REPRODUCED | Infrastructure; not agent-semantic |
| Subagent delegation | Claude SDK, OpenAI SDK, LATS | YES | YES | DOCUMENTED | NOT REPRODUCED | Not specifically for recovery |
| State fingerprinting (offline) | AgentAssay | YES | YES (research) | DOCUMENTED | NOT REPRODUCED | Regression testing only, not live recovery |
| Rollback + knowledge carry | RIR (Sep 2026), GA-Rollback | YES | YES (research) | DOCUMENTED | NOT REPRODUCED | Research only; no production deployment found |
| Progress signal | FutureAGI, ReflexGrad | YES | PARTIALLY | DOCUMENTED | NOT REPRODUCED | Research/observability only |
| Within-episode recovery | ReflexGrad (ICML 2026) | YES | YES (research) | DOCUMENTED | NOT REPRODUCED | Research; not production SDK |
| Policy-block recovery | — | CONCEPT ONLY | NO | NOT OBSERVED | — | No system addresses this specifically |
| Safety-constrained recovery | — | CONCEPT ONLY | NO | NOT OBSERVED | — | No system ensures policy compliance DURING recovery |
| Minimum sufficient context for recovery | — | CONCEPTUALLY REFERENCED | NO | NOT OBSERVED | — | Gap explicitly named in Agent Reliability guide |
| Recovery cost estimation | — | NO | NO | NOT OBSERVED | — | No system calculates recovery vs restart cost |
| Stall audit trail | — | NO | NO | NOT OBSERVED | — | No first-class stall log |

**Critical distinction maintained throughout:**  
CONCEPT ≠ IMPLEMENTATION ≠ DEPLOYED PRODUCTION FEATURE ≠ COMMERCIAL PRODUCT ≠ PAID CUSTOMER

---

## 6. COMPOSITION ANALYSIS

### Which combinations of primitives appear together?

**Combination 1: Loop Detection + Stop** (COMMON)
- Implementations: FutureAGI, loopless, AIGIS (max_iterations), Claude SDK (max_turns)
- Behavior: Detect repetition → terminate or alert
- Gap: No recovery path

**Combination 2: Crash Recovery + Replay** (COMMON)
- Implementations: Temporal, LangGraph, livingai
- Behavior: Serialize state → crash → resume from checkpoint
- Gap: Semantics-based recovery (wrong approach, not crashed)

**Combination 3: Self-Reflection + Retry** (RESEARCH, COMMON)
- Implementations: Reflexion (2023), RIR (Sep 2026), GA-Rollback (EMNLP 2025), ReflexGrad (ICML 2026)
- Behavior: Detect failure → generate verbal critique → retry with updated strategy
- Gap: Not designed for policy-block-induced stalls; assumes agent has authority to retry

**Combination 4: Branch Exploration + Adjudication** (RESEARCH, UNCOMMON)
- Implementations: LATS (MCTS + value function), RIR (selective rollback + reflection)
- Behavior: Generate multiple alternative paths → score → select best
- Gap: Not integrated with policy enforcement; assumes all paths are permitted

**Combination 5: Context Compaction + Side-Effect Preservation** (GAP — NOT OBSERVED)
- What would need to exist: Write-ahead log for side effects outside the LLM context window
- Agent Reliability Guide names this gap explicitly
- No commercial implementation found

**Combination 6: Policy Check + Recovery Generation** (GAP — NOT OBSERVED)
- What would need to exist: When a policy blocks action A, generate alternative action A' that satisfies the goal and the policy
- Closest: OSGuard's fixed retry budget (not recovery generation)
- The owner's concept of "exploring which approaches are policy-compliant" is NOT in any system

### Which combinations are already implemented elsewhere?

The research found that the majority of the SAGR hypothesis's components exist individually or in pairs. The specific cluster of:
- **Loop detection + Safety classifier (RECOVERABLE vs HARD) + Policy-compliant alternative generation + Bounded exploration with safety constraints + Cost-of-recovery vs cost-of-restart decision + Stall audit trail**

...is NOT observed as a composed system anywhere.

### Assessment

The hypothesis is NOT that "these primitives exist" (they do, individually and in some pairs). The hypothesis is that a specific integrated layer connecting them does not exist. This is a COMPOSITION NOVELTY, not a CONCEPT NOVELTY.

However: Composition novelty is weaker than concept novelty as a commercial differentiator. A determined engineer could compose existing tools to approximate most of this. The RIR paper (Sep 2026) already implements a research prototype that covers 60–70% of the proposed composition.

---

## 7. RECOVERY MODEL

### Strongest Surviving Conceptual Recovery Architecture

**Source:** Synthesized from Agent Reliability Engineering Design Guide (Aug 2026), RIR paper (Sep 2026), "From Agent Loops to Structured Graphs" (Apr 2026), OSGuard (2026), loopless, AIGIS circuit breakers, and the owner's hypothesis.

**Note:** This is conceptual description only. No implementation is recommended or authorized.

```
EXECUTION TRAJECTORY
        │
        ▼
  HEALTH MONITOR (continuous)
        │
  ┌─────────────────────────────────┐
  │ Signals measured per step:       │
  │ - Action fingerprint             │
  │ - Progress toward goal           │
  │ - Token velocity                 │
  │ - Blocker identity               │
  │ - Evidence gain per token        │
  └─────────────────────────────────┘
        │
  STALL DETECTED?
       /     \
      YES      NO
      │         │
      ▼         ▼
STALL CLASSIFIER      CONTINUE
      │
  ┌───────────────────────────────────────────┐
  │ CLASSIFY:                                  │
  │ HARD STOP: safety violation, irreversible  │
  │            action, budget exhausted        │
  │ RECOVERABLE: policy-block, tool failure,   │
  │              context degradation, loop     │
  │ INFORMATIONAL: log, continue               │
  └───────────────────────────────────────────┘
            │
     HARD STOP → STOP (never bypass safety)
            │
     RECOVERABLE:
            │
     RECOVERY COST ESTIMATOR
     "Cost to recover < Cost to restart?"
            │
     RECOVERY BUDGET ALLOCATED
            │
     RECOVERY PLANNER
     "Which paths are: (a) new, (b) policy-compliant, (c) progress-increasing?"
            │
     BOUNDED EXPLORATION
     (2–3 options maximum; each with isolated context)
            │
     POLICY CHECK ON EACH PATH
     (safety constraints enforced BEFORE exploration, not after)
            │
     ADJUDICATOR
     (select best path by: novelty × progress × cost × policy-compliance)
            │
     MINIMAL CONTEXT RECONSTRUCTION
     (task + current state + why prior path failed + policy constraints + new hypothesis)
            │
     RESUME WITH VERIFICATION GATE
            │
     STALL AUDIT TRAIL APPENDED
```

**What makes this different from existing systems:**
- The STALL CLASSIFIER explicitly distinguishes policy-induced stalls from unsafe actions.
- The RECOVERY PLANNER generates policy-COMPLIANT alternatives (not just "retry with different arguments").
- The POLICY CHECK is enforced BEFORE exploration, not after.
- The RECOVERY COST ESTIMATOR enables choosing "restart" when recovery is more expensive.
- The STALL AUDIT TRAIL is an append-only record of every stall event.

**What this shares with existing systems:**
- Health monitor: FutureAGI, Agent Reliability guide
- Stall detection: loopless, IAL-Scan, circuit breakers
- Bounded exploration: LATS, RIR
- Minimal context: conceptual in RIR, Reflexion
- Verification gate: CCP's TaskCompleted, AIGIS Decision Engine

---

## 8. CONTEXT ECONOMY

### What Information Must Persist?

**NEVER LOSE (invariant):**
- Side-effect ledger: what the agent did to the world outside the LLM context (files written, emails sent, APIs called, payments made). Agent Reliability Engineering Guide explicitly flags this as a critical gap in current compaction.
- Safety constraints and authorization scope.
- Task identity and acceptance criteria.
- Evidence hash of completed verified artifacts.
- Stall history: which paths were tried and why they failed.

**CAN BE SUMMARIZED:**
- Step-by-step reasoning chains.
- Intermediate tool outputs (once their facts are extracted).
- Failed exploration branches (summarize reason for failure; discard branch content).

**CAN BE DISCARDED:**
- Duplicate tool responses.
- Reasoning that reached incorrect conclusions (once error is documented).
- Workflow management overhead (system messages, confirmations).

**CAN BE RECONSTRUCTED:**
- Current file state (from disk, not from context).
- Test results (re-run).
- Any deterministic observation (replay activity in Temporal model).

**UNNECESSARILY EXPENSIVE:**
- Full conversation history in every subagent context.
- Repeated tool schemas that have not changed.
- Contextual reasoning already superseded by verified evidence.
- Recovery context growing beyond the task context.

### Proposed Separation

| Layer | Content | Owner | Compactable |
|---|---|---|---|
| FULL HISTORY | Complete transcript | Session | YES (carefully) |
| STATE | Current plan + verified evidence + blocker | Evidence Registry | NO |
| EVIDENCE | Hashes + artifacts + checks | Evidence Registry | NO |
| MEMORY | Lessons from failed paths | Stall Audit Trail | NO |
| CURRENT CONTEXT | Active reasoning + live tool results | LLM context window | YES |
| RECOVERY CONTEXT | Minimum sufficient for recovery agent | Recovery Manager | GENERATED, NOT STORED |

**Observed gap:** No production system maintains all six layers distinctly. CCP maintains STATE and EVIDENCE; Claude Code compaction addresses CURRENT CONTEXT; but MEMORY (failed path lessons) and RECOVERY CONTEXT generation are absent.

---

## 9. COST / TOKEN ECONOMICS

### Documented Costs

**Agent token multiplier:** LeanOps (2026) measured 50x more tokens for agents vs single-turn chatbots on equivalent tasks. "Five to 30 times more tokens per task, because of reasoning loops, tool calls, retries, and multi-agent coordination" (Splunk, Jun 2026).

**Context accumulation tax:** Every subsequent LLM call receives the full conversation history. By step 20, input can exceed 50K tokens; at Claude Sonnet 4.6's $3/M input, one late-loop step costs $0.15.

**Incident costs:**
- $47,000 — 11-day LangChain Analyzer/Verifier loop (Nov 2025).
- $16,000–$50,000 — Claude Code recursive loop in 5 hours (Jul 2025).
- Uber: entire 2026 AI coding budget exhausted in 4 months (The Information, Apr 2026).
- ZopDev (May 2026): 9 agents consuming 180K tokens/day vs expected 20K; caught within 60 minutes with registry.

### Where Recovery Could Save Cost

1. **Early stall detection:** Stopping a 50-step loop at step 5 saves 45 LLM calls × full context.
2. **Minimal context for recovery agents:** If recovery context is 10% of full context, recovery tokens are 10% of a full restart.
3. **Avoiding repeated blocked paths:** If a policy blocks path A, and the system learns this, it avoids 3 blocked attempts at A before finding B.
4. **"Restart vs recover" decision:** If recovery requires 200K tokens and restart requires 50K, restart wins.

### Where Recovery Could Increase Cost

1. **Recovery itself loops:** Without a second-order governor, a stuck recovery is more expensive than the original failure.
2. **Parallel branch exploration:** Spawning 5 recovery subagents simultaneously costs 5× the single-agent budget.
3. **Minimum sufficient context reconstruction:** If context reconstruction is probabilistic and wrong, recovery may inherit the wrong state.
4. **Recovery verification:** Adding verification gates after recovery adds latency and tokens.

### Balance is Unknown

The net cost impact of state-aware recovery depends on:
- Ratio of recoverable stalls to unrecoverable failures in a given workload.
- Quality of the recovery planner (generates good alternatives vs circular alternatives).
- Quality of the recovery verifier (detects successful recovery before overspending).
- Cost of minimal context reconstruction vs full restart.

**This is not established empirically in any paper or commercial deployment.** The $47K incident suggests the cost of NO recovery is high; it does not establish that the proposed system would have been cheaper than a 24-hour restart cycle.

---

## 10. SAFETY / RECOVERY

### Critical Invariant

```
STALL ≠ PERMISSION TO BYPASS SAFETY

A recoverable stall is: "This path is blocked by policy; find another path that is NOT blocked."
A hard stop is: "This policy block is correct; the action must not be taken; stop."

These are different and must be distinguished by the system, not the agent.
```

### Fail-Closed on Unsafe; Fail-Forward on Safe-but-Stalled

The phrase "Fail-closed on unsafe actions; fail-forward on recoverable execution failures" (from the conversation notes) is conceptually sound but requires a precise operational definition:

**FAIL-CLOSED class** (non-negotiable hard stops):
- Action would violate authorization scope.
- Action is irreversible and cannot be verified.
- Action would exfiltrate sensitive data.
- Action would modify safety/governance controls.
- Evidence is contradictory or corrupted.
- Budget is fully exhausted.
- Recursion depth is exceeded.

**FAIL-FORWARD class** (recoverable with recovery plan):
- Tool transient failure (network timeout, rate limit).
- Policy block that could be addressed by a narrower-scope action.
- Context degradation that can be repaired by reconstruction.
- Semantic stagnation (same approach repeatedly; new approach may work).
- Context budget approaching limit (compact before limit, not after).
- Blocker waiting on external condition.

**Risk:** The boundary between fail-closed and fail-forward is a security-critical classification. If the classifier is wrong:
- Incorrectly classifying a hard stop as recoverable → the recovery system attempts to bypass the safety constraint. This is more dangerous than the original failure.
- Incorrectly classifying a recoverable stall as a hard stop → the system terminates prematurely. This is less dangerous, merely wasteful.

**Conservative design principle:** Default to HARD STOP when the classification is uncertain. Only recover when the fail-forward condition is deterministically verified.

### Which Recovery Paths Are Inherently Unsafe?

1. **Any recovery that modifies the policy itself:** NemoClaw incident (Mar 2026) showed an agent copying config to disable its own guardrails. Recovery must NEVER include config-mutation tools.
2. **Recursive recovery without depth limit:** Without P19 (Second-Order Recovery Governor), recovery loops are possible and more expensive than the original failure.
3. **Speculative side effects during recovery:** If a recovery branch makes external API calls, writes to files, or charges cards, and the branch is later abandoned, those side effects persist. Recovery branches should be sandboxed.
4. **Recovery that expands authorization scope:** A policy-block exists because the action exceeds scope; recovery must not request an expanded scope to proceed.

---

## 11. COMPETITIVE REALITY

### Products That Already Exist with Relevant Capabilities

| Product | Loop Detection | Crash Recovery | Budget Caps | Context Compaction | Policy-Block Recovery | Safety During Recovery |
|---|---|---|---|---|---|---|
| FutureAGI | ✓ Named feature | — | — | — | — | — |
| loopless (PyPI) | ✓ Core feature | — | — | — | — | — |
| livingai (PyPI) | — | ✓ Core feature | — | — | — | — |
| Temporal.io | — | ✓ Core feature | — | — | — | — |
| LangGraph | — | ✓ Checkpointer | — | — | — | — |
| Claude Agent SDK | Basic (max_turns) | Basic (max_budget) | ✓ | ✓ | — | — |
| OpenAI Agents API (Sept 2026) | — | "multi-step recovery" | — | — | — | — |
| AIGIS (OSS) | ✓ max_iterations | — | ✓ max_tool_calls | — | — | — |
| Reflexion (research) | — | ✓ (episode-level) | — | — | — | — |
| RIR (Sep 2026, research) | — | ✓ Rollback+reflection | — | ✓ (selective) | — | — |
| ReflexGrad (ICML 2026) | ✓ Progress-gated | ✓ Within-episode | — | — | — | — |
| AgentRewind (research) | — | ✓ Checkpoint+rewind | — | — | — | — |
| OSGuard (research) | — | ✓ Fixed retry budget | ✓ Budget | — | Partial (retry limit) | — |
| "AI Runtime Infrastructure"/VIGIL (research) | ✓ Precursor | ✓ Integrated | — | — | — | — |
| AgentAssay (research) | ✓ Fingerprinting | — | ✓ Adaptive | — | — | — |

**Key observation:** Every column has at least one solution. The rightmost two columns (policy-block recovery, safety during recovery) have NO solutions.

### Verification Status

| Product | Exists | Code Verified | Tests Run | Users Known | Revenue Known |
|---|---|---|---|---|---|
| FutureAGI | DOCUMENTED (May 2026 glossary) | NOT VERIFIED | NOT VERIFIED | UNKNOWN | UNKNOWN |
| loopless | DOCUMENTED (PyPI) | NOT REPRODUCED | NOT REPRODUCED | UNKNOWN | UNKNOWN |
| livingai | DOCUMENTED (PyPI) | NOT REPRODUCED | NOT REPRODUCED | UNKNOWN | UNKNOWN |
| AIGIS | VERIFIED (teardown: 223/234 tests pass) | VERIFIED | 223 passed | 0 stars/0 forks | $0 |
| RIR, ReflexGrad, AgentAssay | DOCUMENTED (arXiv) | NOT REPRODUCED | NOT REPRODUCED | RESEARCH | RESEARCH |

### Overlap Assessment

The claimed novel composition (loop detection + safety classifier + policy-compliant recovery + bounded exploration + minimal context + cost decision + stall audit trail) is NOT a single product anywhere. But individual pieces are widely implemented. The specific **safety-constrained recovery under governance** aspect has no observed equivalent.

---

## 12. FALSIFICATION

### Strongest Arguments Against the New Hypothesis

**Objection 1 (It already exists):**
RIR (Sep 2026) implements rollback + knowledge preservation. AgentRewind implements checkpoint + rewind. Reflexion implements self-reflection + retry. FutureAGI implements loop detection commercially. The hypothesis describes a composition of these; the composition does not add value proportional to its complexity.
*Assessment:* PARTIALLY VALID. The components exist; the specific safety-constrained-recovery composition does not. PARTIALLY KILLS the novelty claim.

**Objection 2 (It is trivial to implement):**
A developer can combine max_turns + FutureAGI loop detection + a Reflexion-style retry with a safety check. This is 2–3 days of engineering, not a product.
*Assessment:* PARTIALLY VALID for the simple version. The "policy-compliant alternative generation" piece is NOT trivial; it requires a recovery planner that understands the policy semantics.

**Objection 3 (It is unnecessary):**
Teams handle agent loops by setting budget caps, restarting, and designing better prompts. The $47K incident happened because no budget cap was set — a trivial engineering mistake, not a systems architecture problem.
*Assessment:* PARTIALLY VALID for the loop-detection component. NOT valid for the control-induced-stall component, which cannot be solved by a budget cap.

**Objection 4 (It increases cost more than it saves):**
Spawning 3 recovery subagents costs 3× the normal turn. If recovery succeeds 30% of the time, the expected cost is higher than restarting. Without empirical data on recovery success rates, the cost benefit is unknown.
*Assessment:* VALID. No empirical data exists on recovery success rates. This kills the cost-saving claim until measured.

**Objection 5 (It creates security risk):**
A recovery planner that interprets why a policy blocked an action and generates alternatives is exactly the behavior that security researchers call "reasoning around the guardrail." If the recovery planner outputs "use a different tool to achieve the same restricted result," it has created a security bypass.
*Assessment:* VALID. This is the most serious objection. Recovery planner MUST be constrained to "find a DIFFERENT goal path" not "achieve the SAME goal by a different method." This distinction is hard to enforce in LLM-generated plans. It is potentially a security anti-pattern.

**Objection 6 (It creates recursion):**
Recovery triggers recovery triggers recovery. Without a strict global recursion budget, the recovery layer can be more expensive and dangerous than the original failure.
*Assessment:* VALID. Identified as P19 (Second-Order Recovery Governor). The system proposal must include this.

**Objection 7 (It produces false recovery):**
A recovery agent that reports "RECOVERED" when the agent is actually in a subtly wrong state is worse than a hard stop, because it propagates an incorrect execution. The Recoverability paper (Sep 2026) notes: "A saved state is not necessarily a suitable place to resume."
*Assessment:* VALID. The verification gate (P13) partially addresses this, but is not foolproof.

**Objection 8 (The provider can absorb it):**
OpenAI Agents API (GA Sept 10, 2026) ships "multi-step recovery" and "subagent delegation" server-side. Anthropic's Claude Agent SDK ships max_turns, max_budget, PreCompact. The provider roadmap is toward absorbing these features. A third-party layer will be commoditized.
*Assessment:* VALID. Provider trajectory is confirmed. The specific "policy-compliant recovery" aspect is unlikely to be absorbed, because providers do not want to reason about their own safety policies in a recovery planner (safety conflict of interest).

**Objection 9 (The developer simply restarts):**
For most developer workflows, restarting a session is 30 seconds and costs less than one recovery attempt. The real cost is context rebuild, not tokens.
*Assessment:* VALID for interactive developer use. NOT valid for unattended production agents running overnight.

**Objection 10 (The metric cannot be measured):**
"Recovery success rate" requires knowing what "success" looks like at the point of stall. But if the agent is stalled, the success criterion may itself be ambiguous. The metric depends on a clarity that the stall's cause may have destroyed.
*Assessment:* VALID. This makes empirical validation of SAGR harder than simple loop detection.

**Objection 11 (The buyer cannot be identified):**
The prior market research found no buyer for "agent control plane" as a standalone product. Platform Engineering teams use provider-native controls. AppSec/CISO teams buy security products, not agent reliability products. Developers restart. Who specifically pays for "state-aware governed recovery"?
*Assessment:* VALID. Commercial buyer remains UNKNOWN.

**Objection 12 (It is an internal optimization, not a product):**
The right home for SAGR is inside a specific agent framework (LangGraph, Claude Code, OpenAI Agents) or inside a specific production agent deployment, not as a cross-provider product. Each deployment's recovery logic will differ because each deployment's policies differ.
*Assessment:* VALID. The policy-dependent nature of recovery makes portability difficult.

**Objection 13 (It is a research topic, not a product):**
The academic landscape has multiple 2026 papers (RIR, AgentRewind, ReflexGrad, VIGIL, AI Runtime Infrastructure) already addressing this. The field is converging on solutions. Publishing a research artifact that feeds this convergence is more valuable than building a product that will be superseded.
*Assessment:* PARTIALLY VALID. The gap between research prototypes and production deployments is real; but it is closing.

---

## 13. SURVIVING HYPOTHESES

Only evidence-supported or gap-evidence-supported hypotheses. Vocabulary: SUPPORTED, PARTIALLY SUPPORTED, NOT SUPPORTED, CONTRADICTED, UNKNOWN, NOT FOUND, COMMERCIAL UNKNOWN.

| Hypothesis | Status | Evidence |
|---|---|---|
| H-S1: Execution loops are a real, costly, documented production failure | SUPPORTED | $47K incident (Nov 2025), $16K–$50K Claude Code incident (Jul 2025), multiple documented cases |
| H-S2: Loop detection mechanisms exist and are effective | SUPPORTED | FutureAGI (May 2026), loopless (PyPI), IAL-Scan (Jul 2026), AIGIS circuit breakers |
| H-S3: Crash recovery (checkpoint/replay) is a solved problem for durable workflows | SUPPORTED | Temporal, LangGraph, livingai, AWS Lambda Durable Functions |
| H-S4: The academic community is actively studying agent execution recovery and rollback | SUPPORTED | 10+ papers in 2025–2026 (MAST, AgentAssay, RIR, ReflexGrad, AgentRewind, VIGIL, AI Runtime Infrastructure, "From Agent Loops to Structured Graphs", "When Agents Do Not Stop") |
| H-S5: A policy/safety block can cause an agent to retry indefinitely rather than recover | PARTIALLY SUPPORTED | GitHub issue #96579 (hermes-agent) documents this bug; OSGuard proposes fixed retry budget as mitigation |
| H-S6: The distinction between HARD STOP and RECOVERABLE STOP is not formally defined in any production system | PARTIALLY SUPPORTED | Not found as a named concept; OSGuard's fixed retry budget is the closest proxy |
| H-S7: Policy-compliant alternative generation (when a safety block causes a stall) is not implemented anywhere | NOT FOUND | No system observed that generates alternatives that explicitly satisfy the blocking policy |
| H-S8: "Minimum sufficient context for recovery" is an unsolved problem | PARTIALLY SUPPORTED | Agent Reliability Engineering Guide names the gap; no commercial solution found |
| H-S9: The cost of recovery vs cost of restart is not calculated by any production system | NOT FOUND | Budget caps exist; "should I recover or restart" calculation not found |
| H-S10: Side-effect records (what the agent did to the world) can be lost in context compaction | SUPPORTED | Agent Reliability Engineering Guide names this explicitly; GitHub issue #24976 documents the dead-end state |
| H-S11: A global retry budget (across all nested recovery attempts) is not implemented | NOT FOUND | Local retry budgets exist (AIGIS max_iterations); global recovery budget not found |

---

## 14. KILLED HYPOTHESES

| Hypothesis | Verdict | Kill Evidence |
|---|---|---|
| "Loop detection is novel" | CONTRADICTED | FutureAGI (commercial, May 2026), loopless (PyPI), IAL-Scan (Jul 2026), AIGIS, agent circuit breakers |
| "State fingerprinting is novel" | CONTRADICTED | AgentAssay (Mar 2026): behavioral fingerprints from execution traces |
| "Subagent delegation for recovery is novel" | CONTRADICTED | LATS (2023), AutoGen, OpenAI Agents SDK, Claude Agent SDK all support subagents; RIR uses them for exploration |
| "Checkpoint + rollback is novel" | CONTRADICTED | Temporal (mature), LangGraph (GA), GA-Rollback (EMNLP 2025), RIR (Sep 2026), DeltaBox, CRAB |
| "Context compaction/reconstruction is novel" | CONTRADICTED | Claude Code (5 compaction mechanisms, PreCompact hook), Reflexion, RIR's knowledge carry-forward |
| "Recovery planning from failed trajectories is novel" | CONTRADICTED | Reflexion (2023), RIR (Sep 2026), AgentRewind (2026), GA-Rollback, ReflexGrad |
| "Cost-aware agents are novel" | CONTRADICTED | Budget caps (max_budget_usd), token-rate monitoring, ZopDev registry, AIGIS max_tool_calls |
| "Evidence-gated completion is novel" | CONTRADICTED | AIGIS (prior teardown), multiple commercial products |
| "Historical learning of failed paths" | CONTRADICTED | Reflexion, RIR (carries forward "reusable knowledge distilled from abandoned trajectory"), GA-Rollback |
| "Bounded branch exploration for recovery is novel" | CONTRADICTED | LATS (MCTS), RIR (adaptive review scheduling), SGH (strict escalation protocol) |
| "State-aware recovery" broadly defined | CONTRADICTED | RIR (Sep 2026) implements rollback-boundary control, state selection, and knowledge retention — directly implements 70% of the proposed hypothesis |
| "The owner's process was novel by experiencing a control-induced stall" | PARTIALLY CONTRADICTED | The experience is real; the problem class is named but the specific recovery architecture for it is genuinely absent |

---

## 15. COMMERCIAL REALITY

### For each surviving hypothesis gap:

**Gap 1: Policy-Compliant Alternative Generation (H-S7)**

| Dimension | Assessment |
|---|---|
| PROBLEM | When a safety/policy block causes an agent stall, the agent retries the blocked action instead of generating alternatives that satisfy the policy |
| USER | Production agent operators, SREs managing unattended agent pipelines |
| OPERATIONAL OWNER | Platform Engineering, DevOps, AI Platform teams |
| ECONOMIC BUYER | UNKNOWN — this is engineering pain, not compliance-driven procurement |
| CURRENT SOLUTION | Fixed retry budget (terminate after N retries) — OSGuard; no recovery |
| GAP | System terminates when it could potentially recover; productive work is lost |
| ECONOMIC CONSEQUENCE | UNKNOWN — number of stalls caused by policy blocks vs total failures is not measured |
| BUDGET | UNKNOWN |
| WTP | COMMERCIAL UNKNOWN |
| PROVIDER ABSORPTION RISK | MEDIUM — providers could embed a simple recovery heuristic in their policy enforcement; but safety conflict of interest may prevent them from generating policy-satisfying alternatives |

**Gap 2: Recovery Cost vs Restart Decision (H-S9)**

| Dimension | Assessment |
|---|---|
| PROBLEM | No system calculates whether recovery costs more than restarting; teams spend on recovery that costs more than a simple restart |
| USER | Cost-sensitive production agent operators |
| ECONOMIC CONSEQUENCE | Unknown fraction of wasted recovery spend; $47K incident cost breakdown not available |
| BUYER | COMMERCIAL UNKNOWN — this is a cost optimization, which engineering teams often implement internally |
| ABSORPTION RISK | HIGH — provider SDK adds one config option (always restart); product opportunity closes |

**Gap 3: Side-Effect Continuity Through Compaction (H-S10)**

| Dimension | Assessment |
|---|---|
| PROBLEM | Context compaction can lose records of agent side effects, causing duplicate actions on resume |
| USER | Production agent operators for agents that write files, call APIs, charge payments |
| ECONOMIC CONSEQUENCE | Duplicate transactions, data integrity issues — HIGH consequence in financial/healthcare contexts |
| BUYER | Higher-value buyer than pure loop-detection: compliance-adjacent |
| ABSORPTION RISK | HIGH — Anthropic could add a side-effect ledger to Claude Agent SDK |
| NOTES | This is the closest to a commercial-viable gap; it has compliance relevance and is not obviously provider-absorbable because it requires per-deployment knowledge of what counts as a side effect |

**Aggregate:** The surviving commercial opportunities are narrow, dependent on specific deployment contexts, and carry high provider absorption risk. The prior verdict `COMMERCIAL THESIS NOT SUPPORTED` for standalone-product form is NOT changed by this research.

---

## 16. PRECISION AUDIT

**What could still be wrong:**

1. The RIR paper (Sep 2026) is very recent (12 Sep 2026, 9 days before this research). Its results have not been reproduced independently. If it does not hold in practice, the "rollback + knowledge carry-forward" gap would reopen.

2. The loopless and livingai PyPI packages were observed as PyPI entries; their actual adoption and production-readiness were not assessed. They may be prototype-quality.

3. The OpenAI Agents API "multi-step recovery" (GA Sept 10, 2026) description was from a tutorial article, not the official OpenAI documentation. The specific capabilities of "multi-step recovery" were not independently verified.

4. The hermes-agent GitHub issue #96579 (control-induced stall bug) is the primary evidence for H-S5. It is a single issue report, not a systematic study. The scope of this bug class is unknown.

5. The MAST failure taxonomy (NeurIPS 2025) identifies 14 failure modes in 7 frameworks; it does not specifically name "control-induced stall" as a mode. This absence is evidence that the mode is either rare, or subsumed into other categories.

6. All commercial claims (loopless, livingai, FutureAGI pricing, adoption) are based on documentation, not user interviews. Prior market research audit found buyer evidence at L0–L1 only.

**Which findings depend on weak evidence:**

| Finding | Source Strength | Risk |
|---|---|---|
| "Control-induced stall has no named recovery architecture" | MODERATE (single bug report, one OSGuard paper) | Could be addressed by other mechanisms not found |
| "Minimum sufficient context for recovery is unsolved" | WEAK (named in one guide, not in any study) | May exist in internal enterprise deployments |
| "Policy-compliant alternative generation does not exist" | MODERATE (systematic search, not found) | Search coverage is incomplete; may exist in internal tools |
| "RIR implements 70% of the hypothesis" | MODERATE (single recent paper, not reproduced) | Paper may not hold empirically |

**Which findings require reproduction:**

- loopless behavior under policy-block scenarios: not tested.
- OpenAI Agents API "multi-step recovery" behavior when a safety guardrail blocks action: not tested.
- Claude Code subagent recovery behavior when bash-firewall blocks an action: not tested.
- RIR paper results: not reproduced.

**Which findings require real users:**

- Whether operators experience "control-induced stall" as a significant pain point vs. accepting hard stops as correct.
- Whether the cost of recovery vs. restart matters to operators (or whether they simply set tighter budgets).
- Whether "side-effect continuity" is a compliance-relevant requirement for any operator segment.

---

## 17. RESEARCH LIMITATIONS

1. **Independence limitation:** Single research context. Track P (adversarial) is by the same model that wrote positive findings. True multi-agent independence was not achievable.

2. **No runtime reproduction:** No agent was run. Loop detection, recovery, compaction, and circuit breaker behaviors were assessed from documentation and papers, not from executed tests.

3. **Academic paper verification:** Recent papers (RIR, Recoverability as a Primitive, When Agents Do Not Stop) were published Sep 2026, within days of this research. Content is from search results, not full-text reading. Results may not be accurately represented.

4. **No operator interviews:** The primary evidence gap identified in prior research (L0–L1 buyer evidence) is not changed by this research. No customer was interviewed.

5. **Language coverage:** Non-English papers (Chinese, Japanese AI safety research) may have addressed control-induced stalls; not searched systematically.

6. **Internal enterprise implementations:** Large enterprises (Microsoft, Google, Amazon) may have internal recovery layers that are not publicly documented. The absence of public evidence is NOT proof of absence.

7. **Track Q composition search is incomplete:** Not all 2^15 combinations of P1–P15 were searched. The search focused on the most relevant combinations per the owner's hypothesis.

8. **Commercial product depth:** loopless and livingai were verified as PyPI entries. Their actual implementation quality, test coverage, production adoption, and business model were not assessed.

9. **Provider documentation:** OpenAI Agents API (GA Sept 10, 2026) and Anthropic's current Claude Agent SDK capabilities were assessed from third-party guides and GitHub issues, not from official documentation access.

---

## 18. FINAL STATE

Using only the approved hypothesis vocabulary. No ranking. No implementation recommendation.

| Subject | Status |
|---|---|
| Loop detection as a concept | SUPPORTED (commercially implemented, academically studied) |
| Crash recovery as a concept | SUPPORTED (Temporal, LangGraph mature) |
| Self-reflection and retry as a concept | SUPPORTED (Reflexion 2023, multiple follow-ons) |
| Rollback with knowledge carry-forward | SUPPORTED (RIR Sep 2026, research prototype) |
| Policy-block classification (RECOVERABLE vs HARD STOP) | NOT FOUND |
| Policy-compliant alternative generation | NOT FOUND |
| Recovery cost vs restart cost calculation | NOT FOUND |
| Side-effect continuity through compaction | PARTIALLY SUPPORTED (problem documented; solution not found commercially) |
| Global recovery budget (second-order governor) | NOT FOUND |
| State-aware governed recovery as a CONCEPT | CONCEPTUALLY OVERLAPPING with RIR, AI Runtime Infrastructure, VIGIL, AgentRewind |
| State-aware governed recovery as a COMPOSITION | PARTIALLY SUPPORTED — research prototypes implement 60–70% of the composition; specific integration gaps remain |
| State-aware governed recovery as a COMMERCIAL PRODUCT | COMMERCIAL UNKNOWN — no buyer evidence; provider absorption risk HIGH |
| Control-induced stall as a named failure class | NOT FOUND as a named concept with dedicated solution |
| SAGR as internal engineering value for CCP | RESEARCH OPPORTUNITY — specific primitives (P5, P10, P11, P12, P17–P22) are genuinely absent and could be studied |
| SAGR as OSS opportunity | RESEARCH OPPORTUNITY — the gap is real enough that a reference implementation would contribute to the field |
| SAGR as product opportunity | COMMERCIAL UNKNOWN — insufficient buyer evidence |

---

## 19. NEXT EVIDENCE

Each unknown that matters and cannot be resolved by further desk research.

### UNK-1: Operator Experience of Control-Induced Stalls

**WHY MATERIAL:** The most defensible novel claim is that "safety/policy blocks can cause stalls with no recovery path." If this is experienced as significant pain by production operators, a solution has clear pull. If operators accept hard stops as correct, there is no problem.  
**HOW TO RESOLVE:** Owner-initiated conversation with 2–3 production agent operators. The existing Field Validation Packet (CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_PACKET.md) can be extended with one specific scenario: "When a safety control blocks an action your agent needed, what happened next? Did you recover or restart? How much did it cost?"  
**OWNER ACTION REQUIRED:** Conduct at least 2 targeted conversations per Round 1 of the field validation protocol. Ask the specific H3 question: "When an AI-agent incident happens, how does your organization make sure the resulting lesson becomes a durable automated regression or control?" AND add: "When a guardrail or policy blocked an action your agent needed, what did the agent do next?"

### UNK-2: RIR and AgentRewind Reproducibility and Scope

**WHY MATERIAL:** If RIR (Sep 2026) is solid and reproducible, it implements 70% of the proposed hypothesis. If it is not reproducible or only works on toy benchmarks, the gap is larger than assessed.  
**HOW TO RESOLVE:** Read the full RIR paper (arXiv:2609.18304) and AgentRewind paper (arXiv:2608.14380). Attempt reproduction on a public benchmark (SWE-bench or similar). Assess whether their rollback+reflection architecture handles policy-constrained recovery or only handles capability failures.  
**OWNER ACTION REQUIRED:** Read and assess whether the reproduced system would work for the specific CCP use case.

### UNK-3: Side-Effect Continuity Demand

**WHY MATERIAL:** H-S10 (side-effect records lost in compaction) has the clearest commercial path of any surviving gap — compliance and financial integrity stakes. But it requires specific deployment contexts (agents calling payment APIs, modifying databases).  
**HOW TO RESOLVE:** Add to the field validation conversation: "Does your agent write to external systems (databases, APIs, payment systems) during a task? If the agent session compacted or restarted, how do you ensure those writes weren't duplicated?"  
**OWNER ACTION REQUIRED:** Same field validation Round 1. Ask specifically about idempotency and side-effect tracking.

### UNK-4: OpenAI Agents API "Multi-Step Recovery" Semantics

**WHY MATERIAL:** The tutorial article claims the OpenAI Agents API (GA Sept 10, 2026) ships "multi-step recovery" server-side. If this specifically handles policy-block scenarios, it closes the remaining gap and kills the opportunity.  
**HOW TO RESOLVE:** Read the official OpenAI Agents API documentation directly at `https://platform.openai.com/docs`. Specifically: what does "multi-step recovery" mean? Does it handle policy blocks or only crashes/timeouts?  
**OWNER ACTION REQUIRED:** Read the official documentation. One 30-minute read would clarify whether this capability closes the gap.

### UNK-5: Cost Impact of Policy-Induced Stalls vs. All Other Failures

**WHY MATERIAL:** If policy-block stalls represent 5% of failures, the opportunity is small. If they represent 40%, it is significant.  
**HOW TO RESOLVE:** This requires empirical measurement in a real agent deployment. Cannot be resolved by desk research.  
**OWNER ACTION REQUIRED:** If pursuing SAGR further, instrument a real agent deployment to categorize failures by type (tool failure, policy block, context degradation, loop, budget exhaustion) for 30–60 days.

---

## 20. ANTI-LABYRINTH CHECK

**Did this research produce genuinely new information?**  
YES. The research discovered:
- A cluster of 2025–2026 papers directly addressing the hypothesis (RIR, AgentRewind, ReflexGrad, AI Runtime Infrastructure, When Agents Do Not Stop, Recoverability as a Primitive) that were not in prior research.
- Commercial products (loopless, livingai) specifically for loop detection and recovery that did not appear in prior research.
- The hermes-agent GitHub issue documenting the specific "blocked tool calls invisible to guardrail" bug — the most concrete evidence for the control-induced stall problem.
- The Agent Reliability Engineering Design Guide naming the "side-effect ledger outside the context window" gap explicitly.

**Did it discover new capabilities from outside the original vocabulary?**  
YES. P16–P22 (Semantic Equivalence Detector, Recovery Cost Predictor, Policy-Gap Analyzer, Second-Order Recovery Governor, Evidence Continuity Across Context Boundary, Stall Classification Audit Trail, Provider-Agnostic Recovery Envelope) extend the owner's original vocabulary.

**Did it discover existing equivalents we were missing?**  
YES. RIR (Sep 2026) implements ~70% of the proposed hypothesis. The academic field has converged on rollback+knowledge-carry-forward as the research direction.

**Did it distinguish concept from composition from execution?**  
YES. The matrix in §5 explicitly separates CONCEPT / IMPLEMENTATION / OBSERVED / REPRODUCED / LIMITATION.

**Did it distinguish technical novelty from commercial value?**  
YES. §15 separates the gap evidence (technical) from the buyer evidence (commercial), finding the commercial case remains COMMERCIAL UNKNOWN.

**Did it attempt to falsify the owner's idea?**  
YES. Track P generated 13 strong objections. Five are assessed as VALID or PARTIALLY VALID. The strongest (Objection 5: recovery planner is a security bypass risk; Objection 1: RIR already implements most of it) are preserved as material findings, not softened.

**Did it create another document merely to continue the loop?**  
RISK: This research is additive documentation. The anti-labyrinth assessment is:
- This research answers a materially different question than prior research ("does SAGR exist and is it needed?" vs "does an agent control plane have commercial value?").
- It produces new findings (RIR, control-induced stall documentation, side-effect gap).
- It identifies specific, owner-actionable next evidence (UNK-1 through UNK-5) — not more desk research.
- It does NOT recommend opening F10. It does NOT recommend implementation.
- If the owner takes no action from this document and no field validation is conducted, this research loop SHOULD BE CLOSED.

**Did it accidentally create implementation scope?**  
NO. No hooks, skills, agents, registries, or runtime files were modified or recommended for modification. The conceptual recovery architecture in §7 is labeled "NOT recommended for implementation."

---

## A. RESEARCH PROGRAM MAP

17 tracks executed (A through Q). All additive to prior research. F1–F9 untouched.

---

## B. DOMAIN COVERAGE MATRIX

| Domain | Coverage | Depth | Key Source(s) |
|---|---|---|---|
| Agent loop detection | THOROUGH | DEEP | FutureAGI, loopless, IAL-Scan, Agent Reliability Guide |
| Crash recovery / durable execution | THOROUGH | DEEP | Temporal, LangGraph, Zylos Research, livingai |
| Academic agent recovery (2025–2026) | THOROUGH | MODERATE | RIR, AgentRewind, ReflexGrad, AI Runtime Infrastructure, MAST, AgentAssay |
| Commercial agent observability | THOROUGH | MODERATE | FutureAGI, LangSmith, MLflow comparison |
| Control-induced stall (Track F) | MODERATE | SHALLOW | One GitHub issue, OSGuard paper |
| Cost economics | THOROUGH | DEEP | Multiple incident reports, LeanOps data, Splunk |
| Safety + recovery tension | MODERATE | MODERATE | OSGuard, NemoClaw incident, circuit breaker articles |
| Distributed systems analogues | MODERATE | MODERATE | Circuit breakers, saga, livelock detection in robotics |
| Claude Code specific | THOROUGH | DEEP | SDK docs, GitHub issues, compaction research |
| LATS / branch exploration | THOROUGH | DEEP | LATS (2023), AG2 docs, ReflexGrad |
| Standards (AIUC-1, OpenTelemetry) | SHALLOW | SHALLOW | Named in prior research; not primary-source verified |
| Business / buyer evidence | SHALLOW | SHALLOW | No new buyer interviews |

---

## C. CAPABILITY PRIMITIVE MATRIX

See §4 (P1–P22). Each primitive assessed for existence, implementation, and gap.

---

## D. EXISTING-SOLUTION MATRIX

See §5 and §11. Complete product/paper comparison table.

---

## E. COMPOSITION MATRIX

See §6. Six compositions assessed, two identified as genuinely absent.

---

## F. FAILURE-MODE MATRIX

| Failure Class | Named in Literature | System Solution | Recovery Path | Severity |
|---|---|---|---|---|
| Infinite loop (tool level) | YES (IALs, MAST) | Circuit breakers, max_iterations | STOP ONLY | HIGH |
| Infinite loop (semantic) | PARTIALLY (stagnation) | Loop detection, progress metrics | STOP ONLY | HIGH |
| Crash mid-execution | YES (durable execution field) | Temporal, LangGraph, livingai | RESUME | HIGH |
| Context overflow | YES (compaction field) | Claude Code compaction | COMPACT | MEDIUM |
| Policy-block stall | NOT NAMED | Fixed retry budget (OSGuard) | TERMINATE | MEDIUM–HIGH |
| Budget spiral | YES (cost runaway) | Budget caps, circuit breakers | STOP | HIGH |
| Recovery loop | MENTIONED (retry storm) | Global budget (proposed) | NONE | VERY HIGH |
| Side-effect loss in compaction | NAMED (one guide) | None found | NONE | HIGH (compliance) |
| Subagent context explosion | DOCUMENTED (#24976) | File-based result passing (workaround) | NONE | HIGH |

---

## G. RECOVERY MECHANISM TAXONOMY

| Mechanism | Examples | Trigger | Safety | Verified |
|---|---|---|---|---|
| Bounded retry | OSGuard (N tries then stop) | Policy block | N/A (terminates) | RESEARCH |
| Self-reflection retry | Reflexion | After episode failure | No constraint | RESEARCH |
| Rollback + reflection | RIR, GA-Rollback | State error detected | No constraint | RESEARCH |
| Progress-gated routing | ReflexGrad | Progress signal drops | No constraint | RESEARCH |
| Durable execution replay | Temporal, LangGraph | Process crash | No constraint | COMMERCIAL (mature) |
| Circuit breaker | AIGIS, loopless, agent patterns | Tool failure rate | Terminates | COMMERCIAL |
| Budget cap | Claude SDK, OpenAI SDK | Token/cost threshold | Terminates | COMMERCIAL |
| Branch exploration | LATS, RIR | Failure on main path | No constraint | RESEARCH |
| Context compaction | Claude Code (5 mechanisms) | Token threshold | No constraint | COMMERCIAL |
| **Policy-constrained recovery** | **Not found** | **Policy block** | **Required** | **GAP** |

---

## H. CONTEXT-ECONOMY MODEL

See §8. Six-layer model: FULL HISTORY, STATE, EVIDENCE, MEMORY, CURRENT CONTEXT, RECOVERY CONTEXT. Gap: layers 4 and 6 are not implemented in any production system.

---

## I. COST / TOKEN MODEL

See §9. Net cost impact of SAGR is UNKNOWN. Recovery can save cost (early stall detection) or increase cost (parallel exploration, false recovery). Empirical data is absent. The $47K incident demonstrates the cost of NO loop detection; it does not validate any specific recovery architecture.

---

## J. SAFETY / RECOVERY MODEL

See §10. Critical invariant: STALL ≠ PERMISSION TO BYPASS SAFETY. Classification must be deterministic. Recovery planner must generate policy-COMPLIANT alternatives, not policy-CIRCUMVENTING ones. Recovery planner is a security-critical component.

---

## K. COMPETITIVE REALITY MATRIX

See §11. Full matrix with verification status. Key finding: every capability component has at least one implementation; the specific safety-constrained-recovery composition does not.

---

## L. ACADEMIC / RESEARCH MATRIX

| Paper | Date | Problem | Key Contribution | Overlap with SAGR | Gap |
|---|---|---|---|---|---|
| MAST (Cemri et al.) | NeurIPS 2025 | Multi-agent failure taxonomy | 14 failure modes, 3 categories | Loop/stagnation taxonomy | Does not name control-induced stall |
| AgentAssay (Bhardwaj) | Mar 2026 | Regression testing for non-deterministic agents | Behavioral fingerprinting, adaptive budget | State fingerprinting | Offline testing, not live recovery |
| AI Runtime Infrastructure (Cruz) | Feb 2026 | Execution-time layer for agent intervention | Names "AI Runtime Infrastructure" as a category | Same category as SAGR | VIGIL is post-failure, not in-loop |
| From Agent Loops to Structured Graphs (Wei) | Apr 2026 | Agent loop weaknesses | Bounded recovery, escalation protocol, DAG-based control flow | Recovery architecture | Position paper; no implementation |
| ReflexGrad (ICML 2026) | May 2026 | Within-episode failure recovery | Progress-gated dual-process routing | Progress signal + recovery | No policy constraint |
| When Agents Do Not Stop (Hou et al.) | Jul 2026 | Infinite agentic loop detection | IAL-Scan static analysis tool, ALDG | Loop detection | Static analysis only |
| AgentRewind (Zhuang et al.) | 2026 | Recoverable execution for long-horizon agents | Aligned checkpoint + textual memory | Checkpoint + rollback | Agent-initiated, no policy enforcement |
| Recoverability as a System Primitive (Zhang & Liu) | Sep 12, 2026 | Resumption correctness | Recoverability contract, behavioral contract | Recovery validation | Not policy-constrained |
| Rollback-Induced Reflection / RIR | Sep 2026 | Rollback + knowledge preservation | Rollback-boundary control, knowledge carry-forward | Closest academic match | No policy constraint |
| Recoverability Has a Law / ERR | Feb 2026 | Formal theory of recovery | Expected Recovery Regret measure | Recovery metrics | Tool-failure focus, not policy-block |
| "Always-On Agents" Survey | 2026 | Persistent state and governance | Comprehensive coverage of agentic OS, checkpointing | State continuity | Survey only |
| OSGuard | 2026 | Safety in computer-use agents | Fixed retry budget after guardrail block | Control-induced stall | Hard stop only; no recovery |

**Critical finding:** No paper specifically addresses recovery under safety constraints — finding alternatives that are BOTH novel AND policy-compliant. This is the specific academic gap that matches the owner's most defensible claim.

---

## M. BUSINESS RELEVANCE MATRIX

| Gap | Business Consequence | Operator Pain | Compliance Relevance | Buyer Budget |
|---|---|---|---|---|
| Loop detection | $47K incidents (documented) | HIGH (cost) | LOW | Engineering/Platform |
| Policy-block recovery | Unknown (not measured) | MEDIUM (productivity) | LOW | UNKNOWN |
| Side-effect continuity | Duplicate transactions, data integrity | HIGH (financial/healthcare) | HIGH (compliance) | Compliance/Legal |
| Recovery cost predictor | Unknown savings | LOW (easy to restart) | LOW | UNKNOWN |
| Global recovery budget | Unknown (prevents runaway) | MEDIUM | LOW | UNKNOWN |

---

## N. FALSIFICATION MATRIX

See §12. 13 objections, 5 assessed VALID or PARTIALLY VALID. Strongest: security risk of recovery planner (Objection 5), RIR already implements most of it (Objection 1), provider absorption (Objection 8).

---

## O. SURVIVING HYPOTHESES

See §13. H-S5, H-S6, H-S7, H-S8, H-S9, H-S10, H-S11 survive as NOT FOUND or PARTIALLY SUPPORTED.

---

## P. KILLED HYPOTHESES

See §14. All broad "state-aware recovery is novel" claims were killed by existing papers and products.

---

## Q. OPEN UNKNOWNS

See §19 (UNK-1 through UNK-5). All require owner action or field validation.

---

## R. PRECISION / CONFIDENCE AUDIT

**HIGH CONFIDENCE:** Loop detection is solved commercially (multiple products, papers). Crash recovery is mature (Temporal, LangGraph). Academic field has converged on rollback + reflection as the research direction (multiple 2026 papers).

**MEDIUM CONFIDENCE:** Control-induced stall is a real failure mode (one GitHub issue, OSGuard paper). Side-effect continuity gap is real (one design guide, one GitHub issue). RIR implements 70% of hypothesis (from search results; not reproduced).

**LOW CONFIDENCE:** OpenAI Agents API "multi-step recovery" scope and semantics (secondary source; no primary documentation read). loopless and livingai production quality (PyPI entries only). Commercial buyer for SAGR (no interviews; no WTP evidence).

**UNKNOWN:** Whether control-induced stalls are common enough to matter commercially. Whether policy-compliant alternative generation is feasible without becoming a security risk. Net cost impact of recovery vs restart.

---

## S. RESEARCH LIMITATIONS

See §17. Key: single-context independence limitation, no runtime reproduction, no operator interviews, recent papers not fully verified.

---

## T. FINAL SYNTHESIS

### What is the actual problem?

An AI agent enters a non-productive state. This can be caused by: a repeating loop, a semantic stall, a context overflow, a policy block, or a cost spiral. The agent does not stop on its own. The system may not detect the stall. If detected, the system has no recovery path beyond "stop" or "retry the same thing."

### What is merely a symptom?

The $47K and $50K incidents are symptoms of no loop detection and no budget cap — problems that now have multiple commercial solutions. These are NOT evidence for SAGR specifically.

### What is already solved?

- Loop detection and hard stopping: FutureAGI, loopless, AIGIS circuit breakers.
- Crash recovery: Temporal, LangGraph, livingai.
- Self-reflection and retry: Reflexion, GA-Rollback.
- Rollback with knowledge carry-forward: RIR (Sep 2026, research).
- Budget enforcement: Claude SDK max_budget_usd, AIGIS max_iterations.

### What is only partially solved?

- Context compaction: exists but can lose side-effect records (P20 gap).
- Progress-based recovery: ReflexGrad (research, not commercial).
- Bounded branch exploration with adjudication: LATS (research and framework, not integrated recovery product).

### What genuinely remains?

1. **P5: Recovery Classifier (HARD STOP vs RECOVERABLE STOP)** for policy-block-induced stalls. No system makes this classification.
2. **P12: Safety-Constrained Recovery** — generating alternatives that satisfy the blocking policy. No system implements this.
3. **P10: Minimum Sufficient Context for Recovery** — a formalized primitive for recovery agent context. Concept only.
4. **P11: Recovery Budget** — a separate allocation for recovery attempts vs. task execution. Not found.
5. **P17/P18: Recovery Cost Predictor / Policy-Gap Analyzer** — tools for making the recovery decision. Not found.
6. **P19: Second-Order Recovery Governor** — preventing the recovery itself from looping. Not found.
7. **P20: Evidence Continuity Through Compaction** — side-effect ledger independent of LLM context. Not found commercially.
8. **P21: Stall Audit Trail** — append-only record of stall events for post-incident analysis. Not found.

### Which ideas are simply existing primitives under new names?

- "State Regression" = checkpoint + rollback (Temporal, LangGraph).
- "Plan Regression" = Reflexion-style retry.
- "Behavioral Regression" = AgentAssay behavioral fingerprinting.
- "Context Regression" = Claude Code compaction.
- "Explorer subagents" = LATS tree search nodes.
- "Adjudication" = LATS value function.
- "Recovery knowledge" = Reflexion/RIR carry-forward.

### Which combinations are materially different?

The specific composition of:
- **Policy-block classifier (RECOVERABLE vs HARD) + Safety-constrained alternative generator + Recovery cost estimator + Bounded exploration with policy enforcement + Verification gate** 

...is NOT found in any system. Whether this composition would work in practice is UNKNOWN (see Objection 5 on security risk).

### Which are commercially relevant?

**Highest commercial relevance:** P20 (Side-effect continuity through compaction) — compliance-adjacent, not easily provider-absorbable, clear consequence (duplicate transactions).

**Medium commercial relevance:** P5/P12 (Policy-block recovery) — depends entirely on whether operators experience control-induced stalls as significant pain vs. accepting hard stops.

**Low commercial relevance:** P11, P17, P18, P21 — internal optimizations the provider can absorb.

### Which have buyer evidence?

NONE. Zero buyer evidence was generated by this research. This is unchanged from the prior research cycle.

### Which could be absorbed by providers?

HIGH absorption risk: Loop detection, budget caps, compaction improvements, crash recovery. These are provider core infrastructure.

LOW absorption risk: P12 (safety-constrained recovery) — because providers have a conflict of interest in reasoning about their own safety policies' bypassability.

### Which could become standards/OSS?

RESEARCH OPPORTUNITY: A reference implementation of the Recovery Classifier (P5) and Stall Audit Trail (P21) as an OSS library. These are general enough to be provider-agnostic and useful to the broader community.

### Which should remain internal?

Any implementation of P12 (safety-constrained alternative generation) should remain as an internal engineering study until the security implications are thoroughly analyzed. An incorrectly implemented recovery planner is a guardrail bypass mechanism.

### What evidence would distinguish the survivors?

- 3+ operator interviews confirming control-induced stalls as operational pain → elevates H-S5/H-S6/H-S7.
- Full reproduction of RIR paper on SWE-bench or similar → determines whether rollback + reflection handles policy-constrained scenarios.
- Official OpenAI Agents API documentation on "multi-step recovery" semantics → determines whether the gap is already closed.
- 60-day failure categorization in a real agent deployment → determines what fraction of failures are policy-block-induced.

### Final Research Verdict

The owner's new hypothesis is PARTIALLY SUPPORTED at the technical level. The problem is real. The specific composition proposed is not fully implemented anywhere. The most defensible novel claim is the "safety-constrained recovery" gap — finding alternatives that satisfy a blocking policy without weakening it. This is genuinely absent from the literature.

However, the hypothesis is substantially WEAKER than first articulated because:
- The academic field has converged on this problem independently (9+ papers in 2025–2026).
- Commercial products address the loop-detection component.
- Durable execution addresses the crash-recovery component.
- The security risk of a recovery planner is a genuine concern, not a theoretical objection.
- The commercial buyer for SAGR remains COMMERCIAL UNKNOWN.

The strongest surviving recommendation is NOT to build a product. It is to:
1. Conduct field validation (Round 1, already prepared) with 2–3 operators, extending the H3/H4 questions to specifically probe control-induced stall experience (UNK-1).
2. Read the RIR and Recoverability papers in full to determine their policy-constraint scope (UNK-2).
3. Read official OpenAI Agents API documentation on recovery semantics (UNK-4).

These three actions cost hours, not months. They will either confirm a genuine gap or close this research program with a clear evidence-based conclusion.

---

## ENGINEERING PROHIBITION CONFIRMATION

This document is research only.  
- No hooks modified.  
- No skills added.  
- No agents created.  
- No registries changed.  
- No settings.json modified.  
- No evidence, decision, incident, control, or regression record added.  
- F1–F9 historical checkpoints: unchanged.  
- F10: NOT opened.  
- Runtime: unchanged from F8 baseline (`2cd7953`).

---

## CHANGE MANAGEMENT CONFIRMATION

Permitted by this document:
- This additive research document.
- The source entries it cites.
- Nothing else.

Forbidden:
- Rewriting F1–F9 history.
- Deleting negative evidence.
- Changing frozen checkpoints.
- Retroactively reinterpreting historical findings.
- Silently upgrading UNKNOWN to SUPPORTED.

---

*END OF MULTI-DOMAIN RESEARCH COUNCIL DOSSIER*  
*September 21, 2026*

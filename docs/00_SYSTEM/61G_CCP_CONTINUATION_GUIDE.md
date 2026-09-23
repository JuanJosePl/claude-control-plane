# 61G — CCP Continuation Guide

**Created:** 2026-09-23  
**Purpose:** Exact next actions from the current state. A new AI can use this to continue without re-deriving what's been established.

---

## Current State at Handoff

```
PHASE:              8 — COMPLETE / FROZEN
LAST_MOVEMENT:      007 (2026-09-23)
LAST_GIT_CHECKPOINT: df489d0 (before this handoff commit)
IMPLEMENTATION_READY: false
OWNER_GATES_OPEN:   READY-01, READY-02, READY-03, READY-04
NOW_EXECUTABLE:     HRQS checklist (docs change), PAC corpus (research), query-log.sh (DONE)
```

---

## Immediate Next Actions (No Authorization Needed)

### Action 1: HRQS Checklist (PRIORITY — unblocks READY-04 urgency)

**What:** Add §13 to docs/CONTROL_PLANE_HANDBOOK.md — Human Review Quality Standard checklist.

**Why:** The HRQS gap was identified in M007. When a STALL_POLICY event fires, humans reviewing it need a quality standard for evaluating whether the blocked command was a true positive or false positive. This is especially urgent because PAC-EF-02 (PATTERN_NAME_IN_LITERAL) is a new FP class that reviewers currently have no framework to identify.

**Scope:** Documentation addition only. No changes to hooks, settings, rules, agents, or any .claude/ file.

**Content of §13 should include:**
1. Checklist for evaluating a STALL_POLICY event
2. How to identify each known FP class (including PAC-EF-02)
3. Escalation criteria (when to involve owner)
4. Evidence recording for stall events reviewed by humans
5. N=1 threshold guidance for H-01 monitoring

**Authorization:** Not required. Handbook additions are documented under NOW_EXECUTABLE.

**Evidence:** This is a RESEARCH NOTE / DOCUMENTATION change. Does not require EV-NNN. Does not pass through TaskCompleted gate.

---

### Action 2: PAC Corpus Completion (Research Artifact)

**What:** Extend docs/research/pac/ccp_policies.yaml with the remaining ~12 policies from the 25-policy corpus.

**Why:** The M007 prototype extracted 13 of 25 policies. Completing the corpus validates whether zero semantic drift holds across all policies, and completes the PAC proof-of-concept for the READY-01/02 collapsed decision argument.

**Scope:** Research file only. No runtime impact.

**Authorization:** Not required. PAC corpus completion is documented under NOW_EXECUTABLE.

**Note:** PAC corpus completion does NOT authorize production PAC adoption. It remains a research artifact.

---

### Action 3: Update Exploration Engine for MOVEMENT 008

**What:** After executing HRQS + PAC corpus (these constitute MOVEMENT 008), update:
- docs/00_SYSTEM/CCP_EXPLORATION_ENGINE.md §2 current position
- §10 active experiments (add HRQS and PAC corpus as EXP-020/021, mark COMPLETE)
- §11 movement results (add MOVEMENT 008 block)
- §17 permanent movement history

---

## Next Movement Definition: MOVEMENT 008

**Movement:** MOVEMENT 008  
**Type:** Authorized Execution (both actions are already authorized)  
**Date:** 2026-09-23  

**Objective:** Execute the two authorized improvements that emerged from M007:
1. HRQS checklist (closes the human review quality gap)
2. PAC corpus completion (closes the architecture proof-of-concept gap)

**Expected outcomes:**
- HRQS §13 in CONTROL_PLANE_HANDBOOK.md
- PAC YAML corpus complete (all 25 policies)
- Exploration Engine updated
- Git checkpoint committed

**Stop condition:** Both improvements complete; no new authorized improvements remain without owner decisions.

---

## After MOVEMENT 008: Owner Decision Track

Once MOVEMENT 008 is complete, the frontier is:

```
1. OWNER DECISION: READY-04 (ELEVATED URGENCY — enhanced denial messages)
   → Ask owner: "Authorize updating bash-firewall.sh denial messages to include
     structured context (policy ID, policy text, blocked command, alternatives)?"
   → Implementation in 59A_EXECUTION_REHEARSAL.md §READY-04

2. OWNER DECISION: READY-01 (policy disambiguation)
   → Ask owner: "Authorize adding one sentence of disambiguation to each of 4 PARTIAL policies?"
   → Implementation in 59A_EXECUTION_REHEARSAL.md §READY-01

3. OWNER DECISION: READY-02 (normalization + patterns)
   → Ask owner: "Authorize adding NH-09 normalization + P1'/P2' patterns to bash-firewall.sh?"
   → Implementation in 59A_EXECUTION_REHEARSAL.md §READY-02
   → INVARIANT: Must preserve COMMAND/COMMAND_NORM invariant

4. OWNER DECISION: READY-03 (L1-C closure + N definition)
   → Ask owner: "What is your N threshold? Below N stall events = LABYRINTH-1 immaterial?"
   → Recommended: N = 1 (any event with had_alternative is informative)
   → After N defined: document in appropriate registry
```

---

## Decisions to NEVER Make Unilaterally

1. **Authorizing READY-01/02/03/04** without explicit owner authorization
2. **Modifying any .claude/hooks/ file** without authorization
3. **Creating new agent definition files** (F9-D01=A blocks this)
4. **Declaring F10-F12 scope** (F9-D05=A blocks this)
5. **Promoting deferred candidates** (F9-D01=A + F9-D03=B block this)
6. **Retroactively modifying evidence entries** (EV-001..EV-016 are frozen)
7. **Claiming production-level evidence for synthetic experiments**

---

## How to Record a New Movement

When executing a movement:

1. Create a new numbered research document: `docs/research/CCP_FINAL_RECONCILIATION/6N_MOVEMENT_00N.md`
2. Follow the movement template (see §11 in CCP_EXPLORATION_ENGINE.md for examples)
3. Document: START, QUESTION, TRACKS EXECUTED, RESULT, POSITION CHANGE, OPENED, CLOSED, STOP CONDITION
4. Update `docs/00_SYSTEM/CCP_EXPLORATION_ENGINE.md`:
   - §2 Current Position
   - §3 Frontier (reclassify items)
   - §10 Active Experiments (mark complete)
   - §11 Movement Results (add new block)
   - §15 Key Principles (if new lesson)
   - §16 Next Moves (update)
   - §17 Permanent Movement History (add)
5. Update `PROJECT_STATE.md`:
   - LAST_MOVEMENT field
   - CURRENT_OBJECTIVE if changed
   - Any newly closed/opened items
6. Run `evals/maintenance.sh` — must pass 12/12
7. Git commit: `[RESEARCH] MOVEMENT 00N: {one-line summary}`
8. Run `/checkpoint` to record hash in PROJECT_STATE.md

---

## Minimum Viable Progress Formula

If context is limited or time is short, the minimum viable action is:

```
IMPLEMENT HRQS §13 → COMMIT → UPDATE EXPLORATION ENGINE
```

This:
- Closes the identified human review quality gap
- Elevates review quality for PAC-EF-02 FP class
- Produces a documentable movement result
- Does not require any authorization
- Does not touch any runtime files

---

## Health Check Before Any Movement

Run:
```bash
bash evals/maintenance.sh
```

Expected: 12/12 PASS

If any diagnostic fails, investigate before proceeding. The maintenance suite is the invariant check.

---

## Git State at This Handoff

```
Branch: main
Last checkpoint: df489d0 (MOVEMENT 007)
Current commit: e066757 ([CONFIG] PROJECT_STATE: checkpoint df489d0)

Untracked files (not yet committed):
- .claude/hooks/lib/
- MAP_COMPLETE.md
- docs/00_SYSTEM/CCP_COMPLETE_CONCEPTUAL_MAP.md
- docs/00_SYSTEM/CCP_RESEARCH_ARCHITECTURAL_KNOWLEDGE_ATLAS.md
- docs/00_SYSTEM/STALL_POLICY_LOG.jsonl
- docs/00_SYSTEM/archive/CLAUDE_SESSION_LOG.2026-09-23.md
- docs/research/CCP_FINAL_RECONCILIATION/39_CONCILIACION...
- [many more research docs from M001-M007]
- docs/research/pac/ (PAC prototype)
- evals/r2/
- docs/00_SYSTEM/61_*.md (this handoff — newly created)
```

These untracked files must be staged and committed as part of the handoff checkpoint.

---

## The Handoff Commit

After creating the 61_* documents, commit:

```bash
git add docs/00_SYSTEM/61_CCP_COMPLETE_HANDOFF.md
git add docs/00_SYSTEM/61A_CCP_FILE_CATALOG.md
git add docs/00_SYSTEM/61B_CCP_JOURNEY_MAP.md
git add docs/00_SYSTEM/61C_CCP_DECISION_AND_AUTHORIZATION_HISTORY.md
git add docs/00_SYSTEM/61D_CCP_EVIDENCE_LINEAGE.md
git add docs/00_SYSTEM/61G_CCP_CONTINUATION_GUIDE.md
# Also include untracked files from M001-M007
git add docs/00_SYSTEM/STALL_POLICY_LOG.jsonl
git add docs/00_SYSTEM/archive/
git add docs/research/CCP_FINAL_RECONCILIATION/
git add docs/research/pac/
git add .claude/hooks/lib/
git add MAP_COMPLETE.md
git add docs/00_SYSTEM/CCP_COMPLETE_CONCEPTUAL_MAP.md
git add docs/00_SYSTEM/CCP_RESEARCH_ARCHITECTURAL_KNOWLEDGE_ATLAS.md
git add evals/r2/
git commit -m "[RESEARCH] Phase A: CCP Complete Handoff — M001-M007 history reconstructed + continuation guide"
```

Then update PROJECT_STATE.LAST_GIT_CHECKPOINT to the new hash.

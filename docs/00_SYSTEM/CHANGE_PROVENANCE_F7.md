# F7 Change Provenance

**Status:** SESSION CLOSURE HANDOFF
**Audit posture:** F7 is `CLAIMED_COMPLETE_PENDING_INDEPENDENT_REVALIDATION`.
**Baseline:** `b6e8fd0b76742ec0320af5a1b8598e712c8c67b6`
**Current F7 HEAD:** `094413c963466165443a5a5d8b4c1c3becc068e8`
**Scope:** complete committed delta `b6e8fd0..094413c`.

This document separates git authorship from model/session attribution. Git proves the human author
metadata shown below. The current conversation transcript provides session evidence for the commits
created during this execution. Neither source is a cryptographic model signature.

## Provenance Scale

- **FACT:** directly present in git or a repository artifact.
- **EVIDENCED:** directly supported by the current execution transcript or an executed command.
- **DOCUMENTED:** stated by an existing project document but not independently proven here.
- **INFERRED:** derived from timing, content or sequence; not conclusive authorship.
- **UNKNOWN:** no reliable attribution evidence.

## Current Session Signature

```text
SESSION_EXECUTOR: ChatGPT GPT-5.6 Luna Max
SESSION_EXECUTOR_LABEL: EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX
SESSION_ROLE: F7 FINALIZATION / CLOSURE / HANDOFF
SESSION_SCOPE: Provenance reconciliation + final verification state
SESSION_HEAD: 094413c
BASELINE_HEAD: b6e8fd0
SESSION_DATE: 2026-09-18T19:48:31Z
SESSION_ATTRIBUTION_TYPE: transcript attribution
CRYPTOGRAPHIC_SIGNATURE: NONE
```

This block attributes the closure session only. It does not claim that git can prove a model
identity or that all historical work was performed by this executor.

## Git Commit Matrix

All commits in the range have the same git metadata: author and committer `juan jose polo
<poloj3614@gmail.com>`. That is a human git identity, not a model identity.

| Commit | Date | Files | Bundle | Executor | Evidence | Review | Confidence |
|---|---|---|---|---|---|---|---|
| `37662b4` | 2026-09-18 13:44:59 -05:00 | `.claude/context/DECISIONS.md`, `DECISION_REGISTRY.md`, Handbook | ADR-004 | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-012 | Final fresh review of range: PASS | EVIDENCED / HIGH |
| `148501f` | 2026-09-18 13:45:42 -05:00 | `stop-logger.sh`, stop fixture | A: anti-loop | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-010 / REG-005 | Final fresh review of range: PASS | EVIDENCED / HIGH |
| `cc8634f` | 2026-09-18 13:46:38 -05:00 | `bash-firewall.sh`, firewall fixture | B: firewall | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-011 / REG-002, REG-006 | Final fresh review of range: PASS | EVIDENCED / HIGH |
| `748fc6a` | 2026-09-18 13:48:18 -05:00 | budget, maintenance, freshness and secret fixtures | Freshness + positive fixtures | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-009 / REG-002, REG-003, REG-004 | Final fresh review of range: PASS | EVIDENCED / HIGH |
| `b1471d0` | 2026-09-18 13:49:39 -05:00 | TaskCompleted hook, coupling fixture, maintenance | C: evidence coupling | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-012 / REG-007 | Final fresh review of range: PASS | EVIDENCED / HIGH |
| `7e3a9fc` | 2026-09-18 13:50:46 -05:00 | session logger, rotation fixture, maintenance | D: rotation | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-013 / REG-008 | Final fresh review of range: PASS | EVIDENCED / HIGH |
| `7b575e1` | 2026-09-18 13:52:01 -05:00 | installer, install fixture, maintenance | E: installer | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-014 / REG-009 | Final fresh review of range: PASS | EVIDENCED / HIGH |
| `82aaa75` | 2026-09-18 13:52:26 -05:00 | firewall hook | B: whitespace follow-up | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-011 / REG-006 | Final fresh review of range: PASS | EVIDENCED / HIGH |
| `1a3509e` | 2026-09-18 13:53:32 -05:00 | coupling fixture | C: invalid-evidence coverage | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-012 / REG-007 | Final fresh review of range: PASS | EVIDENCED / HIGH |
| `b659dfb` | 2026-09-18 14:05:35 -05:00 | firewall, TaskCompleted hooks and fixtures | Adversarial fixes | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-011, EV-012 / REG-006, REG-007 | Final fresh review: PASS; prior fresh rounds BLOCKED before these fixes | EVIDENCED / HIGH |
| `3ed9609` | 2026-09-18 14:17:57 -05:00 | registries, state, F7 report, roadmap and plan | Documentation/evidence closure | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-009…EV-014 | Included in final review range | EVIDENCED / HIGH |
| `a770761` | 2026-09-18 14:18:11 -05:00 | state and F7 report | Checkpoint metadata | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | Existing F7 evidence | Included in final review range | EVIDENCED / HIGH |
| `69b2c23` | 2026-09-18 14:18:35 -05:00 | EV-012 artifact hash | Evidence correction | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-012 | Included in final review range | EVIDENCED / HIGH |
| `dc89939` | 2026-09-18 14:18:46 -05:00 | state and F7 report | State closure metadata | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | PROJECT_STATE / POST_F7 | Included in final review range | EVIDENCED / HIGH |
| `ec8b76e` | 2026-09-18 14:19:21 -05:00 | EV-012 task identity | Evidence identity correction | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | EV-012 | Included in final review range | EVIDENCED / HIGH |
| `094413c` | 2026-09-18 14:19:32 -05:00 | state and F7 report | Final checkpoint metadata | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX` | PROJECT_STATE / POST_F7 | Included in final review range | EVIDENCED / HIGH |

The executor column is supported by the current session transcript, where the corresponding files
were read, edited with `apply_patch`, tested, and committed. It is not supported by git metadata.

## Attribution Groups

### PRE-F7 INHERITED WORK

- `b6e8fd0` and all earlier commits are `HISTORICAL_PRE_F7`; git author is FACT, model executor is
  UNKNOWN.
- The working tree at baseline contained six modified docs and four untracked research/audit
  artifacts, as documented in the F7 research handoff. Their model authorship is UNKNOWN.
- The session log contains historical subagent entries, but no model identity mapping to Kimi,
  ChatGPT or Opus. Those entries remain historical and are not relabeled.

### KIMI WORK

- `EXECUTOR_KIMI_K3_OPENCODE`: UNKNOWN for the `b6e8fd0..094413c` commit range.
- No git metadata, repository document or session-log entry explicitly attributes a F7 commit to
  Kimi K3.
- OpenCode is the execution environment; it is not evidence of the underlying model identity.

### CHATGPT WORK

- `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX`: EVIDENCED for all commits `37662b4..094413c` by the current
  conversation transcript and tool actions.
- This attribution covers the current implementation execution and its documentation closure, not
  pre-F7 work or any external execution.

### INDEPENDENT REVIEW

- Three fresh review calls are evidenced in the current transcript.
- The first review returned BLOCKED with firewall/evidence findings.
- The second review returned BLOCKED because it inspected committed code before the latest fixes
  were committed.
- The final review returned PASS for the committed `b6e8fd0..HEAD` range.
- Reviewer label: `REVIEWER_INDEPENDENT_UNSPECIFIED`. The reviewer was a `general` subagent; no
  evidence identifies Claude Opus, so `REVIEWER_OPUS` is not assigned.

### UNKNOWN / AMBIGUOUS WORK

- The human git identity is known; model identity is not encoded in commits.
- Kimi attribution is not proven.
- The authorship of baseline untracked audit documents and session-log entries is not proven.
- Closure documents created in this session are uncommitted and are not part of the F7 commit range.

## F7 Attribution Matrix

| Work item | First implemented by | Last modified by | Reviewed by | Current status | Provenance confidence |
|---|---|---|---|---|---|
| ADR-004 / ARCH-004 | ChatGPT session, `37662b4` | ChatGPT session, `37662b4` | Independent unspecified, final range review | CURRENT / documented | EVIDENCED / HIGH |
| Bundle A anti-loop | ChatGPT session, `148501f` | ChatGPT session, `148501f` | Independent unspecified, final range review | CURRENT / script-tested | EVIDENCED / HIGH |
| Bundle B firewall | ChatGPT session, `cc8634f` | ChatGPT session, `b659dfb` | Independent unspecified, final range review | CURRENT / script-tested | EVIDENCED / HIGH |
| Freshness evaluator | ChatGPT session, `748fc6a` | ChatGPT session, `748fc6a` | Independent unspecified, final range review | CURRENT / script-tested | EVIDENCED / HIGH |
| Positive fixtures | ChatGPT session, `cc8634f` and `748fc6a` | ChatGPT session, `b659dfb` | Independent unspecified, final range review | CURRENT / executed | EVIDENCED / HIGH |
| Bundle C evidence coupling | ChatGPT session, `b1471d0` | ChatGPT session, `b659dfb` | Independent unspecified, final range review | CURRENT / script-tested | EVIDENCED / HIGH |
| Bundle D rotation | ChatGPT session, `7e3a9fc` | ChatGPT session, `7e3a9fc` | Independent unspecified, final range review | CURRENT / script-tested | EVIDENCED / HIGH |
| Bundle E installer | ChatGPT session, `7b575e1` | ChatGPT session, `7b575e1` | Independent unspecified, final range review | CURRENT / script-tested | EVIDENCED / HIGH |
| Adversarial fixes | ChatGPT session, `82aaa75` and `1a3509e` | ChatGPT session, `b659dfb` | Independent unspecified, final review PASS | CURRENT / tested | EVIDENCED / HIGH |
| EV-009…EV-014 | ChatGPT session, `3ed9609` | ChatGPT session, `ec8b76e` | Independent unspecified, final range review | CURRENT / registry-recorded | EVIDENCED / HIGH |
| REG-002…REG-009 | ChatGPT session, `3ed9609` | ChatGPT session, `3ed9609` | Independent unspecified, final range review | CURRENT / active | EVIDENCED / HIGH |
| Documentation and Artifact Manifest | ChatGPT session, `3ed9609` | ChatGPT session, `094413c` | Independent unspecified, final range review | CURRENT / committed | EVIDENCED / HIGH |
| POST_F7_AUDIT_REPORT | ChatGPT session, `3ed9609` | ChatGPT session, `094413c` | Independent unspecified, final range review | CURRENT / committed | EVIDENCED / HIGH |
| PROJECT_STATE | ChatGPT session, `3ed9609` | ChatGPT session, `094413c` | Independent unspecified, final range review | CURRENT claims COMPLETE | EVIDENCED / HIGH |
| Evolution Roadmap | ChatGPT session, `3ed9609` | ChatGPT session, `3ed9609` | Independent unspecified, final range review | CURRENT F7; F8-F12 UNKNOWN | EVIDENCED / HIGH |
| Handbook | ChatGPT session, `37662b4` | ChatGPT session, `3ed9609` | Independent unspecified, final range review | CURRENT / synchronized | EVIDENCED / HIGH |

## Change-Budget Reconciliation

- Planned in the handoff: approximately 80 LOC, approximately 5 fixtures, 1 ADR and 1 config field.
- Documented in POST_F7: 591 additions, 17 deletions and 7 fixture files. This is a DOCUMENTED
  historical claim.
- Independently measured current scoped delta including ADR/Handbook: 608 additions and 18 deletions;
  7 fixture files. This is FACT from `git diff --numstat b6e8fd0..094413c` with the F7 implementation
  paths selected.
- Independently measured complete committed delta including documentation: 2524 additions and 28
  deletions across 24 paths. This is FACT.
- The discrepancy between 591/17 and 608/18 is an unresolved documentation-count reconciliation
  item. It is not silently corrected here.
- The delta remains within the five approved F7 bundles plus documentation. No new runtime hook,
  skill, agent, dependency or architecture was introduced.

## Closure Boundary

This file is a handoff artifact. It does not upgrade F7 from a claim to independent audit truth.
The next session must reproduce the entire range and treat all current PASS records as claims to
recheck.

# F7 Claim Versus Evidence

**Audit posture:** `CLAIMED_COMPLETE_PENDING_INDEPENDENT_REVALIDATION`
**Audit range:** `b6e8fd0..094413c`
**Rule:** repository claims and registry statuses are inputs to the audit, not proof by themselves.

| Claim | Source | Test / recheck | Result currently recorded | Evidence | Provenance | Limitation | Current trust level |
|---|---|---|---|---|---|---|---|
| F7 is complete | `PROJECT_STATE.md`, POST-F7 report | Maintenance, all F7 fixtures, state and registry cross-check | Project state says COMPLETE; current session reproduced the suites | EV-009…EV-014 | Current-session execution; registry-generated records | No independent full audit has yet challenged every claim | CLAIMED / pending independent audit |
| Stop hook is anti-loop | `.claude/hooks/stop-logger.sh` | `evals/hooks/stop-hook-idempotency.sh`; repeated `stop_hook_active=true` | PASS | EV-010 / REG-005 | Script execution in current session | Native Stop lifecycle not exercised | SCRIPT-TESTED / runtime audit required |
| Firewall is hardened | `.claude/hooks/bash-firewall.sh` | Positive fixture plus whitespace, case, tab, quote and process-substitution probes | PASS | EV-011 / REG-002, REG-006 | Current-session scripts plus independent unspecified review | Regexes do not prove arbitrary shell-obfuscation coverage; malformed JSON extraction remains a known limitation | SCRIPT-TESTED / security audit required |
| `.env` read families are covered | Firewall regex and fixture | Source, dot-source, eval, process substitution, read and exec variants | PASS | EV-011 | Current-session adversarial execution | Coverage is finite and pattern-based | SCRIPT-TESTED / adversarial audit required |
| Tier 3 freshness works | `evals/skills/evidence-freshness.sh` | Fresh results, duplicate session_id and stale timestamp probes | PASS | EV-009 / REG-004 | Current-session execution | Mtime fallback is policy, not cryptographic provenance | SCRIPT-TESTED / evidence audit required |
| Positive firewall fixture is active | `evals/hooks/firewall-positive.sh`, maintenance | Maintenance invokes fixture and fixture asserts block/allow outcomes | PASS | EV-009, EV-011 / REG-002 | Current-session execution | Fixture/evaluator share repository trust boundary | SCRIPT-TESTED / evaluator audit required |
| Positive secret-guard fixture is active | `evals/hooks/secret-guard-positive.sh`, maintenance | Fixture asserts real-looking secrets block and placeholders allow | PASS | EV-009 / REG-003 | Current-session execution | No independent mutation/evaluator-integrity control | SCRIPT-TESTED / evaluator audit required |
| TaskCompleted evidence is coupled | `.claude/hooks/task-completed-evidence.sh` | Matching, bare/full hash, empty/null, mismatch, historical mismatch, invalid status and malformed cases | PASS | EV-012 / REG-007 | Current-session execution plus independent unspecified review | Missing contract_hash remains a documented one-phase warning path | SCRIPT-TESTED / evidence audit required |
| Exact task identity is enforced | TaskCompleted awk matching | Historical and nonexistent task probes | PASS | EV-012 | Current-session execution | Current task identity still originates in the payload | SCRIPT-TESTED / identity audit required |
| Session rotation is safe | `.claude/hooks/subagent-stop-logger.sh` | Below threshold, threshold, repeated same-day rotation and archive preservation | PASS | EV-013 / REG-008 | Current-session execution | Native concurrent SubagentStop behavior not exercised | SCRIPT-TESTED / concurrency audit required |
| Installer is idempotent | `install.sh` | Clean, repeat, custom settings, interactive decline, force and partial recovery | PASS | EV-014 / REG-009 | Current-session execution | TTY behavior is fixture-mediated, not native Claude installation runtime | SCRIPT-TESTED / installation audit required |
| EV-001…EV-008 are preserved | Evidence registry and git diff | Append-only comparison against baseline | No deletions detected; current session rechecked | Historical EV records | FACT from git plus current check | Content semantics still need independent audit | HISTORICAL / recheck required |
| REG-001 and incident cycle are preserved | Incident/control/regression registries | Git comparison plus INC-001 execution | PASS / unchanged | REG-001, INC-001, CTRL-001, EV-006 | FACT plus current execution | Does not prove historical incident completeness | HISTORICAL / recheck required |
| EV-009…EV-014 are trustworthy | Evidence registry | Re-run source tests, recompute hashes, compare fields and timestamps | Entries exist and current scripts pass | EV-009…EV-014 | Current-session generated records | Registry authorship and evaluator independence are not cryptographically proven | REGISTRY-RECORDED / audit required |
| REG-002…REG-009 are meaningful | Regression registry and fixture paths | Confirm each path exists and executes | Entries exist; fixtures pass | REG-002…REG-009 | Current-session execution | Baseline Outcome semantics deserve independent review | REGISTRY-RECORDED / audit required |
| Independent review passed | Current-session review transcript and POST-F7 | Review actual committed range and findings | Final fresh `general` subagent returned PASS | POST-F7; no EV-specific reviewer identity field | EVIDENCED in transcript; reviewer model UNKNOWN | Not proven to be Opus; earlier fresh rounds returned BLOCKED | REVIEW-RECORDED / identity unknown |
| F7 introduced no new architecture | Commit/file delta | Scope audit of all 15 F7 commits | No new hooks, skills, agents or dependencies in committed delta | POST-F7; provenance matrix | FACT from file list | Budget/count discrepancy remains unresolved | SCOPE-CLAIM / audit required |
| F7 rollback is available | Git history and POST-F7 | Inspect per-bundle commits and revert paths | Revert paths documented; no destructive rollback executed | POST-F7 | DOCUMENTED and FACT from git | Rollback has not been executed end-to-end | DOCUMENTED / rollback audit required |
| Native Claude Code hooks were verified | None | No native runtime was available | NOT VERIFIED; this claim must not be made | POST-F7, PROJECT_STATE | FACT from execution environment | OpenCode script execution is not native lifecycle execution | NOT VERIFIED |
| F8 is ready | PROJECT_STATE / roadmap | No F8 research exists in repository | False as an implementation claim; F8 remains RESEARCH REQUIRED | PROJECT_STATE, roadmap | DOCUMENTED / current state | Must not be implemented from F7 closure | BLOCKED BY BOUNDARY |

## Trust Interpretation

- `SCRIPT-TESTED` means the repository script and fixture executed in this environment. It does not
  mean native Claude runtime behavior was exercised.
- `REGISTRY-RECORDED` means the entry is structurally present and linked. It does not mean the next
  auditor accepts its claim without reproduction.
- `CLAIMED` means current state documentation says the claim is true, pending independent audit.
- `HISTORICAL` means preserved material must not be retrospectively relabeled as current work.
- `UNKNOWN` model/reviewer attribution must remain UNKNOWN.

## Audit Findings Already Visible

| Finding | Status | Required treatment |
|---|---|---|
| Native Claude runtime not exercised | UNVERIFIED | Preserve; do not upgrade |
| Pre-existing unrelated worktree changes and untracked audit artifacts | DOCUMENTED | Do not revert or stage during audit without owner instruction |
| Pre-existing trailing whitespace blocks whole-worktree `git diff --check` | UNRESOLVED / BASELINE | Do not normalize during this closure |
| Missing `contract_hash` transitional warning path | DEFERRED BY ARCH-004 | Next phase may make it fail-closed; do not change during audit |
| Budget count mismatch: POST-F7 591/17 vs current scoped 608/18 | UNRESOLVED | Reconcile independently; do not rewrite POST-F7 during audit |
| Firewall regex coverage is finite | KNOWN LIMITATION | Attack nearby variants; do not expand controls during audit |
| Reviewer model identity is unspecified | UNKNOWN | Do not label reviewer Opus |

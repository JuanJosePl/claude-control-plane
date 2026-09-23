# 48 - R-2 Instrumentation

## Metadata
- Executor: OpenCode + ChatGPT 5.6 Max
- Date: 2026-09-22
- R2_BASELINE_HEAD: 4ede92ffba9650d35ce279aca9f24e0394ae1b08
- R2_FINAL_HEAD: "no commit"
- Prompt version: R2_OPENCODE_MASTER_PROMPT.md (per Claude Cowork bundle)
- Environment: OPENCODE_WORKDIR=/home/juanls/devProject/killavibes-final, CCP_ROOT=/home/juanls/Escritorio/claude-control-plane

## Objective
Minimum viable instrumentation of the CCP so that, when policy-related decisions are made by existing hooks, an observation event is recorded without changing security behavior, together with an evidence artifact describing future field observation.

## Scope
R-2 records observation events from two existing denial sites: `bash-firewall.sh` policy predicate matches and `task-completed-evidence.sh` denial paths. Events contain hashes and classification, never raw commands, file contents, credentials, tokens, or PII. The log is JSONL and starts empty.

R-2 does not measure STALL_POLICY frequency, collect field data, simulate a 30-day window, implement recovery, generate alternatives, non-bypass verification, SAGR, F10, or any architectural change. F1-F8 files and the canonical evidence registry were not modified.

## Files changed
Created:
- `.claude/hooks/lib/stall-record.sh`
- `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` (empty; no fabricated events)
- `evals/r2/r2-instrumentation.sh`
- `docs/research/CCP_FINAL_RECONCILIATION/48_R2_INSTRUMENTATION.md`

Modified:
- `.claude/hooks/bash-firewall.sh`
- `.claude/hooks/task-completed-evidence.sh`

Deleted:
- None.

Temporary captures under `.tmp/r2/` were used for baseline and post-change verification and are removed before closure.

## Instrumentation point
`bash-firewall.sh` line 6 sources the shared helper. Its existing `block` function at lines 31-46 finalizes `decision=2`, then calls the helper with `|| true`, then exits with the unchanged decision. This is the smallest policy denial site: the caller has already matched one of its existing policy predicates. The raw command is used only to calculate `action_hash` and is not written to the event.

`task-completed-evidence.sh` line 4 sources the shared helper. Its existing `block` function at lines 9-35 finalizes `decision=2`, classifies the existing denial reason, emits non-blocking observation data, and exits with the unchanged decision. The explicit missing-`contract_hash` policy path is `STALL_POLICY`. The generic `Evidence Contract invalid for task_id=...` branch is `UNKNOWN` because the existing branch does not distinguish all underlying causes. Other validation failures default to `STALL_ERROR`.

`secret-guard.sh` was not modified. The reconciliation specifically recommends observing the bash firewall and TaskCompleted gate first, and §10.2 limits the minimum implementation to two modified hooks. This avoids expanding R-2 without evidence that a third hook is required.

## Event schema
The implemented object is one independent JSON object per line:

```json
{"schema_version":"1.0","event_id":"<string>","timestamp":"<UTC ISO-8601>","source_hook":"<hook>","decision":"DENY","stall_type":"<STALL_POLICY|STALL_ERROR|UNKNOWN>","policy_category":"<string>","action_hash":"<sha256 hex or UNKNOWN>","task_id":"<string or null>","session_id":"<string or null>","notes":"<string>","had_alternative":null}
```

`had_alternative` is always `null`; instrumentation never infers it. The helper creates the parent directory when needed and appends only through `jq -nc`. It requires `CLAUDE_PROJECT_DIR` or an explicit `STALL_POLICY_LOG_PATH`; it never falls back to the current directory. The event log contains no header, comment, separator, or free text. The repository log is kept empty during tests; all generated test events are written to temporary fixture paths.

## Security analysis
The security decision is finalized in a local `decision=2` before the observation call. The call is explicitly non-gating with `|| true`, and the hook exits using that unchanged decision. Therefore:

`LOGGING FAILURE  !=  SECURITY BYPASS`

| test/hook | before | after | delta |
|---|---:|---:|---|
| bash-firewall valid allow | 0 | 0 | equivalent |
| bash-firewall policy denial | 2 | 2 | equivalent |
| task-completed-evidence valid allow | 0 | 0 | equivalent |
| task-completed-evidence evidence denial | 2 | 2 | equivalent |
| maintenance suite | 12/12 PASS | 12/12 PASS | equivalent |

Checked:
- Shell syntax for the helper, both modified hooks, and the R-2 harness.
- Baseline and post-change maintenance outputs.
- Baseline and post-change hook return codes using the same four payloads.
- JSON parsing, required fields, enum values, SHA-256 action hash format, and JSONL line count.
- Unknown classification preservation.
- Emission failure through a directory target and an unwritable directory; both retained exit code 2.
- No raw command was present in the generated event fixture.

Not checked:
- Native Claude lifecycle execution. This is script-level verification only.
- Actual disk-full behavior. The fail-safe test used a non-writable local directory.
- Production permissions, log rotation operations, or field observation.

## Tests
Baseline maintenance command:

`bash /home/juanls/Escritorio/claude-control-plane/evals/maintenance.sh > /home/juanls/Escritorio/claude-control-plane/.tmp/r2/baseline_evals.txt 2>&1`

Captured output: `baseline_evals.txt` lines 1-12 were all PASS: schema, installer, hooks, skills, incidents, state, evidence, docs, regression budget, evidence freshness, firewall positive, and secret guard positive.

Baseline hook probes were captured in `baseline_hooks.txt`:

```text
bash-firewall valid allow: 0
bash-firewall policy denial: 2
task-completed-evidence valid allow: 0
task-completed-evidence evidence denial: 2
```

New harness command:

`bash /home/juanls/Escritorio/claude-control-plane/evals/r2/r2-instrumentation.sh`

Captured output:

```text
event_emitted_correctly=PASS
schema_valid=PASS
unknown_preserved=PASS
malformed_event_cannot_weaken_enforcement=PASS
instrumentation_failure_is_fail_safe=PASS
```

Post-change maintenance command:

`STALL_POLICY_LOG_PATH=/home/juanls/Escritorio/claude-control-plane/.tmp/r2/maintenance-events.jsonl bash /home/juanls/Escritorio/claude-control-plane/evals/maintenance.sh > /home/juanls/Escritorio/claude-control-plane/.tmp/r2/after_evals.txt 2>&1`

Captured output: `after_evals.txt` lines 1-12 matched the baseline, all PASS. No test failed. One intermediate capture wrapper attempted to use unsupported `PIPESTATUS`; it was discarded and the command was rerun without a pipeline, returning `MAINTENANCE_AFTER_RC=0`.

## Behavioral verification
The same representative inputs were used before and after:

| Hook | Valid input before/after | Denial input before/after |
|---|---|---|
| `bash-firewall.sh` | `printf ok` -> 0 / 0 | `rm -rf /` -> 2 / 2 |
| `task-completed-evidence.sh` | matching EV-015 contract -> 0 / 0 | missing evidence task -> 2 / 2 |

The direct comparison of `baseline_hooks.txt` and `after_hooks.txt` returned `HOOK_BEHAVIOR_DIFF=equivalent`.

## Limitations
- Only two hooks emit R-2 events; `secret-guard.sh` and all other hooks remain uninstrumented.
- Early bash-firewall failures before a policy predicate, such as malformed input or unavailable `jq`, retain fail-closed behavior but do not use the policy-match event path.
- `task_id` and `session_id` are `null` when the existing hook payload does not provide them; no identifiers are inferred.
- The generic TaskCompleted evidence failure is intentionally `UNKNOWN`; it is not upgraded to a policy classification.
- The action is represented by a SHA-256 hash. The original command or payload is not recoverable from the event.
- The log records hook decisions, not user-visible stalls, agent intent, alternative viability, cost, time, or outcome.
- If neither `CLAUDE_PROJECT_DIR` nor `STALL_POLICY_LOG_PATH` is supplied, the helper emits no event rather than resolving a path from the current directory; the hook still returns its normal decision.
- No production or real-usage observation was performed.
- Native Claude Code lifecycle behavior remains unverified in OpenCode.

## Known unknowns
- Whether the native runtime supplies useful task and session identifiers to every relevant hook payload.
- Whether real operators experience any policy-related denial at a material rate.
- Whether a hook-level denial corresponds to a user-perceived stall in a particular runtime flow.
- Whether a human reviewer would classify any future event as having a viable alternative.
- Whether a future human reviewer can classify a generic evidence failure more precisely without reading data not present in the event.
- The exact production filesystem permissions available for the configured log path.
- The contract lists `docs/00_SYSTEM/DECISION_REGISTRY.md`, but that path does not exist in this repository; the actual operational registry at `CCP_ROOT/DECISION_REGISTRY.md` was read and used.

## How to collect real observation data
1. Confirm the owner is operating the CCP at `/home/juanls/Escritorio/claude-control-plane` and leave the existing hook wiring unchanged.
2. Before the observation window, rotate the current log without adding a header:
   `STAMP=$(date -u +%Y%m%dT%H%M%SZ); if [ -f "/home/juanls/Escritorio/claude-control-plane/docs/00_SYSTEM/STALL_POLICY_LOG.jsonl" ]; then mv "/home/juanls/Escritorio/claude-control-plane/docs/00_SYSTEM/STALL_POLICY_LOG.jsonl" "/home/juanls/Escritorio/claude-control-plane/docs/00_SYSTEM/STALL_POLICY_LOG.jsonl.$STAMP"; fi; : > "/home/juanls/Escritorio/claude-control-plane/docs/00_SYSTEM/STALL_POLICY_LOG.jsonl"`
3. Run normal CCP usage for the chosen N-day window. Do not add synthetic lines or manually mark `had_alternative` during capture.
4. Validate each collected line locally with `jq -e . /home/juanls/Escritorio/claude-control-plane/docs/00_SYSTEM/STALL_POLICY_LOG.jsonl`. A parse failure is an audit issue, not a reason to alter security behavior.
5. If a copy must be shared, redact identifiers in a separate valid JSONL copy: `jq -c '.task_id=null | .session_id=null' /home/juanls/Escritorio/claude-control-plane/docs/00_SYSTEM/STALL_POLICY_LOG.jsonl > /home/juanls/Escritorio/claude-control-plane/docs/00_SYSTEM/STALL_POLICY_LOG.jsonl.redacted`. Do not replace the original before preserving it.
6. After the window, stop collection by stopping CCP usage and preserving the log, or execute the rollback procedure below after checking its precondition. Do not treat the end of the window as a result.

## How to interpret future observations
- One event means one existing hook denial path was observed and an observation object was appended successfully.
- N events mean N recorded denial events in the selected observation window, subject to duplicate review and log integrity checks.
- N events with `had_alternative=true` mean a human later classified N recorded events as having a viable alternative in the human reviewer's judgment. This does not certify that an alternative is safe or non-bypass.
- N events do not establish a normalized frequency without a defined observation window and exposure denominator.
- N events do not establish materiality, safety of an alternative, causality, production coverage, or authorization for F10 or any recovery work.

## Rollback procedure
Run only after confirming that the two modified hooks contain the R-2 changes described above and no later owner changes:

```bash
CCP_ROOT=/home/juanls/Escritorio/claude-control-plane
R2_BASELINE_HEAD=4ede92ffba9650d35ce279aca9f24e0394ae1b08
git -C "$CCP_ROOT" show "$R2_BASELINE_HEAD:.claude/hooks/bash-firewall.sh" > "$CCP_ROOT/.claude/hooks/bash-firewall.sh"
git -C "$CCP_ROOT" show "$R2_BASELINE_HEAD:.claude/hooks/task-completed-evidence.sh" > "$CCP_ROOT/.claude/hooks/task-completed-evidence.sh"
rm -f "$CCP_ROOT/.claude/hooks/lib/stall-record.sh" "$CCP_ROOT/docs/00_SYSTEM/STALL_POLICY_LOG.jsonl" "$CCP_ROOT/evals/r2/r2-instrumentation.sh" "$CCP_ROOT/docs/research/CCP_FINAL_RECONCILIATION/48_R2_INSTRUMENTATION.md"
rmdir "$CCP_ROOT/.claude/hooks/lib" "$CCP_ROOT/evals/r2" 2>/dev/null || true
```

This procedure does not touch pre-existing uncommitted paths, the canonical evidence registry, or any file outside the enumerated R-2 files. The owner must re-run the maintenance suite after rollback.

## Provenance
| Claim | File and line | Command | Captured output |
|---|---|---|---|
| Baseline maintenance passed | `evals/maintenance.sh:44-45` | `bash /home/juanls/Escritorio/claude-control-plane/evals/maintenance.sh` | `.tmp/r2/baseline_evals.txt:1-12`, all PASS |
| Baseline return codes | Modified-hook targets before modification | Absolute hook probes recorded in `.tmp/r2/baseline_hooks.txt` | `.tmp/r2/baseline_hooks.txt:1-4` |
| Event is JSONL and hashed | `.claude/hooks/lib/stall-record.sh:17-41` | `bash /home/juanls/Escritorio/claude-control-plane/evals/r2/r2-instrumentation.sh` | Five named PASS lines; fixture JSONL parsed by `jq` |
| Policy denial remains exit 2 | `.claude/hooks/bash-firewall.sh:31-46` | Same harness and post-change absolute probes | `after_hooks.txt` denial line = 2 |
| Evidence denial remains exit 2 | `.claude/hooks/task-completed-evidence.sh:9-35` | Same harness and post-change absolute probes | `after_hooks.txt` denial line = 2 |
| Maintenance remains equivalent | `evals/maintenance.sh:44-45` | Post-change absolute maintenance command with temporary log path | `.tmp/r2/after_evals.txt:1-12`, all PASS |
| No repository event was fabricated | `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` | Absolute read after implementation and tests | Empty file, zero lines |

## Status
`R2 EXECUTED — AUDIT PENDING`

## Not covered by R-2
Explicit statement:
- STALL_POLICY frequency is NOT known from this artifact.
- Nothing here demonstrates the phenomenon exists at material rate.
- Nothing here justifies F10.
- Nothing here implements SAGR.

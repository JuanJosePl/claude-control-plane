# F8 Claim Versus Evidence

| Claim | Evidence | Verification mode | Status | Limitation |
|---|---|---|---|---|
| `contract_hash` is mandatory | EV-015; coupling fixture; direct absent-hash probe; hook diff | Script + independent fresh review round 3 | VERIFIED | Native TaskCompleted lifecycle NOT VERIFIED |
| Absent `contract_hash` blocks with `exit 2` and identifies the field | EV-015; `task-completed-coupling.sh` | Deterministic fixture | VERIFIED | Canonical repository task ID used for direct probe |
| Malformed firewall JSON fails closed | EV-016; firewall fixture; boundary matrix | Script + independent fresh review round 3 | VERIFIED | Native PreToolUse lifecycle NOT VERIFIED |
| Empty, whitespace-only, multi-document and raw-NUL firewall payloads block | EV-016; direct boundary probes | Deterministic adversarial probes | VERIFIED | No fuzzing framework added |
| Valid `{}` and empty command remain allowed | EV-016; direct boundary probes | Deterministic positive probes | VERIFIED | Policy is limited to valid single JSON payloads |
| Existing F7 firewall controls remain intact | F7 fixtures; maintenance 12/12; REG-002..REG-009 | Regression suite | VERIFIED | Regex coverage remains finite by design |
| A-06 reviewer identity convention is documented | Handbook §12; `92050dd` | Diff inspection; no runtime field added | VERIFIED | Machine field remains the existing `PASS`/`NOT_REQUIRED` schema |
| ARCH-004 was amended in place | `DECISION_REGISTRY.md`; decisions mirror | Diff inspection | VERIFIED | DESIGN.md numbering drift intentionally deferred |
| Historical evidence was preserved | Append-only prefix comparison; F7 reports unchanged | Git comparison | VERIFIED | Historical semantics remain historical, not reclassified |
| F8 evidence and regressions are complete | EV-015/EV-016; REG-010/REG-011; maintenance | Registry + deterministic checks | VERIFIED | Native runtime remains outside OpenCode capability |

# DEFERRAL INVENTORY

> **Purpose:** Empirical enumeration of every deferred decision/candidate in the
> Claude Control Plane, with each existing "reactivation trigger" prose
> classified against an observability rubric. **Data artifact, not policy.**
> Produced by EXP-1 of DEC-11 (see DECISION_SPACE_PREPARED §7 and the
> conversation log for MASTER PROMPT v2.0). Does not alter F9 OWNER GATE.

**Created:** 2026-09-26
**Origin:** DEC-11 experiment 1 (BUSCAR EXPERIMENTO DEC-11)
**Authority:** Data only. No deferral is modified by this file's existence.

---

## Classification Rubric

```
OBSERVABLE-DATE       Trigger is a calendar date or timeout (e.g. "after 2027-01-01").
OBSERVABLE-EVENT      Trigger is a specific event observable when it occurs
                      (e.g. "external audit", "reproducible G-B11 recurrence").
OBSERVABLE-CONDITION  Trigger is a state/predicate testable at review time
                      (e.g. "cadence missed", "boundary insufficient").
OBSERVABLE-COUNT      Trigger is a threshold count (e.g. "N of X events").
OBSERVABLE-LINK       Trigger is defined by reference to another deferral's
                      trigger (transitive; observability inherited).
VAGUE                 Trigger prose exists but predicate is not testable
                      (e.g. "when needed", "future consideration").
ABSENT                No trigger prose exists.
```

Rows may carry composite tags (e.g. `EVENT+CONDITION`).

---

## Cluster A — F9 Owner Decision Gate (2026-09-20)

Source: `docs/00_SYSTEM/F9_OWNER_DECISIONS.md`

### F9-D01 = A · Keep F9 implementation closed
```
Trigger source: F9_OWNER_DECISIONS.md §3 F9-D01 "Reactivation triggers (not authorizations)"
Line refs     : 66-74
Triggers:
  T1.1 Reproducible incident that current control does not cover     EVENT
  T1.2 Firewall bypass that survives F8 fixtures                     EVENT
  T1.3 Tool failure demonstrably lost by /incident open workflow     EVENT
  T1.4 Deterministic native reproduction of G-B11 phantom            EVENT
       SubagentStop entries
  T1.5 Any of F9-D02 or F9-D04 triggers producing evidence           LINK+EVENT
       that crosses a phase threshold
Classification: OBSERVABLE-EVENT (all 5)
Retrofit readiness: TRIVIAL — literal mapping.
```

### F9-D02 = B · Defer native Claude Code evidence
```
Line refs     : 98-105
Triggers:
  T2.1 Deterministic recurrence of G-B11 phantom SubagentStop        EVENT
  T2.2 Tool failure demonstrably lost by manual incident workflow    EVENT
  T2.3 Native integration decision depending on dispatcher/matcher/  CONDITION
       ordering/payload/re-entry facts
  T2.4 Reproducible problem whose resolution requires native         CONDITION
       lifecycle evidence
Classification: OBSERVABLE-EVENT (T2.1, T2.2), OBSERVABLE-CONDITION (T2.3, T2.4)
Retrofit readiness: TRIVIAL.
```

### F9-D03 = B · Keep documentary candidates deferred (6 sub-items)
```
Line refs     : 128-138
Triggers (per item):
  G-S1  Real rollback that fails OR owner-approved recovery          EVENT
        validation micro-task
  G-S2  Same as G-S1                                                 EVENT
  G-Bob-1 Evaluator/maintainer misread caused by missing             EVENT
          semantic header
  G-A1  Maintainer confuses installer template with configured       EVENT
        project pack
  G-N1  Drift or stale system detected because manual                CONDITION
        revalidation cadence missed
  G-N2  Real disk-usage, retention or consumer requirement           EVENT
Classification: OBSERVABLE-EVENT (5/6), OBSERVABLE-CONDITION (1/6)
Retrofit readiness: TRIVIAL for all six.
```

### F9-D04 = B · External requirement trigger for integrity work
```
Line refs     : 154-161
Triggers:
  T4.1 External audit                                                EVENT
  T4.2 Compliance obligation                                         EVENT
  T4.3 Contractual requirement                                       EVENT
  T4.4 Explicit customer requirement                                 EVENT
  T4.5 Owner-approved expansion of the trust boundary                EVENT
  T4.6 Organizational change that makes current boundary             CONDITION
       insufficient
Constraint: An external trigger authorizes RESEARCH first, not implementation
            (see F9_OWNER_DECISIONS §F9-D04 line 163-168).
Classification: OBSERVABLE-EVENT (5/6), OBSERVABLE-CONDITION (1/6)
Retrofit readiness: TRIVIAL. Constraint field should also be captured.
```

### F9-D05 = A · Keep F10-F12 unknown
```
Line refs     : 195-199
Triggers:
  T5.1 Concrete, evidenced problem that requires runtime work        EVENT+
       at phase scale                                                THRESHOLD
  T5.2 External requirement (per F9-D04) that brings own             LINK
       problem+evidence contract
Classification: OBSERVABLE-EVENT (T5.1), OBSERVABLE-LINK (T5.2)
Retrofit readiness: TRIVIAL.
```

**Cluster A summary:** 5 deferrals, ~19 individual triggers, **100% observable**
under the rubric. Retrofit is literal formalization of existing prose.

---

## Cluster B — PROJECT_STATE.DEFERRED

Source: `PROJECT_STATE.md` line 16.

### CDT-02 (blind verifier test)
```
Trigger source: 61C_CCP_DECISION_AND_AUTHORIZATION_HISTORY.md lines 143-147, 410, 418
                61B_CCP_JOURNEY_MAP.md lines 120-121
                61D_CCP_EVIDENCE_LINEAGE.md line 126
Effective trigger:
  T-CDT02.1  New agent authorization + empirical test env            EVENT
             (F9-D01=A currently blocks; reactivation of F9-D01
              is precondition)
Classification: OBSERVABLE-EVENT via LINK to F9-D01
Retrofit readiness: TRIVIAL (link to F9-D01 triggers).
```

### AC-03 (subagent verifier / TRIGGER-4)
```
Trigger source: 61C_CCP_DECISION_AND_AUTHORIZATION_HISTORY.md lines 145, 264,
                293, 351, 417
Effective trigger:
  T-AC03.1   F9-D01 reactivation (currently BLOCKED)                 LINK
  T-AC03.2   Owner reference to "TRIGGER-4" in PROJECT_STATE          EVENT (extant
             (line 11) suggests a specific documented event awaits    documentation)
             owner review; TRIGGER-4 predicate not found in-repo
             — assumed to live in owner-side artifact
Classification: OBSERVABLE-LINK (F9-D01) + LATENT (TRIGGER-4 predicate not
                surfaced in repo)
Retrofit readiness: MEDIUM — link component trivial; TRIGGER-4 predicate
                    needs owner clarification if made explicit.
```

### NH-11 (single-quote normalization hypothesis)
```
Trigger source: 61B_CCP_JOURNEY_MAP.md lines 230-232
Effective trigger:
  Original prose: "NOT AUTHORIZED — logged for future consideration"
Classification: VAGUE (no observable predicate; "future consideration" is not
                testable)
Retrofit readiness: REQUIRES OWNER — original decision to defer did not
                    articulate an observable trigger.
```

### F10-F12 (phase names)
```
Trigger source: Covered by F9-D05 (see Cluster A).
Effective trigger: LINK to F9-D05 triggers T5.1, T5.2.
Classification: OBSERVABLE-LINK
Retrofit readiness: TRIVIAL (linkage; already articulated in F9-D05).
```

**Cluster B summary:** 4 deferrals, **3/4 observable** (F10-F12, CDT-02,
AC-03 via link + latent), **1/4 VAGUE** (NH-11).

---

## Cluster C — BEHAVIORAL_RELIABILITY_AUDIT (2026-09-18)

Source: `docs/00_SYSTEM/BEHAVIORAL_RELIABILITY_AUDIT.md`

### G-B10 (self-modification of hooks by Claude)
```
Trigger source: BEHAVIORAL_RELIABILITY_AUDIT.md lines 634, 690
Effective trigger:
  T-B10.1  Human review fails to catch a self-mod attempt            EVENT
           (currently mitigated by human review)
  T-B10.2  Roadmap G-N4 activation (hook integrity fingerprint)      LINK
Classification: OBSERVABLE-EVENT (T-B10.1), OBSERVABLE-LINK (T-B10.2)
Retrofit readiness: TRIVIAL.
Cross-link: F-SELFMOD-01 (line 690) is a duplicate reference to G-B10 in the
            audit findings table; not a distinct deferral.
```

### G-L1 (PostToolUseFailure not configured)
```
Trigger source: BEHAVIORAL_RELIABILITY_AUDIT.md lines 179, 233, 706
Effective trigger:
  Original prose: "N/A (no configurado, DEFER G-L1)" — no reactivation
                  criterion stated.
Classification: VAGUE (no observable predicate stated)
Retrofit readiness: REQUIRES OWNER — original defer did not articulate trigger.
                    Candidate: "reproducible tool failure lost that a
                    PostToolUseFailure hook would have caught" (similar shape
                    to F9-D01 T1.3).
```

### G-N4 (hook integrity fingerprint)
```
Trigger source: BEHAVIORAL_RELIABILITY_AUDIT.md line 379
                (roadmap DEFER; grouped with G-B10 mitigation path)
Effective trigger:
  T-N4.1  Same triggers as G-B10 (human review fails; incident of      LINK
          silent hook mutation)
Classification: OBSERVABLE-LINK (to G-B10)
Retrofit readiness: TRIVIAL.
```

**Cluster C summary:** 3 deferrals, **2/3 observable** (G-B10 direct + link,
G-N4 via link), **1/3 VAGUE** (G-L1).

---

## Cluster D — PROJECT_STATE.md notes (implicit deferrals)

### Note 55 · Runtime nativo Claude Code
```
Trigger source: PROJECT_STATE.md line 55
Effective trigger (explicit prose):
  T-N55.1  Recurrencia G-B11 determinista                             EVENT
  T-N55.2  Tool failure perdido                                       EVENT
  T-N55.3  Decision de integracion nativa                             EVENT
  T-N55.4  Otro problema reproducible                                 CONDITION
Classification: OBSERVABLE-EVENT (3), OBSERVABLE-CONDITION (1)
Retrofit readiness: TRIVIAL. Note: duplicates F9-D02 triggers → could be
                    normalized as a LINK.
```

### Note 56 · A-05, A-07, G-N5 (trust boundary expansion)
```
Trigger source: PROJECT_STATE.md line 56
Effective trigger (explicit prose):
  T-N56.1  Auditoria                                                  EVENT
  T-N56.2  Compliance                                                 EVENT
  T-N56.3  Requerimiento contractual/cliente                          EVENT
  T-N56.4  Expansion explicita del trust boundary                     EVENT
Classification: OBSERVABLE-EVENT (all 4). Also: constraint on activation
                (research first, not implementation) captured in prose.
Retrofit readiness: TRIVIAL. Note: duplicates F9-D04 triggers → could be
                    normalized as a LINK.
```

**Cluster D summary:** 2 implicit deferrals, **100% observable**, both
duplicate F9-D02/F9-D04 triggers (LINK candidates).

---

## Aggregate Statistics

```
CLUSTER    DEFERRALS  TRIGGERS  OBSERVABLE  VAGUE  ABSENT
Cluster A     5          19        19 (100%)  0     0
Cluster B     4           5         4 ( 80%)  1     0
Cluster C     3           4         3 ( 75%)  1     0
Cluster D     2           8         8 (100%)  0     0
────────────────────────────────────────────────────────
TOTAL        14          36        34 ( 94%)  2     0
```

**Sub-item breakdown** (Cluster A F9-D03 has 6 sub-items counted individually):
Absolute deferrals: 14 top-level entities, 19 including F9-D03 sub-items.
- **17 observable / 19** (~89% at entity level)
- **2 VAGUE** (NH-11, G-L1) — both are HYPOTHESIS-tier candidates, not
  authorized decisions.

---

## Implications for DEC-11 Option Space

| Option    | Fit against inventory data                          |
|-----------|-----------------------------------------------------|
| H1        | Ignores 94% already-observable triggers; wastes existing prose. |
| H2 total  | 34/36 triggers require pure formalization; 2 need Owner articulation. Feasible. |
| H3        | Same as H2 + check overhead; false-positive rate depends on how "vencido" is defined for observable-but-not-dated triggers. |
| HYB-1 (REG-FORWARD) | Under-uses the 94% observable prose already extractable from F9. |
| HYB-3 (INV-first, done) | Fase 1 IS this file. Fase 2 decision can now proceed with data. |
| **HYB-6 (semantic-only retrofit)** | Dominant on this data: F9-D01..D05 prose is 100% observable; retrofit is literal mapping. VAGUE cases (NH-11, G-L1) are hypothesis-tier, deferrable as-is or articulated separately. |
| HYB-5 (Two-Tier) | Justified only if Owner rejects mapping F9 prose to structured fields. |
| HYB-4 (controlled vocabulary) | Compatible with HYB-6; vocab already implicit: {EVENT, CONDITION, LINK, COUNT, DATE}. |

**Empirical shift:** Pre-EXP-1, the fear was that F9-D01..D05 lacked
observable triggers. Post-EXP-1, F9 prose is **exemplary**: 100% observable,
retrofit is trivial. The two VAGUE deferrals (NH-11, G-L1) are the exception,
not the rule.

---

## Provenance

- Grep executed 2026-09-26 over `docs/00_SYSTEM/*.md` + `PROJECT_STATE.md`
- Sources cited by file:line above.
- No F9-D0X decisions were modified.
- No implementation changes made.
- Reversibility: `rm docs/00_SYSTEM/DEFERRAL_INVENTORY.md` restores prior state.

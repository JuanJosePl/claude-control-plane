# 32 — Registro Consolidado de Búsquedas

**Fecha de compilación:** 2026-09-21
**Compilado por:** Claude Sonnet 4.6 (meta-auditoría)
**Alcance:** Búsquedas de GPT-5.6 Luna (reconstruidas desde NOTAS) + búsquedas de Segunda Pasada Claude + búsquedas de esta meta-auditoría.
**Nota de provenance:** Las búsquedas de GPT se reconstruyen desde las fuentes citadas en los NOTAS; no son un registro de verbatim de las consultas originales.

---

## A. Búsquedas de GPT-5.6 Luna (reconstruidas)

| ID | Dominio | Consulta reconstruida | Resultado principal | Negativo notable |
|----|---------|----------------------|---------------------|-----------------|
| G-01 | AI agents | Agent recovery, loop detection, stagnation LLM | OSGuard, AgentRewind, RIR identificados | Término "control-induced stall" no canónico |
| G-02 | Académico | arXiv: loop detection, agent recovery 2026 | Recoverability (2609.13672), RIR (2609.18304) | No papers sobre generate_alternative |
| G-03 | Sistemas clásicos | Saga, circuit breaker, retry storms distributed systems | Saga + compensating transactions mapeados | No equivalente directo para "governance de continuación" |
| G-04 | Workflows | Temporal durable execution, LangGraph checkpoint | Checkpoint/replay confirmado | Replay no garantiza equivalencia semántica |
| G-05 | Académico | arXiv: AgentRewind checkpoint rewind LLM 2026 | AgentRewind (2608.14380) con Safety Review | Límite explícito: no restaura efectos externos |
| G-06 | Comercial | Agent recovery commercial products, WTP 2026 | Ningún producto con WTP documentado | WTP ausente en corpus público |
| G-07 | Académico | arXiv: policy-constrained agent execution 2026 | ACS (mayo 2026), 2604.07833 | Sin implementación comercial de policy recovery |
| G-08 | Sistemas | Write-ahead log, MVCC, savepoints database analogy | Analogías de bases de datos mapeadas | Distinción checkpoint != recovery semántico |
| G-09 | OS/Sistemas | Process supervisor, watchdog, restart policy | Analogías de OS mapeadas | No equivalente a "governance de continuación" |
| G-10 | Seguridad | Policy enforcement, guardrails, bypass risk agents | Riesgo de bypass identificado | Sin solución formal de non_bypass_verify |
| G-11 | Académico | OSGuard arxiv 2606.15034 | Paper verificado | GPT describió incorrectamente como "hard stop only" |
| G-12 | Comercial | LangChain, CrewAI, AutoGPT recovery mechanisms | Checkpoints confirmados | Sin policy-aware alternative generation |
| G-13 | Académico | Side effects agent idempotency recovery | Living AI (PyPI), Replay Agent Recorder | No madurez comercial, solo OSS/research |
| G-14 | Robótica | Robot replanning, safe fallback, dead-end detection | Analogías de planificación mapeadas | Dominio diferente; no transferencia directa |
| G-15 | Control | Feedback loops, stability, livelock detection | Analogías de control theory mapeadas | No equivalente directo en agentes LLM |

---

## B. Búsquedas de Segunda Pasada Claude (de 06_BUSQUEDA_INDEPENDIENTE.md)

| ID | Fecha | Consulta | Resultado principal | Negativo |
|----|-------|----------|---------------------|---------|
| B-01 | 2026-09-21 | OSGuard arxiv 2606.15034 LLM agent runtime safety | Paper verificado; descripción GPT corregida | — |
| B-02 | 2026-09-21 | arxiv 2609.13672 recoverability system primitive | Paper verificado; formaliza HARD STOP / RECOVERABLE STOP | — |
| B-03 | 2026-09-21 | arxiv 2609.18304 RIR agent loop recovery | RIR v2 verificado; rollback-boundary control | "70%" de GPT sin rúbrica |
| B-04 | 2026-09-21 | AgentRewind arxiv 2608.14380 | AgentRewind con Safety Review + AgentDoG | Límite: no restaura efectos externos |
| B-05 | 2026-09-21 | "control-induced stall" agent LLM recovery | NO ENCONTRADO como término canónico | Stalled execution / erroneous trajectory usados en su lugar |
| B-06 | 2026-09-21 | "execution trajectory" LLM stagnation semantic progress | ReflectiChain (MDPI 2026), TRACES, Trajectory Graphs | — |
| B-07 | 2026-09-21 | Temporal.io workflow agent recovery semantic | Durable execution confirmado; sin SAGR features | Replay ≠ semantic recovery explícitamente documentado |
| B-08 | 2026-09-21 | LangGraph agent recovery policy governed alternatives | Checkpoint confirmado; sin policy recovery | Policy-aware alternativas ausentes |
| B-09 | 2026-09-21 | "execution governance" agent policy authorization | ACS (mayo 2026), arXiv:2604.07833 Harnessing Embodied Agents | ACS no especifica cómo generar "modify" |
| B-10 | 2026-09-21 | "recovery budget" agent LLM bounded exploration | BAGEN (2606.00198), Irreversibility Budget (2609.00275), ExTS | Sin SKU comercial |

---

## C. Búsquedas de Meta-Auditoría (esta pasada)

| ID | Fecha | Consulta | Resultado principal | Relevancia para Claim B |
|----|-------|----------|---------------------|------------------------|
| M-01 | 2026-09-21 | policy-aware alternative generation language model agent 2026 | PolicyGuard (2606.29225), PolicyGuide (2608.19861), ACL 2026 policy internalization | ALTA: PolicyGuide implementa workflow-level guidance como alternativa |
| M-02 | 2026-09-21 | safety-constrained replanning LLM agent 2026 | SafeRun (2606.09027), SafeAgent (2604.17562), SafetyDrift | ALTA: SafeAgent implementa constrained replanning cuando acción es misaligned |
| M-03 | 2026-09-21 | generate alternative action policy compliant agent non-bypass | PolicyGuide, Runtime Compliance Verification (2606.19242), Proof of Execution (2607.05397) | ALTA: varias implementaciones parciales encontradas |
| M-04 | 2026-09-21 | PolicyGuide arXiv 2608.19861 (WebFetch) | Confirma: compila políticas en workflow graphs; guía hacia ruta compliant; no genera alternativas libres | MEDIA: workflow-level, no open-ended |
| M-05 | 2026-09-21 | PolicyGuard arXiv 2606.29225 (WebFetch) | Confirma: "conversation-specific remediation that guides the agent's next turn" | MEDIA: remediation guidance, no formal non_bypass_verify |

---

## D. Búsquedas negativas consolidadas

Las siguientes búsquedas (dos pasadas) produjeron ausencia confirmada:

| Concepto | Búsquedas | Resultado |
|----------|-----------|----------|
| "control-induced stall" como categoría canónica | B-05, G-01 | NOT FOUND IN SEARCHED PUBLIC EVIDENCE |
| Producto comercial con pricing para "policy-aware semantic recovery" | G-06, B-09 | NOT FOUND |
| WTP documentado para SAGR o equivalente | G-06, B-09 | NOT FOUND |
| `non_bypass_verify` como función implementada en producción | B-10, M-03 | NOT FOUND para open-ended agents |
| `generate_alternative` en agentes de coding/investigación abiertos | M-01, M-02 | NOT FOUND (existe en workflow-structured agents: PolicyGuide, SafeAgent) |

---

## E. Cobertura de dominios por tipo de búsqueda

| Dominio | Búsquedas GPT | Búsquedas Claude 2P | Búsquedas Meta-auditoría | Total |
|---------|--------------|---------------------|--------------------------|-------|
| AI agents / academia | G-01, G-02, G-05, G-07, G-11 | B-01–B-06 | M-01–M-05 | 14 |
| Sistemas distribuidos / workflows | G-03, G-04, G-08, G-09 | B-07, B-08 | — | 6 |
| Seguridad / política | G-10 | B-09 | M-01, M-03 | 4 |
| Comercial / productos | G-06, G-12 | B-09, B-10 | — | 4 |
| Sistemas clásicos (OS, DB, robótica) | G-08, G-09, G-14, G-15 | — | — | 4 |
| Side effects / idempotency | G-13 | — | — | 1 |

**Total búsquedas registradas:** ~33 (15 GPT reconstruidas + 10 Claude 2P + 5 meta-auditoría + 3 negativas)

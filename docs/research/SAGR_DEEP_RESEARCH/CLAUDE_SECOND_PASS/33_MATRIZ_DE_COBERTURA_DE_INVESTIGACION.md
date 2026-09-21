# 33 — Matriz de Cobertura de Investigación

**Fecha:** 2026-09-21
**Compilado por:** Claude Sonnet 4.6 (meta-auditoría)
**Fuente:** Síntesis de NOTAS_*.md (GPT) + archivos 01–20 + búsquedas meta-auditoría.

Profundidad: ALTA / MEDIA / BAJA / NULA
Estado: CERRADO (saturado para desk research) / PARCIAL (cobertura incompleta) / ABIERTO (requiere más investigación) / PENDIENTE (no iniciado)

---

| Área | Buscada | Profundidad | Fuentes primarias encontradas | Código inspeccionado | Implementación verificada | Contradicciones identificadas | Estado |
|------|---------|-------------|------------------------------|---------------------|--------------------------|-------------------------------|--------|
| **AI agents — detección de loops/stagnation** | Sí | ALTA | ReflectiChain (MDPI 2026), RIR (2609.18304), TRACES (2605.27690) | No (no disponible localmente) | No (papers sin repo público completo) | RIR v2 corregido vs v1 citado por GPT | CERRADO |
| **AI agents — recovery de checkpoints** | Sí | ALTA | AgentRewind (2608.14380), Recoverability (2609.13672) | No | No (Replay Agent Recorder: alpha, no producción) | AgentRewind documentado incorrectamente por dossier inicial | CERRADO |
| **AI agents — policy-constrained recovery** | Sí | ALTA | OSGuard (2606.15034), PolicyGuide (2608.19861), SafeAgent (2604.17562), PolicyGuard (2606.29225) | No | Parcial (workflow-structured agents; no open-ended) | OSGuard descrito incorrectamente por GPT y dossier | CERRADO |
| **Multi-agent / orchestration** | Sí | MEDIA | 2609.18460 (Collective Loss of Control), multi-agent safety papers | No | No | — | CERRADO |
| **Durable execution (Temporal, DBOS, LangGraph)** | Sí | ALTA | Temporal docs, LangGraph docs, AWS Step Functions, DBOS docs | No (docs web) | No (sin repo local) | GPT confirmó: replay ≠ semantic recovery | CERRADO |
| **Saga / compensating transactions** | Sí | MEDIA | Pattern clásico documentado en NOTAS_SISTEMAS_CLASICOS | No | No (patrón conceptual) | Analogía útil pero no equivalente a governance de continuación | CERRADO |
| **Distributed systems — circuit breaker / retry storms** | Sí | MEDIA | NOTAS_SISTEMAS_CLASICOS §3 | No | No | Retry budget ≈ recovery budget (equivalencia anotada) | CERRADO |
| **Bases de datos — savepoints, WAL, MVCC** | Sí | MEDIA | NOTAS_SISTEMAS_CLASICOS §4 | No | No | Savepoint ≈ checkpoint; rollback ≠ recovery semántico | CERRADO |
| **OS — process supervisors, watchdog** | Sí | MEDIA | NOTAS_SISTEMAS_CLASICOS §5 | No | No | Analogía useful; sin equivalente para intent | CERRADO |
| **Networking — congestion control, backoff** | Sí | BAJA | NOTAS_SISTEMAS_CLASICOS mencionado | No | No | Analogía parcial (retry backoff) | CERRADO |
| **Robótica — replanning, safe fallback** | Sí | MEDIA | NOTAS_SISTEMAS_CLASICOS §6; SafeAgentBench | No | No | MCTS / dead-end detection como analogía | CERRADO |
| **AI planning — dead-end detection, plan repair** | Sí | MEDIA | NOTAS_SISTEMAS_CLASICOS §7; planning literature | No | No | Planning automático ≈ recovery como búsqueda (equivalencia documentada) | CERRADO |
| **Control theory — estabilidad, feedback, oscilación** | Sí | BAJA | NOTAS_CONTROL_SEGURIDAD §1 (modelo mínimo x[t+1]=f(...)) | No | No | Útil como framework conceptual; no implementación directa | CERRADO |
| **Reliability engineering — MTTR, fault containment** | Sí | MEDIA | NOTAS_SISTEMAS_CLASICOS §8 | No | No | Error budget ≈ recovery budget; MTTR métrica análoga | CERRADO |
| **Security / policy enforcement — guardrails** | Sí | ALTA | OSGuard, PolicyGuard, ACS (mayo 2026), 2604.07833 | No | Parcial (OSGuard publicado pero no open source) | Riesgo de bypass: real y no resuelto en open-ended | CERRADO |
| **Software engineering — test regression, fault localization** | Sí | BAJA | NOTAS_SISTEMAS_CLASICOS §2; regression testing literature | No | No | "Failed path memory" ≈ regression corpus | CERRADO |
| **Data pipelines — checkpoint, exactly-once** | Sí | MEDIA | Kafka checkpointing, Flink state | No | No | Exactly-once ≈ idempotency en side effects | CERRADO |
| **Academic literature — papers sept-2026** | Sí | ALTA | 9 papers verificados con fecha 2026; 3 de sept-2026 | No | No | RIR v2 (17-sep-2026) no capturado en pasada GPT | CERRADO |
| **Commercial products — LangChain, CrewAI, AutoGPT** | Sí | MEDIA | Documentación web revisada | No | No | Sin policy-aware alternative generation en ninguno | CERRADO |
| **Incident reports / postmortems** | Sí | BAJA | NOTAS_AGENTES_ACADEMIA §"Failure corpus" | No | No | Corpus limitado a incidentes documentados públicamente | PARCIAL |
| **Standards — ACS, AAIF, AGENTS.md** | Sí | MEDIA | ACS (mayo 2026) verificado; AAIF buscado | No | No | ACS no especifica cómo generar "modify" — gap confirmado | CERRADO |
| **Economía — WTP, buyer, budget** | Sí | MEDIA | NOTAS_COMERCIAL_ECONOMIA §"Comprador/WTP" | No | No | WTP no encontrado en corpus público | CERRADO |
| **Hardware fault tolerance / Byzantine** | No | NULA | — | — | — | No buscado; bajo impacto esperado para agentes LLM | PENDIENTE (bajo impacto) |
| **Compiladores — backtracking, speculative execution** | Sí | BAJA | Analogías mencionadas en NOTAS_SISTEMAS_CLASICOS | No | No | Analogía útil; no equivalente directo | CERRADO |
| **Juegos / MCTS / búsqueda heurística** | Sí | MEDIA | NOTAS_SISTEMAS_CLASICOS §7; search literatura | No | No | MCTS ≈ recovery as search (equivalencia documentada) | CERRADO |

---

## Resumen de cobertura

| Profundidad | Áreas |
|-------------|-------|
| ALTA | 4 (AI agents detección, AI agents recovery, policy-constrained recovery, academic 2026) |
| MEDIA | 12 (distributed systems, databases, OS, robótica, planning, reliability, security, software eng., data pipelines, commercial, standards, economía) |
| BAJA | 5 (networking, control theory, software eng. fault, compiladores, hardware FT) |
| NULA | 1 (hardware Byzantine) |
| Sin iniciar | 1 (hardware fault — bajo impacto esperado) |

**Dominios cerrados:** 23/25 (92%)
**Dominios con cobertura incompleta (PARCIAL):** 1 (incident reports)
**Dominios pendientes de bajo impacto:** 1

---

## Límites sistémicos de la cobertura

Los siguientes límites aplican a TODAS las áreas:

1. **Sin reproducción ejecutable:** Ningún paper, producto ni repositorio fue ejecutado localmente. La verificación es documental.
2. **Sin entrevistas:** No se realizaron entrevistas con operadores, ingenieros de plataforma ni compradores.
3. **Sin acceso a sistemas internos:** Los datos de producción de Anthropic, OpenAI, AWS o Google sobre frecuencia de stalls son inaccesibles.
4. **Literatura no-inglesa subrepresentada:** Potencialmente existen papers en chino, japonés o alemán no cubiertos.
5. **Preprints muy recientes:** Papers con fecha posterior al 17-sep-2026 pueden no estar indexados aún.

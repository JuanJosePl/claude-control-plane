# 13 — Reconstrucción de la arquitectura conceptual

**Fecha:** 2026-09-21
**Investigador:** Claude Sonnet 4.6 (segunda pasada)
**Base:** modelo de `12_RECONSTRUCCION_DEL_MODELO.md` + paper 2604.07833 como referencia más cercana.

---

## 1. Arquitectura de referencia: Harnessing Embodied Agents (2604.07833)

El paper académico más cercano a SAGR define 6 componentes de runtime governance:

1. **Capability Admission** — ¿puede esta capacidad ser invocada?
2. **Policy Guard** — ¿está esta acción autorizada?
3. **Execution Watcher** — ¿hay anomalías en la ejecución?
4. **Recovery Manager** — coordinación de rollback y fallback
5. **Human Override** — intervención supervisora
6. **Audit Logger** — registro de decisiones de governance

Esta arquitectura es la más completa encontrada. SAGR extiende el Recovery Manager con la capacidad de alternative generation.

---

## 2. Arquitectura SAGR propuesta

### 2.1 Componentes del sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                          SAGR Runtime                           │
│                                                                 │
│  ┌──────────┐    ┌──────────┐    ┌──────────────────────────┐  │
│  │  SAGR-   │    │  SAGR-   │    │       SAGR-Govern        │  │
│  │  Detect  │───▶│ Classify │───▶│  (Policy Guard Enhanced) │  │
│  │          │    │          │    │                          │  │
│  │ SED/loop │    │RECOVERABLE│   │ - check policy(A')       │  │
│  │ detector │    │/HARD_STOP│    │ - bypass_detect(A',A,O)  │  │
│  └──────────┘    └────┬─────┘    │ - human_approval_gate    │  │
│                       │          └───────────┬──────────────┘  │
│                       │ RECOVERABLE          │ APPROVED         │
│                       ▼                      ▼                  │
│              ┌────────────────┐    ┌──────────────────────┐    │
│              │  SAGR-Persist  │    │    SAGR-Execute      │    │
│              │                │    │                      │    │
│              │ - checkpoint   │    │ - run A'             │    │
│              │ - side_effects │───▶│ - monitor progress   │    │
│              │ - evidence     │    │ - capture new state  │    │
│              └────────────────┘    └──────────┬───────────┘    │
│                                               │                 │
│              ┌────────────────┐               │                 │
│              │  SAGR-Explore  │               │                 │
│              │                │◀──────────────┘                 │
│              │ - gen A' cands │                                 │
│              │ - budget check │    ┌──────────────────────┐    │
│              │ - rank by cost │    │   SAGR-Verify        │    │
│              └───────┬────────┘    │                      │    │
│                      │             │ - verify completion  │    │
│                      └────────────▶│ - update evidence    │    │
│                                    │ - close audit trail  │    │
│                                    └──────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
         │                                        │
         ▼                                        ▼
   Agent Runtime                          Audit / Evidence Store
  (Claude SDK /                          (evidence_gate,
   Temporal /                             side_effects_log,
   LangGraph)                             recovery_audit)
```

### 2.2 Descripción de componentes

#### SAGR-Detect
- **Entrada:** trayectoria τ, métricas de progreso
- **Salida:** tipo de stall detectado {NONE, STALL_SEMANTIC, STALL_LOOP, STALL_POLICY, STALL_BUDGET, STALL_CONTEXT}
- **Implementación posible:** ReflectiChain SFI/TI/RCS thresholds + comparación semántica de historial + budget monitor
- **Dependencias externas:** métricas de progreso (requieren definición por tarea)

#### SAGR-Classify
- **Entrada:** tipo de stall, estado completo S, objetivo O, políticas P
- **Salida:** {CONTINUE, RECOVERABLE, HARD_STOP, ESCALATE}
- **Implementación posible:** reglas determinísticas para tipos simples + LLM classifier para STALL_POLICY + confidence threshold para ESCALATE
- **Limitación:** precisión del clasificador en stalls policy-constrained es desconocida (H-02 de `04_HUECOS_DE_INVESTIGACION.md`)

#### SAGR-Persist
- **Entrada:** trayectoria τ hasta checkpoint C, side_effects_log
- **Salida:** checkpoint validado con evidencia de soporte
- **Implementación posible:** DBOS Transact, Temporal checkpoints, LangGraph checkpointer + side effect ledger
- **Dependencia crítica:** la aplicación debe proveer idempotency y registro de side effects — no es automático

#### SAGR-Explore
- **Entrada:** objetivo O, políticas P, acción bloqueada A_blocked, checkpoint C, budget B
- **Salida:** lista de candidatos A'[] ordenados por P_success × (1 - C_cost)
- **Implementación posible:** subagente con contexto reducido + LLM generation + constraint filtering
- **Limitación:** requiere que el LLM entienda las políticas y el objetivo — puede producir alternativas incorrectas

#### SAGR-Govern
- **Entrada:** candidato A', objetivo O, políticas P, acción bloqueada A_blocked
- **Salida:** {APPROVED, DENIED, ESCALATE_HUMAN}
- **Implementación posible:** OPA/Cedar para policy check + LLM evaluator para bypass detection + confidence threshold para human gate
- **Limitación crítica:** el bypass_detect no tiene implementación formal (NH-02 de `09_NUEVAS_HIPOTESIS.md`)

#### SAGR-Execute
- **Entrada:** A' aprobado, checkpoint C
- **Salida:** nuevo estado S' + side effects nuevos
- **Implementación posible:** agente executor normal con monitoreo adicional
- **Dependencia:** debe registrar todos los side effects en SAGR-Persist

#### SAGR-Verify
- **Entrada:** estado S' post-recovery, objetivo O, evidencia anterior
- **Salida:** {COMPLETE, PARTIAL_PROGRESS, NO_PROGRESS, REGRESSION}
- **Implementación posible:** evidence gate existente del CCP + test suites + LLM evaluator

---

## 3. Integraciones con el ecosistema existente

### 3.1 SAGR como capa sobre el CCP

```
Claude Code (harness)
    │
    ▼
CCP hooks (PreToolUse, PostToolUse, Stop, PreCompact)
    │
    ▼
SAGR Runtime (nueva capa, si se implementa)
    │
    ├── SAGR-Detect: consume eventos del CCP
    ├── SAGR-Persist: usa file checkpointing + side effect ledger
    ├── SAGR-Classify: LLM + reglas sobre contexto CCP
    ├── SAGR-Explore: subagente con contexto reducido
    ├── SAGR-Govern: verifica contra políticas CCP + OPA/Cedar
    ├── SAGR-Execute: vuelve a invocar Claude con contexto SAGR
    └── SAGR-Verify: evidence gate CCP + tests
```

### 3.2 SAGR como feature de durable execution

Alternativa: implementar SAGR como extensión de Temporal/DBOS donde:
- SAGR-Detect → Signal al workflow
- SAGR-Classify → Activity separada
- SAGR-Persist → Temporal history (ya existe)
- SAGR-Explore → Child workflow
- SAGR-Govern → Activity con policy engine
- SAGR-Verify → Activity final

Esta arquitectura tiene la ventaja de usar checkpoint/replay battle-tested de Temporal y desacopla la lógica de recovery de la lógica de negocio.

---

## 4. Lo que esta arquitectura NO resuelve

1. **La función bypass_detect** — no implementada en ningún sistema conocido.
2. **La generación confiable de A'** — depende de la capacidad del LLM de entender políticas semánticas.
3. **La medición de progreso semántico** — requiere definición por dominio de tarea.
4. **La frecuencia de activación** — sin datos de producción, el sistema puede activarse too rarely (no útil) o too often (disruptivo).

Esta arquitectura describe lo que SAGR debería ser, no lo que puede construirse con certeza de éxito en Q4-2026. Los componentes 1-2 de esta lista (SAGR-Detect, SAGR-Persist, SAGR-Verify) son construibles hoy. Los componentes 3-7 (SAGR-Classify, SAGR-Explore, SAGR-Govern, SAGR-Execute con non-bypass) requieren investigación adicional o prototipos con validación.

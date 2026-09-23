# 44 — Impacto Arquitectónico Preliminar

**Fecha:** 2026-09-21
**Auditor:** Claude Opus 4.7
**Alcance:** Si el problema residual (§42) resultara ser válido, ¿qué cambiaría conceptualmente en CCP? — NO diseño de implementación.

> **Precondición:** este documento aplica **sólo si** los 4 pre-requisitos de `43_CANDIDATO_DE_PROPUESTA.md §5` se cumplen. Hoy no se cumplen; este análisis es contingente.

---

## 1. Estado actual de CCP (base de comparación)

### Componentes reales verificados

**Hooks (10):**
- `bash-firewall.sh` — bloquea patrones bash peligrosos; **blocker, no proposer**
- `secret-guard.sh` — detección de secrets
- `task-completed-evidence.sh` — evidence contract gate
- `subagent-context.sh` — inyecta context packs por rol
- `session-start-startup.sh` / `session-start-compact.sh` — orquestación de sesión
- `stop-logger.sh` / `subagent-stop-logger.sh` — logging al parar
- `pre-compact-snapshot.sh` — snapshot pre-compactación
- `config-change-logger.sh` — audit de cambios de config

**Registries:**
- `EVIDENCE_REGISTRY.md` — evidencia canónica (EV-001..EV-016)
- `DECISION_REGISTRY.md` — ADRs
- `INCIDENT_REGISTRY.md`, `REGRESSION_REGISTRY.md` — loop incident→control→regression

**Skills (22):** incluyen adr, checkpoint, doctor, evidence, incident, recovery, TDD, doubt-driven-development, gate, cerrar-fase, no-go, etc.

**Agents (5):** architect, code-reviewer, implementer, researcher, security-auditor.

**Context packs (6):** BUSINESS, CORE, CURRENT_STATE, DECISIONS, NO_GO, SECURITY_RULES.

### Qué CCP GARANTIZA (verificado)

1. **Evidence-gated completion:** `task-completed-evidence.sh` bloquea tasks sin evidence contract válido (fail-closed desde F8).
2. **Bash firewall fail-closed** ante JSON malformado (F8).
3. **Reviewer identity convention** en Evidence Contract (F8).
4. **Learning loop** incident → control → regression instrumentado como pipeline documental.
5. **Phase-gate discipline:** F1-F8 con gates de owner y ADRs.
6. **Historical preservation:** append-only registries por convención documental.
7. **Trust boundary** Git + human reviewer (F9-D04=B).

### Qué CCP NO GARANTIZA (declarado)

1. **Recovery de STALL_POLICY:** cuando un hook bloquea, el agente se detiene; no hay proponer de alternativa.
2. **Non-bypass verification:** cuando se propone una alternativa manualmente, no hay layer que verifique que no elude el intent.
3. **Dependency-aware invalidation:** si un context pack o registry cambia, no se invalida selectivamente evidencia dependiente.
4. **Semantic continuity:** cross-session, no hay garantía de que estado semántico se preserve más allá del texto en registries.
5. **UNKNOWN_EFFECT state:** si un side effect es incierto (tool timeout, network partial), no hay estado explícito para eso.
6. **Cryptographic append-only:** registries son append-only por convención, no criptográficamente.

---

## 2. Delta arquitectónico contingente

**Si** el problema residual (§42) es válido **Y** requiere cambio en CCP:

```
CURRENT CCP:                          CCP + POLICY-AWARE CONTINUATION LAYER:

  agent action                          agent action
       │                                    │
       ▼                                    ▼
  bash-firewall / secret-guard          bash-firewall / secret-guard
       │                                    │
   [BLOCK or PASS]                     [BLOCK or PASS]
       │                                    │
  if BLOCK:                             if BLOCK:
       └── agent stops                       └── STALL_POLICY classifier
                                                  │
                                             if STALL_POLICY:
                                                  │
                                                  ▼
                                             ALTERNATIVE PROPOSER
                                             (skill or subagent)
                                                  │
                                                  ▼
                                             NON_BYPASS_VERIFIER
                                             (INDEPENDENT — different LLM
                                              or human reviewer per VP-CONTROL)
                                                  │
                                             ┌────┴────┐
                                             ▼         ▼
                                         SAFE     UNSAFE
                                             │         │
                                             ▼         ▼
                                        continue   HARD STOP
                                                     + escalate

  evidence registry (append)            evidence registry
                                        + alternative decision log
                                        + verifier attestation
                                        + rejection reasons (for pattern learning)
```

### Componentes nuevos requeridos

| Componente | Tipo | Descripción | Complejidad estimada |
|---|---|---|---|
| STALL_POLICY classifier | hook + skill | detectar si un bloqueo fue político (vs error, timeout, resource) | BAJA |
| Alternative proposer | skill o subagent | pedir al agente una nueva acción con contexto de bloqueo | MEDIA |
| Non_bypass_verifier | agent independiente + criterios | verifier con evidencia distinta del proponente (por VP-CONTROL 62.9%) | **ALTA** — problema no resuelto |
| Alternative decision log | registry nuevo | append-only log de propuestas + veredictos + rationale | BAJA |
| Escalation gate | hook | si UNSAFE o UNKNOWN → parar y solicitar humano | BAJA |

### Nuevo trust boundary

- Actual: Git + human reviewer.
- Nuevo requerimiento: **verifier independence**. Si el mismo agente/modelo propone y verifica, VP-CONTROL 62.9% se aplica y el verifier es ilusorio. Debe usarse un modelo distinto, o un humano, o (mejor) ambos según severidad.

### Nuevo state

- **STALL_POLICY** como estado explícito (además de PASS/BLOCK).
- **ALTERNATIVE_PROPOSED** con propuesta y evidencia de contexto.
- **VERIFIER_VERDICT** con motivos y confianza.
- **UNKNOWN_EFFECT** (opcional, si se toma la lección VERITAS OS) — no directamente relacionado con SAGR pero mencionado por A como gap CCP.

### Cambios en registries existentes

- **EVIDENCE_REGISTRY:** añadir provenance nuevo `ALTERNATIVE_PROPOSAL` y campo `verifier_attestation_hash`.
- **DECISION_REGISTRY:** un ADR por decisión de alternative (ADR-###) — quizá con schema simplificado para no saturar.
- **INCIDENT_REGISTRY:** cada bypass detectado post-hoc es un incident → control → regression.

### Migration impact

- **F1-F8 permanecen frozen.** Ningún componente actual necesita modificarse.
- Es una **capa nueva encima**, no una refactorización.
- El impacto en usuarios: si un flujo actualmente termina en STALL_POLICY, ahora tendría un paso adicional; si funciona, mejor; si falla, mismo resultado (HARD STOP).
- **Compatibilidad:** total. La nueva capa puede desactivarse con un flag.

### Complexity impact

- Cinco componentes nuevos + un registry adicional + reconfiguración de skills.
- Probablemente 2-4 nuevas skills, 1-2 nuevos hooks, 1-2 nuevos agentes.
- Este tamaño **contradice** `SIMPLE > CLEVER` a menos que H-01 justifique el costo.

### Security impact

- **Riesgo introducido:** si non_bypass_verify falla, se abre vector de bypass sistemático.
- **Riesgo mitigado:** hoy el owner puede parar y hacer bypass manual sin traza; la nueva capa haría eso auditable.
- Neto: depende críticamente de la calidad de non_bypass_verify. Sin diseño concreto, el riesgo es negativo.

### Rollback strategy

- Registrar todos los alternative decisions en un log independiente.
- Feature flag off → volver a comportamiento actual sin pérdida.
- Los datos recopilados durante la ventana de operación quedan como base para regresiones futuras.

---

## 3. Alternativa arquitectónica más pequeña

Antes de proponer una capa completa, evaluar un **mínimo delta**:

### Opción 1 — Documentar y contar (menor complejidad, mayor información)

- Nuevo skill: `stall-policy-record`
- Cuando bash-firewall o task-completed-evidence bloquea, prompt manual al owner: "¿había alternativa viable? [Y/N]", registro en log.
- Cero automatización. Sólo instrumentación.
- Costo: 1 skill + 1 log file.
- Beneficio: cierra H-01 en 30 días.
- **Recomendado como Step 1 sin apertura de F10**.

### Opción 2 — Skill de recovery-with-review (media complejidad)

- Skill `sagr-manual` que, ante un stall, pide al agente proponer alternativa y luego dispara un code-reviewer o security-auditor **como verifier independiente**.
- No automatiza generate_alternative; sólo estructura el flujo humano.
- Costo: 1-2 skills + reuso de agents existentes.
- Beneficio: prueba el diseño de non_bypass_verify sin construir la capa completa.
- Requerimiento: H-01 muestra que vale la pena.

### Opción 3 — Capa completa (§2)

- Sólo si Opciones 1-2 producen evidencia clara de valor.

---

## 4. Conclusión de impacto arquitectónico

- **Si el problema residual existe** (todavía no verificado):
  - **Opción 1** requiere delta mínimo (1 skill + 1 log). Compatible con F1-F8 frozen. Se puede hacer sin abrir F10, como instrumentación.
  - **Opción 2** es un paso intermedio testeable con delta moderado (skill + agent reuse). Podría requerir F10 si se formaliza como fase.
  - **Opción 3** requiere una capa arquitectónica nueva completa, sólo justificada si Opciones 1-2 muestran valor + los 4 pre-requisitos de §43 se cumplen.

- **Si el problema residual NO existe** (State-Aware Runtime v4 u otro lo cubre):
  - **Cero cambio arquitectónico.**
  - Recomendación: adoptar el prior art existente en lugar de construir; documentar la decisión.

**Estado actual:** insuficiente evidencia para justificar cualquier opción excepto Opción 1 (instrumentación), y sólo si el owner decide que quiere saber H-01.

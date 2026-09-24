# 02 — CORPUS RECONSTRUCTION

> Fase 1 del protocolo maestro: reconstruir F1–F9 y M001–M007 con enfoque causal, no solo
> cronológico.

---

## 1. Resumen ejecutivo del corpus

CCP se construyó en dos grandes etapas:

1. **Build (F1–F8):** infraestructura real de control plane con hooks, registries, evidence gate,
   maintenance e incident learning.
2. **Research (F9 + M001–M007):** exploración del problema residual post-F8 sin implementación
   autorizada.

La transición de "build" a "research" no fue por agotamiento técnico, sino porque la
investigación concluyó que **ninguna propuesta actual justificaba nueva implementación**.

---

## 2. Reconstrucción de F1–F9

### FASE 0 — Plan y auditoría

| Campo | Valor |
|---|---|
| OBJETIVO DECLARADO | Definir el plan maestro y auditar investigaciones previas. |
| PROBLEMA QUE ATACABA | Falta de ruta de implementación coherente. |
| HIPÓTESIS INICIAL | Se puede construir un control plane disciplinado por fases. |
| DECISIONES TOMADAS | Crear `MASTER_IMPLEMENTATION_PLAN.md`. |
| IMPLEMENTACIÓN | Documentación y plan. |
| EVIDENCIA PRODUCIDA | `docs/MASTER_IMPLEMENTATION_PLAN.md`. |
| RESULTADO REAL | PASS. |
| ¿COINCIDE? | Sí. |
| CAMBIOS INTRODUCIDOS | Ninguno en runtime. |
| DEPENDENCIAS CREADAS | Fases F1–F6 definidas. |
| DEUDA GENERADA | Ninguna identificada. |
| PROBLEMAS CERRADOS | Ruta de implementación. |
| PROBLEMAS ABIERTOS | Alcance futuro post-F6. |

### FASE 1 — Fundación instalable

| Campo | Valor |
|---|---|
| OBJETIVO | Base instalable y estado coherente. |
| PROBLEMA | `settings.json` con comentarios inválidos; falta de registries canónicos. |
| HIPÓTESIS | Un installer + registries canónicos resuelven el baseline. |
| DECISIONES | ARCH-001 (scope proyecto), ARCH-002 (context packs por rol), ARCH-003 (ruta canónica de evidence). |
| IMPLEMENTACIÓN | `install.sh`, registries, `subagent-context.sh`. |
| EVIDENCIA | EV-001. |
| RESULTADO | PASS / FROZEN. |
| CAMBIOS | Installer, settings, hooks, context packs. |
| DEPENDENCIAS | Todo el runtime posterior depende de F1. |
| DEUDA | Context packs con placeholders (G-A1). |
| PROBLEMAS CERRADOS | Instalación, registries, wiring. |
| PROBLEMAS ABIERTOS | Runtime nativo no verificado. |

### FASE 2 — Evidence Contract + TaskCompleted

| Campo | Valor |
|---|---|
| OBJETIVO | Que `TaskCompleted` valide un contrato de evidencia estructurado. |
| PROBLEMA | El hook validaba texto por regex; fácil de bypass. |
| HIPÓTESIS | Un contrato con hashes, checks, reviewer y timestamp cierra el gap. |
| DECISIONES | Schema de evidence; hook bloquea con exit 2 si falta campo. |
| IMPLEMENTACIÓN | `task-completed-evidence.sh` versión inicial. |
| EVIDENCIA | EV-002. |
| RESULTADO | PASS. |
| CAMBIOS | Hook de evidence, schema. |
| DEPENDENCIAS | F1 → F2. |
| DEUDA | `contract_hash` aún no acoplado al payload. |
| PROBLEMAS CERRADOS | Evidence gate básico. |
| PROBLEMAS ABIERTOS | Reutilización de `task_id` histórico (descubierto en F7 como F-FALSE_PASS-01). |

### FASE 3 — SDLC lanes + verificación independiente

| Campo | Valor |
|---|---|
| OBJETIVO | Definir lanes de trabajo y reviewer independiente. |
| PROBLEMA | Verificación dependía del mismo agente. |
| HIPÓTESIS | Tiers 1/2/3 + reviewer fresco cierran el gap. |
| DECISIONES | 4 skills de workflow, agente `code-reviewer`. |
| IMPLEMENTACIÓN | `evals/skills/validate.sh`, fixtures, Tier 3. |
| EVIDENCIA | EV-005 (después de EV-003/EV-004 BLOCKED por autenticación). |
| RESULTADO | PASS. |
| CAMBIOS | Skills, evals, agente reviewer. |
| DEPENDENCIAS | F2 → F3. |
| DEUDA | Tier 3 requiere CLI autenticado; `--bare` falla. |
| PROBLEMAS CERRADOS | Verificación independiente. |
| PROBLEMAS ABIERTOS | Native runtime no verificado. |

### FASE 4 — Incident learning

| Campo | Valor |
|---|---|
| OBJETIVO | Convertir incidentes en controles y regresiones. |
| PROBLEMA | `TaskCompleted` aceptaba completion sin evidence contract. |
| HIPÓTESIS | INC → RCA → CONTROL → REGRESIÓN → EVIDENCIA cierra el ciclo. |
| DECISIONES | Crear `INCIDENT_REGISTRY.md`, `CONTROL_REGISTRY.md`, `REGRESSION_REGISTRY.md`. |
| IMPLEMENTACIÓN | CTRL-001 (TaskCompleted exige evidence), REG-001. |
| EVIDENCIA | EV-006. |
| RESULTADO | PASS. |
| CAMBIOS | Registries + hook de evidence reforzado. |
| DEPENDENCIAS | F2 → F4. |
| DEUDA | Muestra pequeña (un solo incidente orgánico). |
| PROBLEMAS CERRADOS | Ciclo de aprendizaje demostrado. |
| PROBLEMAS ABIERTOS | Escalabilidad del framework sin más incidentes. |

### FASE 5 — Integridad de estado y provenance

| Campo | Valor |
|---|---|
| OBJETIVO | Detectar drift de estado y garantizar provenance. |
| PROBLEMA | `PROJECT_STATE.md` podía modificarse fuera de checkpoints. |
| HIPÓTESIS | Hash de campos críticos + detección de drift en SessionStart. |
| DECISIONES | PreCompact hash, SessionStart drift detection. |
| IMPLEMENTACIÓN | `pre-compact-snapshot.sh`, `session-start-compact.sh`. |
| EVIDENCIA | EV-007. |
| RESULTADO | PASS. |
| CAMBIOS | Hooks de ciclo de sesión. |
| DEPENDENCIAS | F1 → F5. |
| DEUDA | Estados adicionales (`ROLLED_BACK`, etc.) no formalizados. |
| PROBLEMAS CERRADOS | Drift detection. |
| PROBLEMAS ABIERTOS | Ninguno crítico. |

### FASE 6 — Evals y mantenimiento

| Campo | Valor |
|---|---|
| OBJETIVO | Suite determinista de mantenimiento. |
| PROBLEMA | Verificación ad-hoc; posible regressión silenciosa. |
| HIPÓTESIS | `evals/maintenance.sh` 12/12 checks cierra el gap. |
| DECISIONES | Maintenance suite, CI workflow, regression budget. |
| IMPLEMENTACIÓN | `evals/maintenance.sh`, `.github/workflows/control-plane.yml`. |
| EVIDENCIA | EV-008. |
| RESULTADO | PASS. |
| CAMBIOS | Maintenance + CI. |
| DEPENDENCIAS | F1–F5 → F6. |
| DEUDA | Ninguna identificada. |
| PROBLEMAS CERRADOS | Salud determinista. |
| PROBLEMAS ABIERTOS | Ninguno. |

### FASE 7 — Evidence Integrity + Behavioral Reliability

| Campo | Valor |
|---|---|
| OBJETIVO | Cerrar gaps de integridad de evidencia y comportamiento. |
| PROBLEMA | Auditoría adversarial encontró 11 bugs (loop Stop, bypass firewall, false-PASS, etc.). |
| HIPÓTESIS | Endurecer hooks existentes + fixtures positivos. |
| DECISIONES | ARCH-004 (task semantics); bundles A–E. |
| IMPLEMENTACIÓN | Anti-loop, firewall hardening, evidence coupling, freshness, session log rotation, installer idempotency. |
| EVIDENCIA | EV-009..EV-014, REG-002..REG-009. |
| RESULTADO | VERIFIED / FROZEN en `47874a5`. |
| CAMBIOS | 5 bundles + subbundle; ~608 adiciones/18 eliminaciones. |
| DEPENDENCIAS | F1–F6 → F7. |
| DEUDA | `contract_hash` opcional transicional (A-03); JSON malformed firewall (A-04); reviewer identity (A-06); hook self-mod (A-07); artifact hash recompute (A-05). |
| PROBLEMAS CERRADOS | 11 bugs conductuales. |
| PROBLEMAS ABIERTOS | Items diferidos A-03..A-08. |

### FASE 8 — Cierre fail-closed diferido

| Campo | Valor |
|---|---|
| OBJETIVO | Cerrar A-03 y A-04 con mínimo cambio. |
| PROBLEMA | `contract_hash` ausente pasaba; JSON malformed pasaba como comando vacío. |
| HIPÓTESIS | Flip transicional a fail-closed. |
| DECISIONES | F8-A (contract_hash obligatorio), F8-B (firewall reject malformed JSON), A-06 (reviewer convention). |
| IMPLEMENTACIÓN | Cambios en `task-completed-evidence.sh` y `bash-firewall.sh`; extensión de fixtures. |
| EVIDENCIA | EV-015, EV-016; REG-010, REG-011. |
| RESULTADO | COMPLETE / VERIFIED / FROZEN en `2cd7953`. |
| CAMBIOS | ~18 líneas en 2 hooks + 2 fixture extensions. |
| DEPENDENCIAS | F7 → F8. |
| DEUDA | A-05, A-07, G-M1, G-L1, G-N4, G-N5 diferidos. |
| PROBLEMAS CERRADOS | A-03, A-04. |
| PROBLEMAS ABIERTOS | Post-F8: ¿qué sigue? |

### FASE 9 — Gate de investigación

| Campo | Valor |
|---|---|
| OBJETIVO | Determinar si justifica otra fase de implementación post-F8. |
| PROBLEMA | Candidatos diferidos (A-05, A-07, G-*, etc.) sin evidencia de impacto. |
| HIPÓTESIS | Algún candidato justifica F9. |
| DECISIONES | F9-D01=A (F9 cerrado), F9-D02=B (defer native), F9-D03=B (defer docs), F9-D04=B (integrity external trigger), F9-D05=A (F10-F12 unknown). |
| IMPLEMENTACIÓN | Ninguna. |
| EVIDENCIA | Ninguna nueva; `maintenance.sh` 12/12 PASS. |
| RESULTADO | `F9 NOT JUSTIFIED` / OWNER GATE CLOSED. |
| CAMBIOS | Ninguno en runtime. |
| DEPENDENCIAS | F8 → F9 (research). |
| DEUDA | Ninguna nueva. |
| PROBLEMAS CERRADOS | Decisión de no abrir F9. |
| PROBLEMAS ABIERTOS | LABYRINTH-1: ¿qué pasa cuando un agente choca con una política y tiene alternativa? |

---

## 3. Grafo causal del build

```text
F1 (fundación instalable)
  ├── produjo installer + settings + hooks base
  │     └── obligó a F2 a tener dónde validar evidencia
  │           └── F2 creó evidence contract
  │                 └── F4 aprendió de INC-001 sobre fallo de F2
  │                 └── F7 endureció coupling (F-FALSE_PASS-01)
  │                       └── F8-A hizo contract_hash obligatorio
  │
  ├── produjo context packs + subagent-context
  │     └── F3 usó subagentes para reviewer independiente
  │
  └── produjo registries canónicos
        └── F5/F6/F7/F8 los usaron como fuente de verdad

F3 (SDLC lanes)
  ├── produjo code-reviewer agent
  │     └── usado en F7/F8 revisiones independientes
  │
  └── produjo evals/skills/
        └── mantenido por F6

F4 (incident learning)
  └── produjo INC-001/CTRL-001/REG-001
        └── demostró que el ciclo de aprendizaje funciona
              └── justificó regresiones preventivas en F7

F5 (state integrity)
  └── produjo drift detection
        └── usado en maintenance F6/F7/F8

F6 (maintenance)
  └── produjo suite determinista
        └── permitió a F7/F8 verificar cambios de forma repeatable

F7 (behavioral reliability)
  └── dejó A-03 y A-04 sin resolver
        └── obligó a F8

F8 (fail-closed)
  └── cerró A-03/A-04
        └── dejó el sistema estable pero sin frontera clara post-F8
              └── abrió F9 como investigación

F9 (research gate)
  └── concluyó que ningún candidato justifica implementación
        └── abrió LABYRINTH-1 como pregunta de investigación
              └── M001–M007 exploraron LABYRINTH-1
```

---

## 4. Reconstrucción de movimientos M001–M007

### MOVEMENT 001 — R-3 Empirical Test

| Campo | Valor |
|---|---|
| PREGUNTA CENTRAL | ¿El protocolo R-3 discrimina alternativas seguras de bypasses? |
| HIPÓTESIS INICIAL | R-3 podría fallar con UNKNOWN dominante. |
| QUÉ EXAMINÓ | 9 casos sintéticos, una por familia de R-3. |
| QUÉ EJECUTÓ | Aplicó protocolo R-3 con labels gold predefinidos. |
| RESULTADO | 9/9 correctos; C-01 SAFE en dominio explícito. |
| QUÉ REFUTÓ | "R-3 es conceptualmente incoherente" y "UNKNOWN siempre domina". |
| QUÉ SOPORTÓ | R-3 es parcialmente trazable a nivel de diseño. |
| QUÉ QUEDÓ DESCONOCIDO | Independencia real con subagentes; tasa SAFE en políticas reales. |
| NUEVAS RAMAS | ROUTE-INDEP, ROUTE-POLICY, ROUTE-B, ROUTE-ROGER. |
| COMPLEJIDAD | Baja; casos sintéticos. |
| PROBLEMAS CERRADOS | Incoherencia conceptual de R-3. |
| PROBLEMAS ABIERTOS | Tres bloqueadores B-1/B-2/B-3. |
| DEPENDENCIAS | F9-D01=A (sin implementación). |
| SELF-CORRECTION | Alto UNKNOWN inicial fue artefacto del diseño de casos, no propiedad de CCP. |

### MOVEMENT 002 — Frontier Resolution

| Campo | Valor |
|---|---|
| PREGUNTA CENTRAL | ¿Cuál de los tres bloqueadores es el principal? |
| HIPÓTESIS INICIAL | Posiblemente B-2 (policy explicitness) o B-1 (independence). |
| QUÉ EXAMINÓ | Corpus de 25 políticas; 8 casos RCE; modelo de independencia; hipótesis B; Roger. |
| QUÉ EJECUTÓ | Análisis de políticas, diseño de verificador ciego, evaluación de 5 escenarios, falsificación de Roger. |
| RESULTADO | B-2 NO es principal (83% EXPLICIT); B-1 resoluble en principio; Roger = reformulation; B = conditionally sufficient. |
| QUÉ REFUTÓ | "Políticas de CCP son demasiado vagas" y "Roger es nueva capacidad". |
| QUÉ SOPORTÓ | El cuello de botón real es autorización + materialidad (H-01). |
| QUÉ QUEDÓ DESCONOCIDO | H-01 frecuencia real; CDT-02 no ejecutado. |
| NUEVAS RAMAS | CDT-01, NH-02, NH-01, CDT-02. |
| COMPLEJIDAD | Media-alta; análisis multi-ruta. |
| PROBLEMAS CERRADOS | ROUTE-POLICY, ROUTE-B, ROUTE-ROGER. |
| PROBLEMAS ABIERTOS | CDT-02, H-01. |
| DEPENDENCIAS | M001. |
| SELF-CORRECTION | "High UNKNOWN rate" fue flaw de diseño de casos. |

### MOVEMENT 003 — Master Frontier Closure

| Campo | Valor |
|---|---|
| PREGUNTA CENTRAL | ¿Cuál es el máximo progreso sin nueva autorización? |
| HIPÓTESIS INICIAL | NH-04 podría ser suficiente; P4 podría ser viable. |
| QUÉ EXAMINÓ | CDT-01, NH-02, NH-04, taxonomía de bypass, reparaciones de políticas, precedencia. |
| QUÉ EJECUTÓ | 8 escenarios CDT-01, corpus 15 casos NH-04, análisis de 4 familias de bypass, 6 niveles de detección. |
| RESULTADO | CDT-01 CONFIRMED (87.5% SAFE); NH-02 PARTIALLY_SUPPORTED; NH-04 PARTIALLY_SUPPORTED; P4 inadvisable; aliasing gap dominante. |
| QUÉ REFUTÓ | P4 como opción viable; "todo bypass es detectable por regex". |
| QUÉ SOPORTÓ | AC-02 ROI alto; L1-C como salida posible sin AC-03. |
| QUÉ QUEDÓ DESCONOCIDO | Prevalencia real de bypass; FP rate P1'/P2'. |
| NUEVAS RAMAS | NH-05, NH-06, NH-07, NH-08, READY-01/02/03. |
| COMPLEJIDAD | Alta; taxonomía completa. |
| PROBLEMAS CERRADOS | NH-04, taxonomía, reparaciones. |
| PROBLEMAS ABIERTOS | Aliasing, NH-08 (no material sin H-01), UNK-M3-01 (precedencia). |
| DEPENDENCIAS | M002. |

### MOVEMENT 004 — Integration + Decision Readiness

| Campo | Valor |
|---|---|
| PREGUNTA CENTRAL | Resultados de NH-05/06/07; condiciones L1-C; paquetes de decisión. |
| HIPÓTESIS INICIAL | shlex podría resolver normalización; podría haber conflictos de precedencia. |
| QUÉ EXAMINÓ | NH-05 shlex, NH-06 precedencia, NH-07 mensajes, NH-09/10 nuevos. |
| QUÉ EJECUTÓ | Análisis de shlex vs. AST, matriz de conflictos, diseño de mensajes Enhanced-B, 2 sed normalizations, 5 escenarios de escalación. |
| RESULTADO | NH-05 PARTIALLY_SUPPORTED; NH-06 PARTIALLY_SUPPORTED; NH-07 SUPPORTED; NH-09 SUPPORTED; NH-10 CONFIRMED (implementable ahora). |
| QUÉ REFUTÓ | shlex como solución completa; conflictos activos de precedencia. |
| QUÉ SOPORTÓ | NH-09 como simplificación de bajo costo; NH-10 como cierre de gap de proceso. |
| QUÉ QUEDÓ DESCONOCIDO | NH-11 single-quote. |
| NUEVAS RAMAS | READY-04, UNK-M4-01/02. |
| COMPLEJIDAD | Media. |
| PROBLEMAS CERRADOS | NH-05, NH-06, NH-07, NH-09, NH-10, L1-C conditions spec. |
| PROBLEMAS ABIERTOS | UNK-M4-01 (semantic accuracy), UNK-M4-02 (L1.5 threshold). |
| DEPENDENCIAS | M003. |

### MOVEMENT 005 — NH-10 Implementation + Owner Package

| Campo | Valor |
|---|---|
| PREGUNTA CENTRAL | ¿NH-10 se puede implementar? ¿NH-09 es semánticamente seguro? |
| HIPÓTESIS INICIAL | NH-10 es documentación-only; NH-09 es SAFE_NORMALIZATION. |
| QUÉ EXAMINÓ | Implementación de NH-10, corpus 20 comandos NH-09, paquete de decisiones. |
| QUÉ EJECUTÓ | Añadió §12 a `CONTROL_PLANE_HANDBOOK.md`, corpus de 14 categorías, validación de 5 escenarios, paquete READY-01/02/03/04. |
| RESULTADO | NH-10 IMPLEMENTED; UNK-M4-01 RESOLVED; CONFLICT-04 RESOLVED; L1-C Condition 3 SATISFIED; NH-11 hipótesis. |
| QUÉ REFUTÓ | "NH-10 requiere autorización". |
| QUÉ SOPORTÓ | NH-09 invariant (COMMAND_NORM no ejecutable). |
| QUÉ QUEDÓ DESCONOCIDO | NH-11 no autorizado. |
| NUEVAS RAMAS | Ninguna. |
| COMPLEJIDAD | Media. |
| PROBLEMAS CERRADOS | NH-10, UNK-M4-01, CONFLICT-04. |
| PROBLEMAS ABIERTOS | READY-01/02/03/04 pendientes de Owner. |
| DEPENDENCIAS | M004. |

### MOVEMENT 006 — Pre-Authorization Adversarial Gate

| Campo | Valor |
|---|---|
| PREGUNTA CENTRAL | ¿READY-01/02/03/04 se pueden romper antes de autorización? |
| HIPÓTESIS INICIAL | Los paquetes de decisión están listos. |
| QUÉ EXAMINÓ | 17 tracks de auditoría adversarial. |
| QUÉ EJECUTÓ | Source audit, per-repair semantic analysis, invariant verification, cross-decision matrix, branch simulation. |
| RESULTADO | CONDITIONAL PASS; 4 fixes requeridos (A–D); UNK-M4-01 cleaned. |
| QUÉ REFUTÓ | "READY-01 es documentation-only"; "READY-03 riesgo MEDIUM"; "N está definido". |
| QUÉ SOPORTÓ | NH-09 invariant. |
| QUÉ QUEDÓ DESCONOCIDO | N threshold (requiere Owner). |
| NUEVAS RAMAS | UNK-M6-01 (invariant maintenance dependency). |
| COMPLEJIDAD | Alta; 17 tracks. |
| PROBLEMAS CERRADOS | Precisión de READY package. |
| PROBLEMAS ABIERTOS | N = undefined. |
| DEPENDENCIAS | M005. |

### MOVEMENT 007 — Frontier Breakout

| Campo | Valor |
|---|---|
| PREGUNTA CENTRAL | ¿M006 "research should stop" es la conclusión final o existen nuevas rutas? |
| HIPÓTESIS INICIAL | Nuevas formulaciones podrían abrir tracks ejecutables. |
| QUÉ EXAMINÓ | 8 supuestos centrales de CCP; PAC; N threshold; HRQS. |
| QUÉ EJECUTÓ | Prototipo PAC (13 políticas YAML + compiler), experimento que descubrió PAC-EF-02, `query-log.sh`, especificación P1'/P2', 17 ideas. |
| RESULTADO | 3 tracks autorizados ahora (HRQS, PAC corpus completion, query-log.sh); PAC = BREAKOUT CANDIDATE; N=1 recomendado; PAC-EF-02 nueva FP class. |
| QUÉ REFUTÓ | "PAC es solo teórico"; "N requiere field data"; "HRQS es future work"; "READY-01/02 son independientes". |
| QUÉ SOPORTÓ | PAC colapsa READY-01/02; N=1 derivable analíticamente; F9-D01=A es bloqueo genuino. |
| QUÉ QUEDÓ DESCONOCIDO | H-01 materiality; production FP rate. |
| NUEVAS RAMAS | PAC production adoption, HRQS, observability dashboard. |
| COMPLEJIDAD | Alta; prototipo real. |
| PROBLEMAS CERRADOS | Especificación P1'/P2', N recommendation. |
| PROBLEMAS ABIERTOS | PAC production, H-01. |
| DEPENDENCIAS | M006. |

---

## 5. Análisis causal cruzado

### ¿Qué movimiento resolvió indirectamente algo de otro anterior?

- **M005 cerró CONFLICT-04**, que M004 había identificado como missing spec.
- **M002 cerró ROUTE-ROGER**, liberando a M003/M004 de considerar Roger como arquitectura.
- **M007 resolvió el placeholder P1'/P2'** dejado por M003/M004/M006.
- **M007 derivó N=1**, que resuelve parte del gap dejado por M006 Finding B.

### ¿Qué problema reapareció con nombre diferente?

- **Independencia del verificador** apareció como:
  - F-FALSE_PASS-01 (coupling task/evidencia en F7).
  - B-1 en LABYRINTH-1.
  - PI-1 en M001.
  - CDT-02 en M002.
  - AC-03 en READY package.

  Es el mismo problema en distintos niveles: **el agente no puede certificar su propio trabajo.**

- **Política vs. enforcement** apareció como:
  - A-06 (reviewer identity) en F8.
  - PARTIAL policies en M002.
  - READY-01 en M003/M004.
  - PAC en M007.

  Es el problema de que la representación humana y la máquina de política están separadas.

### ¿Qué camino abandonado ahora sería relevante?

- **PAC** fue un concepto mencionado en investigaciones previas pero no prototipado hasta M007.
Ahora es BREAKOUT CANDIDATE porque demuestra que READY-01/02 son un artefacto arquitectónico.

### ¿Qué idea cambió de significado?

- **"Documentation-only"** en READY-01 cambió de "editorial clarification" a "rule clarification
with new constraints/exception" tras M006 Finding A.
- **"UNKNOWN"** pasó de ser una molestia a ser una disciplina válida y explícita del sistema.
- **"Recovery"** pasó de ser "reanudar ejecución" a "gobernanza de continuación" y finalmente a
"non-bypass verification".

---

## 6. Second-order discovery

Combinando descubrimientos:

```text
M001: R-3 funciona en dominio explícito
  +
M002: 83% de políticas CCP son explícitas
  +
M003: reparaciones suben SAFE rate a 87.5%
  +
M007: PAC demuestra que política y enforcement pueden unificarse
  ↓
= X1: El problema no es principalmente técnico (R-3 + políticas explícitas funcionan);
      el problema es que la arquitectura actual mantiene dos representaciones de política
      y eso genera decisión duplicada (READY-01/02).
```

```text
M002: B path (refuse + escalate) es conditionally sufficient
  +
M004: NH-10 cierra gap de escalación
  +
M005: NH-10 implementado
  +
M006: READY-03 requiere aceptación de residual + N
  +
M007: N=1 derivable analíticamente; H-01=0 eventos reales
  ↓
= X2: LABYRINTH-1 puede cerrarse condicionalmente con una decisión del Owner (READY-03)
      sin implementar AC-03, si se acepta B-path como mitigación y se define N=1.
```

```text
M003: Aliasing bypasses ALL patterns
  +
M007: Regex es correcto para sintáctico, incorrecto para semántico
  +
M007: PAC-EF-02 descubre FP real por nombres de patrones en literales
  ↓
= X3: El firewall actual tiene un límite fundamental: no puede distinguir intención semántica.
      Cualquier extensión sintáctica (P1'/P2'/NH-09) reduce la superficie pero no elimina la
      necesidad de B-path (humano) para el residual semántico.
```

---

## 7. Estado actual en el repo

- F1–F8: COMPLETE / FROZEN [VERIFICADO].
- F9: RESEARCH COMPLETE / NOT JUSTIFIED / OWNER GATE CLOSED [VERIFICADO].
- F10-F12: UNKNOWN / NOT STARTED [VERIFICADO].
- R-2: instrumentación operacional; 3 eventos en log [DOCUMENTADO].
- R-3: diseño auditado; test empírico 9/9; NO implementado [DOCUMENTADO].
- PAC: prototipo funcional; 13 políticas YAML; compiler funcional [VERIFICADO].
- READY-01/02/03/04: preparados, no autorizados [VERIFICADO].
- `maintenance.sh`: 12/12 PASS [VERIFICADO].
- Git status: modificación en `docs/CONTROL_PLANE_HANDBOOK.md` (NH-10) consistente con M005;
`CCP_MASTER_EXECUTION_PROMPT.md` no trackeado [VERIFICADO].

---

## 8. Problemas abiertos del corpus

| ID | Problema | Origen | Estado |
|---|---|---|---|
| LABYRINTH-1 | Policy-Aware Continuation with Non-Bypass Verification | F9 | OPEN (1/5 L1-C conditions satisfied) |
| H-01 | Stall frequency with viable alternative | R-2 | BLOCKED (no production environment) |
| A-05 | Artifact hash recomputation | F8 deferred | DEFERRED |
| A-07 | Hook self-modification detection | F8 deferred | DEFERRED |
| G-N5 | Registry append-only enforcement | F8 deferred | DEFERRED |
| Native runtime | Claude Code lifecycle behavior | F9-D02=B | NOT_VERIFIED |
| HRQS | Human Review Quality Standard | M007 | NOW_EXECUTABLE |
| PAC production | Policy-as-Code adoption | M007 | PROTOTYPE / BLOCKED by auth |

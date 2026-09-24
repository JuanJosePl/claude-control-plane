# 06 — NEGATIVE SPACE

> Fase 8 del protocolo maestro: identificar lo que falta, lo que sobra y las cadenas de
> compensación que ocultan ausencias estructurales.

---

## 1. Negative Space Analysis

### 1.1 Capacidades ausentes

#### NS-1 — Motor de políticas unificado

| Campo | Valor |
|---|---|
| CAPACIDAD AUSENTE | Una representación canónica de políticas de la que se derive automáticamente el enforcement. |
| ¿QUÉ PROBLEMA CREA SU AUSENCIA? | Política vive en Markdown + regex bash; drift; reparaciones manuales; READY-01/02. |
| ¿QUÉ MECANISMOS COMPENSAN SU AUSENCIA? | Investigación M002-M007; prototipo PAC; reparaciones textuales manuales. |
| ¿DEBERÍA CREARSE? | Sí, si CCP escala en número o complejidad de políticas. |
| ¿O SU AUSENCIA ES CORRECTA? | Correcta a escala actual (25 políticas, 4 PARTIAL). PAC como research artifact es suficiente. |

#### NS-2 — Clasificación automática de STALL_POLICY events

| Campo | Valor |
|---|---|
| CAPACIDAD AUSENTE | Determinar automáticamente si un stall es TP, FP o UNKNOWN, y si había alternativa viable. |
| ¿QUÉ PROBLEMA CREA SU AUSENCIA? | `had_alternative` es null siempre; revisión humana no estandarizada; PAC-EF-02 FPs difíciles de clasificar. |
| ¿QUÉ MECANISMOS COMPENSAN SU AUSENCIA? | HRQS (M008); `query-log.sh`; revisión humana. |
| ¿DEBERÍA CREARSE? | Parcialmente — un clasificador de FP conocidos es viable; clasificación semántica completa no lo es. |
| ¿O SU AUSENCIA ES CORRECTA? | Parcialmente correcta; HRQS mitiga el gap humano. |

#### NS-3 — Observación de runtime nativo

| Campo | Valor |
|---|---|
| CAPACIDAD AUSENTE | Probes deterministas del comportamiento nativo de Claude Code (SubagentStop, dispatcher, matcher, re-entry). |
| ¿QUÉ PROBLEMA CREA SU AUSENCIA? | Incertidumbre sobre G-B11 phantom events; Tier 3 auth; lifecycle real. |
| ¿QUÉ MECANISMOS COMPENSAN SU AUSENCIA? | F9-D02=B; aceptación de NOT_VERIFIED como knowledge boundary. |
| ¿DEBERÍA CREARSE? | Solo si aparece trigger concreto. |
| ¿O SU AUSENCIA ES CORRECTA? | Correcta por decisión del Owner (coste > beneficio sin problema demostrado). |

#### NS-4 — Datos de campo H-01

| Campo | Valor |
|---|---|
| CAPACIDAD AUSENTE | Medir frecuencia real de STALL_POLICY events con alternativa viable. |
| ¿QUÉ PROBLEMA CREA SU AUSENCIA? | No se puede determinar materialidad de LABYRINTH-1; READY-03 sin base empírica. |
| ¿QUÉ MECANISMOS COMPENSAN SU AUSENCIA? | R-2 instrumentación; STALL_POLICY_LOG; query-log.sh; N=1 recomendado analíticamente. |
| ¿DEBERÍA CREARSE? | No se puede crear sin ambiente de uso real. |
| ¿O SU AUSENCIA ES CORRECTA? | Forzada por contexto; no es decisión de diseño. |

#### NS-5 — Motor de inferencia sobre conocimiento acumulado

| Campo | Valor |
|---|---|
| CAPACIDAD AUSENTE | Sistema que reactive y conecte conocimiento de movimientos previos automáticamente. |
| ¿QUÉ PROBLEMA CREA SU AUSENCIA? | Cada sesión debe releer corpus; riesgo de reinventar investigaciones. |
| ¿QUÉ MECANISMOS COMPENSAN SU AUSENCIA? | `CCP_EXPLORATION_ENGINE.md`; handoffs; `61G_CCP_CONTINUATION_GUIDE.md`; ROOT_ANALYSIS. |
| ¿DEBERÍA CREARSE? | A largo plazo, si el corpus crece. |
| ¿O SU AUSENCIA ES CORRECTA? | Correcta a escala actual (corpus manejable). |

#### NS-6 — Métrica de cobertura de políticas vs patterns

| Campo | Valor |
|---|---|
| CAPACIDAD AUSENTE | Saber qué políticas tienen patrón correspondiente en `bash-firewall.sh` y cuáles no. |
| ¿QUÉ PROBLEMA CREA SU AUSENCIA? | No se detecta fácilmente si una política no está enforceada. |
| ¿QUÉ MECANISMOS COMPENSAN SU AUSENCIA? | Auditorías manuales; M002 análisis de 25 políticas. |
| ¿DEBERÍA CREARSE? | Sí, si se mantiene arquitectura manual. |
| ¿O SU AUSENCIA ES CORRECTA? | Parcialmente correcta; PAC la haría innecesaria. |

#### NS-7 — Append-only enforcement de registries

| Campo | Valor |
|---|---|
| CAPACIDAD AUSENTE | Garantía técnica de que EV-NNN, REG-NNN, CTRL-NNN no se modifican. |
| ¿QUÉ PROBLEMA CREA SU AUSENCIA? | Riesgo de falsificación silenciosa; requiere reviewer humano. |
| ¿QUÉ MECANISMOS COMPENSAN SU AUSENCIA? | Git diff + reviewer humano; F9-D04 differed. |
| ¿DEBERÍA CREARSE? | Solo bajo requerimiento externo. |
| ¿O SU AUSENCIA ES CORRECTA? | Correcta bajo trust boundary Git+humano. |

---

## 2. Positive Space

### 2.1 Subsistemas necesarios que existen

| Subsistema | ¿Por qué es necesario? | Estado |
|---|---|---|
| `bash-firewall.sh` | Bloqueo determinista de comandos peligrosos. | ACTIVO |
| `secret-guard.sh` | Protección de secretos en Write/Edit. | ACTIVO |
| `task-completed-evidence.sh` | Gate de DONE basado en evidencia. | ACTIVO |
| `EVIDENCE_REGISTRY.md` | Fuente de verdad de evidencia verificada. | ACTIVO |
| `PROJECT_STATE.md` | Estado operativo canónico. | ACTIVO |
| `INCIDENT_REGISTRY.md` | Registro de incidentes y RCA. | ACTIVO |
| `CONTROL_REGISTRY.md` | Controles activos. | ACTIVO |
| `REGRESSION_REGISTRY.md` | Tests de regresión. | ACTIVO |
| `evals/maintenance.sh` | Verificación determinista de salud. | ACTIVO |
| `CCP_EXPLORATION_ENGINE.md` | Memoria operativa de investigación. | ACTIVO |
| Git + reviewer humano | Trust boundary declarado. | ACTIVO |

### 2.2 Decisiones que son correctas en su ausencia

- No motor de políticas en producción (escala actual lo permite).
- No probes nativos (sin trigger).
- No append-only técnico de registries (trust boundary humano suficiente).
- No F10-F12 definidos (sin problema concreto).

---

## 3. Unnecessary Space

### 3.1 Elementos que existen pero podrían desaparecer

#### US-1 — Duplicación política/enforcement

| Campo | Valor |
|---|---|
| ELEMENTO | Política en `.claude/rules/*.md` Y patrones en `bash-firewall.sh`. |
| ¿QUÉ RESUELVE? | Nada que no resuelva una sola representación. |
| ¿QUIÉN LO NECESITA? | Actualmente todos, por arquitectura. |
| ¿QUÉ PASA SI DESAPARECE? | Se requiere adoptar PAC u otra representación única. |
| ¿PODRÍA DERIVARSE DE OTRO ELEMENTO? | Sí, de PAC. |
| ¿PODRÍA REEMPLAZARSE POR ALGO MÁS SIMPLE? | Sí, YAML canónico. |
| ¿QUÉ LO GENERÓ? | Decisión de mantener reglas humanas y regex bash manual. |
| VEREDICTO | REDUNDANTE / CANDIDATO A ELIMINACIÓN vía PAC. |

#### US-2 — Múltiples archivos de decisiones

| Campo | Valor |
|---|---|
| ELEMENTO | `DECISION_REGISTRY.md`, `F9_OWNER_DECISIONS.md`, `58_OWNER_DECISION_PACKAGE.md`. |
| ¿QUÉ RESUELVE? | Cada uno cubre un tipo de decisión. |
| ¿QUIÉN LO NECESITA? | Owner y mantenedores. |
| ¿QUÉ PASA SI DESAPARECE? | Difícil saber qué está decidido. |
| ¿PODRÍA DERIVARSE DE OTRO ELEMENTO? | Sí, de un índice unificado en `DECISION_REGISTRY.md`. |
| ¿PODRÍA REEMPLAZARSE POR ALGO MÁS SIMPLE? | Sí, índice unificado. |
| ¿QUÉ LO GENERÓ? | Evolución orgánica del registro de decisiones. |
| VEREDICTO | DERIVABLE / CANDIDATO A CONSOLIDACIÓN. |

#### US-3 — Placeholders de context packs (G-A1)

| Campo | Valor |
|---|---|
| ELEMENTO | Context packs con placeholders en installer template. |
| ¿QUÉ RESUELVE? | Estructura para proyectos destino. |
| ¿QUIÉN LO NECESITA? | Proyectos que usan installer. |
| ¿QUÉ PASA SI DESAPARECE? | Confusión entre template y pack configurado. |
| ¿PODRÍA DERIVARSE DE OTRO ELEMENTO? | Sí, de documentación del installer. |
| ¿PODRÍA REEMPLAZARSE POR ALGO MÁS SIMPLE? | Sí, comentarios explícitos de "TEMPLATE". |
| ¿QUÉ LO GENERÓ? | F1 installer. |
| VEREDICTO | DERIVABLE / LOW PRIORITY. |

#### US-4 — Investigaciones redundantes si L1-C se acepta

| Campo | Valor |
|---|---|
| ELEMENTO | Tracks NH-08, AC-03, CDT-02 si READY-03 = YES y H-01 < N. |
| ¿QUÉ RESUELVE? | Cierre absoluto de LABYRINTH-1. |
| ¿QUIÉN LO NECESITA? | Nadie si aceptación condicional es suficiente. |
| ¿QUÉ PASA SI DESAPARECE? | Se pierde capacidad de cierre absoluto, no funcionalidad actual. |
| ¿PODRÍA DERIVARSE DE OTRO ELEMENTO? | N/A |
| ¿PODRÍA REEMPLAZARSE POR ALGO MÁS SIMPLE? | Sí, monitoreo H-01 + reactivación por trigger. |
| ¿QUÉ LO GENERÓ? | Búsqueda de cierre perfecto de LABYRINTH-1. |
| VEREDICTO | CANDIDATO A ELIMINACIÓN condicional a READY-03. |

---

## 4. Abstraction Discovery

### 4.1 Grupos de mecanismos relacionados

#### Grupo A — Enforcement de seguridad

| Mecanismos | ¿Existe abstracción unificada? | ¿En CCP? | ¿Reduce complejidad? |
|---|---|---|---|
| bash-firewall, secret-guard, settings.json permissions | Sí: "policy enforcement" | No como motor unificado | Sí, si se crea |

#### Grupo B — Verificación de calidad

| Mecanismos | ¿Existe abstracción unificada? | ¿En CCP? | ¿Reduce complejidad? |
|---|---|---|---|
| code-reviewer, doubt-driven, constraint-driven, evidence gate | Sí: "independent verification" | Parcial (skills separados) | Sí, si se unifica conceptualmente |

#### Grupo C — Aprendizaje

| Mecanismos | ¿Existe abstracción unificada? | ¿En CCP? | ¿Reduce complejidad? |
|---|---|---|---|
| INC→CTRL→REG, Exploration Engine, M001-M007 | Sí: "organizational learning" | No como motor | No necesariamente — podría esconder complejidad |

### 4.2 Veredicto sobre abstracciones

- **Policy enforcement** como abstracción es válida y reduciría complejidad.
- **Independent verification** es más una familia de skills que una abstracción útil.
- **Organizational learning** como abstracción esforzada podría esconder más de lo que clarifica.

---

## 5. Compensation Chain Detection

### 5.1 Cadena 1: Ausencia de motor de políticas

```text
LIMITACIÓN ORIGINAL (L1): No hay representación canónica de política.
      ↓
PARCHE 1 (P1): Reglas en Markdown + regex manual en bash-firewall.sh.
      ↓ produce nueva limitación
PARCHE 2 (P2): Reparaciones textuales manuales (READY-01) + nuevos patterns (READY-02).
      ↓ produce nueva limitación
PARCHE 3 (P3): Investigación M002-M007 para entender qué reparaciones son seguras.
      ↓ produce nueva limitación
PARCHE 4 (P4): Prototipo PAC para demostrar que la cadena puede colapsar.
      ↓ produce nueva limitación
PARCHE 5 (P5): F9-D01=A bloquea adopción de PAC en producción.
```

**Capacidad primaria ausente:** un motor de políticas canónico y compilable.

### 5.2 Cadena 2: Ausencia de verificador independiente

```text
LIMITACIÓN ORIGINAL (L2): El mismo modelo propone y verifica.
      ↓
PARCHE 1 (P1): Subagente code-reviewer con contexto fresco.
      ↓ produce nueva limitación
PARCHE 2 (P2): Requiere humano final para aprobación.
      ↓ produce nueva limitación
PARCHE 3 (P3): Diseño R-3 de verificador ciego independiente.
      ↓ produce nueva limitación
PARCHE 4 (P4): CDT-02 requiere nuevo agente y autorización.
      ↓ produce nueva limitación
PARCHE 5 (P5): F9-D01=A + F9-D04=B bloquean implementación.
```

**Capacidad primaria ausente:** arquitectura de proposer/verifier genuinamente aislada.

### 5.3 Cadena 3: Ausencia de datos de campo

```text
LIMITACIÓN ORIGINAL (L3): No hay ambiente de uso real.
      ↓
PARCHE 1 (P1): R-2 instrumentación y STALL_POLICY_LOG.
      ↓ produce nueva limitación
PARCHE 2 (P2): query-log.sh para consultar eventos.
      ↓ produce nueva limitación
PARCHE 3 (P3): N=1 recomendado analíticamente.
      ↓ produce nueva limitación
PARCHE 4 (P4): READY-03 pide aceptación bajo incertidumbre.
```

**Capacidad primaria ausente:** datos de campo sobre frecuencia de bypasses con alternativa.

---

## 6. Resumen de la fase 8

- **Negative space principal:** motor de políticas unificado, clasificación automática de stalls, observación nativa, datos H-01, motor de inferencia, métrica de cobertura, append-only técnico.
- **Positive space:** hooks, evidence gate, registries, maintenance, incident learning, Exploration Engine, Git+reviewer trust boundary.
- **Unnecessary space:** duplicación política/enforcement, archivos de decisiones dispersos, placeholders G-A1, tracks NH-08/AC-03/CDT-02 si L1-C se acepta.
- **Abstracción válida:** policy enforcement unificado.
- **Abstracción riesgosa:** organizational learning como metafora.
- **Cadenas de compensación:** 3 cadenas principales originadas en ausencia de motor de políticas, verificador independiente y datos de campo.
- **Capacidades primarias ausentes:** motor de políticas canónico; arquitectura proposer/verifier aislada; ambiente de uso real.

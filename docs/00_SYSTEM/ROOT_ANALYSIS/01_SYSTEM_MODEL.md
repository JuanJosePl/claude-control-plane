# 01 — SYSTEM MODEL

> Fase 2 del protocolo maestro: determinar qué tipo de sistema es CCP, no asumirlo.

---

## 1. Vista de caja negra

### ¿Qué entra al sistema?

| Entrada | Formato | Fuente |
|---|---|---|
| Intención humana | texto/libre | Owner / desarrollador |
| Comandos shell | payload JSON PreToolUse | Agente principal o subagente |
| Contenido Write/Edit | payload JSON PreToolUse | Agente |
| Solicitud de cierre de tarea | payload JSON TaskCompleted | Agente |
| Eventos de ciclo de sesión | JSON / variables de entorno | Runtime de Claude Code |
| Políticas permanentes | Markdown en `.claude/rules/` | Owner (configuración del proyecto) |
| Evidencia de verificación | Markdown en `EVIDENCE_REGISTRY.md` | Proceso de trabajo + reviewer |

### ¿Qué transforma?

- **Hooks P0**: transforman payloads de entrada en decisiones `allow/block`.
- **Evidence gate**: transforma claims de finalización en `PASS/BLOCK` según contrato.
- **Maintenance suite**: transforma el estado del repositorio en un informe `PASS/FAIL`.
- **Incident learning**: transforma un incidente detectado en control + regresión + evidencia.
- **State integrity**: transforma cambios de `PROJECT_STATE.md` en `PASS/DRIFT_DETECTED`.

### ¿Qué controla?

- Qué comandos Bash pueden ejecutarse.
- Qué contenido puede escribirse/editarse.
- Cuándo una tarea puede declararse completada.
- Qué fases están autorizadas a avanzar.
- Qué contexto recibe cada subagente.
- Qué cambios requieren aprobación humana explícita.

### ¿Qué produce?

- Decisiones de bloqueo/permitido.
- Entradas de evidencia (`EV-NNN`).
- Registros de incidentes, controles, regresiones.
- Logs de sesión y stall.
- Actualizaciones de estado.
- Artefactos de investigación (`docs/research/`).

### ¿Qué observa?

- `STALL_POLICY_LOG.jsonl` registra eventos de bloqueo de política [DOCUMENTADO].
- `maintenance.sh` observa salud determinista del repositorio [VERIFICADO].
- `session-start-compact.sh` observa drift de estado [VERIFICADO].
- `EVIDENCE_REGISTRY.md` observa claims verificados [VERIFICADO].

### ¿Qué almacena?

| Persistencia | Formato | Propósito |
|---|---|---|
| `.claude/settings.json` | JSON | Wiring de hooks y permisos |
| `.claude/hooks/*.sh` | Bash | Enforcement P0/P1/P2 |
| `PROJECT_STATE.md` | Markdown | Estado operativo canónico |
| `EVIDENCE_REGISTRY.md` | Markdown | Evidencia verificada |
| `DECISION_REGISTRY.md` | Markdown | Decisiones arquitectónicas |
| `INCIDENT_REGISTRY.md` | Markdown | Incidentes y RCA |
| `CONTROL_REGISTRY.md` | Markdown | Controles activos |
| `REGRESSION_REGISTRY.md` | Markdown | Tests de regresión |
| `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` | JSONL | Eventos de stall |
| Git history | Git | Provenance y rollback |

### ¿Qué decide?

| Decisión | Quién/Qué la decide |
|---|---|
| allow/block de un comando | `bash-firewall.sh` + `secret-guard.sh` |
| PASS/BLOCK de TaskCompleted | `task-completed-evidence.sh` |
| Avance de fase | Owner (con evidencia como input) |
| Autorización de cambios P0 | Owner explícito |
| Promoción de investigación a implementación | Owner (F9-D01=A) |

### ¿Qué aprende?

El sistema aprende **de incidentes a controles**:

```text
INCIDENTE → RCA → CONTROL AUSENTE → REGRESIÓN → VERIFICACIÓN → EVIDENCIA
```

Esto está demostrado con INC-001 → CTRL-001 → REG-001 → EV-006 [VERIFICADO].
También aprende preventivamente: F7 cerró bugs conductuales descubiertos por auditoría
adversarial y los convirtió en regresiones (REG-002..REG-009).

### ¿Qué genera?

- Nuevas entradas de evidencia.
- Nuevos controles y regresiones.
- Nuevos documentos de investigación.
- Nuevos estados de conocimiento (classification changes en el Exploration Engine).

### ¿Qué vuelve a alimentar al sistema?

- Los resultados de `maintenance.sh` alimentan decisiones de salud.
- Los incidentes alimentan controles.
- Las decisiones del Owner alimentan `PROJECT_STATE.md` y gates posteriores.
- La investigación (M001–M007) alimenta el `CCP_EXPLORATION_ENGINE.md`.

---

## 2. Modelos candidatos del sistema

No se asume un único modelo. Se evalúan candidatos con evidencia.

### 2.1 Pipeline

```text
intención → especificación → ejecución → verificación → evidencia → gate
```

**Qué explica bien:** F1–F8. Cada fase es una etapa del pipeline con entregables y gates.

**Qué NO explica:** La investigación post-F8 (M001–M007) no es un pipeline lineal; es
exploración de un laberinto con ciclos, reformulaciones y decisiones del Owner.

**Predice:** Si el pipeline es correcto, F9 debería haber sido una fase de implementación.
**Evidencia:** F9 fue `NOT JUSTIFIED` [VERIFICADO]. El modelo pipeline es insuficiente.

### 2.2 Ciclo de control (feedback loop)

```text
intención → implementación → enforcement → observación → aprendizaje → nueva intención
```

**Qué explica bien:** El learning loop de incidentes y las regresiones.

**Qué NO explica:** La investigación de frontera (R-1, R-2, R-3) no es un ciclo cerrado;
R-2 está bloqueado por falta de ambiente real, y R-3 no está autorizado para implementarse.

**Predice:** Un ciclo de control completo requeriría que R-2/R-3 se cierren.
**Evidencia:** El ciclo está **roto** en el nodo de observación (H-01 sin datos de campo) y
en el nodo de aprendizaje→implementación (F9-D01=A bloquea) [VERIFICADO].

### 2.3 Sistema de estados

```text
PLANNING → EXECUTING → COMPLETE
OPEN → INVESTIGATING → REGRESSION_ADDED → CLOSED
PROPOSED → VERIFIED | BLOCKED | REJECTED
```

**Qué explica bien:** Los estados documentados en registries.

**Qué NO explica:** Las transiciones no son mecánicas; dependen de juicio humano y gates.
No existe una máquina de estados formal en código.

### 2.4 Sistema de eventos

```text
PreToolUse → bash-firewall / secret-guard
TaskCompleted → task-completed-evidence
SubagentStart → subagent-context
Stop → stop-logger
...
```

**Qué explica bien:** La arquitectura de hooks y settings.json.

**Qué NO explica:** La mayoría de la lógica de gobernanza vive fuera de los eventos, en
registries, decisiones e investigación.

### 2.5 Sistema declarativo

**Qué explica bien:** Las reglas en `.claude/rules/` y los context packs declaran políticas.

**Qué NO explica:** Las reglas no se ejecutan directamente; los hooks las interpretan de
forma imperativa. No hay un motor de políticas declarativo unificado.

### 2.6 Compilador de gobernanza

```text
especificación (reglas + intención) → compilación (hooks + settings) → enforcement → observación → aprendizaje → nueva especificación
```

**Qué explica bien:** La hipótesis PAC (Policy-as-Code) que surgió en M007: un YAML de
políticas se compila a patrones bash.

**Qué NO explica:** PAC es solo un prototipo; la mayoría del sistema no está compilado de
una especificación central. READY-01 y READY-02 existen precisamente porque la compilación
no es la realidad actual.

**Predice:** Si PAC fuera la arquitectura raíz, READY-01/02 colapsarían en una decisión.
**Evidencia:** M007 demostró que PAC colapsa READY-01/02 conceptualmente, pero PAC no está
autorizado para producción [DOCUMENTADO].

### 2.7 Sistema de gobernanza

**Qué explica bien:** CCP gobierna qué puede hacer un agente, bajo qué condiciones, con qué
evidencia, y quién autoriza. Los gates humanos son centrales.

**Qué NO explica:** No explica por qué gran parte del esfuerzo reciente fue investigación
sobre la naturaleza del problema residual, no solo aplicación de políticas.

### 2.8 Sistema de conocimiento acumulativo

**Qué explica bien:** El `CCP_EXPLORATION_ENGINE.md`, el registro de movimientos, las
reclasificaciones de hipótesis, y el aprendizaje de "qué NO construir".

**Qué NO explica:** El sistema no tiene un motor de inferencia automática; el conocimiento
se acumula en documentos Markdown y requiere sesiones para reactivarlo.

### 2.9 Sistema de capacidades controladas

**Qué explica bien:** CCP habilita/deshabilita capacidades según contexto (permisos allow/ask/deny,
gates de fase, decisiones del Owner).

**Qué NO explica:** No capta la dimensión de investigación de frontera.

### 2.10 Modelo híbrido (candidato principal)

CCP es mejor descrito como un **híbrido**:

```text
GOBERNANZA + PIPELINE + CICLO DE CONTROL + SISTEMA DE CONOCIMIENTO
```

- **Pipeline** para F1–F8.
- **Ciclo de control** para incidentes y regresiones (parcialmente cerrado).
- **Gobernanza** para autorización humana y gates.
- **Sistema de conocimiento** para investigación de frontera (M001–M007).

**Por qué es el mejor candidato:**
Ningún modelo puro explica tanto el build como la investigación post-F8. El híbrido absorbe
las fortalezas de cada uno sin forzar a CCP a encajar en una sola metáfora.

---

## 3. Flujo de control

```text
INTENCIÓN DEL AGENTE
        ↓
INTERCEPCIÓN DE HOOK (PreToolUse / TaskCompleted / Stop / ...)
        ↓
DECISIÓN DE POLÍTICA (regex, evidence contract, state check)
        ↓
BLOQUEO / PERMISO (exit 0 / exit 2)
        ↓
ACCIÓN / STALL
        ↓
REGISTRO / EVIDENCIA (STALL_POLICY_LOG, EVIDENCE_REGISTRY)
        ↓
REVISIÓN HUMANA (git diff, owner gates)
        ↓
APRENDIZAJE / CONTROL (INCIDENT_REGISTRY → CONTROL_REGISTRY → REGRESSION_REGISTRY)
```

### ¿Dónde se pierde información?

| Nodo | Pérdida |
|---|---|
| Intercepción de hook | El hook no ve el contexto de alta nivel de la tarea, solo el payload. |
| Decisión de política | Los patrones regex no capturan intención semántica; los falsos positivos/negativos se pierden como "stall" sin análisis automático. |
| Registro | `had_alternative` siempre es `null` en R-2 [DOCUMENTADO]; no se registra si había alternativa viable. |
| Revisión humana | No hay métrica de calidad de revisión humana (HRQS gap identificado en M007). |

### ¿Qué pasa cuando falla cada nodo?

| Nodo fallido | Consecuencia |
|---|---|
| Hook no intercepta | Comando o tarea pasa sin verificación. |
| Decisión de política errónea | Falso positivo (bloqueo legítimo) o falso negativo (bypass). |
| Bloqueo no ocurre | Acción destructiva o evidencia inválida se acepta. |
| Registro falla | Pérdida de forensic data; R-2 no observa. |
| Revisión humana omitida | Cambio P0 sin aprobación; riesgo de trust boundary. |
| Aprendizaje no cierra | Incidente recurrente sin control. |

### ¿Qué nodo tiene demasiadas responsabilidades?

**`bash-firewall.sh`**: combina parsing JSON, validación de payload, detección de patrones
destructivos, detección de secretos, supply chain, y logging de stall. Es el nodo más cargado.

### ¿Qué nodo podría eliminarse?

Ninguno sin degradar el sistema actual. Sin embargo, la dualidad `rules/*.md` + patrones bash
en `bash-firewall.sh` podría colapsarse si PAC se adoptara.

---

## 4. Flujo de información

### Objeto: política

| Aspecto | Detalle |
|---|---|
| Creación | Owner escribe `.claude/rules/*.md` [DOCUMENTADO]. |
| Transformación | Investigación M002/M003 propone reparaciones textuales (READY-01). |
| Transporte | Referenciada en `CCP_EXPLORATION_ENGINE.md`, `58_OWNER_DECISION_PACKAGE.md`. |
| Almacenamiento | `.claude/rules/*.md` (humana) + `bash-firewall.sh` (máquina). |
| Consumo | Agentes la leen como contexto; hooks la aplican como regex. |
| Derivación | PAC propone derivar regex de YAML, pero no está en producción. |
| Observación | No hay métrica de cobertura de política vs. patrones [IDENTIFICADO en M007]. |
| Pérdida | La intención de la política se diluye al traducirse a regex manualmente. |
| Duplicación | Política vive en dos representaciones: Markdown humano y regex bash. |

### Objeto: evidencia

| Aspecto | Detalle |
|---|---|
| Creación | Proceso de trabajo + reviewer genera entrada `EV-NNN`. |
| Transformación | Hook valida contra payload TaskCompleted. |
| Transporte | Referenciada por `task_id` y `contract_hash`. |
| Almacenamiento | `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`. |
| Consumo | `task-completed-evidence.sh` decide PASS/BLOCK. |
| Derivación | No se recompute artifact hash contra archivos (A-05 diferido). |
| Observación | Maintenance verifica conteo y formato. |
| Pérdida | Provenance es semántica, no traza a input exacto. |
| Duplicación | No hay duplicación canónica; `PROJECT_STATE.md` resume estado. |

### Objeto: stall

| Aspecto | Detalle |
|---|---|
| Creación | `block()` en `bash-firewall.sh` o `task-completed-evidence.sh`. |
| Transformación | `stall-record.sh` genera JSONL. |
| Transporte | Append a `STALL_POLICY_LOG.jsonl`. |
| Almacenamiento | `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl`. |
| Consumo | `query-log.sh` y análisis humano. |
| Derivación | No se deriva automáticamente estadística o clasificación de FP. |
| Observación | Conteo manual; 3 eventos registrados [DOCUMENTADO]. |
| Pérdida | `had_alternative=null` siempre; no se sabe si había alternativa viable. |

---

## 5. Flujo de evidencia

| Pregunta | Respuesta |
|---|---|
| ¿Cómo se genera? | Tests, fixtures, revisiones independientes, auditorías. Cada EV-NNN tiene artifact hash, contract hash, checks, reviewer, timestamp. |
| ¿Cómo se valida? | `task-completed-evidence.sh` compara payload con registro VERIFIED. |
| ¿Cómo se almacena? | `EVIDENCE_REGISTRY.md` de forma append-only por convención. |
| ¿Cómo se consulta? | Por `task_id` y `contract_hash` en el hook. |
| ¿Cómo se congela? | F7 y F8 están `COMPLETE / FROZEN` en commits específicos [VERIFICADO]. |
| ¿Cómo se invalida? | No hay invalidación automática; cambios requieren nuevas entradas. |
| ¿Qué pasa si es incorrecta? | Un actor con acceso de escritura puede falsificarla; mitigado por Git diff + reviewer humano. |
| ¿Puede derivarse de otra? | El contract hash debería derivarse del documento de contrato (ej. `F8_RESEARCH.md`), pero no hay validación automática de artifact hash contra archivos. |

---

## 6. Flujo de aprendizaje

```text
INCIDENTE DETECTADO
        ↓
ANÁLISIS RCA
        ↓
CONTROL IDENTIFICADO
        ↓
IMPLEMENTACIÓN DE CONTROL
        ↓
REGRESSION TEST
        ↓
¿CIERRA EL CICLO?
```

Para INC-001 el ciclo está cerrado [VERIFICADO].
Para bugs conductuales descubiertos en F7, el ciclo se cerró con regresiones preventivas.
Para LABYRINTH-1, el ciclo **NO cierra** porque:

- No hay incidente orgánico que active el ciclo.
- R-2 observa pero no tiene datos de campo.
- R-3 está diseñado pero no implementado.
- F9-D01=A bloquea la implementación.

---

## 7. Control Loop Analysis

### Ciclo propuesto

```text
ESPECIFICACIÓN DE INTENCIÓN
        ↓
IMPLEMENTACIÓN DE POLÍTICA
        ↓
ENFORCEMENT (HOOKS)
        ↓
OBSERVACIÓN (R-2, STALL LOG)
        ↓
APRENDIZAJE (INCIDENTES, CONTROLES)
        ↓
REVISIÓN DE ESPECIFICACIÓN
        ↓
NUEVA ESPECIFICACIÓN
```

### Estado de cada nodo

| Nodo | ¿Existe? | ¿Automatizado? | ¿Información se pierde? |
|---|---|---|---|
| Especificación | Sí (reglas, planes, decisiones) | Parcial (Markdown) | Intención no siempre operacionalizable. |
| Implementación | Sí (hooks, settings) | Sí | Traducción a regex pierde semántica. |
| Enforcement | Sí (hooks P0) | Sí | Native runtime no verificado. |
| Observación | Parcial (R-2 log, maintenance) | Parcial | `had_alternative=null`; sin datos de campo. |
| Aprendizaje | Parcial (INC-001 + F7 bugs) | No | Requiere intervención humana. |
| Revisión de especificación | Sí (owner gates) | No | Owner decide. |
| Nueva especificación | Sí (post-decisión) | No | Nuevos movimientos. |

### Conclusión del control loop

El ciclo está **cerrado para incidentes reactivos** (INC-001) pero **roto para el problema
residual de LABYRINTH-1** porque el nodo de observación no produce datos suficientes y el nodo
de implementación está bloqueado por autorización.

---

## 8. Resumen de la fase 2

- **Modelo más preciso:** Híbrido `gobernanza + pipeline + control loop + conocimiento`.
- **Pipeline:** explica F1–F8.
- **Control loop:** explica incidentes y regresiones; roto en LABYRINTH-1.
- **Gobernanza:** explica autorización humana y gates.
- **Conocimiento:** explica investigación de frontera (M001–M007).
- **Modelo parcialmente soportado:** "Compilador de gobernanza" vía PAC (prototipo, no producción).
- **Control loop:** cerrado para reactivo, roto para preventivo/proactivo.
- **Información perdida:** intención semántica al traducir reglas a regex; `had_alternative`;
calidad de revisión humana.
- **Duplicación principal:** política en `.claude/rules/*.md` + patrones en `bash-firewall.sh`.

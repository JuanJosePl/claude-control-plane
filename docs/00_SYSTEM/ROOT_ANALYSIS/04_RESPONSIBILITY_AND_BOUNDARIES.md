# 04 — RESPONSIBILITY AND BOUNDARIES

> Fase 5 del protocolo maestro: mapear responsabilidades, fuentes de verdad, derivaciones y
> fronteras del sistema.

---

## 1. Responsibility Matrix

### 1.1 Hooks de enforcement

#### `bash-firewall.sh`

| Campo | Valor |
|---|---|
| RESPONSABILIDAD DECLARADA | Bloquear comandos shell destructivos, de secretos, supply chain y reads de archivos sensibles. |
| RESPONSABILIDAD REAL (verificada) | Parsing JSON del payload PreToolUse; validación de JSON; matching de múltiples familias regex; logging de stall; denegación con exit 2. |
| ¿COINCIDEN? | PARCIAL — la responsabilidad real es más amplia: también normaliza/compara comandos y maneja salida. |
| PROPIETARIO LÓGICO | Runtime security / hook layer. |
| ¿TIENE UN ÚNICO PROPIETARIO? | Sí dentro de CCP. |
| DUPLICACIÓN | `secret-guard.sh` también detecta secretos, pero en payloads de Write/Edit. |
| ¿DEBERÍA ESTAR EN OTRO LUGAR? | No, es el firewall central. |
| ¿PUEDE DERIVARSE DE OTRO COMPONENTE? | Parcialmente de un motor de políticas (PAC), pero no en la arquitectura actual. |
| ¿PUEDE ELIMINARSE? | No sin perder enforcement L4/L5. |

#### `secret-guard.sh`

| Campo | Valor |
|---|---|
| RESPONSABILIDAD DECLARADA | Detectar secretos en payloads de escritura/edición. |
| RESPONSABILIDAD REAL | Filtrar contenido Write/Edit contra patrones de secretos. |
| ¿COINCIDEN? | Sí. |
| PROPIETARIO LÓGICO | Runtime security / hook layer. |
| DUPLICACIÓN | Parcial con `bash-firewall.sh` (ambos detectan secretos). |
| ¿PUEDE DERIVARSE? | Podría unificarse en un solo guard de secretos. |
| ¿PUEDE ELIMINARSE? | No sin perder cobertura Write/Edit. |

#### `task-completed-evidence.sh`

| Campo | Valor |
|---|---|
| RESPONSABILIDAD DECLARADA | Validar contrato de evidencia antes de aceptar TaskCompleted. |
| RESPONSABILIDAD REAL | Extraer task_id y contract_hash del payload; validar contra EVIDENCE_REGISTRY; rechazar con exit 2 si no coincide. |
| ¿COINCIDEN? | Sí. |
| PROPIETARIO LÓGICO | Evidence gate. |
| DUPLICACIÓN | Ninguna directa. |
| ¿PUEDE DERIVARSE? | El contract_hash debería derivarse del documento de contrato; hoy es manual. |
| ¿PUEDE ELIMINARSE? | No; es el gate central de DONE. |

#### `subagent-context.sh`

| Campo | Valor |
|---|---|
| RESPONSABILIDAD DECLARADA | Cargar context packs por rol para subagentes. |
| RESPONSABILIDAD REAL | Inyectar rutas de contexto según el rol del subagente. |
| ¿COINCIDEN? | Sí. |
| PROPIETARIO LÓGICO | Context management. |
| DUPLICACIÓN | Ninguna. |
| ¿PUEDE DERIVARSE? | De la definición de roles en `agents/`. |
| ¿PUEDE ELIMINARSE? | No mientras se usen subagentes. |

#### `session-start-compact.sh` / `pre-compact-snapshot.sh`

| Campo | Valor |
|---|---|
| RESPONSABILIDAD DECLARADA | Detectar drift de estado al inicio de sesión. |
| RESPONSABILIDAD REAL | Comparar hash de campos críticos de PROJECT_STATE con snapshot previo. |
| ¿COINCIDEN? | Sí. |
| PROPIETARIO LÓGICO | State integrity. |
| DUPLICACIÓN | Maintenance suite también verifica estado. |
| ¿PUEDE DERIVARSE? | De PROJECT_STATE.md directamente. |
| ¿PUEDE ELIMINARSE? | No; proporciona detección temprana. |

### 1.2 Registries

| Componente | Responsabilidad | Propietario | Duplicación | Derivación |
|---|---|---|---|---|
| `PROJECT_STATE.md` | Estado operativo canónico | Owner / sistema | `.claude/context/CURRENT_STATE.md` (mirror) | No derivado; fuente primaria |
| `EVIDENCE_REGISTRY.md` | Evidencia verificada | Reviewer / proceso | Resumen en PROJECT_STATE | No derivado; append-only |
| `DECISION_REGISTRY.md` | Decisiones arquitectónicas | Owner | `F9_OWNER_DECISIONS.md`, `58_OWNER_DECISION_PACKAGE.md` | No unificado |
| `INCIDENT_REGISTRY.md` | Incidentes y RCA | Proceso de incidente | Referenciado en CONTROL/REGRESSION | No derivado |
| `CONTROL_REGISTRY.md` | Controles activos | Proceso de incidente | Debería derivarse de INCIDENT → CONTROL | Parcialmente manual |
| `REGRESSION_REGISTRY.md` | Tests de regresión | Proceso de incidente | Debería derivarse de CONTROL → REG | Parcialmente manual |

### 1.3 Procesos / skills

| Componente | Responsabilidad | Human/Machine | Duplicación |
|---|---|---|---|
| `/test-driven-development` | Workflow TDD | Mixed | Ninguna clara |
| `/code-review-and-quality` | Revisión contra contrato | Mixed (agente + humano) | Ninguna |
| `/doubt-driven-development` | Verificación adversarial | Mixed | Ninguna |
| `/constraint-driven-development` | Trabajo bajo restricciones | Mixed | Ninguna |
| `/incident` | Convertir fallo en control | Mixed | Ninguna |
| `/evidence` | Trazabilidad durable | Mixed | Ninguna |
| `/doctor` | Health check del control plane | Mixed | Ninguna |
| `/gate` | Check objetivo de salida | Mixed | Ninguna |

### 1.4 Problemas de responsabilidad identificados

- **`bash-firewall.sh` está sobrecargado**: parsing JSON + validación + múltiples familias regex + logging + salida. Es el componente con más responsabilidades.
- **Política vive en dos representaciones**: `.claude/rules/*.md` (humana) y `bash-firewall.sh` (máquina). Nadie es dueño de la sincronización entre ambas.
- **Decisiones dispersas**: `DECISION_REGISTRY.md`, `F9_OWNER_DECISIONS.md`, `58_OWNER_DECISION_PACKAGE.md` y `PROJECT_STATE.md` contienen decisiones sin un índice unificado.

---

## 2. Source of Truth Map

### 2.1 Conceptos relevantes

#### Política

| Campo | Valor |
|---|---|
| FUENTE DE VERDAD ACTUAL | `.claude/rules/*.md` (intención humana) + `bash-firewall.sh` (enforcement). |
| ¿ES ÚNICA? | NO |
| FUENTES MÚLTIPLES | Markdown humano; regex bash; prototipo PAC YAML. |
| ¿ESTÁN SINCRONIZADAS? | PARCIALMENTE — M002/M003/M007 proponen reparaciones que aún no se aplican. |
| ¿CÓMO SE SINCRONIZA? | MANUAL |
| ¿DEBERÍA SER CANÓNICO? | Una especificación central (YAML/PAC) debería ser única si se adopta. |
| ¿PODRÍA DERIVARSE DE OTRA? | Sí: regex de `bash-firewall.sh` debería derivarse de `.claude/rules/*.md` o de PAC. |

#### Estado operativo

| Campo | Valor |
|---|---|
| FUENTE DE VERDAD ACTUAL | `PROJECT_STATE.md` |
| ¿ES ÚNICA? | Sí como canónica; `.claude/context/CURRENT_STATE.md` es mirror. |
| ¿ESTÁN SINCRONIZADAS? | Sí por convención; maintenance verifica. |
| ¿CÓMO SE SINCRONIZA? | MANUAL al cerrar fases/movimientos. |
| ¿DEBERÍA SER CANÓNICO? | `PROJECT_STATE.md` ya es canónico. |
| ¿PODRÍA DERIVARSE DE OTRA? | Parcialmente de Git + registries, pero no automáticamente. |

#### Evidencia

| Campo | Valor |
|---|---|
| FUENTE DE VERDAD ACTUAL | `EVIDENCE_REGISTRY.md` |
| ¿ES ÚNICA? | Sí |
| ¿ESTÁN SINCRONIZADAS? | Sí |
| ¿CÓMO SE SINCRONIZA? | MANUAL — reviewer añade entrada tras verificación. |
| ¿DEBERÍA SER CANÓNICO? | Sí |
| ¿PODRÍA DERIVARSE DE OTRA? | El `contract_hash` debería derivarse del documento de contrato; no se verifica automáticamente. |

#### Decisiones

| Campo | Valor |
|---|---|
| FUENTE DE VERDAD ACTUAL | `DECISION_REGISTRY.md` + `F9_OWNER_DECISIONS.md` + `58_OWNER_DECISION_PACKAGE.md` |
| ¿ES ÚNICA? | NO |
| FUENTES MÚLTIPLES | Registro de decisiones técnicas; registro de decisiones del Owner; paquetes de decisión listos. |
| ¿ESTÁN SINCRONIZADAS? | PARCIALMENTE — cada archivo cubre un tipo diferente. |
| ¿CÓMO SE SINCRONIZA? | MANUAL |
| ¿DEBERÍA SER CANÓNICO? | Un único `DECISION_REGISTRY.md` extendido debería indexar todas. |
| ¿PODRÍA DERIVARSE DE OTRA? | Sí de `PROJECT_STATE.md` + handoffs. |

#### Incidente / Control / Regresión

| Campo | Valor |
|---|---|
| FUENTE DE VERDAD ACTUAL | `INCIDENT_REGISTRY.md`, `CONTROL_REGISTRY.md`, `REGRESSION_REGISTRY.md` |
| ¿ES ÚNICA? | Sí por dominio |
| ¿ESTÁN SINCRONIZADAS? | Sí por convención; cada incidente enlaza a control y regresión. |
| ¿CÓMO SE SINCRONIZA? | MANUAL en el proceso `/incident`. |
| ¿DEBERÍA SER CANÓNICO? | Sí |
| ¿PODRÍA DERIVARSE DE OTRA? | CONTROL debería derivarse de INCIDENT; REGRESSION de CONTROL. Hoy es manual pero con proceso claro. |

---

## 3. Derivation Graph

### 3.1 Cadena ideal

```text
ESPECIFICACIÓN (reglas del Owner, intención)
      ↓ deriva
POLÍTICAS (.claude/rules/*.md o YAML PAC)
      ↓ deriva
PATRONES DE ENFORCEMENT (regex bash-firewall.sh)
      ↓ deriva
TESTS DE REGRESIÓN (fixtures positivos/negativos)
      ↓ deriva
EVIDENCIA (EV-NNN)
```

### 3.2 Estado real

```text
ESPECIFICACIÓN (intención del Owner, parcialmente documentada)
      ↓ MANUAL
POLÍTICAS (.claude/rules/*.md) ─────────────┐
      ↓ MANUAL                                │ DUPLICACIÓN
PATRONES (bash-firewall.sh) ←───────────────┘
      ↓ MANUAL
TESTS (evals/fixtures)
      ↓ MANUAL
EVIDENCIA (EVIDENCE_REGISTRY.md)
```

### 3.3 Cadenas rotas identificadas

| Rotura | Descripción | Impacto |
|---|---|---|
| R1 | Política Markdown no deriva automáticamente regex bash | Duplicación; riesgo de drift (READY-01/02) |
| R2 | `contract_hash` no se deriva del documento de contrato | Posible mismatch no detectado por máquina (A-05 contexto) |
| R3 | `artifact_hash` no se recompute contra archivos | Evidencia podría referenciar artifact modificado (A-05) |
| R4 | Decisiones dispersas en múltiples archivos | Dificulta saber qué está decidido y qué no |
| R5 | `PROJECT_STATE.md` no se deriva de Git + registries | Requiere actualización manual; riesgo de drift |

---

## 4. Boundary Analysis

### 4.1 ¿Qué pertenece a CCP?

- `.claude/` del proyecto destino tras `install.sh`.
- Registries de estado, evidencia, decisiones, incidentes, controles, regresiones.
- Hooks de enforcement y ciclo de sesión.
- Skills de workflow.
- Documentación del control plane.
- Suite de evaluación y mantenimiento.

### 4.2 ¿Qué NO pertenece?

- Código de producción del proyecto destino.
- Runtime nativo de Claude Code / OpenCode (no controlado por CCP).
- Políticas de negocio del proyecto destino (salvo que se configuren en context packs).
- Infraestructura de CI/CD del proyecto destino (aunque CCP tiene su propio workflow GH Actions).

### 4.3 ¿Qué está DEMASIADO DENTRO? (debería estar fuera)

- **Investigación de frontera (M001-M007)**: gran parte vive en `docs/research/` dentro del mismo repositorio. Esto es correcto por ahora, pero si escala podría separarse en un research archive.
- **Prototipo PAC**: como research artifact está bien, pero si no se adopta, eventualmente podría moverse a un repo de experimentos.

### 4.4 ¿Qué está DEMASIADO FUERA? (debería estar dentro)

- **Native runtime behavior**: CCP no puede observar directamente el runtime nativo de Claude Code. Esto es una limitación, no un error de diseño.
- **H-01 field data**: requiere uso real del sistema, fuera del alcance del repositorio.

### 4.5 Interfaces reales del sistema

| Interfaz | Tipo | Descripción |
|---|---|---|
| PreToolUse payload | Entrada | Hooks bash/secret interceptan comandos y writes. |
| TaskCompleted payload | Entrada | Hook evidence valida cierre. |
| SubagentStart payload | Entrada | Hook context carga packs. |
| Stop payload | Entrada | Hook stop-logger registra fin. |
| `maintenance.sh` | Salida/Verificación | Reporte PASS/FAIL del estado del repo. |
| `EVIDENCE_REGISTRY.md` | Salida | Entradas EV-NNN. |
| `STALL_POLICY_LOG.jsonl` | Salida | Eventos de bloqueo. |
| Git history | Provenance | Trazabilidad de cambios. |
| Owner decisions | Control | Gates humanos. |

---

## 5. Human vs Machine Boundary

### 5.1 Procesos importantes

#### Decisión allow/block de comando

| Campo | Valor |
|---|---|
| ACTUALMENTE | MACHINE (bash-firewall.sh) |
| DEBERÍA SER | MACHINE |
| RAZÓN ACTUAL | Velocidad y determinismo. |
| ¿PODRÍA AUTOMATIZARSE? | Ya lo está. |
| ¿DEBERÍA AUTOMATIZARSE? | Sí. |
| RIESGO DE AUTOMATIZAR | Falsos positivos; PAC-EF-02 demostró que puede pasar. |
| RIESGO DE NO AUTOMATIZAR | No escala; bypasses comunes no detectados. |

#### Decisión PASS/BLOCK de TaskCompleted

| Campo | Valor |
|---|---|
| ACTUALMENTE | MACHINE (task-completed-evidence.sh) |
| DEBERÍA SER | MACHINE |
| RAZÓN ACTUAL | Determinismo; contrato explícito. |
| ¿PODRÍA AUTOMATIZARSE? | Ya lo está. |
| ¿DEBERÍA AUTOMATIZARSE? | Sí. |
| RIESGO DE AUTOMATIZAR | Evidencia falsa u omitida puede pasar si reviewer falla. |
| RIESGO DE NO AUTOMATIZAR | Agentes declaran DONE sin evidencia. |

#### Avance de fase

| Campo | Valor |
|---|---|
| ACTUALMENTE | HUMAN (Owner) |
| DEBERÍA SER | HUMAN |
| RAZÓN ACTUAL | POLÍTICA — cambios de fase son decisiones estratégicas. |
| ¿PODRÍA AUTOMATIZARSE? | Parcialmente con gates objetivos, pero la decisión final requiere juicio. |
| ¿DEBERÍA AUTOMATIZARSE? | No. |

#### RCA y diseño de control

| Campo | Valor |
|---|---|
| ACTUALMENTE | MIXTO — agente investiga, humano aprueba. |
| DEBERÍA SER | MIXTO |
| RAZÓN ACTUAL | El agente puede proponer, pero el control afecta comportamiento. |
| ¿PODRÍA AUTOMATIZARSE? | Parte de documentación; no la aprobación. |
| ¿DEBERÍA AUTOMATIZARSE? | No completamente. |

#### Revisión independiente

| Campo | Valor |
|---|---|
| ACTUALMENTE | MIXTO — subagente code-reviewer + humano final. |
| DEBERÍA SER | MIXTO |
| RAZÓN ACTUAL | CONFIANZA — el mismo modelo no puede certificar su propio trabajo. |
| ¿PODRÍA AUTOMATIZARSE? | El subagente es automático; el humano es trust boundary. |
| ¿DEBERÍA AUTOMATIZARSE? | La parte mecánica sí; la aprobación final no. |

#### Definición de threshold N para H-01

| Campo | Valor |
|---|---|
| ACTUALMENTE | HUMAN (Owner, aún no definido) |
| DEBERÍA SER | HUMAN |
| RAZÓN ACTUAL | POLÍTICA — aceptación de riesgo residual. |
| ¿PODRÍA AUTOMATIZARSE? | No sin datos de campo. |
| ¿DEBERÍA AUTOMATIZARSE? | No. |

### 5.2 Procesos que son manuales solo por falta de capacidad

| Proceso | ¿Por qué es manual? | ¿Podría automatizarse? |
|---|---|---|
| Sincronización política → regex | No hay motor de políticas | Sí, vía PAC |
| Recompute artifact hash | No hay integración Git-hash en evidence | Sí, parcialmente |
| Actualización de PROJECT_STATE.md | No hay derivación automática de estado | Parcialmente |
| Clasificación de STALL_POLICY events | No hay clasificador automático de FP | Parcialmente, con riesgo |

---

## 6. Resumen de la fase 5

- **Componente más sobrecargado:** `bash-firewall.sh`.
- **Duplicación principal:** política en `.claude/rules/*.md` + regex en `bash-firewall.sh`.
- **Fuentes de verdad únicas:** `PROJECT_STATE.md`, `EVIDENCE_REGISTRY.md` (con mirrors manuales).
- **Fuentes de verdad duplicadas:** política; decisiones.
- **Cadenas de derivación rotas:** política→regex; contract_hash→contrato; artifact_hash→archivos; PROJECT_STATE→Git+registries.
- **Boundary más importante:** CCP no controla el runtime nativo de Claude Code — es una frontera externa.
- **Procesos que deben permanecer humanos:** avance de fase, aceptación de riesgo residual, aprobación final de cambios P0.

# 07 — COUNTERFACTUAL AND EVOLUTION

> Fase 9 del protocolo maestro: explorar caminos no tomados, reconstruir CCP desde cero con
> el conocimiento actual y proyectar su evolución bajo carga.

---

## 1. CCP desde cero

Con el conocimiento acumulado en F1–F9 y M001–M007, si se diseñara CCP hoy:

### CONSERVAR

- **Evidence-gated completion** como primitiva central: ninguna tarea contractual se cierra sin evidencia verificable.
- **Incident → Control → Regression → Evidence**: el ciclo de aprendizaje demostrado con INC-001.
- **Git + reviewer humano como trust boundary**: funciona y evita over-engineering de self-verification.
- **Maintenance suite determinista**: `evals/maintenance.sh` 12/12 es un invariante valioso.
- **Fail-closed design**: F7/F8 demostraron que fallar cerrado es más seguro que fallar abierto.
- **Context packs por rol**: carga controlada de contexto evita sorpresas de runtime.
- **Reversibilidad**: checkpoints, rollback, scope limitado.

### ELIMINAR

- **Duplicación política/enforcement**: una sola representación canónica de política.
- **Fases predefinidas post-F8**: no nombrar F10-F12 hasta tener problema+evidencia.
- **Investigaciones sin problema concreto**: evitar laberintos de research sin trigger.
- **Decisiones dispersas en múltiples archivos**: un índice unificado de decisiones.

### FUSIONAR

- **Reglas `.claude/rules/*.md` + regex `bash-firewall.sh`** en un motor PAC desde el inicio.
- **Registros de decisiones** (`DECISION_REGISTRY.md`, `F9_OWNER_DECISIONS.md`, `58_OWNER_DECISION_PACKAGE.md`) en un único ledger con clasificación.
- **Skills de verificación** (`/code-review-and-quality`, `/doubt-driven-development`, `/constraint-driven-development`) bajo una abstracción común de "independent verification" si la complejidad lo justifica.

### DERIVAR

- **Regex de enforcement** a partir de la especificación de política.
- **`contract_hash`** a partir del documento de contrato.
- **`artifact_hash`** a partir de los archivos del artifact (con posibilidad de invalidación).
- **`PROJECT_STATE.md`** a partir de Git + registries (parcialmente, con aprobación humana).
- **Controles** a partir de incidentes; **regresiones** a partir de controles.

### CENTRALIZAR

- **Política**: un YAML canónico si se adopta PAC.
- **Decisiones**: un índice unificado.
- **Estado**: `PROJECT_STATE.md` como canónico (ya lo es), con mirrors derivados.

### DESCENTRALIZAR

- **Investigación de frontera**: si escala, podría vivir en un archive separado para no contaminar el control plane operativo.
- **Prototipos** (como PAC): repositorio de experimentos hasta que se autorice producción.

---

## 2. Contrafactuales específicos

### SIN PAC

`[CONTRAFACTUAL]`

- READY-01 y READY-02 seguirían siendo decisiones separadas.
- Las reparaciones de políticas serían ediciones manuales de Markdown y regex.
- M002-M007 seguirían siendo necesarias para cada nueva ambigüedad.
- El riesgo de drift política↔enforcement persistiría.
- No habría breakout candidate para colapsar R3.

### SIN F9-D01=A

`[CONTRAFACTUAL]`

- Se habrían implementado A-05, A-07 y posiblemente G-N5.
- F10 podría haberse definido como fase de integridad/self-verification.
- Se habría invertido complejidad sin incidente demostrado.
- Riesgo de over-engineering alto; trust boundary se habría expandido prematuramente.

### SIN STALL_POLICY_LOG

`[CONTRAFACTUAL]`

- R-2 sería puramente teórico.
- No se podría medir H-01.
- READY-03 carecería incluso de base analítica.
- PAC-EF-02 no habría sido descubierto experimentalmente.
- El argumento de L1-C sería más débil.

### SIN EVIDENCE GATE

`[CONTRAFACTUAL]`

- TaskCompleted aceptaría DONE sin evidencia.
- INC-001 no se habría aprendido como control+regresión.
- F7/F8 no tendrían razón de ser.
- CCP se reduciría a un conjunto de hooks sin contrato de terminación.

### SI ELIMINAMOS UNA CAPA

| Capa | ¿Cuál eliminar con menor daño? | Impacto |
|---|---|---|
| Hooks | Ninguna — son el enforcement core. | Perdemos control P0/P1/P2. |
| Registries | `DECISION_REGISTRY.md` podría consolidarse. | Pérdida de trazabilidad de decisiones. |
| Maintenance | Ninguna — es el invariante de salud. | Perdemos verificación determinista. |
| Skills | `/doubt-driven-development` y `/constraint-driven-development` son menos usados que TDD/review. | Pérdida de workflows específicos. |
| Exploration Engine | No eliminar — es la memoria de investigación. | Reinventar movimientos. |

**Conclusión:** la capa más segura para consolidar es el registro de decisiones, no una capa funcional.

### SI CENTRALIZAMOS UNA RESPONSABILIDAD

- **Política en PAC**: mayor simplificación. Reduce READY-01/02 a especificación YAML.
- **Decisiones en índice único**: menor fricción administrativa.
- **Enforcement en un solo hook**: riesgoso — bash-firewall y secret-guard cubren capas distintas (shell vs Write/Edit).

### SI TODO FUERA DERIVADO

`[CONTRAFACTUAL]`

Quedarían como raíz:
- Especificación de intención (reglas, planes).
- Trust boundary humano (Git + reviewer).
- Runtime de ejecución (hooks derivados).
- Evidencia (derivada de tests + reviews).

Esto es atractivo conceptualmente pero requiere un motor de derivación confiable. Hoy ese motor no existe para decisiones humanas.

### SI LA ARQUITECTURA ACTUAL FUERA INCORRECTA

`[CONTRAFACTUAL]`

La alternativa mínima sería:
- Evidence gate + human review como únicos mecanismos.
- Sin hooks P0 de firewall (o solo secret-guard).
- Sin fases; solo tareas con evidence.
- Sin registries separados; todo en Git.

Esta alternativa es más simple pero menos determinista y sin fail-closed en comandos.

### SI NO EXISTIERAN DECISIONES DEL OWNER

`[CONTRAFACTUAL]`

- Probablemente se habría implementado F9 y F10-F12.
- Se habrían añadido A-05/A-07/G-N5 sin requerimiento demostrado.
- PAC podría haberse promovido a producción sin validación de FP.
- El sistema sería más complejo pero no necesariamente más seguro.
- **Veredicto:** las decisiones del Owner evitaron over-engineering.

---

## 3. Evolution Analysis

### 3.1 ¿Qué ocurre cuando CCP crece?

| Dimensión de carga | Componente que falla primero | Por qué |
|---|---|---|
| Más políticas | `bash-firewall.sh` | Regex manual se vuelve inmanejable; drift política↔enforcement. |
| Más incidentes | `INCIDENT_REGISTRY.md` + proceso manual | Sin automatización, el RCA y control design no escalan. |
| Más proyectos | `install.sh` + context packs | Idempotencia y personalización por proyecto aumentan complejidad. |
| Más evidencia | `EVIDENCE_REGISTRY.md` | Append-only manual requiere más reviewer time. |
| Más agentes/subagentes | `subagent-context.sh` | Mantener context packs correctos por rol se complica. |
| Más datos de campo | `STALL_POLICY_LOG.jsonl` | Análisis manual no escala; requiere clasificación automática. |

### 3.2 Arquitecturas que escalan

| Tipo de escalabilidad | ¿Cómo escala CCP actual? | ¿Cómo escalaría con PAC? |
|---|---|---|
| Añadiendo piezas | Mal — cada política requiere editar 2 lugares. | Bien — añadir política YAML. |
| Añadiendo datos/config/especificación | Parcial — reglas Markdown no son data. | Bien — YAML es data. |
| Añadiendo solo políticas | Mal — requiere regex manual. | Bien — compiler genera patterns. |

### 3.3 ¿Qué requeriría rediseño?

- **Escalar más allá de ~50 políticas manuales:** requiere PAC o equivalente.
- **Más de un agente/modelo:** requiere abstraer hooks del payload específico de Claude Code.
- **Requerimiento de compliance/auditoría externa:** requiere A-05/A-07/G-N5.
- **Uso real con muchos stalls:** requiere clasificación automática y dashboard de observabilidad.

### 3.4 Capacidades imposibles bajo arquitectura actual

- **Auto-derivación completa de enforcement**: requiere motor de políticas.
- **Verificación nativa de Claude Code**: requiere ambiente/control que CCP no tiene.
- **Determinar materialidad de LABYRINTH-1**: requiere datos de campo.
- **Certificación formal sin humano**: requiere trust boundary técnico que F9-D04 rechazó.

### 3.5 Capacidades que surgirían naturalmente bajo arquitectura PAC

- Políticas como data.
- Tests de regresión generados automáticamente desde YAML.
- Métrica de cobertura política↔enforcement trivial.
- Rollback de políticas atómico.
- Auditoría de quién cambió qué política y cuándo.

---

## 4. Resumen de la fase 9

- **Desde cero se conservaría:** evidence gate, incident learning, Git+reviewer trust boundary, maintenance, fail-closed, context packs, reversibilidad.
- **Desde cero se eliminaría:** duplicación política/enforcement, fases post-F8 predefinidas, decisiones dispersas.
- **Contrafactual más instructivo:** sin F9-D01=A, CCP habría over-engineering; las decisiones del Owner fueron correctivas.
- **Componente que falla primero bajo carga:** `bash-firewall.sh` por acumulación de regex manual.
- **Arquitectura que mejor escala:** PAC (policy-as-data) para políticas; mantener evidence gate y human review.
- **Capacidad imposible actual:** auto-derivación completa, verificación nativa, datos H-01.

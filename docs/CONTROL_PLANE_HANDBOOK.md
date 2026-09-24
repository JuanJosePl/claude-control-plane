# Manual Operativo Del Claude Control Plane

Este documento explica el sistema completo desde la perspectiva de una persona que acaba de
instalarlo en un proyecto. El README resume el producto; este manual explica la mecanica interna,
el orden de uso, la razon de cada pieza y varios casos reales.

## Como Carga Claude El Contexto

Claude Code carga `CLAUDE.md` como bootstrap del proyecto. No lee automaticamente todos los
archivos de `docs/`; por eso el `CLAUDE.md` raiz solo contiene el mapa y el orden de lectura.

El orden recomendado es:

```text
CLAUDE.md
    ↓
MASTER_IMPLEMENTATION_PLAN.md
    ↓
PROJECT_STATE.md
    ↓
ARTIFACT_MANIFEST.md
    ↓
DESIGN.md + CONTROL_PLANE_HANDBOOK.md
    ↓
EVIDENCE_REGISTRY.md
    ↓
git status / git log
```

Durante el arranque de un subagente, `SubagentStart` inyecta los context packs correspondientes al
rol. El agente no debe inferir el estado desde una conversacion anterior ni confiar en el campo
`skills:` del frontmatter como mecanismo runtime.

## 1. La Idea En Una Frase

Claude Code puede escribir codigo, leer archivos, ejecutar comandos y coordinar subagentes. El
problema es que ninguna de esas capacidades demuestra por si sola que el trabajo este correcto.

Claude Control Plane agrega el sistema que decide:

```text
Que sabe el agente
Que puede hacer
En que fase esta
Que debe entregar
Como se verifica
Que evidencia queda
Si puede declarar DONE
Como se aprende de los fallos
```

La diferencia con una coleccion de prompts es el **enforcement**. Una instruccion dice "haz tests";
un gate puede bloquear el cierre si no existe evidencia de tests.

## 2. Que Problema Resuelve

Sin control plane, el flujo tipico es:

```text
Usuario pide feature
       ↓
Agente interpreta
       ↓
Agente escribe codigo
       ↓
Agente dice "listo"
```

Los fallos habituales son:

- el agente empieza a escribir antes de entender el contrato;
- la documentacion contradice el estado real;
- el mismo agente implementa y revisa su propio trabajo;
- los tests se agregan despues o se debilitan para obtener verde;
- un incidente se corrige una vez y vuelve a ocurrir;
- una compactacion de contexto pierde fase, bloqueadores o decisiones;
- `settings.json` invalido impide que Claude Code arranque;
- nadie puede demostrar por que un cambio fue aceptado.

Con el control plane, el flujo pasa a ser:

```text
INTENCION HUMANA
       ↓
AUDITORIA DEL ESTADO REAL
       ↓
CONTRATO / PLAN
       ↓
LANE SEGUN RIESGO
       ↓
EJECUCION
       ↓
CHECKS DETERMINISTAS
       ↓
REVIEW INDEPENDIENTE SI APLICA
       ↓
REGISTRO DE EVIDENCIA
       ↓
GATE
       ├── BLOCKED → corregir / recuperar / abrir incidente
       └── PASS    → cerrar fase / entregar / aprender
```

## 3. Que Se Crea Al Instalar

El comando:

```bash
bash install.sh /ruta/a/tu-proyecto
```

crea o completa estas areas:

```text
tu-proyecto/
├── CLAUDE.md
├── PROJECT_STATE.md
├── ARTIFACT_MANIFEST.md
├── DECISION_REGISTRY.md
├── INCIDENT_REGISTRY.md
├── CONTROL_REGISTRY.md
├── REGRESSION_REGISTRY.md
├── docs/00_SYSTEM/
│   ├── CLAUDE_SESSION_LOG.md
│   └── EVIDENCE_REGISTRY.md
└── .claude/
    ├── agents/
    ├── context/
    ├── hooks/
    ├── rules/
    ├── skills/
    └── settings.json
```

El instalador:

1. pide nombre y stack del proyecto;
2. crea directorios `.claude`, `docs/00_SYSTEM` y `evals/incidents`;
3. copia hooks y les asigna permisos ejecutables;
4. copia skills de contexto y de proceso;
5. copia agentes y rules;
6. valida la fuente `settings.json` con `jq`;
7. reserializa `settings.json` para eliminar comentarios invalidos;
8. copia templates raiz solo si no existen;
9. instala el registry canonico de evidencia;
10. crea el session log.

No reemplaza el codigo de negocio. No decide tu stack. No llena automaticamente los placeholders
del proyecto salvo el nombre basico.

## 4. Que Es Imprescindible Y Que Es Opcional

### Imprescindible

| Pieza | Por que es imprescindible |
|---|---|
| `.claude/settings.json` | Conecta permisos y hooks con Claude Code |
| `bash-firewall.sh` | Bloquea comandos destructivos o exfiltracion |
| `secret-guard.sh` | Impide escribir secretos mediante Write/Edit |
| `task-completed-evidence.sh` | Impide cerrar tareas sin evidencia |
| `PROJECT_STATE.md` | Fuente unica de fase, objetivo y bloqueadores |
| `EVIDENCE_REGISTRY.md` | Prueba que un cambio fue verificado |
| `/doctor` | Detecta configuracion incompleta |
| `evals/maintenance.sh` | Comprueba que el propio control plane no se rompio |

### Recomendado

| Pieza | Cuando aporta valor |
|---|---|
| TDD | Features y cambios de comportamiento |
| Code review | Cambios medium/high risk |
| Doubt-driven | Claims fuertes o decisiones irreversibles |
| Constraint-driven | Seguridad, migraciones, permisos o anti-gaming |
| `/incident` | Fallos repetidos o bypasses de controles |
| `code-reviewer` | Cuando el implementer no debe revisarse a si mismo |
| `ARTIFACT_MANIFEST.md` | Proyectos organizados por fases |

### Opcional O Fuera Del Alcance Inicial

- Agent Teams como dependencia del core;
- cross-provider fallback;
- dashboards;
- plugins completos;
- mutation testing global;
- hooks nuevos sin riesgo concreto demostrado.

## 5. Las Capas Del Sistema

### 5.1 Context Layer

Responde: **que debe saber Claude antes de trabajar?**

#### `CLAUDE.md`

Instrucciones permanentes y cortas del proyecto. Debe contener invariantes, limites, convenciones y
el modo de usar el control plane. No debe convertirse en un manual enorme.

#### `.claude/context/CORE.md`

Identidad tecnica: stack elegido, modulos, convenciones y fuentes de verdad.

#### `.claude/context/CURRENT_STATE.md`

Mirror compacto de `PROJECT_STATE.md`. No es una segunda fuente de estado. Si diverge, manda
`PROJECT_STATE.md`.

#### `.claude/context/DECISIONS.md`

Resumen de decisiones activas. El detalle completo vive en `DECISION_REGISTRY.md`.

#### `.claude/context/SECURITY_RULES.md`

Restricciones de seguridad: secretos, auth, inputs, tenant isolation, webhooks y compliance.

#### `.claude/context/BUSINESS.md`

Prioridades comerciales y restricciones de negocio. Principalmente util para researcher y architect.

#### `.claude/context/NO_GO.md`

Anti-patrones que no deben repetirse. No reemplaza un hook de enforcement.

### 5.2 State Layer

Responde: **en que punto operativo esta el proyecto?**

#### `PROJECT_STATE.md`

Es la fuente unica del estado operativo. Campos importantes:

```text
CURRENT_PHASE
PHASE_STATUS
CURRENT_OBJECTIVE
BLOCKERS
ACTIVE_DECISIONS
PENDING_DECISIONS
LAST_GIT_CHECKPOINT
NEXT_ALLOWED_PHASE
IMPLEMENTATION_READY
```

No dupliques estos valores en `CLAUDE.md`, memory o un segundo archivo de estado.

#### `ARTIFACT_MANIFEST.md`

Define que debe existir para cerrar cada fase. Un artefacto faltante mantiene la fase bloqueada.

#### `DECISION_REGISTRY.md`

Registra decisiones con ID, estado, evidencia, riesgos y reversibilidad. Sirve para evitar que el
agente vuelva a debatir una decision ya aprobada o revierta algo sin saberlo.

### 5.3 Evidence Layer

Responde: **que puedo demostrar?**

La unica ruta canonica es:

```text
docs/00_SYSTEM/EVIDENCE_REGISTRY.md
```

Una entrada de evidencia debe vincular:

```text
task_id
claim
source
provenance
artifact_hash
contract_hash
checks
reviewer
exceptions
timestamp
```

`Provenance` distingue si algo fue `EXTRACTED`, `INFERRED`, `ASSUMED`, `EXTERNAL` o `GENERATED`.

### 5.4 Control Layer

Responde: **que puede bloquear el sistema aunque el agente insista?**

Su centro es:

```text
.claude/settings.json
.claude/hooks/
```

Las reglas Markdown orientan. Los hooks y permisos hacen enforcement real.

### 5.5 Execution Layer

Responde: **quien ejecuta y con que procedimiento?**

Contiene agentes con limites de herramientas y skills de workflow. El agente no debe inventar su
propio proceso para cada tarea.

### 5.6 Verification Layer

Responde: **como se decide PASS o BLOCKED?**

Incluye:

- `/gate` para fases;
- `TaskCompleted` para tareas;
- checks deterministas;
- reviewer independiente;
- security auditor;
- regresiones;
- `evals/maintenance.sh` para el harness.

## 6. Cada Hook Explicado

Todos los hooks reciben un payload JSON por stdin. Los hooks que bloquean deben salir con codigo `2`.

### `SessionStart` — startup, resume, fork

Archivo:

```text
.claude/hooks/session-start-startup.sh
```

Cuando comienza o se reanuda una sesion:

1. lee `PROJECT_STATE.md`;
2. obtiene la rama git;
3. extrae fase, status, objetivo, blockers y checkpoint;
4. inyecta ese contexto al agente.

No bloquea. Es recuperacion de contexto.

### `SessionStart` — compact, clear

Archivo:

```text
.claude/hooks/session-start-compact.sh
```

Despues de compactar contexto:

1. recupera estado operativo;
2. recupera decisiones activas;
3. muestra las ultimas entradas de sesion;
4. compara el hash critico de estado;
5. informa `STATE_INTEGRITY: PASS` o `DRIFT_DETECTED`.

No debe ocultar drift. Si no puede verificar, informa `UNKNOWN`.

### `PreToolUse` sobre `Bash`

Archivo:

```text
.claude/hooks/bash-firewall.sh
```

Es fail-closed. Bloquea, entre otros:

- `rm -rf` destructivo;
- `mkfs`, `dd` sobre dispositivos;
- `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`;
- secretos en argumentos;
- lectura de `.env`, `.pem`, `.key`, `.pfx`;
- `git add` de secretos;
- patrones `curl | bash`.

Si `jq` no esta disponible, bloquea porque no puede analizar el comando.

### `PreToolUse` sobre `Write|Edit`

Archivo:

```text
.claude/hooks/secret-guard.sh
```

Es fail-closed. Examina el contenido que se va a escribir y bloquea:

- claves privadas;
- API keys;
- Bearer tokens;
- AWS access keys;
- JWT;
- asignaciones de secretos con valores reales.

Permite placeholders obvios como `CHANGE_ME`, `example` o `<your-...>` salvo que tambien exista
una clave privada real.

### `SubagentStart`

Archivo:

```text
.claude/hooks/subagent-context.sh
```

Antes de que arranque un subagente:

1. identifica el `agent_type`;
2. lee estado dinamico de `PROJECT_STATE.md`;
3. carga context packs segun el rol;
4. inyecta todo mediante `additionalContext`.

Mapeo actual:

| Agente | Packs |
|---|---|
| `researcher` | CORE, BUSINESS, DECISIONS |
| `architect` | CORE, CURRENT_STATE, DECISIONS, SECURITY_RULES |
| `implementer` | CORE, CURRENT_STATE, SECURITY_RULES |
| `security-auditor` | CORE, SECURITY_RULES, DECISIONS |
| `code-reviewer` | CORE, CURRENT_STATE, SECURITY_RULES, DECISIONS |

Esto evita depender de `skills:` en el frontmatter del agente, porque ese mecanismo no tenia contrato
runtime verificado.

### `SubagentStop`

Archivo:

```text
.claude/hooks/subagent-stop-logger.sh
```

Registra que un subagente termino, su tipo, ID y resumen. Es observabilidad; no valida calidad.

### `Stop`

Archivo:

```text
.claude/hooks/stop-logger.sh
```

Registra el final de la sesion y recuerda actualizar `PROJECT_STATE.md` si no se modifico durante el
dia. Es fail-open y no bloquea.

### `PreCompact`

Archivo:

```text
.claude/hooks/pre-compact-snapshot.sh
```

Antes de compactar:

1. copia `PROJECT_STATE.md` a `.claude/backups/PROJECT_STATE.precompact.md`;
2. extrae campos criticos;
3. calcula hash SHA-256;
4. guarda `.claude/backups/PROJECT_STATE.critical.sha256`;
5. inyecta el snapshot como contexto preservado.

### `ConfigChange`

Archivo:

```text
.claude/hooks/config-change-logger.sh
```

Registra cambios de configuracion en `CLAUDE_SESSION_LOG.md`. Es fail-open. No aprueba por si solo
un cambio sensible.

### `TaskCompleted`

Archivo:

```text
.claude/hooks/task-completed-evidence.sh
```

Es el gate P0 de cierre. Comprueba:

1. existe `jq`;
2. existe el registry canonico;
3. el payload es JSON valido;
4. existe `task_id`;
5. el riesgo es valido;
6. existe una entrada VERIFIED para esa tarea;
7. existen hashes SHA-256 no vacios;
8. tests, static y security tienen resultado valido;
9. reviewer es PASS para riesgo medio/alto/critico;
10. exceptions son `NONE` o `APPROVED`;
11. existe timestamp.

Si falla cualquier punto, devuelve `exit 2` y bloquea la finalizacion.

## 7. `settings.json` Explicado

### `permissions.allow`

Permisos base permitidos sin preguntar:

```json
"Bash(git *)"
"Read(*)"
"Glob(*)"
"Grep(*)"
"Bash(jq *)"
```

La lista debe adaptarse al stack del proyecto. No agregues comandos amplios solo para evitar una
pregunta.

### `permissions.ask`

Acciones que requieren confirmacion:

```json
"Bash(git push*)"
"Bash(rm *)"
```

Esto separa trabajar localmente de publicar o borrar.

### `permissions.deny`

Archivos que nunca deben leerse mediante el control plane:

```text
.env
.env.*
secrets/**
*.pem
*.key
*.pfx
~/.ssh/**
~/.aws/credentials
```

`deny` es mas fuerte que una instruccion Markdown.

### `hooks`

Cada evento debe apuntar a un script que exista y tenga permisos ejecutables. Si cambias el nombre de
un hook, debes actualizar ambos lados:

```text
.claude/settings.json
.claude/hooks/
```

`evals/maintenance.sh` comprueba ese wiring.

## 8. Agentes Y Limites De Herramientas

### `researcher`

Investiga web y tecnologia. No escribe archivos ni ejecuta Bash. Entrega hallazgos con fuentes.

### `architect`

Disena modulos, APIs, esquemas y flujos. Escribe documentacion, no ejecuta shell.

### `implementer`

Implementa codigo y ejecuta checks. Pasa por firewall y secret guard.

### `security-auditor`

Solo lectura. Busca vulnerabilidades y no implementa fixes.

### `code-reviewer`

Solo lectura y contexto fresco. Recibe contrato, artifact y checks, pero no el razonamiento del
implementer. No puede escribir ni ejecutar comandos.

La separacion existe para evitar que una misma persona produzca el cambio y firme su propia revision.

## 9. Skills Y Cuando Usarlas

### `/test-driven-development`

Para comportamiento nuevo o bugfix:

```text
CONTRATO → TEST RED → IMPLEMENTACION → GREEN → REGRESION → EVIDENCIA
```

No hace falta para un cambio puramente documental.

### `/code-review-and-quality`

Revisa correccion, regresiones, seguridad, complejidad y mantenibilidad. Usa severidades:
`BLOCKER`, `HIGH`, `MEDIUM`, `LOW`, `NOTE`.

### `/doubt-driven-development`

Para decisiones no triviales:

```text
CLAIM → EXTRACT → DOUBT → RECONCILE → STOP
```

El reviewer no recibe el razonamiento del implementer.

### `/constraint-driven-development`

Define `MUST`, `MUST NOT`, `MAY` y `DEFERRED`. Busca bypasses como `skip`, `ignore`, assertions
eliminadas, thresholds reducidos o guards removidos.

### `/incident`

Convierte un fallo en control y regresion. No se cierra un P0/P1 sin enlaces a ambos registros.

### Skills operativas existentes

| Skill | Funcion |
|---|---|
| `/doctor` | Diagnostico de salud |
| `/estado` | Estado actual, bloqueadores y fase |
| `/gate` | Comprueba salida de fase |
| `/cerrar-fase` | Cierra fase y actualiza registros |
| `/checkpoint` | Crea checkpoint git |
| `/evidence` | Registra evidencia |
| `/adr` | Registra decision arquitectonica |
| `/no-go` | Comprueba anti-patrones |
| `/audit-config` | Audita settings y wiring |
| `/audit-context` | Detecta divergencia entre fuentes |
| `/recovery` | Recupera errores conocidos |

## 10. Como Se Planea Antes De Ejecutar

El control plane no esta pensado para saltar directamente a codigo. El orden correcto es:

### Paso 1 — Auditar

Antes de modificar:

```text
git status
git log
PROJECT_STATE.md
ARTIFACT_MANIFEST.md
DECISION_REGISTRY.md
```

Y despues inspeccionar los archivos reales. La documentacion no prueba que algo exista.

### Paso 2 — Clasificar La Tarea

| Tipo | Ejemplo | Lane minima |
|---|---|---|
| Micro | typo, docs simple | check determinista |
| Normal | feature pequena | TDD + checks |
| Alto riesgo | auth, pagos, permisos | TDD + review + security |
| Irreversible | migracion destructiva, cambio de boundary | todo lo anterior + humano |
| Incidente | regresion o bypass | `/incident` |

### Paso 3 — Crear Contrato

Definir:

- objetivo;
- fuera de alcance;
- archivos esperados;
- dependencias;
- checks requeridos;
- criterio de PASS;
- criterio de BLOCKED;
- rollback.

### Paso 4 — Planear Fases

Para un cambio grande, el plan debe indicar:

```text
Fase
Objetivo
Entradas
Archivos afectados
Dependencias
Checks
Evidencia
Rollback
Gate
```

No se debe ejecutar F2 antes de cerrar F1. `PROJECT_STATE.md` y `ARTIFACT_MANIFEST.md` hacen
visible ese orden.

### Paso 5 — Ejecutar

Solo despues de que el contrato existe se ejecuta el cambio. Si aparece un problema fuera de alcance:

1. no se implementa automaticamente;
2. se registra como hallazgo;
3. se determina si bloquea;
4. se continua solo si el objetivo actual sigue siendo verificable.

### Paso 6 — Verificar Y Registrar

La explicacion del agente no es evidencia. Hay que ejecutar los checks, registrar hashes y actualizar
los registros canonicos antes de cerrar.

## 11. Casos De Uso

### Caso A — Crear Un Proyecto Nuevo

```bash
bash install.sh /home/usuario/proyecto
cd /home/usuario/proyecto
```

Luego:

1. `/doctor`;
2. completar `CORE.md`, `BUSINESS.md`, `SECURITY_RULES.md` y `NO_GO.md`;
3. definir stack y fuentes de verdad;
4. revisar `settings.json`;
5. crear fase inicial en `PROJECT_STATE.md`;
6. ejecutar el trabajo con la lane correspondiente.

No conviene empezar por instalar todas las skills del mundo. Primero configura identidad, estado,
seguridad y contrato de cierre.

### Caso B — Cambio Pequeno De Documentacion

Ejemplo: corregir una seccion del README.

1. Auditar que no cambie comportamiento.
2. Editar.
3. Ejecutar `git diff --check`.
4. No necesitas crear un reviewer ni un workflow TDD completo.
5. Registrar evidencia si el cambio pertenece a una fase activa.

El control plane no debe convertir un typo en una ceremonia de diez agentes.

### Caso C — Feature Normal

Ejemplo: agregar un endpoint de preferencias.

1. Crear contrato de entrada, salida, errores y autorizacion.
2. Usar `/test-driven-development`.
3. Crear test RED.
4. Implementar minimo.
5. Ejecutar GREEN y suite relacionada.
6. Usar `/code-review-and-quality` si el riesgo es medium.
7. Registrar evidencia con hashes.
8. Completar la tarea solo cuando `TaskCompleted` acepte.

### Caso D — Cambio De Auth O Permisos

Ejemplo: cambiar login, roles, permisos o acceso tenant.

1. Clasificar como high/critical.
2. Leer `SECURITY_RULES.md` y rules.
3. Definir constraints no negociables.
4. TDD para casos autorizados y no autorizados.
5. Ejecutar `code-reviewer` en contexto fresco.
6. Ejecutar `security-auditor`.
7. Requerir reviewer PASS y, si es irreversible, aprobacion humana.
8. Registrar excepciones explicitamente.

### Caso E — Bug De Produccion

Ejemplo: un bug permite cerrar un checkout sin evidencia o rompe un flujo.

1. Abrir `/incident open`.
2. Congelar logs y reproducer.
3. Aplicar 5 Whys.
4. Clasificar el control ausente.
5. Escribir regresion que falle sin control.
6. Implementar control minimo.
7. Verificar que la regresion pasa con control.
8. Registrar `INC`, `CTRL`, `REG` y `EV`.
9. Cerrar solo con review y rollback.

### Caso F — Compactacion De Contexto

Antes de compactar, `PreCompact` guarda snapshot y hash. Al reanudar:

1. `SessionStart compact` recupera estado;
2. compara hash critico;
3. informa PASS o DRIFT_DETECTED;
4. si hay drift, se detiene el trabajo y se audita `PROJECT_STATE.md`.

Nunca se debe continuar con un estado probablemente alterado sin registrar `UNKNOWN` o `BLOCKED`.

### Caso G — Varios Agentes

Ejemplo: arquitectura + implementacion + review.

```text
architect       → contrato y diseño
implementer     → codigo y tests
code-reviewer   → revision fresca
security-auditor→ seguridad cuando aplica
main agent      → reconcilia evidencia y ejecuta el gate
```

Los agentes no deben invocarse entre si libremente. El agente principal coordina y conserva el
contrato.

### Caso H — Instalar En Un Proyecto Existente

El instalador no debe destruir archivos existentes:

- templates raiz se copian solo si no existen;
- `settings.json` si existe se reemplaza por el control plane instalado, por lo que debes hacer
  backup si ya tienes configuracion propia;
- `.claude/context` y `.claude/skills` deben revisarse despues de instalar;
- ejecuta `/doctor` antes de usar el proyecto.

## 12. Que Hacer Cuando Algo Se Bloquea

### `TaskCompleted` bloquea

No desactives el hook. Revisa:

```text
docs/00_SYSTEM/EVIDENCE_REGISTRY.md
task_id
Status
Artifact Hash
Contract Hash
Checks
Reviewer
Exceptions
Timestamp
```

#### ARCH-004 — TASK TRACKING SEMANTICS

El hook `TaskCompleted` puede dispararse para cualquier `TaskUpdate → completed`, incluidas
subtareas internas del tracker. ARCH-004 establece la distincion operativa antes de cerrar una
tarea:

```text
USER INTENT
    ↓
CONTRACTUAL TASK          ← unica que debe pasar por Evidence Gate
    ↓
INTERNAL TODO / CHECKLIST ← scaffolding; no requiere EV-NNN individual
    ↓
SUBTASK                   ← hereda la evidencia de su CONTRACTUAL TASK
    ↓
ARTIFACT
    ↓
EVIDENCE
    ↓
GATE
```

Una `RESEARCH NOTE` es una salida de investigacion que se registra en documentacion y no pasa por
el gate. Solo una CONTRACTUAL TASK obtiene evidencia `VERIFIED` y un `task_id` con la convencion
`<fase>-<slug>-YYYY-MM-DD-<hash>`. Los TODOs internos y SUBTASKs se marcan como `deleted`, no como
`completed`, cuando el contrato que los contiene se cierra. El payload puede incluir `contract_hash`;
si lo incluye, debe coincidir con el registro VERIFIED. Durante F7 la ausencia se permite con un
warning transicional para no romper payloads existentes; la siguiente fase debe hacerla fail-closed.

La decision completa vive en `DECISION_REGISTRY.md` como ARCH-004.

#### Reviewer identity convention (A-06 / F8)

Cuando una revision se registra en documentacion o notas de cierre, usa la identidad explicita:

- `Reviewer: PASS (code-reviewer@fresh-context)` para una revision de subagente en contexto fresco.
- `Reviewer: PASS (human/@owner)` para una aprobacion humana explicita.
- `Reviewer: NOT_REQUIRED` cuando la politica documentada de bajo riesgo permite omitir reviewer.

Esta es una convencion documental solamente. No agrega campos de schema, enforcement runtime ni
afirma verificacion nativa de Claude Code.

Desde F8-A, una tarea contractual sin `contract_hash` es bloqueada con `exit 2`; la ausencia ya no
usa el warning transicional de F7.

### `/doctor` falla

Ejecuta:

```text
/doctor
/audit-config
/audit-context
```

Cada fallo debe terminar en `WARNING`, `ERROR` o `BLOCKED`, nunca en `probably fine`.

### Hay drift de estado

1. no avances de fase;
2. compara `PROJECT_STATE.md` con `CURRENT_STATE.md`;
3. revisa el snapshot en `.claude/backups/`;
4. identifica el ultimo checkpoint;
5. registra el incidente si el drift tuvo impacto.

### Un secreto fue detectado

No conviertas el valor en placeholder para forzar el check. Elimina el secreto, rota la credencial si
fue expuesta y mueve el valor a variables de entorno.

### El control plane deja de arrancar

Primero valida:

```bash
jq empty .claude/settings.json
bash -n .claude/hooks/*.sh
```

Si hace falta rollback, conserva primero el estado actual y utiliza el checkpoint registrado. No
restaures configuracion global sin backup.

### Un hook P0 bloquea con STALL_POLICY o UNKNOWN

Este es el procedimiento canónico de escalamiento cuando un agente queda bloqueado y no puede
continuar autónomamente. Aplica a cualquier bloqueo con código `STALL_POLICY`, `UNKNOWN`, o
`BLOCKED` emitido por un hook P0.

**Cuándo aplica**

```text
TRIGGER:   Un hook P0 (bash-firewall, task-completed-evidence) emite exit 2 con:
           - reason_code = STALL_POLICY   (alternativa propuesta bloqueada)
           - reason_code = UNKNOWN        (el agente no puede clasificar la acción)
           - reason_code = BLOCKED        (condición de bloqueo explícita)
           - Cualquier bloqueo donde la acción correcta no está definida por la política
```

**Qué hace el agente**

```text
1. HALT    — detener la tarea actual; no reintentar la acción bloqueada.
2. LOG     — el evento queda registrado en STALL_POLICY_LOG automáticamente (R-2 operacional).
3. INFORM  — reportar al humano: qué fue bloqueado, por qué razón, qué política aplica.
4. WAIT    — aguardar confirmación explícita del humano antes de reanudar.
```

**Qué NO hace el agente**

```text
PROHIBIDO:
  - Reintentar la misma acción con formulación diferente (bypass semántico).
  - Marcar la tarea como completada mientras persiste el bloqueo.
  - Asumir que el bloqueo es un falso positivo sin confirmación humana.
  - Continuar con subtareas que dependen de la acción bloqueada.
```

**Qué incluye el reporte al humano**

```text
  - Acción bloqueada: comando o evento exacto que disparó el hook.
  - Razón: código de bloqueo + política aplicada.
  - Alternativa considerada (si existe): qué intentó el agente y por qué fue clasificada UNKNOWN.
  - Referencia: archivo de política relevante (.claude/rules/, DECISION_REGISTRY.md, etc.).
```

**Proceso de resolución humana**

```text
1. Revisar la acción bloqueada contra la política citada en el bloqueo.
2. Consultar DECISION_REGISTRY.md para contexto arquitectónico.
3. Consultar docs/00_SYSTEM/F9_OWNER_DECISIONS.md para decisiones del owner que apliquen.
4. Decidir:
     A. La acción es conforme → autorizar explícitamente y el agente reanuda.
     B. La acción está correctamente bloqueada → redirigir al agente con alternativa.
     C. La política es ambigua para este caso → escalar al project owner para decisión.
```

**Escalamiento al project owner**

```text
CUÁNDO:  La revisión humana no produce una decisión clara en el paso 4C.
QUIÉN:   Project owner (juanjosepolo.dev@gmail.com).
QUÉ INCLUYE:
  - Descripción del bloqueo (tarea, acción, hook, razón).
  - La política citada y por qué produce ambigüedad.
  - La alternativa considerada y por qué fue clasificada UNKNOWN.
  - Impacto de no resolver: qué progreso queda bloqueado.
```

**Qué cierra el escalamiento**

```text
  - Una decisión explícita del humano (autorizar o prohibir la acción).
  - Una actualización de política que elimine la ambigüedad (requiere autorización separada).
  - Una redirección del agente con un camino alternativo que no requiere la acción bloqueada.
```

**Evidencia registrada**

```text
  - STALL_POLICY_LOG: entrada automática por R-2 (bash-firewall).
  - SESSION_LOG: entrada manual si el bloqueo requirió decisión humana o cambio de rumbo.
  - Si genera incidente: INCIDENT_REGISTRY.md con RCA y resolución.
```

### Estándar de Calidad para Revisión Humana (HRQS — Human Review Quality Standard)

Cuando un humano revisa un bloqueo STALL_POLICY, esta checklist asegura que la decisión de
revisión sea reproducible, documentada y útil para el sistema de aprendizaje.

**Objetivo del HRQS**

```text
Transformar "este comando fue bloqueado" en "se determinó si fue TP o FP, por qué, y qué clase es".
```

**Checklist HRQS — Revisión de Bloqueo**

```text
[ ] 1. IDENTIFICAR: ¿Qué comando/acción fue bloqueada exactamente?
        → Copiar el comando literal desde el reporte del agente o STALL_POLICY_LOG.

[ ] 2. POLÍTICA: ¿Qué política/patrón disparó el bloqueo?
        → El hook debería indicarlo en su mensaje de salida.
        → Si no indica la política, marcar como "MENSAJE_INSUFICIENTE" y ver READY-04.

[ ] 3. CLASIFICAR CLASE DE BLOQUEO:
        TP  — Verdadero Positivo: el comando es peligroso y fue correctamente bloqueado.
        FP  — Falso Positivo: el comando es legítimo y el bloqueo fue un error.
        UNKNOWN — No hay suficiente contexto para decidir.

[ ] 4. SI FP — IDENTIFICAR CLASE DE FALSO POSITIVO:
        FP-PATTERN_NAME_IN_LITERAL (PAC-EF-02):
          El comando referencia el NOMBRE de un patrón peligroso como identificador literal,
          no como la acción peligrosa. Ejemplos:
            - git commit -m "fix: bypass for testing" → la palabra 'bypass' en el mensaje
            - git commit -m "add rm-rf safeguard" → 'rm -rf' en un comentario o mensaje
            - Variable o string que contiene el nombre de un comando bloqueado
          Diagnóstico: ¿El patrón peligroso ESTÁ en el comando o solo NOMBRA al patrón?
        
        FP-BENIGN_VARIANT:
          El comando tiene la forma sintáctica del patrón pero no el efecto peligroso.
          Ejemplo: 'chmod 755 ./script.sh' (no chmod 777 de archivos del sistema)
        
        FP-CONTEXT_MISSING:
          El contexto del comando cambia su clasificación pero el hook no lo puede ver.

[ ] 5. REGISTRAR DECISIÓN:
        TP → Confirmar bloqueo. Redirigir agente con alternativa.
        FP → Autorizar acción explícitamente. Si FP-PATTERN_NAME_IN_LITERAL → agregar
             nota en STALL_POLICY_LOG con clase identificada.
        UNKNOWN → Escalar al project owner (ver procedimiento de escalamiento arriba).

[ ] 6. H-01 REGISTRO (si had_alternative = true en el log):
        Este evento cuenta para el umbral N del parámetro H-01.
        N = 1 es suficiente para abrir investigación de materialidad de LABYRINTH-1.
        Documentar: ¿El agente tenía una alternativa viable? ¿Cuál era?
```

**Cuándo un bloqueo es "de alta calidad" para el sistema**

```text
ALTA CALIDAD:
  - Clase TP/FP identificada (no solo "decidí autorizar")
  - Para FP: clase específica documentada (PAC-EF-02, FP-BENIGN_VARIANT, etc.)
  - had_alternative registrado (sí/no + descripción si sí)
  - Decisión tomada en el momento (no semanas después)

BAJA CALIDAD (no aprende el sistema):
  - "Autorizo esta vez" sin clasificación
  - Decisión no documentada en SESSION_LOG ni STALL_POLICY_LOG
  - Asumir que el bloqueo es FP sin verificar la política
```

**Umbrales de escalamiento**

```text
Escalar al owner si:
  - 3+ eventos UNKNOWN en la misma semana (política potencialmente ambigua)
  - 2+ eventos PAC-EF-02 del mismo patrón (patrón potencialmente demasiado amplio)
  - 1 evento TP genuino que los controles actuales no debían cubrir (nuevo riesgo)
```

**Clases de FP conocidas (registro vivo — actualizar cuando se descubran nuevas)**

| Clase | ID | Descripción | Primera aparición |
|---|---|---|---|
| Pattern Name In Literal | PAC-EF-02 | El nombre del patrón aparece como literal en un comando legítimo | M007 (2026-09-23) |

## 13. Como Personalizarlo Sin Romperlo

### Puedes personalizar

- reglas del dominio;
- context packs del proyecto;
- allow-list segun stack;
- agents y skills de dominio;
- fases del `ARTIFACT_MANIFEST`;
- criterios de riesgo;
- comandos de mantenimiento.

### No debes cambiar silenciosamente

- la ruta canonica de evidencia;
- la fuente unica de estado;
- el significado de `VERIFIED`;
- el comportamiento fail-closed de hooks P0;
- los permisos `deny` de secretos;
- los limites del reviewer independiente;
- un gate de fase sin actualizar el Master Plan.

Si quieres cambiar cualquiera de esas piezas:

1. actualiza el contrato en `docs/MASTER_IMPLEMENTATION_PLAN.md`;
2. registra una decision en `DECISION_REGISTRY.md`;
3. agrega o actualiza un test;
4. registra evidencia;
5. ejecuta `evals/maintenance.sh`.

## 14. Rollback Y Blast Radius

Antes de modificar algo, pregunta:

```text
Que alcance tiene?
Que rompe si falla?
Como lo revierto?
Que evidencia demuestra que volvi al estado anterior?
```

| Cambio | Blast radius | Rollback |
|---|---|---|
| Skill o context pack | Proyecto | Restaurar archivo desde git |
| Hook P0 | Proyecto y todas sus tareas | Restaurar hook + settings y ejecutar smoke tests |
| `settings.json` de proyecto | Todas las sesiones del proyecto | Restaurar version valida y ejecutar `jq empty` |
| `~/.claude/settings.json` | Todos los proyectos del usuario | Backup manual previo obligatorio |
| Registry de estado | Fases y gates | Restaurar con evidencia del checkpoint |

No modificar `~/.claude/*` como parte de una instalacion de proyecto sin un backup explicito.

## 15. Mantenimiento Recomendado

Antes de cada cambio al control plane:

```bash
git status
git log --oneline -5
evals/maintenance.sh
```

Despues de cada cambio:

```bash
git diff --check
git status
```

El CI ejecuta la misma suite mediante:

```text
.github/workflows/control-plane.yml
```

La suite cubre:

- schema de settings;
- salida del instalador;
- sintaxis de hooks;
- estructura y fixtures de skills;
- regresion de incidentes;
- hash y drift de estado;
- provenance y hashes de evidencia;
- referencias obsoletas;
- regression budget;
- freshness y unicidad de resultados Tier 3;
- fixtures positivos de firewall y secret-guard;
- regresiones F7 de Stop, firewall, TaskCompleted, rotacion e instalacion.

F7 Extended agrega tres comprobaciones visibles al resultado de mantenimiento:
`evidence_freshness=PASS`, `firewall_positive=PASS` y `secret_guard_positive=PASS`, por lo que la
salida esperada actual es 12/12. Los fixtures adicionales se ejecutan dentro de sus suites
correspondientes aunque no agregan nuevos hooks ni nuevos registries.

La verificacion local distingue `SCRIPT VERIFIED` de `CLAUDE RUNTIME VERIFIED`. En OpenCode solo
se ejecutan scripts, fixtures y mantenimiento; la ejecucion nativa de los eventos Claude Code es
`NOT_VERIFIED`.

Rollback por bundle: `git revert <bundle-commit>`, volver a ejecutar `bash evals/maintenance.sh` y
confirmar que EV-001 a EV-008 e INC-001/CTRL-001/REG-001 permanecen intactos. No se ejecuta rollback
destructivo durante el cierre normal.

## 16. Resumen Mental

Cuando no sepas que hacer, sigue esta secuencia:

```text
1. AUDITAR
2. DEFINIR CONTRATO
3. CLASIFICAR RIESGO
4. PLANEAR
5. EJECUTAR
6. TESTEAR
7. REVISAR
8. REGISTRAR EVIDENCIA
9. EJECUTAR GATE
10. CERRAR O RECUPERAR
```

No agregues una feature, hook, skill o agente solo porque parece util. Primero demuestra que existe
un riesgo, define el control, prueba el control y registra el resultado.

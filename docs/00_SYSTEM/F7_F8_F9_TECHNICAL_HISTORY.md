# Claude Control Plane - Dossier de Historia Técnica y Arquitectura

## F7 -> F8 -> F9

*Reconstrucción factual de la implementación, verificación, investigación, arquitectura, decisiones y estado actual.*

---

## 1. Propósito Y Metadatos

Este dossier es una referencia técnica única para un ingeniero o auditor que
no haya visto las sesiones anteriores. Reconstruye el estado del repositorio,
la cronología de Git, la arquitectura, los cambios, la evidencia, la
verificación, las decisiones, las limitaciones y los límites de fase desde F7
hasta F9.

| Campo | Valor |
|---|---|
| Generado por | `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX_OPENCODE` |
| Timestamp de generación | `2026-09-19T18:07:11-05:00` |
| Repositorio | `claude-control-plane` |
| Rama | `main` |
| Línea base histórica de reconstrucción | Checkpoint F7 `47874a5` |
| Línea base de cierre F8 | `2cd795321486a30240197ac12a0bf51564ffba66` |
| HEAD actual | `bfe03b7ddd9906b4dca6acfa1ee24907cf14ba14` |
| Alcance | F7 hasta F9 |
| Estado | Documentación de referencia |
| Implementación realizada por esta tarea | NO |
| Cambios de runtime realizados por esta tarea | NO |

El HEAD actual corresponde a un commit documental de F9. El documento de
investigación F9 y el handoff de sesión ya estaban presentes en ese HEAD; este
dossier no reemplaza ninguno de ellos ni los modifica.

### Cronología del dossier respecto de F9

El commit de investigación F9 es `bfe03b7` y contiene únicamente
`docs/00_SYSTEM/F9_RESEARCH.md` y `docs/00_SYSTEM/SESSION_HANDOFF_CURRENT.md`.
Este dossier se agregó después, en el commit `9a52875`, como documentación
suplementaria de referencia. No forma parte del contrato de cambio de la
investigación F9, no autoriza implementación F9 ni F10, no modifica runtime y
no reescribe evidencia histórica. Cualquier reconciliación documental
posterior (por ejemplo, la actualización de metadatos de `PROJECT_STATE.md` o
del handoff) queda registrada en su propio commit documental y no altera esta
distinción.

### Regla de autoridad y reconstrucción

La reconstrucción usa la siguiente precedencia:

1. Contenido real del repositorio.
2. Historial y diffs reales de Git.
3. Salidas reproducibles de comandos registradas en artefactos del repositorio
   o de la sesión.
4. Documentos y registros canónicos del proyecto.
5. Informes y auditorías de F7.
6. Documentos de investigación, implementación y auditoría de F8.
7. Documento de investigación F9.
8. Handoffs de sesión.
9. Prompts y material histórico anterior.

Cuando un handoff o informe difiere de Git o de una fuente canónica, este
dossier registra la diferencia en lugar de normalizarla silenciosamente.

---

## 2. Resumen Ejecutivo

### F7: endurecimiento conductual y de integridad de evidencia

F7 partió de un control plane F1-F6 completo y de una auditoría adversarial que
encontró gaps conductuales reales. Se convirtió en una fase de implementación
extendida, en lugar de limitarse a la propuesta inicial de freshness, porque la
auditoría reprodujo un loop de Stop, varias familias de bypass del firewall, un
false-PASS de evidencia, problemas de rotación de logs y sobrescritura del
instalador.

F7 endureció hooks, fixtures y checks de mantenimiento existentes. No añadió
una nueva capa arquitectónica. Su implementación consistió en cinco bundles,
un subbundle de freshness/fixtures positivos y la convención de semántica de
tareas ARCH-004. Produjo EV-009 a EV-014 y REG-002 a REG-009. El owner aceptó
la variación de tamaño respaldada por evidencia y la fase cerró en el
checkpoint `47874a5`.

### F8: cierre residual fail-closed

F8 comenzó como investigación después de congelar F7. Su investigación
rechazó una expansión amplia de arquitectura e identificó solo dos cierres de
runtime impulsados por evidencia:

- A-03: la ausencia de `contract_hash` podía pasar el gate TaskCompleted bajo
  la regla transicional de F7.
- A-04: un JSON de firewall malformado podía convertirse en comando vacío y
  pasar por la ruta de extracción preexistente.

F8 también documentó A-06, una convención de identidad del reviewer, y
enmendó ARCH-004 in-place. F8 modificó dos hooks existentes y extendió dos
fixtures existentes. No introdujo hooks, skills, agents, rules, dependencias,
tipos de registry ni campos de identidad nuevos. Produjo EV-015/EV-016 y
REG-010/REG-011, pasó la ronda independiente 3 y cerró como
`COMPLETE / FROZEN` en
`2cd795321486a30240197ac12a0bf51564ffba66`.

### F9: gate de investigación, no implementación

F9 no comenzó seleccionando una funcionalidad. Preguntó si existía evidencia
para justificar otra fase de implementación. La investigación examinó los
candidatos diferidos, los controles actuales, el límite de runtime nativo, las
limitaciones de integridad de evidencia y el balance beneficio/complejidad.

El resultado fue:

```text
F9_RESEARCH_STATUS = COMPLETE
F9_DECISION        = F9 NOT JUSTIFIED
IMPLEMENTATION     = NOT AUTHORIZED / NOT PERFORMED
RUNTIME_CHANGED    = NO
```

Esto no es una fase fallida. Es una conclusión de investigación: ningún
candidato actual reúne impacto observado, control insuficiente, beneficio
proporcional y alcance reversible suficientes para abrir otra fase de runtime.
Los candidatos permanecen documentados con triggers explícitos de reactivación
en lugar de perderse.

---

## 3. Vista General De La Arquitectura

El control plane es infraestructura local al proyecto bajo `.claude/`,
respaldada por registries Markdown canónicos, evaluaciones shell deterministas
y una frontera de revisión basada en Git. La arquitectura está organizada por
capas, pero las capas tienen distintas fuerzas de enforcement. La guidance en
Markdown no equivale a un hook bloqueante.

```text
CONTEXTO       -> qué conoce el agente
ESTADO         -> dónde está el proyecto
CONTROL        -> qué puede bloquearse
EJECUCIÓN      -> qué agents y workflows actúan
VERIFICACIÓN   -> cómo se decide PASS/BLOCK
APRENDIZAJE    -> cómo los incidentes se convierten en controles y regresiones
GATE HUMANO    -> cuándo se autoriza una fase o un cambio de frontera de confianza
```

### 3.1 Capa de contexto

La capa de contexto incluye:

- `CLAUDE.md`, el bootstrap corto del proyecto y el mapa de fuentes.
- `.claude/rules/*.md`, reglas permanentes de seguridad, compliance, política
  de Git y no-go.
- `.claude/context/*.md`, seis packs orientados por rol: `CORE`,
  `CURRENT_STATE`, `DECISIONS`, `BUSINESS`, `SECURITY_RULES` y `NO_GO`.
- Context skills que hacen los packs auditables y cargables.

`SubagentStart` inyecta contexto mediante `additionalContext` según el rol del
agent. El repositorio no trata el campo `skills:` del frontmatter de un agent
como mecanismo de carga de runtime verificado.

`CLAUDE.md` proporciona el mapa y el orden de lectura. No demuestra que una
capacidad exista. Esa prueba proviene de los archivos de runtime, Git y los
checks.

### 3.2 Capa de estado y registries

La capa de estado tiene una fuente canónica para cada tipo de hecho:

| Preocupación | Fuente canónica | Propósito |
|---|---|---|
| Fase/estado operativo | `PROJECT_STATE.md` | fase, status, objetivo, bloqueadores, checkpoint y autorización |
| Decisiones | `DECISION_REGISTRY.md` | decisiones arquitectónicas/de proceso y reversibilidad |
| Entregables | `ARTIFACT_MANIFEST.md` | salidas esperadas por fase |
| Evidencia | `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | claims, fuente, provenance, hashes, checks y status |
| Incidentes | `INCIDENT_REGISTRY.md` | síntomas, RCA, reproducer y cierre |
| Controles | `CONTROL_REGISTRY.md` | controles derivados de incidentes |
| Regresiones | `REGRESSION_REGISTRY.md` | checks reproducibles de controles |

Los mirrors permitidos están declarados explícitamente. `PROJECT_STATE.md`
manda sobre su mirror compacto `.claude/context/CURRENT_STATE.md`;
`DECISION_REGISTRY.md` manda sobre `.claude/context/DECISIONS.md`.

### 3.3 Capa de control

`.claude/settings.json` conecta permisos y eventos de hooks. Los settings
definen comportamiento `allow`, `ask` y `deny`. La frontera de confianza
importante es:

- Los comandos Bash pasan por `bash-firewall.sh` en `PreToolUse`.
- El contenido de Write/Edit pasa por `secret-guard.sh` en `PreToolUse`.
- La finalización de tareas pasa por `task-completed-evidence.sh` en
  `TaskCompleted`.
- Los hooks de ciclo de sesión recuperan estado, toman snapshots, registran
  actividad y emiten recordatorios.

El wiring actual tiene diez scripts de hook distribuidos entre SessionStart,
PreToolUse, SubagentStart, SubagentStop, Stop, PreCompact, ConfigChange y
TaskCompleted. Los hooks de seguridad/evidencia que bloquean usan exit code
`2`. Los hooks de logging y recuperación de contexto suelen ser fail-open.

### 3.4 Capa de ejecución

El repositorio contiene cinco agents con roles limitados:

- `researcher`: investigación y fuentes, solo lectura.
- `architect`: diseño y documentación, sin ejecución shell.
- `implementer`: implementación y checks.
- `security-auditor`: auditoría de seguridad, solo lectura.
- `code-reviewer`: revisión en contexto fresco, sin escritura ni shell.

El repositorio también contiene 22 skills en el inventario F7/F8: packs de
contexto, workflows de verificación, lanes SDLC, aprendizaje de incidentes y
skills operativas. La arquitectura prefiere herramientas nativas y skills
locales existentes antes que importar un framework externo.

### 3.5 Capa de verificación

La capa de verificación combina:

- `bash evals/maintenance.sh` para la salud determinista de integración.
- `bash -n` para la sintaxis del instalador, hooks y evaluaciones.
- Validación estructural Tier 1 de skills.
- Fixtures de routing Tier 2.
- Corridas conductuales Tier 3 con firmas normalizadas.
- Fixtures de hooks para casos positivos, negativos y adversariales.
- Regresión de incidente `INC-001-task-completed-evidence.sh`.
- Fixture de integridad de estado para estado sin cambios y drift.
- Validación de freshness para resultados Tier 3.
- Revisión independiente en contexto fresco para cambios de riesgo medio/alto.
- Evidencia y gates de fase.

El repositorio distingue explícitamente `SCRIPT VERIFIED` de
`CLAUDE RUNTIME VERIFIED`. La ejecución directa de shell prueba comportamiento
del script; no prueba el dispatcher nativo de Claude Code, sus matchers, su
ordenamiento ni su reentrada de eventos.

### 3.6 Capa de aprendizaje

El learning loop previsto es:

```text
INCIDENTE
   -> CAUSA RAÍZ
      -> CONTROL
         -> REGRESIÓN
            -> VERIFICACIÓN
               -> EVIDENCIA
                  -> CIERRE
```

`INC-001`, `CTRL-001`, `REG-001` y EV-006 son el ejemplo concreto.
F7 también creó regresiones preventivas para gaps demostrados sin fabricar un
incidente. F9 preservó explícitamente la regla de que un segundo incidente
debe ser orgánico y no fabricado.

### 3.7 Gate humano

La autorización humana es una frontera de fase y de confianza. Los documentos
de investigación F7 y F8 definen contratos, pero no autorizan implementación
por sí mismos. `permissions.ask` protege acciones seleccionadas como push y
eliminación destructiva. Los cambios P0, de permisos o de trust boundary
requieren aprobación humana explícita según el proceso documentado.

---

## 4. Arquitectura Del Flujo De Control

El repositorio documenta el siguiente flujo conceptual:

```text
INTENCIÓN HUMANA
      |
      v
ESPECIFICACIÓN / CONTRATO
      |
      v
EJECUCIÓN POR AGENT PRINCIPAL / AGENT CON ROL
      |
      v
TESTS Y FIXTURES DETERMINISTAS
      |
      v
REVISIÓN INDEPENDIENTE EN CONTEXTO FRESCO CUANDO EL RIESGO LO REQUIERE
      |
      v
ENTRADA EN EVIDENCE REGISTRY
      |
      v
GATE DE EVIDENCIA TaskCompleted
      |
   PASS / BLOCK
      |
      v
APRENDIZAJE DE INCIDENTE / REGRESIÓN / CONTROL
```

Los componentes tienen distinta fuerza de enforcement:

| Componente | Rol real | Estado de enforcement |
|---|---|---|
| `CLAUDE.md`, rules y contexto | instrucciones y contexto | guidance/inyección de contexto |
| permisos de `settings.json` | frontera de acceso a herramientas | comportamiento nativo cuando el runtime está disponible |
| hooks Bash/secret | filtrado síncrono de payloads | scripts bloqueantes, fail-closed en entradas requeridas |
| hook TaskCompleted | gate de evidencia de finalización | script bloqueante; ciclo nativo no verificado bajo OpenCode |
| fixtures y maintenance | verificación determinista | checks ejecutables del repositorio |
| reviewer fresco | revisión independiente | frontera de rol/herramientas y registro de revisión |
| gate humano | autorización de fase y trust boundary | gate de proceso explícito |

El flujo no afirma que cada paso sea una única pipeline automatizada. La
entrada de evidencia, el reviewer, la suite de maintenance y el hook de
finalización son mecanismos separados enlazados por task IDs, hashes y
registros.

---

## 5. Propósito Y Contexto De F7

### 5.1 Línea base heredada

F7 heredó la base F1-F6 completada:

- F1: instalación, estado coherente y registries canónicos, EV-001.
- F2: contrato de evidencia y hardening de TaskCompleted, EV-002.
- F3: lanes SDLC y verificación independiente, EV-005 después de la
  evidencia inicialmente bloqueada por autenticación en EV-003/EV-004.
- F4: ciclo de aprendizaje de incidentes, INC-001/CTRL-001/REG-001 y EV-006.
- F5: snapshot de estado PreCompact, hash y detección de drift, EV-007.
- F6: maintenance determinista, regression budget, CI y baseline, EV-008.

F1-F6 permanecieron como línea base histórica. F7 no reinterpretó ni reescribió
su evidencia.

### 5.2 Por qué se abrió F7

El roadmap posterior a F6 identificó G-V1, G-Bob-2 y G-T1 como gaps de
integridad de evidencia. La auditoría conductual adversarial reprodujo además:

- Stop emitía el mismo `additionalContext` después de
  `stop_hook_active=true`, creando un loop de continuación.
- Los patrones literales del firewall podían evadirse con espacios y variantes
  de mayúsculas/minúsculas SQL.
- Las lecturas de `.env` mediante `source`, dot-source, `eval`, `read`, `exec`
  y redirección no estaban cubiertas por completo.
- TaskCompleted aceptaba un task ID histórico sin enlazar el payload actual a
  un contract hash.
- La rotación copiaba en lugar de mover y los archivos mensuales podían
  sobrescribirse.
- La reinstalación podía sobrescribir settings del usuario sin protección.
- `agent_type` vacío era un problema cosmético de datos.
- El guard podía bloquear la creación de los fixtures que probaban el propio
  guard.

F7 se expandió por tanto desde la propuesta original de freshness a una fase
extendida basada en evidencia. La regla de diseño fue endurecer componentes
existentes, no crear un control plane alternativo.

### 5.3 Principio de alcance de F7

El alcance F7 se mantuvo local y reversible:

- se endurecieron hooks existentes;
- se extendió maintenance existente;
- se agregaron o ampliaron fixtures;
- se añadieron entradas a registries canónicos;
- no se introdujeron hooks, agents, skills, rules, tipos de registry,
  dependencias ni arquitectura nueva.

---

## 6. Historia Completa De Implementación De F7

La implementación F7 comenzó después de la línea base de proyecto `b6e8fd0` y
cerró en `47874a5`. El trabajo de runtime/tests llegó hasta `b659dfb`; los
commits posteriores cerraron evidencia, informes y estado.

### 6.1 Subbundle F7 de integridad de evidencia

**BUNDLE:** freshness y controles positivos F7  
**PROBLEMA:** los snapshots de resultados Tier 3 podían ser antiguos o
reutilizar un `session_id`; el firewall y el secret guard no tenían fixtures
positivos dedicados.  
**RAÍZ / MODO DE FALLA:** maintenance demostraba sintaxis y comportamiento
seleccionado, pero podía aceptar JSON Tier 3 editable/antiguo y no detectaría
una regla de seguridad debilitada mediante un fixture positivo específico.  
**CAMBIO:** se añadió `evidence_freshness_days=30`, un evaluador de freshness,
fixtures positivos de firewall y secret-guard y su ejecución desde maintenance.  
**ARCHIVOS DE RUNTIME:** `evals/maintenance.sh`,
`evals/REGRESSION_BUDGET.json`.  
**FIXTURES:** `evals/skills/evidence-freshness.sh`,
`evals/hooks/firewall-positive.sh`, `evals/hooks/secret-guard-positive.sh`.  
**TESTS:** resultados fresh pasan; session IDs reutilizados y timestamps
antiguos fallan; payloads de seguridad maliciosos bloquean; placeholders y
comandos legítimos permiten.  
**REGRESIONES:** REG-002, REG-003 y REG-004.  
**EVIDENCIA:** EV-009.  
**COMMIT:** `748fc6a`.  
**VERIFICACIÓN:** maintenance ejecutó los tres checks; freshness Tier 3,
sintaxis y fixtures positivos pasaron.  
**ROLLBACK / REVERSIBILIDAD:** revertir el commit; no hace falta reescribir
evidencia histórica.  
**POR QUÉ ESTE ENFOQUE:** añadió un check determinista donde ya existía un gap
concreto, sin modificar el hook de finalización ni introducir un framework de
evaluación nuevo.  
**LO QUE NO SE HIZO:** recomputación de artifact hash, mutation testing,
testing property-based, hooks append-only ni nuevos campos de identidad.

### 6.2 Bundle A - anti-loop de Stop

**BUNDLE:** A - idempotencia de Stop  
**PROBLEMA:** el hook Stop emitía un recordatorio cuando `PROJECT_STATE.md` no
se había tocado ese día, incluso durante invocaciones Stop repetidas causadas
por su propio `additionalContext`.  
**RAÍZ / MODO DE FALLA:** el hook no leía la señal nativa `stop_hook_active`.
La auditoría conductual reprodujo nueve recordatorios repetidos en una sesión
anterior y un caso determinista con mtime antiguo.  
**CAMBIO:** leer `.stop_hook_active` y devolver sin output cuando sea true.  
**ARCHIVO DE RUNTIME:** `.claude/hooks/stop-logger.sh`.  
**FIXTURE:** `evals/hooks/stop-hook-idempotency.sh`.  
**TESTS:** estado antiguo con `false` emite; estado antiguo con `true` no emite;
Stop activo repetido no emite; estado fresco no emite; input ausente/malformed
permanece fail-open.  
**REGRESIÓN:** REG-005.  
**EVIDENCIA:** EV-010.  
**COMMIT:** `148501f`.  
**VERIFICACIÓN:** fixture, sintaxis y maintenance pasaron.  
**ROLLBACK / REVERSIBILIDAD:** revertir `148501f`; no se reescribe estado ni
evidencia.  
**POR QUÉ ESTE ENFOQUE:** usa la señal de idempotencia existente del evento en
lugar de añadir archivos de estado, rate limits o un componente de ciclo nuevo.  
**LO QUE NO SE HIZO:** no se creó un archivo `WAITING_HUMAN`, un evento Stop
nuevo ni un claim de ciclo nativo bajo OpenCode.

### 6.3 Bundle B - hardening del firewall

**BUNDLE:** B - familias de bypass demostradas del firewall  
**PROBLEMA:** los patrones literales, de espacio único y sensibles a mayúsculas
no cubrían variantes cercanas de comandos destructivos o lecturas de entorno.  
**RAÍZ / MODO DE FALLA:** los patrones `grep -qF` no detectaban espacios
variables ni SQL en minúsculas. La expresión de lectura de entorno no cubría
todas las interpretaciones demostradas.  
**CAMBIO:** se reemplazaron literales destructivos por regex tolerantes a
espacios, se hicieron explícitas las variantes de case SQL, se amplió la
cobertura `.env` y luego se añadieron formas de fork-bomb/process-substitution
en la corrección adversarial.  
**ARCHIVO DE RUNTIME:** `.claude/hooks/bash-firewall.sh`.  
**FIXTURE:** `evals/hooks/firewall-positive.sh`.  
**TESTS:** bloquean eliminación raíz, eliminación con espacios, fork bombs, SQL
mixed-case, formas `source`/dot-source/`eval`/`read`/`exec` de `.env`, pipes de
supply-chain y asignaciones de secretos; permiten comandos ordinarios y
limpieza local de dependencias.  
**REGRESIONES:** REG-002 y REG-006.  
**EVIDENCIA:** EV-011.  
**COMMITS:** `cc8634f`, `82aaa75` y las correcciones adversariales de
`b659dfb`.  
**VERIFICACIÓN:** fixture positivo, probes adversariales directos, maintenance
y `bash -n` pasaron.  
**ROLLBACK / REVERSIBILIDAD:** revertir los commits del Bundle B; la evidencia
F1-F6 permanece preservada.  
**POR QUÉ ESTE ENFOQUE:** el repositorio necesitaba cubrir formas cercanas
demostradas, no un parser general de shell ni un claim de protección contra
obfuscación arbitraria.  
**LO QUE NO SE HIZO:** no se construyó una prueba general de seguridad del
lenguaje shell, un mutation harness ni un conjunto infinito de patrones.

### 6.4 Bundle C - coupling entre evidencia y tareas

**BUNDLE:** C - coupling tarea/evidencia  
**PROBLEMA:** TaskCompleted buscaba una entrada VERIFIED por `task_id`, pero un
task ID histórico podía reutilizarse para una finalización nueva.  
**RAÍZ / MODO DE FALLA:** no existía coupling entre un contract hash actual
suministrado en el payload y la entrada del registry. F7 hizo exigible el
coupling cuando el payload suministraba `contract_hash`, manteniendo una
advertencia transicional si faltaba.  
**CAMBIO:** parsear el hash del payload, normalizar un hash sin prefijo a
`sha256:`, compararlo con la entrada exacta y bloquear mismatch, preservando
checks de riesgo, reviewer y status. ARCH-004 documentó tareas contractuales,
TODOs internos, subtareas y notas de investigación.  
**ARCHIVO DE RUNTIME:** `.claude/hooks/task-completed-evidence.sh`.  
**FIXTURE:** `evals/hooks/task-completed-coupling.sh`.  
**TESTS:** hash completo/abreviado coincidente permite; hash mismatch, tareas
históricas e inexistentes bloquean; evidencia malformed/inválida bloquea; el
hash ausente siguió siendo advertencia transicional F7.  
**REGRESIONES:** REG-001 sigue siendo la regresión de incidente; REG-007 cubre
el coupling.  
**EVIDENCIA:** EV-012.  
**COMMITS:** `37662b4` para la convención ARCH-004, `b1471d0` para coupling,
`1a3509e` para evidencia inválida y `b659dfb` para cierre adversarial.  
**VERIFICACIÓN:** fixture de coupling, INC-001, maintenance y fresh review
pasaron; el reuso de tareas históricas quedó cubierto.  
**ROLLBACK / REVERSIBILIDAD:** revert por bundle; los registries históricos se
preservan.  
**POR QUÉ ESTE ENFOQUE:** fortaleció el gate y registry existentes, en lugar de
añadir un segundo task registry o un modelo de identidad nuevo.  
**LO QUE NO SE HIZO:** recomputación de hash contra archivos, firmas
criptográficas ni una máquina de estados formal de tareas.

### 6.5 Bundle D - rotación de logs de sesión

**BUNDLE:** D - rotación reversible del log de sesión  
**PROBLEMA:** el logger copiaba el log activo a un archive mensual sin
truncarlo y podía sobrescribir el mismo archive mensual.  
**RAÍZ / MODO DE FALLA:** `cp` dejaba crecer el log principal y los Stop
repetidos podían destruir historia intra-mes.  
**CAMBIO:** mover el log activo con `mv`, usar un nombre diario y añadir sufijo
numérico cuando el nombre del día ya existe.  
**ARCHIVO DE RUNTIME:** `.claude/hooks/subagent-stop-logger.sh`.  
**FIXTURE:** `evals/hooks/session-log-rotation.sh`.  
**TESTS:** por debajo del umbral conserva el log activo; al alcanzar el umbral
lo mueve; dos rotaciones del mismo día conservan ambos archives y sus entradas.  
**REGRESIÓN:** REG-008.  
**EVIDENCIA:** EV-013.  
**COMMIT:** `7e3a9fc`.  
**VERIFICACIÓN:** fixture, maintenance y sintaxis pasaron.  
**ROLLBACK / REVERSIBILIDAD:** revertir el commit; no se añadió una política de
retención.  
**POR QUÉ ESTE ENFOQUE:** `mv` hace finita la rotación y el sufijo preserva la
historia sin un servicio de logging nuevo.  
**LO QUE NO SE HIZO:** no se añadió eliminación automática a largo plazo ni
una política de retención.

### 6.6 Bundle E - idempotencia del instalador

**BUNDLE:** E - preservación de settings al reinstalar  
**PROBLEMA:** repetir el instalador podía reemplazar un
`.claude/settings.json` personalizado sin una decisión explícita.  
**RAÍZ / MODO DE FALLA:** el instalador serializaba incondicionalmente el
template sobre el settings destino.  
**CAMBIO:** parsear `--force`, preservar settings idénticos, preguntar antes de
reemplazar settings distintos, preservar en modo no interactivo y reemplazar
solo con force/confirmación explícitos.  
**ARCHIVO DE RUNTIME:** `install.sh`.  
**FIXTURE:** `evals/install/idempotency.sh`.  
**TESTS:** instalación limpia, reinstalación, settings personalizados,
recuperación parcial.  
**REGRESIÓN:** REG-009.  
**EVIDENCIA:** EV-014.  
**COMMIT:** `7b575e1`.  
**VERIFICACIÓN:** fixture del instalador, maintenance, `jq` y sintaxis pasaron.  
**ROLLBACK / REVERSIBILIDAD:** revertir el commit; los proyectos temporales del
fixture no modifican settings reales.  
**POR QUÉ ESTE ENFOQUE:** hizo explícita la decisión destructiva sin crear un
subsystem de merge de configuración.  
**LO QUE NO SE HIZO:** no se construyó un merge general de settings ni un
cambio de configuración global.

### 6.7 Cierre adversarial y documentación F7

`b659dfb` aplicó las correcciones adversariales finales a fixtures y hooks del
firewall y la evidencia. Permaneció dentro del threat model F7 y no creó un
componente nuevo.

La secuencia de documentación/cierre:

- registró evidencia y registries en `3ed9609`;
- registró metadata de checkpoints en `a770761`, `dc89939` y `094413c`;
- corrigió identidad de artifact/task de EV-012 en `69b2c23` y `ec8b76e`;
- finalizó el paquete canónico de cierre F7 en `47874a5`.

El conjunto final de evidencia/auditoría F7 incluye la auditoría conductual,
la matriz claim-versus-evidence, provenance, post-F7 audit, handoff de
investigación F7-F12 y logs de sesión históricos congelados.

---

## 7. Arquitectura Del Firewall En F7

En F7, `bash-firewall.sh` se ejecutaba como hook `PreToolUse` asociado a Bash.
Lee un payload JSON desde stdin y extrae `.tool_input.command` con `jq`. La
ausencia de `jq` es fail-closed. Un comando extraído vacío permite porque no
hay comando que inspeccionar; un envelope JSON válido no es un claim de que
cualquier programa shell sea seguro.

Las reglas F7 son checks de patrones finitos. Cubren las siguientes familias
demostradas:

- eliminación destructiva de root/home;
- escrituras a dispositivos y formateo;
- formas de fork bomb;
- cambios recursivos de permisos/ownership;
- familias de SQL destructivo;
- argumentos con forma de secreto;
- patrones de tokens API/Bearer/AWS;
- lecturas de `.env`, claves privadas y credenciales SSH/AWS;
- `git add` de archivos secretos;
- supply-chain `curl|bash` y `wget|bash`.

Cada match emite una razón y sale con `2`. `DRY_RUN=true` es una ruta de
simulación para inspección controlada, no el comportamiento normal de bloqueo.

El fixture F7 prueba los dos lados del contrato: payloads maliciosos conocidos
deben bloquearse, mientras `ls`, `git status`, limpieza local de
`node_modules`, lectura normal de README y dot-sourcing de scripts no secretos
deben permitir. F7 amplió tests de espacios, case, lectura/citas,
process-substitution y variantes de lectura de entorno. F8 añadió después la
validación del envelope JSON antes de extraer el comando; esa adición se
documenta aparte.

El firewall no es un intérprete general de shell y no afirma cubrir obfuscación
arbitraria. Su arquitectura es determinista, basada en patrones y revisable.
El límite de cobertura finita es intencional y permanece como limitación
conocida.

---

## 8. Arquitectura Del Evidence Gate En F7

`.claude/hooks/task-completed-evidence.sh` está conectado al evento
`TaskCompleted`. Lee el registry canónico
`docs/00_SYSTEM/EVIDENCE_REGISTRY.md` y compara el payload de finalización con
una entrada Markdown de evidencia.

El gate valida, según el riesgo y la semántica de la fase:

- existe `task_id` y coincide exactamente;
- el status de evidencia es exactamente `VERIFIED`;
- `Artifact Hash` tiene forma SHA-256 y no es cero;
- `Contract Hash` tiene forma SHA-256 y no es cero;
- tests, static y security tienen valores permitidos;
- el reviewer existe y, para riesgo medium/high/critical, es `PASS`;
- las excepciones son `NONE` o están aprobadas;
- existe timestamp;
- cuando se suministra, el `contract_hash` del payload coincide con el
  `Contract Hash` del registry.

Durante F7, el `contract_hash` ausente era una advertencia transicional
documentada en ARCH-004. El gate podía acoplar un hash suministrado, pero aún
no exigía el campo en toda finalización. F8 eliminó esa transición.

El gate es un lookup del registry y un check contractual. No recomputa el
artifact hash contra un conjunto de archivos, no identifica criptográficamente
al reviewer y no prueba entrega nativa del evento cuando se ejecuta directamente
bajo OpenCode.

El propósito del evidence coupling es distinguir una tarea contractual actual
de una entrada de evidencia histórica. F7 no introdujo un segundo task registry
ni un modelo de identidad nuevo con `run_id`/`attempt_id`.

---

## 9. Arquitectura De Aprendizaje De Incidentes En F7

`INC-001` es el ejemplo concreto del learning loop:

```text
INC-001: la evidencia de finalización no se exigía
    -> causa raíz: faltaba test/ruta de control
       -> CTRL-001: TaskCompleted exige evidencia VERIFIED
          -> REG-001: mismo payload sin control desprotegido y con control bloqueado
             -> EV-006: verificación registrada
```

Los cuatro registries tienen funciones distintas:

- `INCIDENT_REGISTRY.md` registra síntoma, contexto, reproducer, RCA y control
  faltante.
- `CONTROL_REGISTRY.md` registra control activo, enforcement level, incidente
  de origen, owner y rollback.
- `REGRESSION_REGISTRY.md` registra test ejecutable, outcome base, outcome con
  control, evidencia y status.
- `EVIDENCE_REGISTRY.md` registra claim de verificación, provenance, hashes,
  checks, reviewer y timestamp.

Las regresiones preventivas F7 de firewall, secret guard, freshness, Stop,
coupling, rotación e instalador fueron permitidas porque cada una tenía un gap
documentado o un finding adversarial reproducible. F7 no fabricó un segundo
incidente orgánico.

---

## 10. Integridad De Estado Y Provenance En F7

F7 preservó el modelo de estado establecido en F5:

- `PROJECT_STATE.md` es la fuente de verdad operativa.
- `pre-compact-snapshot.sh` guarda snapshot de estado y hash de campos críticos.
- `session-start-compact.sh` informa `STATE_INTEGRITY: PASS` o
  `DRIFT_DETECTED`.
- Las entradas de evidencia usan el vocabulario fijo de provenance:
  `EXTRACTED`, `INFERRED`, `ASSUMED`, `EXTERNAL` o `GENERATED`.
- Los checkpoints Git identifican cierre de fase y permiten rollback por bundle.

Un artifact o contract hash es evidencia de integridad sobre un valor
registrado. No es garantía de inmutabilidad. Un actor con escritura en el
mismo repositorio puede modificar código, evaluadores o registry salvo que el
cambio sea detectado por revisión Git o una futura trust boundary independiente.
Esa limitación se conserva en la documentación F7/F8/F9 y no se convirtió
silenciosamente en una garantía de seguridad.

---

## 11. Modelo De Verificación F7

F7 usó varias capas porque cada check responde una pregunta distinta:

| Capa | Pregunta | Mecanismo real |
|---|---|---|
| Sintaxis | ¿Los scripts se pueden parsear? | `bash -n` sobre installer, hooks y evals |
| Estructural | ¿Las skills tienen la forma correcta? | `evals/skills/validate.sh` Tier 1 |
| Routing | ¿Los fixtures enrutan a la skill correcta? | Fixtures Tier 2 |
| Conductual | ¿Las corridas autenticadas tienen comportamiento estable? | Resultados Tier 3 y firmas normalizadas |
| Hooks | ¿Los controles bloquean/permiten casos conocidos? | Fixtures de hooks |
| Aprendizaje de incidente | ¿El baseline sin control difiere del control? | Regresión INC-001 |
| Integridad de estado | ¿Se detecta drift? | `evals/state/state-integrity.sh` |
| Freshness | ¿Los resultados Tier 3 son recientes y no reutilizados? | `evals/skills/evidence-freshness.sh` |
| Integración | ¿El harness sigue saludable? | `evals/maintenance.sh` |
| Revisión independiente | ¿Un contexto fresco encuentra defectos materiales? | Ruta `code-reviewer` |

El cierre F7 registra `maintenance.sh` 12/12 PASS, todos los fixtures F7,
INC-001, integridad de estado, validación de skills y sintaxis pasando. También
registra una variación de budget: POST-F7 reportó 591 adiciones/17
eliminaciones y siete archivos fixture; un recount independiente acotado midió
608 adiciones/18 eliminaciones. La diferencia quedó documentada y aceptada en
lugar de reescribir la auditoría.

### Script versus verificación nativa

`SCRIPT VERIFIED` significa que un script del repositorio y su fixture se
ejecutaron en el entorno disponible. No significa que el dispatcher de Claude
Code entregó el payload o interpretó la salida de forma nativa.

El handoff F7 registra observaciones nativas parciales para ciertos
comportamientos, pero la documentación final F7/F8 conserva el límite más
estricto: OpenCode no proporcionó verificación completa del ciclo de vida nativo
de Claude Code. TaskCompleted, PreCompact, compact/resume, installer nativo y
secret-guard nativo quedan fuera de ese claim verificado.

---

## 12. Límite De Runtime Nativo En F7

Los scripts F7 se ejecutan bajo Bash en OpenCode. Eso permite tests directos de
payloads y fixtures deterministas. No establece:

- comportamiento nativo de matchers de eventos;
- ordenamiento nativo de hooks;
- forma nativa de payload para cada evento;
- semántica nativa de reentrada de Stop;
- ciclo nativo de TaskCompleted;
- comportamiento del installer dentro de Claude Code;
- identidad nativa de reviewer o modelo.

La auditoría F7 conservó labels `NOT_VERIFIED`/`UNKNOWN` donde no había
ejecución nativa. Una observación live documentada no se amplía a una garantía
nativa universal.

---

## 13. Estado Congelado De F7

F7 está `COMPLETE / FROZEN` en el checkpoint `47874a5`:

- EV-001 a EV-008 son la línea base F1-F6 preservada.
- EV-009 a EV-014 son la evidencia F7.
- REG-001 sigue siendo la regresión de INC-001.
- REG-002 a REG-009 son regresiones F7 activas.
- Informes F7, provenance y matrices de claims permanecen retenidos.
- Las rutas de rollback por bundle están documentadas.
- Las fases posteriores no deben reinterpretar ni reescribir evidencia histórica
  F7 sin evidencia nueva independiente y alcance explícito.

F7 congelada significa que fases posteriores pueden referenciar sus salidas y
añadir evidencia nueva, pero no convertir silenciosamente una limitación
histórica en un cambio F7 no registrado.

---

## 14. Transición De F7 A F8

F8 existió porque F7 dejó deliberadamente un conjunto residual después de
cerrar el alcance conductual más amplio.

Los items residuales importantes fueron:

- A-03: la ausencia de `contract_hash` seguía la ruta de advertencia
  transicional.
- A-04: un JSON de firewall malformado podía convertirse en comando vacío y
  permitir.
- A-05: el artifact hash no se recomputaba contra un conjunto declarado.
- A-06: la identidad del reviewer seguía siendo una convención libre.
- A-07: faltaba detección estructural de self-modification de hooks.
- A-08: la reconciliación del budget histórico era documental.

La investigación F8 separó los cierres impulsados por demanda A-03/A-04 de
las ideas diferidas de integridad, automatización, mutation, registries y
arquitectura. La propuesta mínima fue intencionalmente pequeña: dos cambios en
hooks existentes, dos extensiones de fixtures, una enmienda de decisión
in-place y dos pares de evidencia/regresión.

El cierre F7 no autorizaba automáticamente la implementación F8. Primero se
persistió la investigación F8; después las decisiones del owner suministraron
la autorización.

---

## 15. Investigación F8

`docs/00_SYSTEM/F8_RESEARCH.md` se persistió en `c236b58`. Era un contrato de
investigación, no una autorización de implementación.

### 15.1 Método de evaluación F8

F8 evaluó cada candidato usando:

- evidencia actual;
- controles actuales y gap residual;
- impacto esperado en usuario/sistema;
- beneficio del cierre;
- complejidad de implementación y mantenimiento;
- carga de verificación;
- reversibilidad;
- alternativas nativas/externas/existentes;
- si un componente nuevo crearía más superficie de confianza de la que elimina.

Las reglas rectoras fueron `BENEFIT > COMPLEXITY`, `EVIDENCE > CLAIM`,
`RUNTIME > DOCUMENTATION`, `REUSE > REINVENT` y fail-closed ante incertidumbre
en controles P0.

### 15.2 Alcance seleccionado por F8

F8 seleccionó:

- F8-A: exigir `contract_hash` en TaskCompleted.
- F8-B: fallar cerrado con payloads de firewall malformed/vacíos/no únicos.
- A-06: documentar la convención de identidad del reviewer.
- Enmendar ARCH-004 in-place.

### 15.3 Exclusiones F8

Se excluyeron explícitamente:

- recomputación de artifact hash A-05;
- baseline de integridad de hooks A-07/G-N4;
- Git hook append-only G-N5;
- framework de mutation G-M1;
- automatización `PostToolUseFailure` G-L1;
- frameworks property-based, fuzzing y metamorphic;
- hooks, skills, agents, rules, dependencias o registries nuevos;
- telemetry/OpenTelemetry, MCP, dashboards y routing cross-provider;
- evidencia criptográfica y nuevos campos de identidad;
- formalización de state machine y orchestration especulativa;
- implementación F9-F12.

La razón no fue que estas ideas fueran imposibles. La razón documentada fue
que la evidencia actual no justificaba su complejidad ni una nueva superficie
de confianza.

---

## 16. Decisiones Del Owner En F8

Las decisiones finales F8 registradas en el post-audit y el handoff son:

| Decisión | Valor final | Consecuencia técnica |
|---|---|---|
| D1 | `GO` | Se autorizaron F8-A, F8-B y la documentación A-06. |
| D2 | `AMEND_IN_PLACE` | ARCH-004 conservó su wording histórico y recibió un addendum F8; no se creó ARCH-005. |
| D3 | `TOGETHER` | La documentación de reviewer A-06 entró en la ruta de cierre/revisión F8. |
| D4 | `DEFER` | No se tocó el drift de numeración ARCH-004/ARCH-005 pre-F7 en `DESIGN.md`. |

Estas decisiones tratan de alcance técnico, documentación y gates de fase. No
identifican a una persona ni implican atribución criptográfica.

---

## 17. Implementación F8

### 17.1 F8-A - contract hash obligatorio

**Problema:** la ruta transicional F7 de hash ausente permitía una finalización
aparentemente válida sin `contract_hash` en el payload.

**Cambio real:** `task-completed-evidence.sh` ahora verifica si el campo está
presente, rechaza valores vacío/null y bloquea la ausencia después de la
validación normal del registry. El bloqueo usa exit code `2` e identifica el
campo.

**Archivos cambiados:**

- `.claude/hooks/task-completed-evidence.sh`.
- Extensión de `evals/hooks/task-completed-coupling.sh`.

**Commit:** `f840c71`.

**Tests:** hash completo/abreviado coincidente permite; hash vacío/null,
mismatch, histórico, inexistente, malformed y evidencia inválida bloquean; el
hash ausente bloquea.

### 17.2 F8-B - validación fail-closed del payload de firewall

**Problema:** antes de F8, un input malformado podía extraerse como comando
vacío y pasar por el firewall.

**Cambio real:**

- `0f79b68` añadió rechazo fail-closed de JSON inválido/vacío.
- `e25179f` exigió exactamente un documento JSON, cerrando fallthroughs de
  whitespace-only y múltiples documentos.
- `1427fbe` conservó stdin crudo en un archivo temporal y rechazó NUL bytes
  antes de que la sustitución de comandos pudiera borrarlos.

**Archivos cambiados:**

- `.claude/hooks/bash-firewall.sh`.
- Extensión de `evals/hooks/firewall-positive.sh`.

**Contrato preservado:** `{}` válido, JSON válido sin comando y comando vacío
válido siguen permitidos; payloads malformed, vacíos, whitespace-only,
truncados, múltiples y con NUL bloquean. La matriz de comandos F7 permanece.

### 17.3 A-06 y ARCH-004

`92050dd` cambió solo documentación:

- `PASS (code-reviewer@fresh-context)` para una revisión de subagent en contexto
  fresco;
- `PASS (human/@owner)` para una revisión humana explícita;
- `NOT_REQUIRED` cuando una política de bajo riesgo permite omitirla.

La convención no añade un campo de schema ni identidad criptográfica. ARCH-004
fue enmendado in-place para marcar el warning F7 como superseded por F8-A.

### 17.4 Límite de implementación F8

F8 cambió dos hooks existentes y extendió dos fixtures existentes. No añadió:

- archivos fixture nuevos;
- hooks nuevos;
- agents ni skills nuevos;
- rules, dependencias, registries ni campos de identidad nuevos;
- arquitectura nueva.

---

## 18. Evidencia Y Regresiones F8

### EV-015 / REG-010

`EV-015` registra que un payload válido de tarea completada sin `contract_hash`

El artifact hash de evidencia es el hash del fixture de coupling commiteado:

```text
sha256:93ac496409c13c0b2f4f67c62eeea1a2dc55c86c13a2bd211e2b12c8183d8a4d
```

### EV-016 / REG-011

`EV-016` registra que payloads malformed, vacíos, whitespace-only, truncados,
comandos inocuos permanecen permitidos. `REG-011` registra la ruta de
extracción como comando vacío pre-F8 y el bloqueo F8.

El artifact hash de evidencia es el hash del fixture de firewall commiteado:

```text
sha256:758ecc2734e4376d8d942710eddee9c84cd4d2bc973cb1cf7d998687b3ddbc84
```

Ambas entradas usan el contract hash F8:

```text
sha256:a0bbbd9f01d99110aa9674316d30b7525fbfb8f4b0a7e3d2c3829a4c0579a7e7
```

Estas entradas prueban scripts y fixtures del repositorio. No prueban el ciclo
de vida nativo de eventos Claude Code.

---

## 19. Auditoría Independiente F8

`POST_F8_AUDIT_REPORT.md` identifica fecha de auditoría 2026-09-19, checkpoint
F7 `47874a5`, checkpoint de evidencia F8 `95f1555` y status
`COMPLETE / FROZEN`. El informe identifica el rol auditor como Claude Code /
Claude Opus 4.7, pero también registra que la identidad del modelo reviewer no
está probada criptográficamente.

La auditoría evaluó:

- bloqueo de hash ausente F8-A;
- bloqueo de payloads malformed y de boundary F8-B;
- documentación A-06;
- enmienda in-place de ARCH-004;
- EV-015/EV-016 y REG-010/REG-011;
- todos los fixtures F7 y los prefijos históricos;
- maintenance, incidente, integridad de estado, skills y sintaxis;
- rounds de revisión y budget de alcance;
- rollback y limitaciones de runtime nativo.

La historia de revisión independiente tuvo dos rondas bloqueadas y una ronda
final 3 PASS después de correcciones dentro del alcance F8. El informe deja
`BLOCKERS: NONE` en el estado resultante y preserva evidencia, regresiones,
informes y checkpoint F7.

La auditoría F8 no afirmó verificación del ciclo de vida nativo de Claude Code.
Verificó el comportamiento del repositorio en el entorno disponible.

---

## 20. Limitaciones De Auditoría F8

Las siguientes limitaciones se preservaron en lugar de tratarlas como defectos
automáticos.

### Ciclo TaskCompleted nativo

El script TaskCompleted y su fixture se verifican directamente, pero OpenCode
no ejercitó el dispatcher TaskCompleted nativo de Claude Code. La ausencia de
acceso nativo no se convierte en una inferencia de fallo nativo.

### Ruta JSON nativa malformed

El script puede recibir input malformed y fallar cerrado. No estuvo disponible
la forma normal del wire Claude Code para probar que el dispatch nativo
produciría ese input ni cómo lo enrutaría. Testing de boundary del script y
testing del wire nativo son preguntas separadas.

### Raíces JSON válidas no-object

El firewall valida un único documento JSON, no un schema completo de object para
cualquier raíz JSON posible. No existe evidencia de que el input normal Bash de
Claude Code sea un scalar o array, y ningún incidente actual depende de ello.
Es un límite de política, no un defecto de runtime probado.

### Cobertura finita del firewall

El conjunto de regex cubre familias demostradas y revisadas. No afirma
protección contra obfuscación shell arbitraria. Un bypass documentado futuro
sería evidencia nueva; el límite finito en sí es intencional.

### Identidad del reviewer

La convención de reviewer está documentada, pero el schema no prueba
criptográficamente la identidad de un modelo. Los informes evitan tratar un
label de reviewer como prueba criptográfica.

---

## 21. Por Qué F8 Fue Más Pequeña Que F7

F7 fue una fase de hardening conductual multi-bundle. Tocó comportamiento Stop,
familias del firewall, freshness, fixtures de secret-guard, coupling de tareas,
rotación, instalador y semántica de tareas. El owner aceptó la variación
respaldada por evidencia de 591 adiciones/17 eliminaciones en el post-F7, con
un recount independiente acotado de 608/18 y siete archivos fixture.

F8 no fue otra ronda amplia de hardening. Cerró dos rutas fail-open nombradas y
añadió una convención documental:

| Medida | F7 | F8 |
|---|---:|---:|
| Foco de runtime | múltiples hooks existentes e instalador | dos hooks existentes |
| Alcance de fixtures | siete archivos fixture en la variación F7 aceptada | dos extensiones de fixtures existentes |
| Archivos fixture nuevos | parte del alcance F7 | 0 |
| Componentes nuevos | 0 | 0 |
| Dependencias nuevas | 0 | 0 |
| Líneas de runtime cambiadas | variación aceptada; reportado 591/17, recount 608/18 | 18 líneas cambiadas / 14 adiciones en dos hooks |
| Evidencia | EV-009..EV-014 | EV-015/EV-016 |
| Regresiones | REG-002..REG-009 | REG-010/REG-011 |

La diferencia es un límite de ingeniería: F8 no trató cada item diferido como
objetivo de implementación.

---

## 22. Arquitectura Final F8 Después Del Cierre

Después de F8 la arquitectura siguió siendo el mismo control plane por capas:

- packs de contexto existentes e inyección por rol;
- estado y registries canónicos existentes;
- permisos y wiring de hooks existentes;
- agents y skills existentes;
- modelo existente de maintenance y fixtures deterministas;
- coupling payload/evidencia TaskCompleted más fuerte;
- validación del envelope de firewall más fuerte;
- convención de reviewer documentada;
- trust boundary de Git diff/reviewer humano.

F8 no cambió:

- el schema de settings ni el modelo de permisos;
- el número de hooks, agents, skills o rules;
- la arquitectura de registries;
- el schema de hashes de evidencia;
- el modelo de aprendizaje de incidentes;
- la documentación de state machine a una máquina runtime formal;
- la disponibilidad del runtime nativo.

---

## 23. Transición De F8 A F9

El cierre de F8 no implicaba que otra fase de implementación fuera necesaria.
La evidencia posterior a F8 mostraba una suite determinista saludable, cero
blockers F8 y un conjunto de items intencionalmente diferidos o desconocidos.
Por ello F9 se abrió como gate de investigación, no como backlog de
implementación.

La distinción rectora fue:

```text
RESEARCH != IMPLEMENTATION AUTHORIZATION
```

F9 podía inspeccionar evidencia, ejecutar checks existentes, reconstruir gaps
diferidos y crear un artefacto de investigación. No podía cambiar runtime,
fixtures, registries, arquitectura ni registros históricos F8.

---

## 24. Objetivo De Investigación F9

La pregunta F9 fue:

```text
¿Qué evidencia justifica otra fase de implementación?
```

No fue:

```text
¿Qué podemos construir después?
```

El contrato de investigación F9 evaluó si algún item diferido tenía:

- un problema actual y evidenciado;
- un gap residual no cubierto por controles existentes;
- impacto material en usuario/sistema;
- beneficio medible;
- costo de implementación y mantenimiento proporcional;
- método de verificación;
- alcance reversible;
- una razón para no reutilizar controles actuales.

---

## 25. Inventario De Candidatos F9

Los siguientes candidatos se reconstruyeron explícitamente a partir de la
investigación F8, el roadmap, las auditorías F7 y la evidencia actual:

| Candidato | Estado de investigación F9 |
|---|---|
| A-05 / G-N3 | Diferido; artifact hash no se recomputa contra un conjunto declarado; no hay tampering. |
| A-07 / G-N4 / G-B10 | Diferido; amenaza teórica y baseline en el mismo repositorio no sería trust domain independiente. |
| G-N5 | Diferido; enforcement append-only duplicaría revisión Git y no hay history rewrite. |
| G-M1 | Diferido; no hay mutation relevante superviviente ni bypass nuevo que justifique un mutator shell. |
| G-L1 | Diferido; no hay tool failure omitido documentado; el evento nativo no está verificado. |
| G-B11 | Unknown/sospechado; los phantom SubagentStop no tienen reproducción determinista. |
| G-T2 | Diferido; existe un incidente real y no debe fabricarse un segundo. |
| G-S1 | Limitación documentada de smoke de rollback; no se observó fallo de rollback. |
| G-S2 | Problema documental de claridad del comando de rollback; no hay recovery fallido registrado. |
| G-Bob-1 | Ambigüedad de label de intención de fixture; sin fallo operativo. |
| G-A1 | Placeholders en packs de contexto template; existen instrucciones explícitas de template. |
| G-N1 | Cadencia manual de revalidación; no hay incidente por cadencia omitida. |
| G-N2 | Política de retención; existe rotación diaria, sin requerimiento de storage/consumer. |
| G-B6 | False block al crear fixtures; los fixtures distribuidos evitan esa ruta live. |
| G-B9 | Campo `agent_type` vacío; problema cosmético de logging. |
| G-D3 | Resuelto/documentado por ARCH-004; no se reabre. |
| G-V1 / G-Bob-2 / G-T1 | Cerrados por F7 y preservados por F8. |
| A-03 / A-04 / A-06 | Cerrados o documentados por F8; no se reabren. |
| OpenTelemetry | Diferido; sin aggregator ni demanda de RCA en la escala actual. |
| MCP | Diferido; MCP no está en uso. |
| Cross-provider routing | Fuera del alcance actual; no hay requerimiento de outage. |
| Vector memory | No hay workload cross-project. |
| Fuzzing/property-based/metamorphic | No hay incidente de input no cubierto que requiera framework. |
| Evidencia criptográfica | No hay tampering ni demanda de compliance; complejidad desproporcionada. |
| Nuevos campos de identidad | Identificadores actuales bastan a la escala; no hay incidente de colisión. |
| Infraestructura nueva | No existe problema concreto no cubierto por controles actuales. |

F9 no trató la existencia de un item en el roadmap como prueba de que
perteneciera a una fase.

---

## 26. Método De Investigación F9

Para cada candidato serio, la investigación F9 registró:

- fuente y problema original;
- estado actual y evidencia real;
- riesgo e impacto soportados;
- control actual y gap residual;
- beneficio del cierre;
- complejidad de implementación, mantenimiento y verificación;
- reversibilidad;
- relevancia para F9;
- recomendación de continuar, diferir o descartar investigación.

El análisis reutilizó:

- hooks y fixtures existentes;
- registries y contratos de evidencia existentes;
- historial Git y comparaciones de prefijos;
- checks de integridad de estado;
- revisión humana de diff y review en contexto fresco;
- workflows existentes de maintenance e incidentes.

La carga de prueba estuvo en introducir un subsystem nuevo. Un item diferido
no se promovió por ser técnicamente interesante, y una limitación de
verificación no se promovió a defecto de runtime sin evidencia.

---

## 27. Investigación De Runtime Nativo En F9

F9 confirmó que el ciclo de vida nativo de Claude Code sigue
`NOT_VERIFIED` bajo OpenCode. Esto no significa que el runtime nativo esté roto.
Significa que el entorno disponible puede ejecutar scripts y fixtures, pero no
probar dispatch nativo, selección de matcher, ordenamiento, forma de payload ni
reentrada.

La evidencia nativa podría afectar materialmente solo decisiones acotadas:

- si los phantom SubagentStop de G-B11 son eventos nativos reales;
- si G-L1 debería reaccionar a un fallo que el workflow manual pierde;
- si el wiring nativo y los payloads de eventos coinciden con los contratos de
  los scripts.

No cambiaría el hecho de que scripts y fixtures F7/F8 pasan, ni reabriría F8
retroactivamente ni justificaría artifact recomputation, hook baselines,
mutation testing o enforcement de registries.

El paquete nativo futuro más pequeño usaría un proyecto disposable y una
sesión Claude Code nativa autenticada. Observaría hooks existentes sin cambiar
el runtime del repositorio: casos PreToolUse válidos/bloqueados, reentrada Stop,
allow/block de TaskCompleted, identidad SubagentStop, integridad
PreCompact/SessionStart compact y, solo si fuera necesario, un tool failure
controlado. Registraría evento, forma de payload redacted, exit code, output,
ordenamiento y reproducibilidad.

F9 concluyó que esto solo es investigación previa si se selecciona G-B11 o G-L1
para consideración posterior. No es razón para crear ahora una fase de
implementación F9.

---

## 28. Resultado Final De Investigación F9

El artefacto canónico F9 registra:

```text
F9_RESEARCH_STATUS       = COMPLETE
F9_DECISION              = F9 NOT JUSTIFIED
IMPLEMENTATION_AUTHORIZED = NO
IMPLEMENTATION_PERFORMED  = NO
RUNTIME_CHANGED           = NO
NEW_EVIDENCE              = NONE
NEW_REGRESSIONS           = NONE
```

Técnicamente, esto significa que la investigación no identificó una necesidad
respaldada por evidencia suficiente para abrir otra fase de implementación. No
significa que todas las limitaciones hayan desaparecido. Significa que cada
candidato restante tiene mitigación actual suficiente, carece de trigger
observado, es una frontera de verificación aceptada o es un item documental de
bajo impacto que conviene tratar de forma independiente.

El budget de implementación F9 fue cero archivos de runtime, cero hooks, cero
fixtures, cero entradas de evidencia/regresión, cero dependencias, cero
arquitectura nueva y cero schemas nuevos.

---

## 29. Items Diferidos F9 Y Triggers De Reactivación

| Item | Por qué queda diferido | Evidencia que podría reactivarlo |
|---|---|---|
| A-05/G-N3 | No hay tampering ni contrato exacto de conjunto de artifacts | Tampering documentado o mismatch de hash repetido |
| A-07/G-N4/G-B10 | Baseline en el mismo repositorio no es trust domain independiente; no hay weakening silencioso | Hook weakening aceptado o frontera externa de compliance |
| G-N5 | La revisión Git expone cambios actuales; no hay history rewrite | History rewrite documentado o registry tampered aceptado |
| G-M1 | Costo de mutator shell bespoke; no hay mutation relevante superviviente | Bypass de firewall o mutation de seguridad que sobreviva fixtures |
| G-L1 | No hay incidente manual perdido; automation puede producir ruido | Tool failure que demuestre pérdida en el workflow manual |
| G-B11 | No hay causa determinista ni reproducción nativa | Phantom event nativo reproducible |
| G-T2 | No hay segundo incidente orgánico | Segundo incidente real |
| G-S1/G-S2 | Limitación de recovery sin fallo observado | Validación de recovery aprobada o necesidad real de rollback |
| G-Bob-1/G-A1/G-N1/G-N2/G-B9 | Hygiene documental/cosmética/operativa sin impacto de fase | Requerimiento concreto de mantenimiento, storage u operación |
| OpenTelemetry | No hay aggregator ni demanda de RCA | Operación multi-project donde traces faltantes bloqueen RCA |
| MCP | No hay superficie MCP | Adopción explícita de MCP |
| Cross-provider | El alcance actual fija el provider | Requerimiento demostrado por outage del provider |
| Vector memory | No hay workload cross-project | Necesidad sostenida de conocimiento cross-project |
| Fuzzing/property-based | Fixtures deterministas cubren casos demostrados | Fallos repetidos de variación de input fuera de fixtures |
| Evidencia criptográfica | No hay tampering/demanda de compliance | Auditoría o compliance que cambie trust model |

Diferido significa que no se persigue hasta que exista el trigger indicado. No
significa que el item se haya perdido de la historia técnica.

---

## 30. Gate De Decisiones Del Owner F9

F9 preservó cinco superficies de decisión sin ordenar ni recomendar sus
opciones.

### F9-D01 - ¿autorizar runtime F9?

**Pregunta:** ¿Debe autorizarse alguna implementación runtime F9 después de esta
investigación?

- **Opción A:** mantener cerrada la implementación F9. Consecuencia: los
  controles y trust boundaries actuales no cambian.
- **Opción B:** autorizar después un contrato específico de candidato.
  Consecuencia: debe identificarse candidato, umbral de evidencia, archivos,
  tests, rollback y no-goals.
- **Opción C:** autorizar primero una investigación de runtime nativo.
  Consecuencia: no cambia el runtime del repositorio; la evidencia del ciclo de
  vida se recoge por separado.

**Evidencia:** ningún candidato actual alcanza el umbral de fase; maintenance
está 12/12 PASS y F8 está complete/frozen.

### F9-D02 - ¿cuándo obtener evidencia nativa?

**Pregunta:** ¿Cuándo debe obtenerse evidencia Claude Code nativa?

- **Opción A:** obtenerla ahora en un entorno disposable autenticado.
- **Opción B:** diferirla hasta una recurrencia G-B11, un tool failure perdido o
  una decisión de integración nativa.

**Evidencia:** OpenCode no puede probar dispatcher, matcher, ordenamiento ni
reentrada nativos, y ninguna decisión actual requiere esos hechos.

### F9-D03 - candidatos documentales

**Pregunta:** ¿Cómo deben tratarse G-S1, G-S2, G-Bob-1, G-A1, G-N1 y G-N2?

- **Opción A:** ejecutar micro-tasks aislados de documentación/recovery.
- **Opción B:** mantenerlos diferidos con sus referencias actuales.
- **Opción C:** retirar items obsoletos del roadmap después de revisión,
  preservando la razón histórica.

**Evidencia:** no hay fallo runtime demostrado; las fuentes canónicas los
clasifican como documentales o de bajo impacto.

### F9-D04 - trigger de controles de integridad

**Pregunta:** ¿Qué trigger debe exigirse antes de revisar controles de artifact
o hook integrity?

- **Opción A:** un incidente documentado de tampering de evidencia o weakening
  silencioso de hook.
- **Opción B:** una auditoría externa o requerimiento de compliance definido por
  el owner.
- **Opción C:** conservar la frontera actual de Git/reviewer a esta escala.

**Evidencia:** no hay tampering ni weakening silencioso aceptado en historia
F7/F8; un baseline en el mismo repositorio no sería independiente frente al
threat model más fuerte.

### F9-D05 - definición de F10-F12

**Pregunta:** ¿Deben F10-F12 continuar sin definirse hasta que aparezca nueva
evidencia?

- **Opción A:** mantenerlas unknown y research-required.
- **Opción B:** definirlas ahora a partir de temas del roadmap aunque no exista
  contrato de problema/evidencia actual.

**Evidencia:** no existe contrato histórico F10-F12 y ningún candidato actual
las requiere.

---

## 31. Búsquedas, Inspecciones E Investigaciones Realizadas

Esta sección distingue investigaciones registradas en artefactos F7/F8 de las
inspecciones realizadas para reconstruir F9 y producir este dossier.

| Pregunta | Método | Resultado observado | Impacto en decisión |
|---|---|---|---|
| ¿Cuál es la cronología real? | `git log --oneline --decorate --graph --all -50`, `git log --stat` completo y `git show` de commits | Implementación/cierre F7, investigación/implementación/auditoría F8 y commit de investigación F9 son separables | Se estableció cronología sin depender de prompts |
| ¿Qué cambió desde el checkpoint F7? | `git diff --stat/name-only 47874a5..HEAD` | 21 paths, 1912 adiciones y 29 eliminaciones; runtime son paths hook/fixture F8 y el resto documentación/evidencia/estado | Se limitó el dossier a paths y fronteras reales |
| ¿F8 alteró evidencia F7? | Comparación de prefijos de evidence/regression registries contra F7 | Prefijos EV-001..EV-014 y REG-001..REG-009 coinciden byte a byte | Preservación histórica PASS |
| ¿Existen artifacts F8? | Lectura de evidence, regression, post-audit, provenance y claim-vs-evidence | Existen EV-015/016, REG-010/011 y artifacts de auditoría | El cierre F8 es reconstruible |
| ¿Los hashes F8 coinciden con sus notas? | `sha256sum` sobre fixtures de coupling, firewall y contrato F8 | Los tres valores coinciden | Recomputación de investigación; no control nuevo |
| ¿Pasan los controles deterministas actuales? | `bash evals/maintenance.sh` | 12/12 PASS | No aparece necesidad F9 por fallos actuales |
| ¿Sigue funcionando el loop de incidentes? | `bash evals/incidents/INC-001-task-completed-evidence.sh` | `without_control=UNPROTECTED`, `with_control=BLOCKED`, REG-001 PASS | Aprendizaje manual sigue reproducible |
| ¿Funciona drift detection? | `bash evals/state/state-integrity.sh` | `unchanged=PASS`, `drift=DETECTED` | Control de estado sigue operativo a nivel script |
| ¿Pasan los checks de skills? | `evals/skills/validate.sh` | Tier 1, Tier 2 y Tier 3 PASS | Sin regresión de skills |
| ¿Son válidos los scripts? | `bash -n` sobre installer, maintenance, hooks y eval directories | PASS | Sin drift sintáctico |
| ¿Siguen vigentes los candidatos diferidos? | Búsquedas en auditorías F7/F8, plan, roadmap, handoff y runtime | Aliases y estados closed/deferred reconciliados | No se promovió un item antiguo solo por existir en una lista |
| ¿Existe evidencia de ciclo nativo? | Lectura de informes, handoffs y boundary F9 | Sigue NOT_VERIFIED bajo OpenCode | El límite nativo no se convirtió en defecto runtime |
| ¿El alcance F9 fue limitado? | Git status, diff de commit y archivos actuales | Commit F9 solo cambió documentación de investigación/handoff | No hubo implementación runtime F9 |

### Investigaciones F7 registradas en material canónico

La documentación F7 registra:

- reproducción adversarial del loop Stop;
- probes de espacios, case, SQL y lecturas de entorno del firewall;
- probe de reuso histórico de task ID con false-PASS;
- auditoría de interacción false-block al crear fixtures;
- comportamiento de reinstalación;
- comportamiento de rotación de logs;
- fixture de integridad de estado y drift;
- tests de freshness Tier 3 y resultados duplicate/stale;
- rounds de revisión en contexto fresco;
- auditoría de budget y rollback.

### Investigaciones F8 registradas en material canónico

La documentación F8 registra:

- probes de coupling con `contract_hash` ausente;
- probes de boundary firewall malformed, vacío, whitespace-only, multi-document
  y NUL;
- casos válidos de comando vacío e innocuous command;
- reruns de regresiones F7;
- tres rounds de revisión independiente, con round 3 PASS;
- comparación histórica de prefijos append-only;
- auditoría de alcance y budget F8;
- preservación del límite de ciclo nativo.

### Investigaciones F9

F9 no instaló herramientas, agregó fixtures, agregó hooks ni creó wrappers
nativos. Leyó la historia canónica, inspeccionó archivos de runtime actuales,
ejecutó verificaciones existentes, recomputó hashes existentes seleccionados,
buscó IDs diferidos y evaluó beneficio versus complejidad. No ejecutó el ciclo
de vida nativo de Claude Code.

---

## 32. Hechos, Claims Y Fronteras De Verificación

| Label | Significado en este dossier | Ejemplos |
|---|---|---|
| FACT | Está directamente en Git o en un artifact del repositorio | commit IDs, paths, registry entries, `HEAD` actual |
| OBSERVED | Se observó directamente en un comando o fixture ejecutado | maintenance 12/12 PASS, `drift=DETECTED` |
| VERIFIED | Está soportado por un check/evidence contract en el nivel indicado | comportamiento script EV-015, fixture REG-011 |
| CLAIM | Un documento lo afirma, pero su boundary sigue aplicando | atribución de reviewer o resumen de fase |
| SCRIPT VERIFIED | Script Bash y fixture pasaron en el entorno disponible | fixtures F7/F8 y maintenance |
| NATIVE VERIFIED | Se ejercitó ciclo nativo directamente en el alcance indicado | no está establecido globalmente para F7/F8 bajo OpenCode |
| NOT VERIFIED | El entorno no ejercitó directamente el comportamiento | ciclo nativo Claude Code |
| UNKNOWN | La evidencia disponible no basta para clasificar | causa del phantom event G-B11 |
| DEFERRED | Se decidió no perseguirlo hasta que aparezca un trigger | A-05, G-M1, G-L1, G-N5 |

Fronteras importantes:

- Un campo con forma SHA-256 no prueba que se haya hasheado el artifact actual.
- Un fixture shell en verde no prueba dispatch nativo del hook.
- Un label de reviewer no es identidad criptográfica del modelo.
- Un registro histórico congelado no autoriza reescribirlo.
- Una idea diferida no es una fase aprobada.

---

## 33. Cambios Consolidados Por Fase

| Fase | Cambios de runtime | Cambios de fixtures | Documentación | Evidencia | Regresiones | Arquitectura |
|---|---|---|---|---|---|---|
| F7 | Stop hook, firewall Bash, coupling TaskCompleted, rotación logger, preservación installer; extensiones maintenance/budget | Fixtures Stop, firewall, secret guard, freshness, coupling, rotación e installer | ARCH-004, handbook, roadmap, planes, auditorías, provenance y claims | EV-009..EV-014 | REG-002..REG-009; REG-001 preservada | Componentes existentes endurecidos; cero componentes runtime nuevos |
| F8 | Fail-closed por hash ausente TaskCompleted; validación fail-closed de payload firewall | Dos extensiones de fixtures existentes; cero archivos fixture nuevos | convención reviewer, enmienda ARCH-004, investigación, auditoría, provenance, claims y handoff | EV-015/EV-016; EV-001..EV-014 preservada | REG-010/REG-011; REG-001..REG-009 preservadas | Cero componentes, dependencias o tipos de registry nuevos |
| Investigación F9 | Ninguno | Ninguno | `F9_RESEARCH.md`; actualización del handoff en commit de cierre F9 | Cero EV nuevas | Cero REG nuevas | Sin cambio de arquitectura; sin contrato de implementación |

El commit de investigación F9 cambió dos archivos Markdown. Este dossier es
otra salida documental y no modifica los artifacts de las fases que describe.

---

## 34. Lo Que No Cambió

El rango Git actual y las comparaciones de registries soportan estos hechos de
preservación:

- la evidencia F1-F6 permaneció como línea base histórica;
- el checkpoint F7 `47874a5` sigue presente;
- EV-001..EV-014 permanecen preservadas en su prefijo histórico;
- REG-001..REG-009 permanecen preservadas en su prefijo histórico;
- los informes, provenance y matrices de claims F7 permanecen en el repositorio;
- los informes, provenance y matrices de claims F8 permanecen en el repositorio;
- EV-015/EV-016 y REG-010/REG-011 fueron añadidas, no sustituyeron entradas F7;
- `INCIDENT_REGISTRY.md`, `CONTROL_REGISTRY.md` y el loop de incidentes siguen
  presentes;
- `.claude/settings.json` no fue cambiado por F8 o F9 después de la línea base
  F7, salvo el wiring histórico F7/F8 ya documentado en el rango; F9 no lo
  cambió;
- hooks, skills, agents y rules existentes no se ampliaron en F8 ni F9;
- no se añadió dependencia, tipo de registry, campo de identidad ni arquitectura
  en F8 o F9.

El diff exacto de paths runtime `47874a5..HEAD` es la frontera de autoridad; la
tarea del dossier F9 no añade ningún path runtime.

---

## 35. Cronología De Commits

La siguiente cronología se deriva de `git log`, estadísticas de commits y diffs
dirigidos. Las horas usan el offset `-05:00` registrado por el repositorio. La
columna de verificación describe el resultado de fase asociado al commit; un
commit documental no se presenta como test de runtime.

| Fecha/hora | Commit | Propósito y archivos | Fase | Verificación/resultado |
|---|---|---|---|---|
| 2026-09-18 13:44:59 | `37662b4` | Convención semántica de tareas en `DECISION_REGISTRY.md`, mirror de decisiones y Handbook | F7 | ARCH-004 documentado; sin cambio de hook |
| 2026-09-18 13:45:42 | `148501f` | Stop hook lee `stop_hook_active`; añade fixture Stop | F7 A | Fixture de idempotencia y ruta de sintaxis |
| 2026-09-18 13:46:38 | `cc8634f` | Hardening regex firewall y fixture positivo | F7 B | Familias conocidas de espacios/case/read cubiertas |
| 2026-09-18 13:48:18 | `748fc6a` | Budget freshness, evaluador freshness, fixture secret-guard y wiring maintenance | Subbundle evidencia F7 | Freshness y controles positivos cableados |
| 2026-09-18 13:49:39 | `b1471d0` | Coupling contract hash de TaskCompleted y fixture | F7 C | Contract hash suministrado debe coincidir |
| 2026-09-18 13:50:46 | `7e3a9fc` | Rotación diaria mediante move y fixture | F7 D | Log activo se mueve y archives no se sobrescriben |
| 2026-09-18 13:52:01 | `7b575e1` | Preservación/prompt/force del installer y fixture | F7 E | Settings se preservan salvo reemplazo explícito |
| 2026-09-18 13:52:26 | `82aaa75` | Tolerancia adicional de espacios en lecturas de entorno del firewall | F7 B | Variantes adversariales ampliadas |
| 2026-09-18 13:53:32 | `1a3509e` | Casos de evidencia de finalización inválida | F7 C | Status/shape inválidos bloquean |
| 2026-09-18 14:05:35 | `b659dfb` | Correcciones adversariales finales de firewall y fixtures de evidencia/hooks | F7 B/C | Blockers de fresh review resueltos dentro de scope |
| 2026-09-18 14:17:57 | `3ed9609` | Documentos de cierre de evidencia, regression, estado, reporte, roadmap y plan | Docs F7 | Material de cierre EV/REG persistido |
| 2026-09-18 14:18:11 | `a770761` | Metadata de checkpoint final en estado/reporte | Docs F7 | Metadata de checkpoint actualizada |
| 2026-09-18 14:18:35 | `69b2c23` | Corrección artifact hash EV-012 | Evidencia F7 | Identidad de evidencia corregida |
| 2026-09-18 14:18:46 | `dc89939` | Metadata de cierre de estado/reporte | Docs F7 | Cierre de estado refinado |
| 2026-09-18 14:19:21 | `ec8b76e` | Alineación de identidad de tarea EV-012 | Evidencia F7 | Task ID canónico alineado |
| 2026-09-18 14:19:32 | `094413c` | Metadata de checkpoint de evidencia F7 | Docs F7 | Checkpoint de evidencia registrado |
| 2026-09-18 17:47:31 | `47874a5` | Paquete final de auditoría F7, auditoría conductual, provenance, claims e informes congelados | Cierre F7 | F7 `COMPLETE / FROZEN`; checkpoint establecido |
| 2026-09-18 18:00:39 | `c236b58` | Persistencia de `F8_RESEARCH.md`, pointers de estado, manifest y README | Investigación F8 | Investigación completa; implementación pendiente de aprobación |
| 2026-09-19 14:23:08 | `f6eb0d5` | Handoff canónico de sesión | Docs F8 | Handoff apunta a investigación y gate humano |
| 2026-09-19 16:44:05 | `f840c71` | Exige `contract_hash` en hook TaskCompleted y fixture coupling | F8-A | Hash ausente bloquea |
| 2026-09-19 16:44:55 | `0f79b68` | Rechazo inicial de payload firewall malformed/vacío y extensión fixture | F8-B | JSON inválido bloquea |
| 2026-09-19 16:45:52 | `92050dd` | Convención reviewer y enmienda in-place ARCH-004 | Docs F8 | Convención A-06 registrada |
| 2026-09-19 16:50:19 | `e25179f` | Exige exactamente un documento JSON | F8-B | Fallthrough whitespace-only/multi-document cerrado |
| 2026-09-19 16:54:57 | `1427fbe` | Rechaza NUL antes de command substitution | F8-B | Boundary NUL cerrado |
| 2026-09-19 17:04:43 | `95f1555` | Añade EV-015/EV-016 y REG-010/REG-011 | Evidencia F8 | Cierre de evidencia/regresión registrado |
| 2026-09-19 17:06:57 | `916acf7` | Post-F8 audit, provenance, claim matrix y cierre de estado/manifest/roadmap/handoff | Cierre F8 | Auditoría F8 completa; round 3 PASS |
| 2026-09-19 17:08:29 | `2cd7953` | Referencias finales de estado/checkpoint F8 | Cierre F8 | F8 `COMPLETE / FROZEN`; F9 solo research |
| 2026-09-19 17:28:29 | `bfe03b7` | Documento de investigación F9 y actualización del handoff actual | Investigación F9 | `F9 NOT JUSTIFIED`; sin cambio runtime |

El metadata superior del handoff actual registra `2cd7953` como checkpoint de
cierre F8 porque es la línea base previa a la investigación F9. El HEAD real de
Git después del commit de investigación F9 es
`bfe03b7ddd9906b4dca6acfa1ee24907cf14ba14`.

---

## 36. Estado Arquitectónico Actual

```text
F7:                  COMPLETE / FROZEN
CHECKPOINT F7:       47874a5
F8:                  COMPLETE / FROZEN
AUDIT F8:            COMPLETE / FROZEN
INVESTIGACIÓN F9:    COMPLETE
DECISIÓN F9:         F9 NOT JUSTIFIED
IMPLEMENTACIÓN:      NOT AUTHORIZED
F10-F12:             UNKNOWN / NOT STARTED
RAMA:                main
HEAD:                bfe03b7ddd9906b4dca6acfa1ee24907cf14ba14
WORKTREE:            CLEAN al iniciar la reconstrucción del dossier
```

La arquitectura operativa sigue siendo el control plane F8: contexto local al
proyecto, registries de estado, permisos, diez hooks, agents con roles, skills,
evals deterministas, evidence gate y fronteras de revisión humana. F9 no añadió
un control nuevo ni cambió un control actual.

### Frontera de sincronización del estado actual

`PROJECT_STATE.md` todavía informa `CURRENT_PHASE: 8` y
`NEXT_ALLOWED_PHASE: F9 (RESEARCH REQUIRED - no implementation authorized)`.
El documento de investigación F9 y el handoff actual informan que la
investigación F9 terminó y que la siguiente acción es revisión del owner. Esta
es una diferencia temporal documentada entre registros de estado: la tarea de
documentación F9 deliberadamente no modificó `PROJECT_STATE.md`. El estado Git
real, el artifact de investigación F9 y el handoff deben leerse juntos, sin
afirmar silenciosamente que todos los mirrors fueron sincronizados.

El dossier no resuelve esta frontera porque hacerlo sería otro cambio de estado/
documentación fuera de la salida única solicitada.

---

## 37. Qué Debe Verificar El Siguiente Auditor

El siguiente auditor debe permanecer independiente y verificar, en lugar de
aceptar este dossier como autoridad. Las superficies factuales útiles son:

1. `docs/00_SYSTEM/F7_F8_F9_TECHNICAL_HISTORY.md`, incluida su cronología de
   commits y referencias de fuente.
2. `docs/00_SYSTEM/F7_F12_RESEARCH_HANDOFF.md`, `POST_F7_AUDIT_REPORT.md` y
   documentos de claim/provenance F7.
3. `docs/00_SYSTEM/F8_RESEARCH.md`, `POST_F8_AUDIT_REPORT.md`,
   `F8_CLAIM_VS_EVIDENCE.md` y `CHANGE_PROVENANCE_F8.md`.
4. `docs/00_SYSTEM/F9_RESEARCH.md` y el handoff actual de sesión.
5. El HEAD Git actual, rama, worktree y rango `47874a5..HEAD`.
6. Preservación de prefijos de evidencia y regresiones F7/F8.
7. Paths runtime reales cambiados por F7/F8 y ausencia de paths runtime F9.
8. EV-015/EV-016 y REG-010/REG-011 contra sus fixtures y notas.
9. Rationale de candidatos F9, triggers diferidos y IDs de decisión
   F9-D01 a F9-D05.
10. Distinción entre verificación de scripts y verificación del ciclo nativo.
11. Boundary de sincronización actual entre `PROJECT_STATE.md` y handoff.
12. Ausencia de arquitectura, dependencias, hooks, agents, skills, rules o
    tipos de registry nuevos durante la investigación F9.

El auditor no debe inferir una conclusión de esta lista. Es un mapa de
superficies para inspeccionar.

---

## 38. Resumen Factual Final

- F7 fue una fase sustancial de implementación basada en evidencia que
  endureció comportamiento existente sin añadir arquitectura nueva.
- F7 cerró gaps conductuales, de patrones de seguridad, evidence coupling,
  rotación e installer y registró EV-009..EV-014/REG-002..REG-009.
- F7 está congelada en `47874a5`.
- F8 investigó los gaps restantes y seleccionó solo dos cierres runtime
  fail-closed más una convención documental.
- F8-A hizo obligatorio `contract_hash` para TaskCompleted.
- F8-B hizo fail-closed los payloads malformed, vacíos, no únicos y con NUL,
  preservando el comando vacío válido.
- A-06 documentó convenciones de reviewer y ARCH-004 fue enmendado in-place.
- F8 registró EV-015/EV-016 y REG-010/REG-011 y cerró como
  `COMPLETE / FROZEN` en `2cd7953`.
- El ciclo de vida nativo Claude Code sigue `NOT_VERIFIED` bajo OpenCode.
- F9 evaluó si se justificaba otra fase de implementación.
- F9 no encontró ningún candidato con evidencia actual suficiente y beneficio
  proporcional.
- F9 concluyó `F9 NOT JUSTIFIED`.
- La implementación F9 no se realizó y el runtime no cambió.
- F10-F12 siguen unknown y no iniciadas.
- Este dossier es exclusivamente documentación/reconstrucción.

```text
DOCUMENTATION != IMPLEMENTATION
HISTORY != CLAIM
CLAIM != EVIDENCE
SCRIPT != NATIVE
RESEARCH != AUTHORIZATION
DEFERRED != FORGOTTEN
```

---

**FIN DEL DOSSIER DE HISTORIA TÉCNICA Y ARQUITECTURA**

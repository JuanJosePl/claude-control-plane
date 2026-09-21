# SAGR: analogías funcionales en sistemas clásicos

**Fecha de corte:** 2026-09-21  
**Objeto:** State-Aware Governed Recovery (SAGR), tal como se define en `CCP_SAGR_RESEARCH_DOSSIER.md`: detectar estancamiento, ciclos, degradación de contexto, explosión de coste o bloqueo inducido por controles; recuperar mediante exploración acotada, delegación, restauración de estado, reconstrucción de contexto mínimo y reverificación.  
**Alcance:** sistemas distribuidos, bases de datos, sistemas operativos, networking, fault tolerance, reliability y workflow engines.  
**Restricción operativa:** investigación documental únicamente. No se modificó runtime, `.claude/`, `evals/`, registries ni configuración. No se ejecutaron ejemplos ni tests externos.

## 1. Resumen ejecutivo

1. **SAGR no introduce primitivas nuevas en sentido amplio.** Deadlock detection, watchdogs, backoff, circuit breakers, retry limits, backpressure, savepoints, WAL, MVCC, snapshots, replicated logs, supervisors, replay, compensations e idempotencia existen desde hace décadas o están implementados hoy en sistemas de producción.
2. **La analogía más fuerte es composicional.** Los sistemas clásicos separan detección, control de presión, persistencia del estado, recuperación y verificación. SAGR propone conectarlos alrededor de una trayectoria semántica de ejecución, especialmente cuando el bloqueo proviene de una política y no de una caída del proceso.
3. **Un límite no es una recuperación.** Un retry budget, circuit breaker, `MaxAttempts`, `StartLimitBurst` o intensidad de supervisor puede detener la repetición, pero normalmente no genera una ruta alternativa ni demuestra que la nueva ruta es compatible con la política.
4. **Un checkpoint no es un estado correcto de negocio.** WAL, un snapshot de Raft, una historia de Temporal, un checkpoint de Durable Functions o un redrive de Step Functions garantizan una posición técnica desde la que continuar. No garantizan que esa posición sea semánticamente deseable, que no haya side effects externos duplicados ni que el plan original deje de estar bloqueado.
5. **La equivalencia oculta más útil es `ack/progress -> permiso para avanzar`.** TCP usa ACK y ventanas; Reactive Streams usa `request(n)`; Raft usa `committed/applied`; PostgreSQL usa LSN y snapshots; los workflows usan eventos y checkpoints. Todos limitan lo que puede considerarse progreso durable. SAGR puede tomar esa forma, pero el significado de "progreso" en SAGR es semántico y no viene dado por esos mecanismos.
6. **El principal hueco observado en el corpus es la gobernanza de la recuperación.** No encontré un estándar o producto de los sistemas clásicos consultados que combine explícitamente: `HARD STOP vs RECOVERABLE STOP`, alternativa compatible con la política, presupuesto global de recuperación anidada, comparación `recover vs restart`, ledger de side effects fuera del contexto y verificación de progreso semántico.
7. **Ese hueco es UNKNOWN, no una prueba de inexistencia universal.** La búsqueda negativa se limita a las fuentes primarias y repositorios identificados en esta nota. No demuestra que no exista una implementación interna o no publicada.

## 2. Cómo leer la evidencia

### 2.1 Etiquetas de evidencia

- **DOCUMENTADO:** la fuente primaria afirma el comportamiento en una especificación, paper o documentación oficial.
- **OBSERVED:** se inspeccionó código, configuración o tests publicados; no se ejecutó.
- **REPRODUCED:** el comportamiento fue ejecutado en esta investigación. No hay filas con esta etiqueta: no se ejecutó ningún ejemplo externo.
- **INFERRED:** equivalencia funcional razonada a partir de una o más fuentes; no es una afirmación del sistema fuente.
- **UNKNOWN:** la fuente no permite concluirlo o la búsqueda negativa no es exhaustiva.

### 2.2 Capas de afirmación

- **CONCEPTO:** propiedad o patrón descrito por un paper, RFC o patrón arquitectónico.
- **IMPLEMENTACIÓN:** existe código, API, configuración o test que materializa la propiedad.
- **PRODUCCIÓN:** la propiedad forma parte de un sistema liberado y orientado a operación real según documentación oficial. No significa que esté desplegada en Claude Control Plane ni prueba por sí sola adopción de clientes.

`PRODUCCIÓN` se usa con prudencia: cuando sólo hay un paper o un repositorio experimental, queda en `UNKNOWN` aunque el concepto sea sólido.

## 3. Matriz de analogías

| Mecanismo clásico | Qué resuelve en su dominio | Equivalencia funcional con SAGR | Diferencia operacional crítica | Evidencia / capa |
|---|---|---|---|---|
| Deadlock detection | Detecta un ciclo de espera y aborta un participante o espera con timeout. | Detectar un ciclo de acciones, estados o bloqueos de política. | El ciclo de locks tiene una semántica formal; el ciclo semántico de un agente requiere definir equivalencia de estado y progreso. | PostgreSQL/Linux: DOCUMENTADO + OBSERVED; SAGR: INFERRED. CONCEPTO + IMPLEMENTACIÓN + PRODUCCIÓN en los sistemas fuente. |
| Livelock / stall watchdog | Detecta actividad sin avance, CPU que no llega a un punto de quiescencia o ausencia de heartbeat. | Señal de estancamiento y disparador de recuperación. | El watchdog observa tiempo, scheduling o heartbeat, no si el objetivo de negocio avanzó. | Linux RCU/systemd: DOCUMENTADO. SAGR: INFERRED. IMPLEMENTACIÓN + PRODUCCIÓN fuente. |
| Retry budget | Limita intentos o proporción de reintentos para evitar amplificación y cascadas. | Presupuesto de recuperación y governor de segundo orden. | Los presupuestos encontrados son por request, cliente, proceso, item o estado; no un presupuesto global de todas las recuperaciones anidadas. | Google SRE/Envoy/Kubernetes/Step Functions: DOCUMENTADO + OBSERVED. IMPLEMENTACIÓN + PRODUCCIÓN fuente. |
| Circuit breaker | Falla rápido o deja de intentar cuando una dependencia está degradada. | Hard stop operacional y prevención de retry storm. | Protege capacidad y latencia; no clasifica intención, no planifica alternativa y no verifica progreso semántico. | Envoy/AWS SDK: DOCUMENTADO. IMPLEMENTACIÓN + PRODUCCIÓN fuente. |
| Backpressure | Hace que el consumidor anuncie capacidad y limita buffers o emisión. | Regula fan-out, subagentes, tokens y trabajo pendiente. | Reduce flujo; no decide qué trabajo eliminar, reordenar o recuperar. | TCP/Reactive Streams/etcd raft: DOCUMENTADO + OBSERVED. IMPLEMENTACIÓN + PRODUCCIÓN fuente. |
| Savepoint | Rollback parcial dentro de una transacción local que aún no hizo commit. | Punto de retorno para descartar una rama y conservar estado previo. | No deshace llamadas externas ni sobrevive como recovery point independiente a la sesión/DB. | PostgreSQL 18.6/MySQL 8.4: DOCUMENTADO. IMPLEMENTACIÓN + PRODUCCIÓN fuente. |
| WAL / redo log | Persistencia previa de cambios y replay tras crash; permite PITR. | Ledger durable de evidencia y side effects, con posición reproducible. | Un WAL conoce el protocolo de almacenamiento; no conoce archivos, APIs, pagos o efectos externos salvo que un adaptador los haga transaccionales. | PostgreSQL/ARIES/InnoDB: DOCUMENTADO. ARIES CONCEPTO; DB IMPLEMENTACIÓN + PRODUCCIÓN. |
| MVCC / snapshots | Ofrece lecturas de versiones consistentes y permite validar conflictos. | Vista histórica del estado y comparación antes de reanudar una rama. | MVCC versiona datos; no versiona planes, permisos, evidencia ni intención. | PostgreSQL/InnoDB: DOCUMENTADO. IMPLEMENTACIÓN + PRODUCCIÓN fuente. |
| Saga / compensación | Divide una transacción distribuida en transacciones locales y compensa lo ya confirmado. | Recuperación después de side effects parciales y ruta de convergencia. | Compensar no es rollback atómico; puede fallar, no ser inverso y no restituir aislamiento. | Sagas 1987/Azure: DOCUMENTADO. CONCEPTO + PRODUCCIÓN fuente de patrones; adopción concreta UNKNOWN. |
| Checkpoint / replay | Reconstituye el estado desde log, snapshot o historia. | Restaurar un estado de ejecución mínimo y continuar. | Replay exige determinismo o idempotencia; el mismo plan puede repetir el mismo bloqueo. | Chandy-Lamport/Temporal/Azure/Step Functions/Raft: DOCUMENTADO + OBSERVED. |
| Supervisor / watchdog | Observa procesos, reinicia hijos y limita intensidad de restart. | Aislar fallos, reiniciar worker o escalar una recuperación. | Reinicia el contenedor de ejecución; no repara un estado semántico ni conserva automáticamente side effects. | Erlang OTP 29.1/systemd/Linux: DOCUMENTADO + OBSERVED. IMPLEMENTACIÓN + PRODUCCIÓN fuente. |
| Durable execution | Mantiene una workflow history para tolerar crash, eviction o reinicio de worker. | Continuidad de una trayectoria sin depender del contexto en memoria. | Está orientado a fallos de infraestructura; no equivale a recuperación de un plan incorrecto o bloqueado por policy. | Temporal/AWS/Azure: DOCUMENTADO. IMPLEMENTACIÓN + PRODUCCIÓN fuente. |
| Idempotency | Hace seguro repetir una operación identificando el intento lógico y reutilizando el resultado. | Permite retries/redrive/replay sin duplicar efectos. | Sólo funciona si el receptor persiste la clave y la aplica de forma atómica o semánticamente segura. | Stripe/IETF draft/AWS: DOCUMENTADO. IMPLEMENTACIÓN + PRODUCCIÓN fuente; estándar HTTP definitivo UNKNOWN. |
| Event sourcing | Guarda eventos inmutables, rehidrata estado y crea proyecciones. | Historial completo, reconstrucción de estado y auditoría de trayectoria. | El event stream no impone por sí mismo avance, política, orden global ni idempotencia de consumidores. | Azure pattern/Durable Functions: DOCUMENTADO. CONCEPTO + IMPLEMENTACIÓN; adopción concreta UNKNOWN. |
| Failover / replicated log | Cambia de líder o réplica conservando safety bajo fallos. | Reubicar la ejecución y reconstruir estado desde un punto durable. | Failover preserva una historia aceptada por el protocolo; no elige la mejor alternativa de negocio ni garantiza que el líder viejo no tenga efectos externos pendientes. | Raft/etcd/PostgreSQL warm standby: DOCUMENTADO + OBSERVED. IMPLEMENTACIÓN + PRODUCCIÓN fuente. |
| Recovery point | Define hasta qué LSN, índice, evento o step se puede restaurar. | Punto conocido desde el que SAGR puede reanudar o bifurcar. | Consistencia técnica no implica corrección semántica; el punto puede preceder a un efecto externo no registrado. | PostgreSQL PITR/Raft snapshots/Temporal/AWS: DOCUMENTADO + OBSERVED. |

## 4. Deadlock, livelock y estancamiento

### 4.1 Deadlock: ciclo formal de espera

PostgreSQL 18 documenta el caso clásico: dos transacciones mantienen locks que la otra necesita. El servidor detecta el deadlock y aborta una transacción; si no se detecta, una espera de lock puede durar indefinidamente. La misma documentación recomienda adquirir objetos en orden consistente y, cuando no se puede evitar, reintentar la transacción abortada completa [S08]. InnoDB hace algo equivalente: con `innodb_deadlock_detect` activado, detecta el ciclo y elige una víctima, normalmente una transacción pequeña; con la detección desactivada depende de `innodb_lock_wait_timeout` [S09].

**Equivalencia SAGR:** un `wait-for graph` es un caso formal de `state graph`. El abort de la víctima es un `HARD/RECOVERABLE STOP` muy restringido: se descarta una unidad de trabajo, se conserva el estado durable de los demás y se reintenta la unidad abortada.

**Diferencia:** el motor de base de datos sabe qué es un lock, qué transacciones lo sostienen y qué significa rollback. SAGR tendría que definir qué significa que dos acciones sean equivalentes aunque cambien texto, tool o subagente. La detección de `A -> B -> A` no basta para detectar un ciclo semántico de planes.

### 4.2 Lockdep: detección de ciclos potenciales

El kernel Linux `lockdep` construye dependencias entre clases de lock a partir de secuencias observadas. La documentación describe que una inversión `L1 -> L2` y `L2 -> L1` puede formar un ciclo y que el validador puede detectarlo aunque la combinación completa de tareas aún no haya ocurrido. También distingue clases de lock y contextos de IRQ, y reconoce que hay excepciones de orden jerárquico [S13].

Esto es una analogía especialmente útil para el **state fingerprint** de SAGR:

- La identidad no es sólo el nombre del lock: incluye clase, contexto y orden.
- El sistema registra una relación de precedencia, no sólo el último evento.
- El detector intenta demostrar una posibilidad de bloqueo, no esperar a que el sistema se congele.

La diferencia es que `lockdep` opera sobre un grafo finito y tipado; un fingerprint de agente podría contener texto, estado de archivos, evidencia, permisos, coste y contexto, por lo que la equivalencia no es decidible de forma general. La equivalencia semántica de dos estados SAGR queda `UNKNOWN` como mecanismo general.

### 4.3 Livelock y watchdog: actividad sin avance

El documento de RCU del kernel identifica como causas de un CPU stall un CPU que gira en una sección crítica, corre con interrupciones o preemption deshabilitadas, o impide que los hilos de grace period se ejecuten. El detector emite una advertencia después de un umbral temporal; el valor normal documentado para `CONFIG_RCU_CPU_STALL_TIMEOUT` es 21 segundos [S14]. No decide una nueva ruta de ejecución.

Google SRE describe otro caso funcionalmente parecido: varios proposers pueden competir en una elección de líder y ninguno avanzar; backoff aleatorio reduce el problema de “dueling proposers” [S29]. No es un deadlock formal, porque hay actividad y mensajes, pero el progreso útil es cero o muy bajo. La etiqueta `livelock` es aquí una **INFERENCIA**, no el nombre normativo de esas fuentes.

**Implicación para SAGR:**

- Deadlock: no hay transición útil porque existe una espera circular; abortar una rama puede liberar el sistema.
- Livelock: sí hay transiciones, pero no aumenta el estado útil; repetir con backoff solamente puede reducir carga, no encontrar una solución.
- Stall semántico: el agente puede producir texto, llamadas o archivos diferentes sin cambiar el estado verificable. Requiere una métrica de progreso, no sólo un contador de pasos.

## 5. Retry budgets y circuit breakers

### 5.1 Lo que realmente significa un retry budget

Google SRE distingue varias capas:

- máximo de intentos por request;
- presupuesto por cliente medido como proporción de retries frente a requests originales;
- presupuesto de servidor, por ejemplo un número máximo de retries por minuto;
- rechazo explícito de errores que no deben reintentarse.

El capítulo de overload muestra un ejemplo de hasta tres intentos por request y un límite de 10% de retries por cliente. La motivación es limitar la multiplicación de carga: en una pila con retries en varias capas, tres reintentos por capa pueden convertir una llamada lógica en `4^3 = 64` llamadas al backend [S02]. El capítulo de cascading failures recomienda backoff exponencial aleatorio y un presupuesto de retries a nivel de servidor [S01].

**Equivalencia SAGR:** el presupuesto no representa sólo dinero. Es una cuota de oportunidad de recuperación: cuántas acciones adicionales puede consumir una rama antes de ser detenida. El dato importante es el **scope** del presupuesto.

**Diferencia:** el retry budget de SRE protege capacidad y disponibilidad del servicio. No mide si el agente aprendió, si cambió de hipótesis o si la nueva acción satisface la policy. El error budget de SRE tampoco es un recovery budget: es margen de incumplimiento del SLO para gobernar cambios.

### 5.2 Envoy: retry budget concurrente

La API v3 de Envoy define `retry_budget` como un límite de retries concurrentes relativo a requests activos y pendientes. La documentación actual de Envoy 1.40.0-dev muestra un ejemplo con 25% y mínimo de 10, y especifica un default de 20% y mínimo de 3 si no se configura [S04]. El presupuesto puede reemplazar al circuit breaker estático de `max_retries`.

La equivalencia oculta es fuerte: el sistema no pregunta si cada retry va a triunfar; limita la cantidad de energía que puede consumir la reacción a un fallo. La diferencia es igualmente importante: mide concurrencia de solicitudes, no historia de recuperación, coste acumulado ni progreso.

### 5.3 Kubernetes workqueue: presupuesto distribuido entre item y cola

El código actual de `client-go` combina en `DefaultTypedControllerRateLimiter`:

- `TypedItemExponentialFailureRateLimiter` por item, de 5 ms a 1000 s;
- `TypedBucketRateLimiter` global, 10 QPS y burst 100;
- `MaxOfRateLimiter`, que elige el delay mayor.

`Forget` elimina el contador del item. Los tests publicados verifican la secuencia 1, 2, 4, 8, 16 ms, el reset de `Forget` y la combinación `MaxOf` [S24]. El código de esta investigación fue inspeccionado, no ejecutado: `OBSERVED`, no `REPRODUCED`.

Para SAGR, este es un patrón concreto de **presupuesto local + presupuesto global**. Pero la implementación no tiene un máximo semántico de reintentos por objetivo: el item puede continuar entrando a la cola durante mucho tiempo, cada vez con mayor delay, salvo que el controlador llame a `Forget`, elimine el item o imponga otro límite.

### 5.4 SDK de AWS: token bucket como circuit breaker

La documentación actual del SDK de Kotlin describe un retry token bucket. Los fallos consumen capacidad; los éxitos pueden devolver tokens; cuando la capacidad llega a cero, el SDK falla inmediatamente con `Retry capacity exceeded`, sin intentar la operación. El modo adaptativo añade rate limiting basado en throttling [S28].

Esto se acerca a un **circuit breaker de carga** y a un governor de segundo orden, pero no a un clasificador SAGR. El SDK sabe que continuar es demasiado costoso o probablemente inútil; no sabe qué alternativa conserva la intención del task.

### 5.5 Límites de la analogía

Un presupuesto de retries sólo es seguro si se combinan:

- clasificación de errores transitorios frente a permanentes;
- backoff y jitter;
- una sola capa responsable del retry, para evitar multiplicación;
- idempotencia o semántica segura de repetición;
- límite de tiempo total, no sólo de número de intentos.

Si se trasladara literalmente a SAGR, faltaría añadir `recovery_depth`, `recovery_cost`, `paths_already_tried`, `policy_constraints` y una condición de progreso. Esos campos no aparecen como contrato común en las fuentes consultadas: `UNKNOWN`.

## 6. Backpressure y control de capacidad

### 6.1 Reactive Streams: demand explícita y buffers acotados

Reactive Streams 1.0.4 define una interfaz mínima para streams asíncronos con backpressure no bloqueante. La regla 1.1 exige que un `Publisher` no emita más `onNext` que elementos solicitados por el `Subscriber`; las reglas 3.5 y 3.6 hacen `cancel` idempotente y convierten requests posteriores en no-op. La especificación explica que los buffers deben ser acotados y controlados por el consumidor [S05].

El TCK de la misma versión prueba reglas `MUST`, `SHOULD` y casos de error; también reconoce que algunas reglas no pueden verificarse automáticamente [S05]. Esto ofrece una analogía directa con un gate de evidencia: no basta con declarar que hay backpressure, hay que verificar contratos observables.

**SAGR:** `request(n)` puede ser el permiso para que un explorador produzca hasta `n` resultados.  
**No equivale a:** seleccionar el mejor resultado, validar policy o saber si el resultado cambió el objetivo.

### 6.2 TCP: ACK, ventana, retransmisión y recuperación de congestión

RFC 9293 define TCP como stream fiable y ordenado, con números de secuencia, ACK acumulativos, retransmisión y ventanas de recepción. RFC 5681 define slow start, congestion avoidance, fast retransmit y fast recovery; `cwnd` limita la cantidad de datos en vuelo y `rwnd` la capacidad anunciada por el receptor [S06][S07].

La equivalencia funcional es instructiva:

- un ACK confirma recepción, no corrección de negocio;
- una ventana limita trabajo en vuelo, no el total de trabajo posible;
- una pérdida reduce la tasa y activa recuperación localizada;
- una secuencia evita aceptar datos de una encarnación anterior;
- el timeout es una señal de falta de progreso observable.

TCP no sabe si el payload representa una orden segura, ni puede deshacer un side effect en el receptor. Del mismo modo, SAGR no puede tratar un `tool call completed` como prueba de que el objetivo avanzó.

### 6.3 etcd/raft: backpressure del estado aplicado

El código `go.etcd.io/raft/v3` separa `committed`, `applying` y `applied`. `maxApplyingEntsSize` limita bytes pendientes de aplicación; cuando se alcanza, `applyingEntsPaused` evita entregar más entradas hasta que la aplicación confirme progreso mediante `appliedTo`. El `Ready` exige persistir entradas antes de enviar mensajes cuando no se usan escrituras asíncronas [S12].

Los tests `TestAcceptApplying`, `TestAppliedTo`, `TestNextCommittedEnts` y `TestCompactionSideEffects` comprueban precisamente la pausa, el avance reconocido, los límites y la compactación [S12]. Es una analogía de alta calidad para SAGR porque separa:

- lo comprometido por consenso;
- lo que la aplicación está procesando;
- lo que realmente aplicó;
- la presión para no producir más trabajo.

No es un detector de progreso semántico: `applied` puede avanzar aunque el comando aplicado sea una decisión de negocio equivocada.

## 7. Bases de datos: savepoints, WAL, MVCC y puntos de recuperación

### 7.1 Savepoints: rollback local, no máquina del tiempo global

PostgreSQL 18 documenta que `SAVEPOINT` marca una posición dentro de una transacción y que `ROLLBACK TO SAVEPOINT` revierte los comandos posteriores manteniendo viva la transacción. `RELEASE SAVEPOINT` conserva los cambios y los integra en el contexto transaccional anterior [S08]. Los locks adquiridos después del savepoint también se liberan al hacer rollback a ese savepoint.

Esto se parece a una rama SAGR:

- se conserva un prefijo validado;
- se descarta una exploración posterior;
- la ejecución puede probar otra operación dentro del mismo dominio transaccional.

Pero no es un checkpoint SAGR general:

- sólo cubre recursos y operaciones que participan en la transacción;
- no revierte un correo, API, pago, proceso o archivo externo;
- no convierte un plan inválido en un plan alternativo;
- si la sesión muere o la transacción hace commit, el savepoint deja de ser utilizable.

El manual de MySQL 8.4 documenta igualmente `SAVEPOINT`, `ROLLBACK TO SAVEPOINT` y `RELEASE SAVEPOINT`; las diferencias de implementación no cambian esta frontera [S09].

### 7.2 WAL y ARIES: preservar antes de aplicar

PostgreSQL describe WAL con la regla: los cambios de los data files se escriben sólo después de persistir los registros WAL que los describen. Tras un crash se pueden rehacer los cambios desde el WAL. El mismo mecanismo habilita backups continuos y point-in-time recovery [S08].

El paper ARIES de Mohan et al. formaliza la familia de técnicas de logging con análisis, redo y undo; es una fuente conceptual primaria para entender por qué un log durable, un LSN y un checkpoint no son lo mismo que una copia completa [S10]. El DOI de ACM fue accesible como metadata del paper, no como texto completo en esta sesión.

**Equivalencia oculta con SAGR:** la regla "persistir la evidencia del cambio antes de confiar en el estado derivado" es un patrón de continuidad de evidencia. Un side-effect ledger SAGR tendría una función análoga a WAL.

**Diferencias que bloquean una traslación literal:**

- WAL conoce el formato y la atomicidad del storage engine.
- El redo de una página no reenvía una API ni vuelve a cobrar una tarjeta.
- El WAL puede restaurar consistencia física/lógica de la base, pero no configuración manual ni sistemas externos; PostgreSQL lo documenta explícitamente para PITR.
- Si el archive se retrasa, crece `pg_wal` y puede producir un shutdown; el sistema no oculta el coste de una cadena de recuperación incompleta.

### 7.3 MVCC: versiones y validación de conflictos

PostgreSQL 18 usa MVCC: cada sentencia ve un snapshot y los lectores no bloquean a los escritores. `Repeatable Read` conserva una vista estable y puede abortar la transacción con `could not serialize access due to concurrent update`; la documentación exige abortar y reintentar la transacción completa. `Serializable` detecta anomalías de serialización y también exige manejar `SQLSTATE 40001` [S08].

InnoDB 8.4 mantiene `DB_TRX_ID`, `DB_ROLL_PTR` y undo records para reconstruir versiones anteriores y soportar rollback y consistent reads [S09].

**SAGR:** un snapshot es una representación de `state_t` que permite comparar una rama con el estado que existía antes de una exploración. La detección de conflicto de serialización se parece a una verificación posterior a la recuperación.

**No es SAGR:** MVCC no captura la intención del agente, el motivo de un bloqueo, las llamadas que no tocaron la DB ni la validez de una policy. Una versión vieja de una fila no es automáticamente una alternativa válida.

### 7.4 Deadlock y retry de transacción

La práctica de abortar una víctima y reintentar una transacción completa es una versión madura de `stop -> restore local state -> replay`. El alcance es preciso: la unidad de recuperación es la transacción y el motor conoce sus efectos. SAGR tendría que decidir cuál es su unidad equivalente: tool call, subtask, etapa, workflow completo o sesión.

## 8. Saga y compensación

El paper original de Sagas propone descomponer transacciones largas en una secuencia de transacciones cortas y asociar compensaciones cuando una transacción posterior falla [S26]. La documentación de Azure, actualizada en 2026, distingue:

- transacciones compensables;
- una transacción pivote que marca un punto de no retorno;
- transacciones posteriores que deben ser idempotentes y reintentables;
- choreography frente a orchestration;
- anomalías por ausencia de aislamiento entre servicios;
- el hecho de que una compensación puede fallar.

**Equivalencia SAGR:** cuando la ejecución ya hizo side effects irreversibles o independientes, la recuperación no puede ser `rollback`; debe ser una secuencia compensatoria o una convergencia a otro estado válido. La noción de pivote es una forma explícita de recovery boundary.

**Diferencias operacionales:**

1. Una compensación no garantiza el estado anterior. Puede emitir una acción opuesta, corregir una proyección o registrar una cancelación, pero no borrar el hecho de que el efecto ocurrió.
2. No existe aislamiento global. Puede haber lecturas sucias, lost updates o estados parcialmente visibles.
3. El coordinador de una saga puede ser un nuevo punto de fallo; choreography reduce ese punto único pero puede introducir ciclos entre participantes.
4. Compensar un bloqueo de policy no debe convertirse en una vía alternativa para conseguir el mismo resultado prohibido. SAGA resuelve consistencia posterior a un efecto autorizado; no autoriza a rodear un control.

Por eso, llamar "saga" a cualquier retry de SAGR sería incorrecto. Saga aplica cuando ya existe una secuencia de efectos locales y una política de compensación; una exploración pre-side-effect es otra cosa.

## 9. Checkpoint, replay y durable execution

### 9.1 Snapshot distribuido

Chandy y Lamport describen un algoritmo para registrar un estado global consistente de un sistema distribuido, incluyendo el tratamiento de mensajes en tránsito [S25]. La analogía con SAGR es el intento de capturar no sólo el estado local del worker, sino también el contexto de mensajes, tareas pendientes y fronteras de causalidad.

El límite es central: un snapshot consistente no implica que el estado sea correcto respecto al objetivo. Es un corte coherente de la ejecución, no una aprobación.

### 9.2 Temporal: historia durable y replay determinista

La documentación actual de Temporal describe `Event History` como un log durable de los eventos de un Workflow. El worker reconstruye el estado reejecutando el código y comparando los Commands generados con la historia; los Activities ya completados no se ejecutan de nuevo durante replay [S17].

Detalles operacionales relevantes:

- los Workflows deben ser deterministas;
- las operaciones no deterministas y las llamadas externas deben vivir en Activities;
- Activities tienen Retry Policy por defecto con backoff exponencial y `Maximum Attempts = infinity` cuando es cero;
- Workflows no tienen retry policy por defecto;
- la documentación desaconseja reintentar el Workflow completo porque puede repetir el mismo plan y el mismo fallo;
- la historia tiene límites y `Continue-As-New` inicia una nueva ejecución conservando el estado que el Workflow decida pasar.

Esto aproxima muy bien `checkpoint/replay + idempotency`, pero no resuelve la recuperación semántica. Un Workflow determinista que siempre elige una ruta bloqueada puede fallar o reintentarse sin descubrir otra. Un Activity externo puede haber aplicado el efecto antes de que el worker pierda la respuesta; por eso Temporal exige que el código del Activity sea idempotente o tolere reejecución.

### 9.3 AWS Step Functions: Retry, Catch y redrive

La documentación actual de Step Functions define `Retry` con `MaxAttempts`, `IntervalSeconds`, `BackoffRate`, `MaxDelaySeconds` y `JitterStrategy`. El default documentado es tres intentos, backoff 2.0 y jitter desactivado. `Catch` transfiere el input y el error a un estado alternativo [S18].

`RedriveExecution` continúa un Standard Workflow fallido desde el step no exitoso y conserva resultados e historial de los pasos exitosos. Tiene límites operacionales documentados: elegibilidad de 14 días, máximo de ejecución de un año y límites de eventos. En un redrive, el contador de retry de ciertos estados vuelve a cero [S18].

**Analogía SAGR:** redrive es una restauración parcial con historial preservado.  
**Riesgo SAGR:** resetear contadores locales al redrive demuestra por qué un presupuesto de recuperación debe vivir fuera de la unidad que se redrivea si se quiere evitar un presupuesto global infinito.

Step Functions no garantiza que repetir un `Task` no duplique un efecto. El operador debe diseñar el `Task` con idempotencia o una clave de operación.

### 9.4 Azure Durable Task / Durable Functions

La documentación de Microsoft, actualizada el 2026-08-24, indica que los orchestrators usan event sourcing y deben ser deterministas; llamadas externas, reloj, UUID aleatorio y I/O directo deben estar fuera del orchestrator o utilizar APIs durables [S19]. La vista general, actualizada el 2026-08-14, documenta checkpoints automáticos al hacer `await`/`yield`, historial append-only y replay completo del orchestrator [S19].

El mismo documento advierte que el proveedor Azure Storage no ofrece garantías transaccionales entre Table Storage y queues; usa patrones de consistencia eventual. Otros proveedores, como Durable Task Scheduler o MSSQL, ofrecen propiedades distintas [S19]. Esta diferencia es relevante para SAGR: "durable" no es una propiedad única, sino un contrato dependiente del storage provider.

## 10. Supervisors, watchdogs y fault isolation

### 10.1 Erlang/OTP

La documentación de Erlang OTP 29.1 define un supervisor como responsable de iniciar, parar y monitorizar hijos. Las estrategias `one_for_one`, `one_for_all` y `rest_for_one` determinan el alcance del restart. `intensity` y `period` limitan la cantidad de restarts; si se supera el límite, el supervisor termina y escala la decisión al supervisor padre [S16].

La fuente incluye dos advertencias directamente relevantes:

- una intensidad demasiado permisiva puede reiniciar indefinidamente y llenar logs;
- en árboles anidados, el número total de restarts puede ser el producto de las intensidades de los supervisores superiores.

Esto es un precursor claro de un **second-order recovery governor**. También muestra el problema del blast radius: `one_for_all` recupera coherencia entre hijos cooperantes, pero destruye más estado que `one_for_one`.

La pérdida de hijos añadidos dinámicamente cuando el supervisor se recrea es otra diferencia importante: reiniciar el coordinador no equivale a reconstruir todo el contexto de trabajo.

### 10.2 systemd

El código fuente actual de `systemd.service` describe `WatchdogSec=`: el proceso debe enviar `WATCHDOG=1`; si no llega el ping dentro del intervalo, systemd marca el servicio fallido y lo termina. `Restart=` puede reiniciarlo. También documenta `RestartSec=`, pasos exponenciales (`RestartSteps=`/`RestartMaxDelaySec=`), `RestartRandomizedDelaySec=` y límites de start mediante `StartLimitIntervalSec=`/`StartLimitBurst=` [S15].

Estas piezas cubren:

- heartbeat de vida;
- detección temporal de stall;
- restart con backoff;
- jitter para evitar que instancias fallen y reinicien juntas;
- límite de restart para no crear un bucle de recuperación.

No cubren:

- si el proceso hizo progreso de negocio;
- qué side effects dejó antes de morir;
- si restart es más barato que reconstruir contexto;
- si la nueva instancia puede ejecutar la misma operación sin duplicarla.

### 10.3 Linux RCU y lockdep

RCU stall detector y lockdep complementan a un supervisor: uno detecta falta de quiescencia/progreso temporal; el otro detecta dependencias de locks potencialmente cíclicas. Ambos son evidencia de que el sistema operativo separa **detección de salud** de **acción correctiva**. La acción correctiva puede ser un warning, abortar, matar o escalar; no necesariamente una reparación semántica.

## 11. Idempotencia y efectos externos

Stripe documenta un contrato concreto para `Idempotency-Key`: conserva status y body del primer request, incluso si fue `500`; rechaza una reutilización con parámetros distintos; puede eliminar claves después de al menos 24 horas; y no guarda resultado si la validación falla o si otra request idéntica está ejecutándose de forma concurrente [S22].

Este comportamiento es mucho más preciso que decir "POST es retryable":

- la clave identifica la operación lógica, no el intento de transporte;
- el servidor debe asociar clave, parámetros y resultado;
- la ventana de retención cambia el significado de un retry tardío;
- el resultado persistido puede ser un error, por lo que un retry no significa volver a ejecutar.

La búsqueda IETF no encontró un RFC definitivo de `Idempotency-Key` a la fecha de corte. El documento recuperado es `draft-ietf-httpapi-idempotency-key-header-07`, publicado el 2025-10-15 y expirado el 2026-04-18 [S23]. Por tanto:

- el concepto está DOCUMENTADO;
- existen implementaciones PRODUCCIÓN como Stripe;
- la estandarización HTTP definitiva queda UNKNOWN;
- RFC 9457 no es un RFC de idempotencia: es `Problem Details for HTTP APIs`, publicado en julio de 2023, y no debe citarse como tal.

**SAGR:** cualquier retry, redrive, replay o reanudación que pueda tocar el mundo externo necesita `operation_id`, idempotency key, resultado durable y una política explícita para `in-flight`/`unknown outcome`. Sin eso, un WAL de la conversación no prueba que el efecto no se duplicó.

## 12. Event sourcing y reconstrucción de estado

La guía oficial de Azure sobre Event Sourcing, actualizada en 2026, describe un event stream append-only como fuente de verdad; el estado actual se rehidrata reproduciendo eventos. También documenta snapshots como optimización, no como reemplazo del stream, y exige controlar versionado, orden, consistencia eventual e idempotencia de consumidores [S20].

Dos detalles son particularmente relevantes para SAGR:

1. La guía advierte que los consumers suelen recibir eventos **at least once**; una proyección debe ser idempotente o rastrear el último número de secuencia.
2. La guía advierte que un handler que genera otro evento puede crear lógica circular e infinite loop. Esto es un antecedente directo de `livelock` a nivel de workflow, aunque no use la etiqueta SAGR.

La misma guía distingue un event store de un message broker: Kafka puede distribuir eventos, pero no sustituye automáticamente la consulta por entidad, concurrencia optimista ni semántica de event store [S20].

**Equivalencia:** el historial de SAGR puede ser un event stream de decisiones, evidencia, bloqueos y side effects.  
**Diferencia:** event sourcing reconstruye el estado que el modelo de eventos define; no decide si el estado reconstruido sigue autorizado por una policy nueva ni si el objetivo original continúa siendo válido.

## 13. Failover, consensus y recovery points

### 13.1 Raft: safety antes que progreso

La página oficial de Raft y el paper de Ongaro/Ousterhout explican que los servidores mantienen una state machine y un log; un cluster de cinco puede continuar con una mayoría de tres, y cuando no hay mayoría deja de progresar sin devolver un resultado incorrecto [S11].

El código actual de `etcd-io/raft` muestra el contrato operativo:

- `Ready.Entries` y `HardState` deben guardarse antes de enviar mensajes cuando la storage es síncrona;
- `CommittedEntries` sólo se aplican después de estar en storage estable;
- `Snapshot` se persiste y aplica como recovery point;
- `Advance` confirma que la aplicación consumió el progreso;
- una propuesta puede perderse sin aviso y es responsabilidad del usuario reintentarlo;
- `ReportSnapshot(SnapshotFailure)` es necesario para que el líder salga del limbo de un follower que no aplicó el snapshot.

Los tests de `raftLog` verifican conflictos de términos, compactación, restore desde snapshot, límites de aplicación y el hecho de que el commit nunca retrocede [S12]. No se ejecutaron.

**SAGR:** Raft ofrece una gramática sólida para `term/index/commit/applied`, fencing lógico y recuperación de una state machine replicada.  
**No ofrece:** elegir una alternativa semántica a una acción prohibida, deshacer un API externo o comparar el coste de recuperación con restart.

### 13.2 PostgreSQL PITR, warm standby y timelines

PostgreSQL 18.6 documenta que WAL puede reproducirse hasta un tiempo, LSN, transaction ID o restore point; puede detenerse en un recovery target y crear una nueva timeline después del fork. También permite alimentar un warm standby con el mismo base backup y la secuencia de WAL [S08].

La analogía con SAGR es exacta para **recovery point + branch history**:

- el LSN es un cursor de reconstrucción;
- el restore point nombra una frontera operacional;
- una timeline evita mezclar el futuro de una rama recuperada con el futuro abandonado;
- un standby mantiene una copia casi actualizada.

El sistema no dice que el punto elegido sea el último estado de negocio correcto. La documentación pide inspeccionar el estado recuperado y permite repetir la recuperación con otro target. Esa separación entre replay técnico y aprobación humana es un límite importante para SAGR.

## 14. Qué está realmente establecido frente a SAGR

| Primitiva SAGR | Equivalentes comprobados | Estado del equivalente | Lo que todavía falta para llamarlo SAGR |
|---|---|---|---|
| State fingerprint | Raft `(term,index)`, WAL LSN, event sequence, MVCC snapshot, retry count | DOCUMENTADO; algunos OBSERVED en etcd | Un fingerprint que incluya objetivo, plan, policy, evidencia, side effects y coste, con equivalencia semántica en vivo. |
| Progress signal | ACK, TCP window, `applied`, `request(n)`, heartbeat, commit index | DOCUMENTADO + OBSERVED | Medida de progreso hacia el objetivo, no sólo entrega/aplicación técnica. |
| Loop detector | lockdep, RCU stall, circuit breaker, rate limiter, retry count | DOCUMENTADO + OBSERVED | Detectar oscilación semántica y equivalencia de estados superficiales distintos. |
| Hard vs recoverable stop | DB victim/retry, non-retryable error, `Catch`, supervisor escalation | DOCUMENTADO de forma local | Clasificador general y conservador de bloqueo de policy frente a acción insegura. UNKNOWN como estándar común. |
| Recovery planner | Saga compensation, Catch branch, supervisor strategy | DOCUMENTADO | Generar una alternativa que preserve objetivo permitido sin convertir el planner en bypass de policy. UNKNOWN en el corpus. |
| Bounded exploration | Raft election backoff, retries con MaxAttempts, restart intensity, branching de workflow | DOCUMENTADO | Adjudicación entre ramas según novedad, progreso, coste y policy. |
| Minimum sufficient context | Snapshot + log, event history, WAL + base backup | DOCUMENTADO | Selección automática de contexto mínimo que conserve side effects y restricciones. UNKNOWN. |
| Recovery budget separado | límites locales de retries/restarts | DOCUMENTADO | Presupuesto global que cubra tarea, subagentes y recuperación de la recuperación. UNKNOWN. |
| Recover vs restart cost | timeouts, rate limits, budgets | Sólo INFERRED como necesidad | Ninguna fuente primaria consultada documenta una decisión general basada en coste esperado de recuperar frente a reiniciar. UNKNOWN. |
| Side-effect ledger | WAL local, event history, idempotency store, saga log | DOCUMENTADO por separado | Ledger provider-agnostic de efectos externos, durable y obligatorio en compaction/replay. UNKNOWN como capacidad general. |
| Verification after recovery | Serializable retry, replay command matching, TCK, restore inspection | DOCUMENTADO + OBSERVED | Verificar que hubo progreso semántico y que la policy sigue satisfecha. |
| Historical failed-path registry | event history, logs, compensation history | DOCUMENTADO por separado | Índice vivo que impida repetir una ruta bloqueada en otra rama. UNKNOWN. |

## 15. Diferencias operacionales que no deben ocultarse

### 15.1 Seguridad frente a liveness

Raft detiene progreso sin mayoría para preservar safety. PostgreSQL aborta una transacción para romper deadlock. Envoy corta retries para proteger capacidad. systemd puede matar un proceso que no envía heartbeat. Todas son respuestas correctas en su dominio, pero ninguna autoriza a "probar otra cosa".

En SAGR, clasificar un bloqueo de policy como recuperable es una decisión de seguridad. El default conservador debe ser `HARD STOP` cuando no se puede demostrar que la nueva ruta está dentro de autorización y no intenta conseguir el mismo resultado prohibido por otro camino.

### 15.2 At-least-once, at-most-once y exactly-once

- Retry y redrive tienden a producir at-least-once execution.
- Circuit breaker puede producir at-most-once attempt, pero no garantiza efecto cero si el servidor procesó y la respuesta se perdió.
- Idempotency key puede hacer que múltiples deliveries produzcan un único resultado lógico, pero sólo dentro del contrato del receptor.
- `exactly once` de un workflow interno no implica exactly-once en un sistema externo.

### 15.3 Localidad de rollback

Savepoint, MVCC undo y WAL revierten o reconstruyen dentro de un recurso coordinado. Saga y compensación operan después del commit de recursos independientes. No hay una equivalencia legítima entre `ROLLBACK TO SAVEPOINT` y "deshacer lo que el agente hizo en el mundo".

### 15.4 Determinismo frente a creatividad

Temporal y Durable Functions necesitan que el orchestrator produzca las mismas decisiones durante replay. La recuperación SAGR propuesta puede necesitar cambiar de plan. Por tanto, el plan creativo debe vivir en una rama nueva o en una Activity controlada, mientras que el motor durable debe conservar la historia anterior y verificar que la transición nueva es legal. Mezclar replay determinista con generación libre en el mismo nivel puede romper la reconstrucción.

### 15.5 Recovery point frente a known-good point

Un LSN, snapshot index, event number o Workflow Task boundary es un recovery point técnico. Sólo se convierte en `known-good` si existe una verificación externa de invariantes, evidencia y efectos. Esta distinción es la más importante para no sobrerrepresentar WAL, event sourcing o durable execution como SAGR completo.

## 16. Búsquedas negativas y límites de ausencia

Se buscaron en documentación oficial, RFCs, papers y código/tests las siguientes combinaciones, en inglés y español cuando aplicaba:

| Búsqueda negativa | Resultado en el corpus | Clasificación correcta |
|---|---|---|
| `SAGR` / `State-Aware Governed Recovery` en PostgreSQL, Linux, systemd, Erlang, Envoy, RFC, Temporal, AWS Step Functions, Azure Durable Task | No apareció como término propio de esos sistemas. | DOCUMENTADO sólo como hipótesis del dossier; equivalencia externa UNKNOWN. |
| `policy-block recovery` + `policy-compliant alternative` en esos sistemas | No apareció una primitive nombrada que genere alternativas autorizadas después de un policy block. | NOT FOUND EN EL CORPUS; no prueba ausencia universal. |
| `global retry budget` para retries anidados, subagents y recovery | Se encontraron budgets locales, token buckets, ratios y restart intensity; no un contrato global común. | NOT OBSERVED; estado global UNKNOWN. |
| `recovery cost vs restart cost` en durable execution y workflow engines | Se encontraron límites, timeouts y billing, no una decisión general basada en coste esperado. | NOT OBSERVED; UNKNOWN. |
| `side-effect WAL` provider-agnostic para compaction/replay de agentes | Se encontraron WAL de DB, histories de workflows e idempotency stores, pero no un ledger universal de efectos externos. | NOT OBSERVED; UNKNOWN fuera de este corpus. |
| `Idempotency-Key RFC` | El IETF draft-07 estaba expirado el 2026-04-18; no se encontró RFC definitivo en la consulta. | CONCEPTO DOCUMENTADO; estándar definitivo UNKNOWN. |
| `semantic progress` como contrato de circuit breaker clásico | Los sistemas consultados miden salud, carga, ACK, commits o timeouts; no una semántica común de progreso del objetivo. | INFERRED gap; UNKNOWN global. |

La ausencia se debe leer como `NOT FOUND / UNKNOWN`, nunca como `CONTRADICTED`. Sistemas internos, productos no documentados, papers no indexados o documentación detrás de autenticación pueden cerrar cualquiera de estos huecos.

## 17. Reproducción y comandos

No se ejecutaron ejemplos, benchmarks ni tests externos. Por tanto:

- `REPRODUCED`: ninguno.
- `OBSERVED`: inspección de código/tests publicados de etcd/raft, Kubernetes workqueue, Reactive Streams TCK y systemd; lectura de documentación oficial de los demás sistemas.
- `/tmp`: no se crearon artefactos ni clones.
- El workspace del control plane no recibió cambios de runtime.

Bloqueos de acceso documentados, sin convertirlos en silencio:

- ACM respondió `403` para las páginas de los papers de Sagas y ARIES; se conservaron los DOI y se usaron las fuentes oficiales accesibles para la parte operacional.
- Algunas páginas de MySQL respondieron `403` al fetch automatizado; los enlaces oficiales y snippets del manual 8.4 se conservaron como `DOCUMENTADO`, no como `REPRODUCED`.
- `freedesktop.org` respondió `418`; se leyó el XML oficial de systemd en el repositorio `systemd/systemd`.
- La URL antigua de Temporal para durable execution devolvió `404`; se sustituyó por las páginas actuales `workflow-execution`, `event-history` y `retry-policies`.
- El sample de Saga de Temporal consultado devolvió `404`; no se le atribuyen capacidades.

## 18. Conclusión de investigación

La investigación sostiene una formulación precisa y limitada:

> **SAGR puede entenderse como una capa de composición que intenta unir detección de falta de progreso, control de presión, presupuestos de retry, reconstrucción durable, idempotencia, compensación y verificación semántica bajo una política de seguridad.**

La formulación no sostiene que SAGR invente deadlock detection, checkpoint/replay, event sourcing, Saga, supervisor o circuit breaker. Tampoco sostiene que los sistemas clásicos resuelvan el problema completo. El resultado más defendible es:

- `CONCEPTO`: DOCUMENTADO por analogías clásicas y por el dossier SAGR.
- `IMPLEMENTACIÓN`: las piezas existen individualmente y en varias composiciones parciales.
- `PRODUCCIÓN`: las piezas individuales son production-facing; la composición SAGR completa no quedó verificada.
- `REPRODUCED`: no evaluado en esta sesión.
- `UNKNOWN`: si la recuperación policy-constrained es viable sin crear un guardrail bypass, si ahorra frente a restart y si existe demanda operativa suficiente.

El próximo dato que más reduciría incertidumbre no es otra lista de patrones: es una reproducción controlada que fuerce, en un workflow real, un bloqueo de policy, un retry perdido después de un side effect, una compaction/replay y una decisión entre recuperar o reiniciar, registrando coste, progreso, duplicaciones y verificación final.

## 19. Fuentes principales

### Reliability, overload y retries

- **[S01] Google SRE, _Addressing Cascading Failures_, libro SRE online (publicación del libro: 2016; retrieval 2026-09-21).** Retry amplification, jitter, límite por request y server-wide retry budget.  
  https://sre.google/sre-book/addressing-cascading-failures/
- **[S02] Google SRE, _Handling Overload_, libro SRE online (2016; retrieval 2026-09-21).** Presupuesto por request y cliente, ratio 10%, evitar retries en varias capas.  
  https://sre.google/sre-book/handling-overload/
- **[S29] Google SRE, _Managing Critical State_, libro SRE online (2016; retrieval 2026-09-21).** Backoff aleatorio y dueling proposers en elección distribuida.  
  https://sre.google/sre-book/managing-critical-state/
- **[S03] AWS Well-Architected, REL05-BP03 _Control and limit retry calls_, documentación vigente consultada 2026-09-21.** Backoff, jitter, máximos y retry storms.  
  https://docs.aws.amazon.com/wellarchitected/latest/framework/rel_mitigate_interaction_failure_limit_retries.html
- **[S04] Envoy 1.40.0-dev, _Circuit breaking_, documentación actual con copyright 2026.** `retry_budget`, concurrencia relativa, default 20% y mínimo 3.  
  https://www.envoyproxy.io/docs/envoy/latest/configuration/upstream/cluster_manager/cluster_circuit_breakers
- **[S28] AWS SDK for Kotlin, _Retries_, documentación vigente consultada 2026-09-21.** Token bucket, circuit breaker y adaptive retry.  
  https://docs.aws.amazon.com/sdk-for-kotlin/latest/developer-guide/retries.html

### Networking y backpressure

- **[S05] Reactive Streams JVM 1.0.4, release 2022-05-26; código, especificación y TCK tag `v1.0.4`.**  
  https://github.com/reactive-streams/reactive-streams-jvm/tree/v1.0.4  
  https://github.com/reactive-streams/reactive-streams-jvm/tree/v1.0.4/tck
- **[S06] RFC 9293, _Transmission Control Protocol_, Standards Track, 2022-08.** Secuencias, ACK, ventanas, retransmisión y estados TCP.  
  https://www.rfc-editor.org/rfc/rfc9293.html
- **[S07] RFC 5681, _TCP Congestion Control_, Standards Track, 2009-09.** Slow start, congestion avoidance, fast retransmit/recovery y `cwnd`.  
  https://www.rfc-editor.org/rfc/rfc5681.html
- **[S27] RFC 6585, _Additional HTTP Status Codes_, 2012-04.** `429 Too Many Requests` y `Retry-After`; fuente normativa de señalización de overload HTTP.  
  https://www.rfc-editor.org/rfc/rfc6585.html#section-4

### Bases de datos y recovery

- **[S08] PostgreSQL 18.6 Documentation, release 2026-08-13.** MVCC, isolation, deadlocks, savepoints, WAL, recovery targets, PITR, warm standby y timelines.  
  https://www.postgresql.org/about/news/postgresql-186-1711-1615-1519-1424-and-19-beta-3-released-3365/  
  https://www.postgresql.org/docs/18/mvcc-intro.html  
  https://www.postgresql.org/docs/18/transaction-iso.html  
  https://www.postgresql.org/docs/18/explicit-locking.html  
  https://www.postgresql.org/docs/18/sql-savepoint.html  
  https://www.postgresql.org/docs/18/wal-intro.html  
  https://www.postgresql.org/docs/18/continuous-archiving.html
- **[S09] MySQL 8.4 Reference Manual, InnoDB.** MVCC/undo, redo log, crash recovery, deadlock detection y savepoints. Fetch directo parcialmente bloqueado por 403; URLs primarias conservadas.  
  https://dev.mysql.com/doc/refman/8.4/en/innodb-multi-versioning.html  
  https://dev.mysql.com/doc/refman/8.4/en/innodb-undo-logs.html  
  https://dev.mysql.com/doc/refman/8.4/en/innodb-redo-log.html  
  https://dev.mysql.com/doc/refman/8.4/en/innodb-recovery.html  
  https://dev.mysql.com/doc/refman/8.4/en/innodb-deadlock-detection.html  
  https://dev.mysql.com/doc/refman/8.4/en/savepoint.html
- **[S10] C. Mohan et al., _ARIES: A Transaction Recovery Method Supporting Fine-Granularity Locking and Partial Rollbacks Using Write-Ahead Logging_, ACM, 1992.** Paper conceptual primario; página ACM respondió 403.  
  https://dl.acm.org/doi/10.1145/128765.128770

### Sistemas distribuidos y fault tolerance

- **[S11] D. Ongaro y J. Ousterhout, _In Search of an Understandable Consensus Algorithm (Raft)_, USENIX ATC 2014 / extended paper.** Safety, majority, replicated log, snapshots y state machine.  
  https://raft.github.io/  
  https://raft.github.io/raft.pdf
- **[S12] etcd-io/raft, branch `main`, package v3; código y tests inspeccionados, no ejecutados.** `raftLog`, `Ready`, `Snapshot`, `Advance`, `applyingEntsPaused`, compaction y restore.  
  https://github.com/etcd-io/raft/blob/main/log.go  
  https://github.com/etcd-io/raft/blob/main/log_test.go  
  https://github.com/etcd-io/raft/blob/main/node.go
- **[S25] K. M. Chandy y L. Lamport, _Distributed Snapshots: Determining Global States of Distributed Systems_, ACM TOCS, 1985.** Snapshot consistente y mensajes en tránsito; PDF del autor.  
  https://lamport.azurewebsites.net/pubs/chandy.pdf
- **[S26] H. Garcia-Molina y K. Salem, _Sagas_, ACM SIGMOD, 1987.** Paper original de transacciones compensables; página ACM respondió 403.  
  https://dl.acm.org/doi/10.1145/38713.38742

### Sistemas operativos y supervisión

- **[S13] Linux kernel documentation, _Runtime locking correctness validator_, versión de documentación observada `7.3.0-rc4`.** Lock classes, ciclos, dependencias y límites de lockdep.  
  https://docs.kernel.org/locking/lockdep-design.html
- **[S14] Linux kernel documentation, _Using RCU's CPU Stall Detector_, versión de documentación observada `7.3.0-rc4`.** Loops, falta de quiescence, watchdog temporal y falsos positivos.  
  https://docs.kernel.org/RCU/stallwarn.html
- **[S15] systemd, `main` branch, XML oficial de `systemd.service`; man page latest consultada 2026-09-21.** `WatchdogSec`, `Restart`, backoff, jitter y start rate limiting.  
  https://github.com/systemd/systemd/blob/main/man/systemd.service.xml  
  https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html
- **[S16] Erlang/OTP System Documentation 29.1, _Supervisor Behaviour_, 2026.** Estrategias de restart, intensidad/periodo, jerarquía y advertencias de multiplicación.  
  https://www.erlang.org/doc/system/sup_princ.html

### Workflow engines y durable execution

- **[S17] Temporal Documentation, páginas actuales consultadas 2026-09-21.** Event History, Workflow replay, determinismo y Retry Policies.  
  https://docs.temporal.io/workflow-execution  
  https://docs.temporal.io/encyclopedia/event-history  
  https://docs.temporal.io/workflow-execution/event  
  https://docs.temporal.io/encyclopedia/retry-policies
- **[S18] AWS Step Functions Developer Guide, documentación vigente consultada 2026-09-21.** `Retry`, `Catch`, backoff/jitter, `MaxAttempts` y `RedriveExecution`.  
  https://docs.aws.amazon.com/step-functions/latest/dg/concepts-error-handling.html  
  https://docs.aws.amazon.com/step-functions/latest/dg/redrive-executions.html
- **[S19] Microsoft Durable Task / Durable Functions, páginas actualizadas 2026-08-14 y 2026-08-24.** Event sourcing, checkpoints, replay, determinismo, providers y límites de I/O.  
  https://learn.microsoft.com/en-us/azure/durable-task/common/durable-task-orchestrations  
  https://learn.microsoft.com/en-us/azure/durable-task/common/durable-task-code-constraints
- **[S20] Microsoft Azure Architecture Center, _Event Sourcing Pattern_, `ms.date` 2026-03-27, updated 2026-08-15.** Rehydration, snapshots, at-least-once, idempotencia y loops circulares.  
  https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing
- **[S21] Microsoft Azure Architecture Center, _Saga Design Pattern_, `ms.date` 2025-02-25, updated 2026-06-03.** Compensations, pivot, idempotent retryable transactions, choreography y orchestration.  
  https://learn.microsoft.com/en-us/azure/architecture/patterns/saga

### Idempotencia y contratos HTTP

- **[S22] Stripe API, _Idempotent requests_, documentación vigente consultada 2026-09-21.** Retención de status/body, 500, comparación de parámetros, pruning de claves y concurrencia.  
  https://docs.stripe.com/api/idempotent_requests
- **[S23] IETF, `draft-ietf-httpapi-idempotency-key-header-07`, publicado 2025-10-15, expirado 2026-04-18.** Especificación propuesta, no RFC definitivo al corte de esta investigación.  
  https://datatracker.ietf.org/doc/html/draft-ietf-httpapi-idempotency-key-header-07

### Código y tests adicionales

- **[S24] Kubernetes `client-go`, `master`, `default_rate_limiters.go` y `default_rate_limiters_test.go`, inspeccionados sin ejecución.** Token bucket global, backoff por item, `Forget`, `MaxOf` y tests de secuencia.  
  https://github.com/kubernetes/client-go/blob/master/util/workqueue/default_rate_limiters.go  
  https://github.com/kubernetes/client-go/blob/master/util/workqueue/default_rate_limiters_test.go

## 20. Estado final de confianza

| Afirmación | Estado |
|---|---|
| Deadlock detection, retry limits, backpressure, WAL, MVCC, checkpoint/replay y supervisors existen | SUPPORTED / DOCUMENTADO; algunas implementaciones OBSERVED |
| Esos mecanismos son funcionalmente relevantes para SAGR | INFERRED fuerte |
| Ninguno de ellos, tomado aisladamente, es SAGR | INFERRED fuerte por diferencia operacional |
| Existe un compuesto clásico idéntico a SAGR | UNKNOWN; no encontrado en el corpus |
| Existe recuperación policy-constrained con alternativa segura | UNKNOWN; no encontrada en el corpus |
| Existe un recovery budget global que abarque retries anidados | UNKNOWN; no observado |
| Recuperar cuesta menos que reiniciar en workloads reales | UNKNOWN; no medido |
| La composición completa está verificada en producción | UNKNOWN; no reproducida ni demostrada |

**Veredicto:** las analogías clásicas son suficientemente concretas para servir como vocabulario de diseño y falsificación de SAGR, pero no autorizan a reclamar novedad de las primitivas individuales ni producción de la composición. La diferencia defendible, si sobrevive evidencia posterior, está en la unión de progreso semántico, policy, side-effect continuity, presupuesto global y verificación posterior.

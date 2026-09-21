# ¿Existe el control-induced stall?

**Fecha de investigación:** 2026-09-21

**Alcance:** investigación documental en español sobre teoría de control, planificación automática, robótica, seguridad, autorización y *policy-constrained recovery*. No se inspeccionó ni modificó ningún runtime, repositorio de aplicación o sistema en producción.

**Respuesta corta:** `control-induced stall` no aparece, en la búsqueda realizada, como una categoría canónica transversal en papers, estándares o documentación técnica. Es mejor tratarlo como una **etiqueta de trabajo para un fallo de liveness/progreso inducido por la política de control o por la interacción controlador-planificador**, no como diagnóstico primario. Los vocabularios establecidos ya cubren sus mecanismos vecinos: *integrator windup*, saturación, *limit cycle*, oscilación, *chattering*, histéresis, *local minimum*, *dead-end*, *trap*, *deadlock*, *livelock*, *failed to make progress*, fallo de plan, fallo de autorización y efecto externo indeterminado. La hipótesis se sostiene solo cuando una intervención sobre el controlador, el plan, la información disponible o la política cambia la trayectoria manteniendo el entorno comparable; observar que el sistema “no avanza” no basta para atribuir causalidad al control.

## 1. Método y disciplina epistemológica

### Convenciones

- **[O] Observación:** el texto fuente afirma o muestra explícitamente el hecho.
- **[I] Inferencia:** conclusión razonada a partir de una o más observaciones; no es una definición del fuente.
- **[H] Hipótesis:** explicación todavía no confirmada.
- **[N] Resultado negativo:** no se encontró evidencia suficiente en las búsquedas indicadas. No equivale a demostrar inexistencia.
- **[P] Paper:** artículo académico, proceedings, preprint o tesis. Los preprints se marcan como tales y no se presentan como consenso.
- **[S] Estándar o fuente gubernamental:** ISO, IEC, NIST, NASA, FAA, NRC, etc.
- **[D] Documentación o código:** documentación de proyecto, API, repositorio o guía operativa.
- **[C] Caso o práctica real:** programa, sistema desplegado, experimento físico o experiencia operativa documentada.

### Cómo se evaluó la etiqueta

La pregunta no es solamente si existe un nombre, sino si el nombre delimita una clase causal útil. Para que `control-induced stall` sea una categoría técnica y no una metáfora debe especificar al menos:

1. El estado físico o computacional que queda estancado.
2. Una métrica de progreso y una ventana temporal.
3. El conjunto de acciones actualmente admisibles.
4. La intervención que conecta el estancamiento con el controlador, el planificador o la política.
5. La diferencia frente a saturación, dead-end, deadlock, livelock, autorización denegada y efecto externo ambiguo.
6. Una condición de salida y un límite de reintentos o recuperación.

Sin esos elementos, la frase es un resumen del síntoma, no un diagnóstico.

### Modelo mínimo propuesto

Para razonar con precisión, sea un sistema híbrido:

```text
x[t+1] = f(x[t], u[t], w[t])
u[t]   = K(x[t], memoria[t], plan[t], observaciones[t])
plan   = P(estado, objetivo, restricciones)
autz   = A(principal, capacidad, argumentos, contexto, política)
```

Sea `S` el conjunto de estados seguros, `G` el conjunto de estados objetivo y `V` una medida de distancia o avance semántico. Propongo usar la siguiente definición operacional, **no normativa**:

> Existe un `control-induced stall` cuando la ejecución permanece dentro de `S`, durante una ventana `W`, con `V` prácticamente constante o sin transición de subobjetivo, porque el lazo cerrado actual `K + P + A` no produce una acción admisible que avance; además, una intervención controlada sobre `K`, `P`, las observaciones o `A` cambia la posibilidad de progreso.

La definición tiene una cláusula deliberadamente fuerte: **sin intervención contrafactual no se debe afirmar “inducido por control”**. Si ninguna acción segura y autorizada puede llevar a `G`, el diagnóstico correcto es *physical uncontrollability*, *planning dead-end* o *policy-constrained recovery dead-end*, según la causa. Si sí existe una acción pero el controlador no la selecciona, entonces aparece el componente inducido por control.

## 2. Veredicto taxonómico: categoría real, combinación o renombre

### Resultado de la búsqueda exacta

**[N]** Las consultas exactas `"control-induced stall" control theory`, `"control-induced stall" robotics OR planning OR agent` y `"control-induced instability" oscillation hysteresis control` no devolvieron una definición canónica general comparable a `integrator windup`, `limit cycle`, `deadlock` o `livelock`. Los resultados relevantes fueron de tres tipos:

- “Stall” aeronáutico o aeroelástico: *deep stall*, *dynamic stall*, pérdida de efectividad de controles y recuperación de una aeronave.
- “Stall” robótico o de navegación: robot atascado, oscilación del planificador local, *live-lock*, fallo en alcanzar el objetivo.
- “Control-induced oscillation” o *pilot-induced oscillation*: fenómeno establecido en control y aviación, pero no equivalente a todo estancamiento.

**[I]** Por tanto, el término es actualmente más defendible como **renombre de una composición** que como categoría independiente. El renombre puede ser útil en un sistema interno si se define como etiqueta superior, pero no debe sustituir la causa específica.

### Taxonomía de términos cercanos

| Término establecido | Qué describe | Cuándo se parece a “stall” | Qué no debe confundirse |
|---|---|---|---|
| `Integrator windup` | La acción integral sigue acumulando error mientras el actuador está saturado; al recuperar autoridad, la memoria del controlador retrasa la respuesta. | El sistema puede quedarse mucho tiempo fuera de régimen o responder tarde. | No implica que el objetivo sea inalcanzable ni que el planificador esté equivocado. |
| `Actuator saturation` | La orden calculada no puede ser aplicada por límites de fuerza, velocidad, energía o hardware. | La trayectoria solicitada no es físicamente seguible. | Es una restricción de autoridad; el stall puede existir sin saturación. |
| `Limit cycle` | Órbita periódica o auto-oscilación sostenida del lazo no lineal. | El estado progresa poco mientras el control alterna. | No es necesariamente “atasco”; puede ser una oscilación estable alrededor de un objetivo. |
| `Chattering` | Conmutación rápida, a menudo asociada a relés, control por modos deslizantes o discretización. | Consume tiempo/energía y puede impedir avance. | No todo alternar dos acciones es chattering. |
| `Hysteresis` | Dependencia de la historia o umbrales diferentes de entrada y salida. | Puede evitar o producir conmutaciones repetidas. | Es un mecanismo de memoria, no el resultado operativo por sí mismo. |
| `Local minimum` | No hay dirección de descenso local para un controlador reactivo o campo potencial. | El agente queda en un equilibrio no objetivo. | Puede requerir planificación global, pero no es un fallo de autorización. |
| `Dead-end` o `trap` | Estado desde el cual el objetivo es inalcanzable en el modelo de planificación. | El agente puede seguir ejecutando acciones sin futuro válido. | Un dead-end es una propiedad de alcanzabilidad; no requiere oscilación. |
| `Deadlock` | Dependencia circular o espera mutua sin transición posible. | El sistema se detiene aunque existan recursos o acciones en abstracto. | El origen puede ser multiagente, recursos o locks, no control continuo. |
| `Livelock` | El sistema sigue actuando, pero no alcanza una condición de salida. | Es la forma más cercana al “stall activo”. | Hay actividad observable, por lo que un watchdog de silencio no basta. |
| `Failed to make progress` / `stuck` | Predicado operacional basado en odometría, tiempo, distancia o estado. | Es un detector útil de síntoma. | No identifica causa causal. |
| `Pilot-induced oscillation` | Oscilación producida por la interacción entre humano/controlador, dinámica, retardos y percepción. | Demuestra que la interacción de control puede inducir inestabilidad. | Es un fenómeno específico, no un nombre general para todo stall. |
| `Policy-constrained recovery dead-end` | No existe acción de recuperación simultáneamente segura y autorizada. | El control podría avanzar, pero la política deja el conjunto de acciones vacío. | Es un fallo de intersección entre seguridad y autorización, no necesariamente del controlador. |
| `Unknown side effect` | No se sabe si una operación externa ocurrió antes de perder la respuesta. | Un reintento puede duplicar efectos o bloquear el flujo. | Es incertidumbre transaccional, no falta de movimiento físico. |

### El precedente de “control-induced oscillation” sí es real

**[O]** La literatura de control reconoce oscilaciones auto-sostenidas en lazos no lineales con saturaciones, relés e histéresis. La teoría de funciones descriptivas y el criterio del círculo se usan precisamente para estudiar estabilidad y oscilación en estos sistemas ([material docente de control sobre relés, saturación y oscilaciones](https://isy.gitlab-pages.liu.se/rt/en/courses/TSRT09/slides/rteoh9_en.pdf)). También existe una literatura específica sobre *pilot-induced oscillations* en aeronaves ([DTIC, “Pilot-Induced Oscillations: Their Cause and Control”](https://apps.dtic.mil/sti/html/tr/AD0481994/index.html)).

**[I]** Esto apoya una versión acotada de la hipótesis: un lazo de control puede inducir una dinámica no progresiva. No apoya el uso de `control-induced stall` como categoría paraguas sin separar oscilación, saturación, dead-end y autorización.

### “Stall” también tiene un significado físico distinto

**[O]** La FAA trata la pérdida aerodinámica como una condición en la que disminuye la efectividad de los controles y advierte que mantener conectado un piloto automático puede producir ajustes inadecuados durante una recuperación ([FAA Airplane Flying Handbook, capítulo 5](https://www.faa.gov/sites/faa.gov/files/regulations_policies/handbooks_manuals/aviation/airplane_handbook/06_afh_ch5.pdf)). La literatura de *deep stall* describe una aeronave bloqueada en una actitud de alto ángulo de ataque a pesar de una orden completa de morro abajo ([Cambridge, “Derivation of control inputs for deep stall recovery”](https://www.cambridge.org/core/journals/aeronautical-journal/article/derivation-of-control-inputs-for-deep-stall-recovery-using-nonlinear-frequency-analysis/C6D7E61E499C123E8A6B8CC224629BA7)).

**[I]** En robótica y control de agentes, usar “stall” sin calificativo puede importar accidentalmente un sentido aeroelástico o de pérdida de sustentación. Si el sistema investigado no es una aeronave, conviene usar `liveness stall`, `progress stall`, `control-induced livelock` o una etiqueta causal más concreta.

## 3. Control: cómo un lazo puede perder progreso

### Saturación y windup

**[O]** Åström y Rundqwist explican que la saturación rompe efectivamente el lazo de realimentación entre la salida del controlador y la planta; con acción integral, el estado interno sigue creciendo aunque el actuador no pueda aplicar la orden. El sistema puede tardar en volver al equilibrio después de que desaparece el error ([“Integrator Windup and How to Avoid It”](http://cse.lab.imtlucca.it/~bemporad/teaching/controllodigitale/pdf/Astrom-ACC89.pdf)). Un informe de NASA descompone la degradación por saturación en *controller windup* y *directionality*, y señala que la orden del controlador deja de coincidir con la entrada real de la planta ([NASA, “Control Strategies for Systems With Limited Actuators”](https://ntrs.nasa.gov/api/citations/19940028235/downloads/19940028235.pdf)).

**[I]** Un detector de stall debería registrar como mínimo `u_cmd`, `u_applied`, el error de saturación y la memoria integral. Si `u_cmd != u_applied` y el error interno continúa acumulándose, la etiqueta correcta es `saturation/windup`, aunque el síntoma visible sea “no avanza”.

### Oscilación, histéresis y conmutación

**[O]** Los sistemas con relés, histéresis, zonas muertas, backlash y saturaciones pueden presentar ciclos límite. La literatura de relés describe ciclos con *chattering* y conmutaciones rápidas ([Johansson et al., “Limit cycles with chattering in relay feedback systems”](https://www.diva-portal.org/smash/get/diva2%3A340579/FULLTEXT01.pdf)). En sistemas híbridos, el comportamiento de Zeno representa infinitas transiciones discretas en tiempo finito; es un fenómeno de modelos con conmutación, no un sinónimo de livelock ([Zhang, Johansson y Lygeros, “Dynamical Systems Revisited: Hybrid Systems with Zeno Executions”](https://web.ece.ucsb.edu/~hespanha/ece229/references/ZhangJohanssonHSCC00.pdf)).

**[I]** Un controlador con umbral puede generar una trayectoria alternante incluso si cada decisión individual es localmente razonable. La corrección no es simplemente aumentar el número de reintentos: puede requerir histéresis explícita, *cooldown*, memoria de dirección, suavizado, *dwell time*, una acción de escape o un cambio de representación.

### Control reactivo y mínimos locales

**[O]** El análisis de campos circulares reactivos para planificación de movimiento identifica escenarios en los que el robot queda atrapado en un ciclo límite alrededor de obstáculos ([“Motion Planning using Reactive Circular Fields”](https://arxiv.org/pdf/2210.16106v1)). El trabajo reciente sobre control reactivo multiobjetivo explica que los conflictos de gradientes pueden crear mínimos locales y que la exploración en un espacio nulo, junto con umbrales asimétricos e histéresis, puede escapar de ellos ([“Riding the Shifting Potential”](https://arxiv.org/html/2605.27314v1)); es un preprint de 2026, por lo que sirve como evidencia emergente, no como consenso.

**[I]** Si el robot está inmóvil porque la suma de fuerzas o gradientes es cero, el diagnóstico más preciso es `local minimum` o `undesired equilibrium`. Solo se convierte en `control-induced stall` si se demuestra que otra ley de control, una maniobra de escape o un plan global habilita progreso dentro del mismo estado físico.

### Liveness no es estabilidad

**[O]** Un sistema puede mantenerse seguro y acotado sin alcanzar el objetivo. En robótica multiagente, la literatura distingue seguridad de *liveness*, entendida como alcanzar el destino sin gridlock o desvíos excesivos ([Cai et al., “Rules of the Road: Formal Guarantees for Autonomous Vehicles”](https://dl.acm.org/doi/abs/10.1109/TRO.2023.3247951)). También se han estudiado controladores que preservan separación pero pierden liveness por las interacciones de las funciones barrera ([Jankovic, Santillo y Wang, “Multi-agent systems with CBF-based controllers”](https://arxiv.org/pdf/2207.04915)).

**[I]** Para SAGR, el monitor no debe tener una única bandera `safe`. Necesita al menos dos propiedades independientes:

| Propiedad | Pregunta | Fallo si |
|---|---|---|
| Seguridad | ¿La trayectoria actual permanece dentro del conjunto seguro? | Hay riesgo de colisión, violación de límite o efecto prohibido. |
| Liveness/progreso | ¿El estado se acerca a un subobjetivo verificable? | La ejecución se repite, espera o se aleja sin una razón válida. |

Un controlador que mantiene `safe = true` pero `progress = false` durante una ventana relevante es un candidato a stall, no un sistema correcto.

### Trayectoria y control

**[O]** La planificación kinodinámica clásica incorpora el sistema de control en la generación de trayectorias admisibles: el planificador muestrea entradas y simula las ecuaciones de movimiento, y puede recomputar una trayectoria mientras el robot ejecuta la anterior ([LaValle y Kuffner, “Randomized Kinodynamic Motion Planning with Moving Obstacles”](http://ai.stanford.edu/~latombe/papers/IJRR-kino/final.pdf)). Esto evita tratar una trayectoria geométrica como si fuera automáticamente ejecutable.

**[O]** En navegación móvil, un trabajo de 2024 usa un modelo predictivo de control para producir estados futuros, estima el riesgo de fallo del planificador con un proceso gaussiano y, al superar un umbral, detiene el robot, busca un estado seguro de recuperación y vuelve a la planificación nominal ([Mohammad, Higgins y Bezzo, “A GP-based Robust Motion Planning Framework for Agile Autonomous Robot Navigation and Recovery in Unknown Environments”](https://arxiv.org/html/2402.01617v1)). El trabajo distingue fallo del *front-end* por ausencia de corredor y fallo del *back-end* por incapacidad del solver para producir una trayectoria.

**[I]** `trajectory control` debe registrar la diferencia entre trayectoria nominal, trayectoria aplicada y estado observado. Un plan puede ser válido en el espacio geométrico pero no en el espacio de control; un controlador puede seguir fielmente una trayectoria que ya no conduce al objetivo; y un monitor puede ver movimiento físico sin progreso semántico.

## 4. Planificación: dead-end, reparación, información y progreso semántico

### Dead-end y trap son categorías técnicas

**[O]** Lipovetzky, Muise y Geffner definen un invariante como una fórmula verdadera en el estado inicial y en todos los estados alcanzables, un *trap* como un invariante condicional que una vez alcanzado no se abandona, y un *dead-end* como un estado desde el que el objetivo es inalcanzable. Proponen preprocesar fórmulas para detectar *traps* y *dead-ends* ([ICAPS, “Traps, Invariants, and Dead-Ends”](https://ojs.aaai.org/index.php/ICAPS/article/view/13774)).

**[O]** Steinmetz y Hoffmann muestran que una detección de dead-end basada en caminos críticos puede capturarse con un *nogood* precalculado o aprendido en línea, evitando repetir evaluaciones costosas ([ICAPS, “Critical-Path Dead-End Detection versus NoGoods”](https://ojs.aaai.org/index.php/ICAPS/article/view/13802)). La topología de búsqueda distingue dead-ends reconocidos de dead-ends no reconocidos; los últimos permiten que la búsqueda avance dentro de regiones enteras sin solución ([“Local Search Topology in Planning Benchmarks”](https://arxiv.org/pdf/1109.5713)).

**[I]** La predicción de dead-end es diferente de un watchdog de inactividad. Un sistema puede ejecutar mucho código, cambiar variables y emitir nuevas acciones mientras ya está dentro de una región sin solución. La señal fuerte no es “no hubo eventos”, sino “no existe un sufijo de plan válido bajo las restricciones y el modelo actual”.

### Plan repair frente a restart

**[O]** La reparación de planes trata de conservar información y trabajo del prefijo ejecutado, modificando el sufijo que quedó inválido. Scala estudia reparación de planes con recursos consumibles y continuos mediante *numeric macro actions*, y reporta mejoras en tiempo de CPU y estabilidad frente a generar de nuevo el plan completo ([Scala, “Plan Repair for Resource Constrained Tasks via Numeric Macro Actions”](https://ojs.aaai.org/index.php/ICAPS/article/view/13624)). Un trabajo temprano de AAAI formula la depuración y reparación de fallos de plan como un problema de decisión bajo incertidumbre, con diagnóstico probabilístico, selección entre estrategias y cálculos de valor de información ([“Decision-Theoretic Plan Failure Debugging and Repair”](https://cdn.aaai.org/AAAI/1994/AAAI94-223.pdf)).

**[I]** `restart` y `recovery` no son sinónimos:

| Acción | Qué reinicia o modifica | Riesgo principal | Cuándo es razonable |
|---|---|---|---|
| Restart computacional | Proceso, memoria volátil o sesión de planificación. | Repite la misma decisión y puede perder el contexto del fallo. | El fallo es puramente interno y no hubo efecto externo ambiguo. |
| Retry | La misma operación o una operación equivalente. | Duplica efectos si la primera llamada pudo completarse. | La operación es idempotente o tiene una clave de idempotencia. |
| Recovery | Estado físico, controlador, trayectoria, observación o rama del plan. | Puede introducir una maniobra nueva y un efecto adicional. | Hay una trayectoria de escape verificada y autorizada. |
| Plan repair | Conserva el prefijo confirmado y recompone el sufijo. | El modelo puede haber quedado obsoleto o ser incompleto. | El estado actual es conocido y el prefijo sigue siendo válido. |
| Compensation | Ejecuta una acción que contrarresta efectos ya confirmados. | No siempre existe un inverso; puede haber concurrencia. | Hay registro de efectos, operación compensadora idempotente y reglas de negocio. |
| Human escalation | Transfiere una decisión de alto impacto o ambigua. | El operador puede llegar tarde o no tener contexto. | El efecto es irreversible, la autoridad es sensible o el estado es incierto. |

### Valor de la información

**[O]** El trabajo de AAAI de 1994 no selecciona siempre el análisis más sofisticado: usa redes de creencias para estimar clases de error y cálculos de *value of information* para decidir qué análisis costoso merece ejecutarse. La motivación es que el diagnóstico completo puede ser demasiado caro o incierto para cada fallo ([“Decision-Theoretic Plan Failure Debugging and Repair”](https://cdn.aaai.org/AAAI/1994/AAAI94-223.pdf)). En percepción activa, Ghasemi, Bulgur y Topcu formulan planificación y percepción conjunta bajo semántica parcialmente conocida; las observaciones se priorizan por su capacidad de reducir incertidumbre sobre las proposiciones que habilitan la transición del autómata de tarea ([PMLR, “Task-Oriented Active Perception and Planning in Environments with Partially Known Semantics”](https://proceedings.mlr.press/v119/ghasemi20a/ghasemi20a.pdf)).

**[I]** Una recuperación debería pagar el coste de observar o diagnosticar solo si:

```text
VOI(observación) > coste(computación + demora + exposición + energía)
```

y si la información puede cambiar la decisión. Preguntar a un sensor o replanificar no es automáticamente progreso; puede ser una nueva forma de loop.

### Progreso semántico

**[O]** El monitoreo semántico de ejecución de planes robóticos se estudia como una forma de usar conocimiento del dominio para inferir condiciones implícitas durante la ejecución ([Bouguerra et al., “Monitoring the execution of robot plans using semantic knowledge”](https://www.sciencedirect.com/science/article/abs/pii/S0921889008001152)). El trabajo de percepción activa citado arriba representa progreso mediante proposiciones semánticas y un autómata de tarea, no solo mediante distancia o número de acciones.

**[I]** Para un agente con herramientas, el progreso semántico no debe ser `tool_call_count`, tokens emitidos, eventos de heartbeat o mensajes de “intentando”. Debe ser una transición verificable de estado, por ejemplo:

| Nivel | Ejemplo de señal | Riesgo de falso progreso |
|---|---|---|
| Actividad | La herramienta devolvió HTTP 200 o el controlador emitió una orden. | El efecto puede no haber ocurrido o no cambiar el objetivo. |
| Estado físico | Se movió `d` metros, cambió la pose o bajó la temperatura. | Puede alejarse del objetivo o repetir una órbita. |
| Estado del recurso | El recurso pasó de reservado a confirmado. | El commit externo puede ser ambiguo. |
| Subobjetivo | Se estableció una precondición o landmark del plan. | La precondición puede estar obsoleta. |
| Objetivo | Se verificó el estado final desde una fuente independiente. | La verificación puede ser incompleta o manipulada. |

Un detector robusto debe poder decir “hubo actividad sin progreso”, “hubo progreso físico sin progreso semántico” y “hubo efecto semántico pero no se conoce su confirmación transaccional”.

### Replanificar demasiado o demasiado poco

**[O]** Honda et al. modelan el momento de replanificar como una decisión en un POMDP y comparan estrategias por distancia, tiempo y detección de atasco. Reportan que replanificar poco puede dejar al robot atascado, mientras que hacerlo demasiado puede producir oscilación de ruta; el resultado depende del entorno y de la pareja de planificadores ([“When to Replan? An Adaptive Replanning Strategy for Autonomous Navigation”](https://arxiv.org/html/2304.12046v3)).

**[I]** Una política de recuperación necesita *dwell time*, memoria de la última rama, penalización por volver a una acción rechazada y una condición de “no replanificar todavía”. Replanificar es una acción con coste y puede ser el agente causal del stall.

## 5. Robótica: detección, recuperación y trayectoria segura

### Recuperación proactiva antes del fallo

**[O]** El marco GP-MPC de Mohammad et al. no espera a que el solver falle físicamente. Predice sobre un horizonte la probabilidad de fallos del planificador, detiene el robot cuando el riesgo supera un umbral, muestrea puntos de recuperación y retorna al plan nominal desde un estado donde el fallo es menos probable ([paper y experimentos con Jackal y Spot](https://arxiv.org/html/2402.01617v1)). El trabajo distingue el fallo del corredor del fallo del solver y usa una métrica de riesgo acumulada sobre estados futuros.

**[I]** Esto es más cercano a `dead-end prediction + safe recovery trajectory` que a un simple restart. La propiedad que se intenta recuperar no es “el proceso volvió a responder”, sino “existe un estado cercano desde el cual el planificador nominal vuelve a ser ejecutable”.

### Recuperación operativa en ROS

**[O]** La navegación ROS clásica documenta dos comportamientos de recuperación: limpiar el costmap y rotar 360 grados. También documenta oscilación en puertas o pasillos, un umbral de distancia para resetear la bandera y el hecho operativo de que el robot puede agotar recuperaciones y quedarse quieto ([ROS Navigation Tuning Guide](https://ar5iv.labs.arxiv.org/html/1706.09068)). La guía registra observaciones en simulación y robots reales, pero no debe confundirse con un estándar ni con evidencia causal general.

**[O]** Nav2 expone una condición `IsStuckCondition` que rastrea odometría y devuelve éxito si el robot se considera atascado ([documentación Nav2](https://docs.ros.org/en/humble/p/nav2_behavior_tree/generated/classnav2__behavior__tree_1_1IsStuckCondition.html)). El árbol de comportamiento permite combinar detección, recuperación y navegación, pero la condición por sí sola no explica si la causa fue percepción, control, planificación o política.

**[I]** El patrón correcto para un agente de control es “detectar, clasificar, elegir una recuperación nueva y verificar el resultado”, no “detectar, reiniciar la misma rama”. El historial de acciones fallidas es parte del estado de recuperación.

### Safe replanning y shields

**[O]** En POMDP, una política que maximiza retorno esperado no garantiza por sí misma una probabilidad de seguridad adecuada. Sheng, Parker y Feng integran *shields* con POMCP para restringir acciones que violan especificaciones *reach-avoid* casi seguras ([“Safe POMDP Online Planning via Shielding”](https://arxiv.org/abs/2309.10216)). El trabajo de Jansen et al. formula *probabilistic shields* para restringir exploración insegura con alta probabilidad ([CONCUR, “Safe Reinforcement Learning Using Probabilistic Shields”](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.CONCUR.2020.3)).

**[O]** El filtrado basado en alcanzabilidad Hamilton-Jacobi puede modificar mínimamente un controlador nominal para preservar seguridad o liveness, pero puede introducir conmutación abrupta y comportamiento *bang-bang* ([Borquez et al., “On Safety and Liveness Filtering Using Hamilton-Jacobi Reachability Analysis”](https://arxiv.org/abs/2312.15347)).

**[I]** Un *shield* puede evitar una acción insegura y, al mismo tiempo, eliminar todas las acciones que producen progreso. Por eso debe exponer estados distintos: `allowed`, `denied`, `no_safe_progress_action`, `policy_indeterminate` y `fallback_active`. “No colisión” no demuestra recuperación correcta.

### Simplex y runtime assurance

**[O]** La arquitectura Simplex mantiene un controlador avanzado y un controlador base, y cambia la autoridad cuando un monitor determina que la trayectoria avanzada amenaza una propiedad de seguridad. La variante *Black-Box Simplex* usa comprobaciones de runtime para no exigir verificación estática completa del controlador avanzado o de la línea base, y presenta casos con MPC multi-robot y redes neuronales para evitar colisiones ([Mehmood et al., “The Black-Box Simplex Architecture for Runtime Assurance of Autonomous CPS”](https://arxiv.org/abs/2102.12981)).

**[O]** NASA documenta una línea de *Resilient Autonomy* con *Multi-Monitor Run-Time Assurance*, arquitectura de variable autonomía y demostraciones en las que el sistema puede continuar de forma segura, abortar la misión o volver a base ([NASA Armstrong, “Autonomous Systems”](https://www.nasa.gov/centers-and-facilities/armstrong/autonomous-systems)). NASA también describe R2U2 como verificación de runtime para detectar fallos y violaciones de seguridad o rendimiento en sistemas autónomos ([NASA, “Multi-Platform, Multi-Architecture Runtime Verification”](https://www.nasa.gov/directorates/stmd/space-tech-research-grants/multi-platform-multi-architecture-runtime-verification-of-autonomous-space-systems)).

**[I]** Para recovery, Simplex ofrece una arquitectura útil: el planificador o controlador avanzado puede equivocarse, pero un monitor independiente debe poder tomar autoridad antes de cruzar una frontera no recuperable. Esto es distinto de un reinicio, que puede volver a entregar autoridad al mismo controlador sin cambiar el estado que causó el fallo.

## 6. Seguridad, autorización y capability security

### Autorización no es exposición de capacidades

**[O]** El problema clásico del *confused deputy* surge cuando un programa usa autoridad propia para actuar sobre recursos en nombre de un iniciador sin conservar la intención ni el alcance de esa autoridad ([Hardy, “The Confused Deputy”](https://www.cs.utexas.edu/~witchel/S25-380L/papers/hardy88confused.pdf); versión ACM, [DOI 10.1145/54289.871709](https://dl.acm.org/doi/10.1145/54289.871709)).

**[O]** En sistemas de object capabilities, una referencia no falsificable puede ser simultáneamente identidad del recurso y autoridad para usarlo; la descomposición por privilegios mínimos permite reducir *confused deputy* y ciertos TOCTTOU ([Wagner, “Object capabilities for security”](https://dl.acm.org/doi/10.1145/1134744.1134745)). Un análisis formal sostiene que los modelos de access control y capabilities no son idénticos y estudia su relación con ataques de *confused deputy* ([Rajani, Garg y Rezk, “On access control, capabilities, their equivalence, and confused deputy attacks”](https://people.mpi-sws.org/~dg/papers/csf16-caps.pdf)).

**[O]** Un preprint de 2026 que auditó defaults públicos de LangChain/LangGraph, LlamaIndex y Stripe Agent Toolkit distingue *capability gating* de autorización por valores concretos de cada llamada. Reporta que la exposición de una herramienta no equivale a una decisión determinista *fail-closed* sobre los argumentos del modelo, y propone un PDP/PEP downstream del modelo ([Mellafe Zuvic, “Capability Gates Are Not Authorization”](https://arxiv.org/abs/2606.28679)). Es un audit de código fijado y no una auditoría de servicios vivos; el propio paper dice que no ejecutó un exploit de producción ni afirma un CVE.

**[I]** Para recuperación, una capability debe ser una autoridad limitada por operación, recurso, argumentos, presupuesto, tiempo, finalidad y contexto. Un booleano `can_use_tool = true` no basta para autorizar `tool(args)`; el chequeo debe recibir la llamada concreta justo antes del efecto.

### Policy engine y punto de enforcement

**[O]** Cedar modela cada solicitud con principal, acción, recurso y contexto. Su algoritmo es `Deny` por defecto, hace que `forbid` prevalezca sobre `permit` y devuelve diagnósticos; sin embargo, si una policy produce error, la policy se omite y el resultado final puede seguir siendo `Allow` si otra policy permite la operación ([Cedar Authorization](https://docs.cedarpolicy.com/auth/authorization.html)).

**[I]** `default deny` no es exactamente lo mismo que `deny on evaluator error`. Para un efecto de alto impacto, el PEP debe decidir qué significa `indeterminate`, incluso si el motor de policy permite continuar con diagnósticos. La semántica de seguridad debe estar en el borde que puede impedir el efecto, no solo en la librería que evalúa reglas.

**[O]** OPA documenta que una respuesta `undefined` puede significar que todavía no hay policies o que ninguna regla decide. OPA afirma explícitamente que elegir *fail-open* o *fail-closed* cuando OPA no está listo es responsabilidad de la aplicación que lo consulta; la elección depende del coste de permitir o denegar incorrectamente ([OPA Operations](https://www.openpolicyagent.org/docs/operations)). OPA puede emitir `decision_id`, entrada, resultado, revisión de bundle y trazas para auditoría y depuración ([OPA Decision Logs](https://www.openpolicyagent.org/docs/management-decision-logs)).

**[I]** Un control robusto debe distinguir al menos `ALLOW`, `DENY`, `INDETERMINATE`, `NOT_READY`, `STALE_POLICY` y `SIDE_EFFECT_UNKNOWN`, y mapearlos por clase de efecto. La política no puede decidir lo que el caller no modela; el caller debe impedir que una ausencia de decisión se convierta accidentalmente en permiso.

### Least privilege y capabilities

**[O]** NIST define *least privilege* como permitir solo los accesos autorizados necesarios para las tareas asignadas y extiende el principio a procesos, cuentas y funciones privilegiadas ([NIST IR 7657, Privilege Management Workshop](https://csrc.nist.gov/pubs/ir/7657/final); [NIST Glossary, least privilege](https://csrc.nist.gov/glossary/term/least_privilege)).

**[I]** La capability de recovery no debe ser más amplia que la capability nominal. La recuperación puede necesitar otra trayectoria, pero no debe convertirse en una vía para saltarse autorización, presupuesto, aislamiento o aprobación humana. En términos de delegación, una capability hija debe ser una atenuación de la capability padre, nunca una ampliación.

## 7. Sandbox, dry-run y side-effect uncertainty

### Dry-run no significa “sin efectos” por magia

**[O]** Kubernetes server-side dry-run procesa una solicitud como la real, incluyendo validación, defaulting y admission, pero no la persiste. Los webhooks que tienen efectos laterales deben suprimirlos en `dryRun: true` y declarar `NoneOnDryRun`; si el sistema no conoce o no puede suprimir sus efectos, la solicitud dry-run puede rechazarse ([Kubernetes, Dynamic Admission Control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers); anuncio de server-side dry-run y `kubectl diff`](https://kubernetes.io/blog/2019/01/14/apiserver-dry-run-and-kubectl-diff/)).

**[O]** Kubernetes también advierte que un webhook que modifica recursos externos necesita reconciliación, porque una etapa posterior de admission puede rechazar el objeto después de que el webhook ya produjo el efecto ([Kubernetes, Admission Control](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers)).

**[I]** La propiedad relevante no es “dry-run” como nombre, sino una afirmación verificable: “esta ejecución no cruza la frontera de efectos externos” o “los efectos son reversibles y reconciliables”. Un sandbox que comparte credenciales, red, filesystem o APIs con producción no es un dry-run seguro por etiqueta.

### Aislamiento de capacidades de ejecución

**[O]** Docker rootless ejecuta daemon y contenedores en un *user namespace* sin privilegios root ([Docker Rootless mode](https://docs.docker.com/engine/security/rootless)). Docker seccomp usa un perfil de allowlist con acción por defecto de denegación para restringir syscalls, junto con capacidades y otros mecanismos ([Docker seccomp](https://docs.docker.com/engine/security/seccomp)).

**[I]** Rootless, seccomp, AppArmor, una VM o un sandbox reducen la superficie de efectos, pero no prueban que la operación de negocio sea semánticamente correcta ni que una llamada de red no haya modificado un tercero. Son controles de capability de ejecución; la autorización de negocio y la idempotencia siguen siendo necesarias.

### At-least-once, at-most-once y exactamente una vez

**[O]** AWS Durable Execution documenta que los retries y replay pueden ejecutar varias veces una operación. `At-least-once` es el default y solo es seguro para operaciones idempotentes; `at-most-once per retry` evita una reejecución en ciertas interrupciones, pero ni siquiera esa semántica garantiza exactamente una ejecución en todo el workflow. Para efectos externos se recomienda una clave de idempotencia o no retry ([AWS, “Idempotency and retries”](https://docs.aws.amazon.com/durable-execution/patterns/best-practices/idempotency)).

**[O]** La misma documentación advierte que la clave debe ser estable entre retries y que un error de “duplicate request” normalmente significa que el primer intento pudo haber tenido éxito. La decisión correcta puede ser reconciliar el estado, no volver a cobrar, enviar o crear.

**[I]** Ante una respuesta perdida, el estado correcto no es `failed`; es `unknown`. La máquina de recuperación debería hacer:

```text
UNKNOWN_EFFECT
  -> reconcile(read/query/status) 
  -> CONFIRMED_SUCCESS | CONFIRMED_FAILURE | STILL_UNKNOWN
```

Solo `CONFIRMED_FAILURE` autoriza un retry normal. `STILL_UNKNOWN` debe bloquear el efecto duplicable, abrir una compensación o escalar a una persona según el riesgo.

### Compensation no es rollback


**[O]** Microsoft describe la compensación como una operación específica que intenta contrarrestar pasos ya completados en un workflow eventualmente consistente. Señala que puede haber concurrencia, que no siempre existe un inverso, que la compensación puede fallar y que algunos efectos externos o legalmente vinculantes no se pueden deshacer. Recomienda definir puntos de no retorno, usar comandos idempotentes y escalar a una persona para decisiones de alto impacto o difíciles de automatizar ([Microsoft, “Compensating Transaction pattern”](https://github.com/MicrosoftDocs/architecture-center/blob/main/docs/patterns/compensating-transaction.md)).

**[I]** Reiniciar después de un efecto desconocido es especialmente peligroso: puede transformar una incertidumbre recuperable en una duplicación confirmada. La compensación necesita un ledger de efectos, una relación causal entre operación y contraoperación, y una política que autorice también la compensación.



## 8. Fail-closed, escalación humana y safety cases

### Fail-closed no es una regla universal de disponibilidad

**[O]** OPA deja la decisión fail-open/fail-closed al sistema que integra el motor porque el coste de un falso allow y un falso deny cambia según el caso. Kubernetes permite configurar políticas de fallo de admission con distintos efectos. Cedar usa default deny pero omite policies con error y entrega diagnósticos.

**[I]** La regla práctica debe ser por clase de efecto:

| Tipo de acción | Fallo del PDP o contexto incompleto | Respuesta preferible |
|---|---|---|
| Lectura no sensible o simulación aislada | Puede degradar disponibilidad sin exposición material. | Permitirse un modo degradado explícito y auditable. |
| Cambio reversible e idempotente | Denegar o pasar a cola hasta confirmar policy y estado. | `DENY/DEFER`, no retry ciego. |
| Destrucción, privilegio, dinero, comunicación externa, control físico | La incertidumbre es un riesgo de autorización. | `FAIL-CLOSED`, conservar estado y escalar si procede. |
| Parada física de emergencia | La acción de seguridad debe seguir disponible aunque el PDP esté caído. | Canal de parada independiente del policy engine. |

Fail-closed significa “la incertidumbre no se convierte en permiso”. No significa que el sistema pueda quedarse sin salida: debe existir una acción segura mínima, una cola, un rollback o una escalación.


### Human escalation

**[O]** El NIST AI RMF Playbook recomienda definir roles y responsabilidades de supervisión humana, monitorizar continuamente, preparar respuesta a incidentes y mantener procesos de *appeal and override* ([NIST AI RMF Playbook](https://airc.nist.gov/docs/AI_RMF_Playbook.pdf)).

**[O]** La guía de NRC sobre interfaces humano-sistema separa niveles de automatización como *operation by consent*, *operation by exception* y operación autónoma; en los niveles supervisados, el humano debe aprobar decisiones críticas y poder intervenir ([NRC, “Human-System Interfaces to Automatic Systems”](https://www.nrc.gov/docs/ML1027/ML102720251.pdf)).

**[I]** Una escalación útil debe contener estado, evidencia, efecto ya confirmado, efecto potencial, opciones autorizadas, tiempo restante antes del punto de no retorno y una acción segura por timeout. Pedir “¿qué hago?” después de ejecutar un efecto irreversible no es human-in-the-loop preventivo; es gestión de incidente.


### Safety case y evidence case

**[O]** ISO 26262 trata la seguridad funcional como un ciclo de vida que incluye análisis de peligros, requisitos, diseño, integración, validación y operación; la parte 8 cubre procesos de soporte, integración de sistemas preexistentes y argumentos *proven in use* ([ISO 26262-8:2018](https://www.iso.org/cms/live/live/en/sites/isoorg/contents/data/standard/06/83/68390.html)). IEC 61508 exige considerar el sistema completo, incluidos sensores, lógica, actuadores y acciones humanas críticas ([IEC Functional Safety FAQ](https://www.iec.ch/functional-safety/faq)).

**[O]** NASA usa *assurance cases* y Goal Structuring Notation para organizar afirmaciones, estrategias y evidencia; su herramienta AdvoCATE busca automatizar parte de la construcción y métricas de estos argumentos ([NASA, “New Tool for Developing Safety Assurance Cases”](https://sma.nasa.gov/news/articles/newsitem/2020/09/22/new-tool-for-developing-safety-assurance-cases); [NASA AdvoCATE](https://www.faa.gov/about/office_org/headquarters_offices/ang/redac/redac-sas-201503-advocate.pdf)).

**[O]** ISO 10218-1:2025 cubre requisitos del robot industrial como máquina parcialmente terminada, mientras ISO 10218-2:2025 cubre integración, puesta en marcha, operación, mantenimiento y desmantelamiento de aplicaciones y celdas. El preview de ISO 10218-2 incluye parada, emergencia, reset, interlock de start/restart y protección contra reinicio inesperado ([ISO 10218-1:2025](https://www.iso.org/cms/live/live/es/sites/isoorg/contents/data/standard/07/39/73933.html); [ISO 10218-2:2025](https://www.iso.org/cms/live/live/en/sites/isoorg/contents/data/standard/07/39/73934.html); preview de contenidos](https://cdn.standards.iteh.ai/samples/73934/3578b7f9a402489fb9af1cf1ca03ea68/ISO-10218-2-2025.pdf)).

**[I]** Un safety case no prueba que cada recovery concreto sea correcto en tiempo real. Aporta el argumento de que la arquitectura, sus monitores, límites, pruebas y procedimientos satisfacen una reclamación de seguridad. El runtime todavía necesita observar, bloquear y registrar; el safety case necesita evidencia de que esas funciones operan como se afirma.


## 9. Arquitectura conceptual de policy-constrained recovery

Esta sección es una síntesis de ingeniería basada en las fuentes anteriores, no una implementación ni una instrucción de tocar runtime.

### Estados que deben distinguirse

| Estado | Evidencia mínima | Acción inicial |
|---|---|---|
| `PROGRESSING` | Cambia un estado semántico verificable y la trayectoria es segura. | Continuar. |
| `CONTROL_OSCILLATION` | Signo o rama alterna, frecuencia repetida, progreso bajo. | Aplicar histéresis, cooldown o controlador de escape. |
| `SATURATION_WINDUP` | `u_cmd` excede `u_applied`, memoria interna acumulada. | Anti-windup, reducir referencia o cambiar trayectoria. |
| `PLANNER_DEAD_END` | No existe sufijo válido en el modelo actual o el solver devuelve no-solución. | Backtrack, repair o replanificar con observación nueva. |
| `EXECUTION_LIVELOCK` | Hay eventos y acciones, pero no hay transición de subobjetivo. | Penalizar repetición y activar diagnóstico causal. |
| `AUTHZ_DENY` | PDP/PEP deniega la llamada concreta. | No reintentar igual; seleccionar alternativa autorizada o escalar. |
| `AUTHZ_INDETERMINATE` | Policy no lista, timeout, contexto inválido o policy obsoleta. | Fail-closed para efectos sensibles; mantener estado. |
| `EFFECT_UNKNOWN` | Timeout o pérdida de respuesta después de una llamada con posible efecto. | Reconciliar con la misma identidad de operación. |
| `RECOVERY_DEAD_END` | El conjunto de acciones seguras y autorizadas queda vacío. | Parada segura, cola o escalación humana. |
| `PHYSICAL_UNCONTROLLABLE` | Ninguna acción disponible mantiene seguridad y alcanza un estado recuperable. | Mitigación física, abortar misión o modo seguro. |

### Secuencia de decisión

1. **Congelar nuevos efectos:** no emitir otra operación externa hasta clasificar el estado de la anterior.
2. **Capturar identidad:** asociar request, plan, versión de policy, capability, argumentos, trayectoria y resultado a un `operation_id` estable.
3. **Clasificar el resultado:** éxito confirmado, fallo confirmado, no ejecutado, denegado o efecto desconocido.
4. **Medir progreso semántico:** comprobar landmarks, precondiciones y estado de recursos, no solo actividad.
5. **Buscar signos de control:** saturación, windup, oscilación, histéresis, equilibrio no objetivo, repetición de comandos y divergencia entre trayectoria nominal y aplicada.
6. **Buscar dead-end:** comprobar alcanzabilidad, recursos, invariantes, restricciones y fallos conocidos del solver.
7. **Calcular VOI:** pedir más observación o diagnóstico solo si puede cambiar la acción y el coste es aceptable.
8. **Generar candidatos:** continuar, cambiar controlador, volver a un estado seguro, reparar el sufijo del plan, compensar, reiniciar, poner en cola o escalar.
9. **Filtrar antes del efecto:** safety shield, alcance de trayectoria, capability concreta, presupuesto, idempotencia y aprobación.
10. **Ejecutar por horizonte corto:** aceptar solo un segmento acotado y volver a verificar; no entregar autoridad ilimitada a un plan de recuperación.
11. **Aplicar salida:** si no hay progreso verificable dentro del presupuesto, detener la rama; no convertir el retry en una política de perseverancia infinita.

### Cuándo recovery supera a restart

`Recovery` es preferible a `restart` cuando el fallo contiene información sobre una trayectoria, una precondición, una saturación, una denegación o un efecto externo. El reinicio elimina precisamente esa memoria y puede repetir la causa. `Restart` es preferible cuando el fallo está confinado al proceso, no hubo efecto externo, el estado del mundo se puede volver a observar y el nuevo intento cambia de forma verificable la hipótesis o la versión del plan.

### Barrera de inevitabilidad de la atribución

Antes de etiquetar un incidente como `control-induced stall`, la evidencia mínima debería ser:

- Un trace temporal con estado, acción, observación, versión de plan, decisión de policy y efecto.
- Una métrica de progreso semántico y una ventana de no progreso.
- Un replay o experimento con la misma escena y una intervención en control, plan, observación o autorización.
- Un resultado que cambie al intervenir, con límites de confusión documentados.
- Una prueba de que no se trata mejor de un dead-end, saturación, denegación o efecto desconocido.

## 10. Hipótesis alternativas y falsificadores

Las siguientes hipótesis están diseñadas para destruir la explicación única. Cada falsificador es una prueba concreta que podría hacer abandonar esa hipótesis.

| ID | Hipótesis alternativa | Predicción observable | Falsificador concreto |
|---|---|---|---|
| H1 | `control-induced stall` es solo una etiqueta interna, no una categoría de la literatura. | No aparece una definición transversal en papers, estándares ni documentación; aparecen términos vecinos. | Encontrar una definición publicada que delimite causa, observables y frontera de la categoría en varios dominios. |
| H2 | El fenómeno es `control-induced livelock`, no un dead-end. | Hay acciones y eventos repetidos, pero ninguna transición de subobjetivo. | Un solver de alcanzabilidad demuestra que el estado actual no tiene ningún plan válido, aun con otro controlador. |
| H3 | El origen es un mínimo local del controlador reactivo. | El gradiente o acción resultante se anula o alterna cerca de un obstáculo; una maniobra de escape progresa. | Con el mismo controlador y entorno, una inicialización o perturbación mínima no cambia el atasco y no existe dirección segura de escape local. |
| H4 | El origen es saturación o integrator windup. | `u_cmd` supera límites, `u_applied` queda recortada y la memoria integral continúa creciendo. | Todas las señales están lejos de saturación, no hay estado integral relevante y anti-windup no cambia el comportamiento. |
| H5 | El origen es histéresis, umbrales o conmutación. | El sistema alterna ramas cerca del umbral y un `dwell time` o histéresis reduce la oscilación. | Se sustituyen los switches por una ley suave y el mismo stall persiste con igual periodo y estado. |
| H6 | El origen es interacción planificador-controlador. | Cada módulo aislado parece correcto, pero la combinación produce trayectorias no rastreables, retrasos o cambios de plan demasiado frecuentes. | Un controlador fijo con distintos planificadores y un planificador fijo con distintos controladores producen exactamente el mismo stall bajo estados equivalentes. |
| H7 | El origen es replanning-induced oscillation. | Replanificar más rápido aumenta cambios de ruta, alternancia o tiempo sin progreso; una cadencia con memoria mejora. | Congelar el plan o usar una cadencia fija no cambia la trayectoria y la oscilación aparece sin replanning. |
| H8 | El origen es un dead-end de planificación no reconocido. | El plan sigue siendo sintácticamente activo, pero el objetivo es inalcanzable; aparecen invariantes/traps o todos los sufijos válidos desaparecen. | Un planificador completo encuentra un sufijo válido que el mismo estado puede ejecutar sin cambiar el controlador ni las observaciones. |
| H9 | El origen es incertidumbre parcial de percepción. | Una observación adicional cambia la creencia, el mapa o la rama óptima; el coste de VOI es justificable. | Con estado completo o una observación independiente el sistema sigue el mismo loop, sin cambios de decisión. |
| H10 | El origen es progreso semántico mal medido. | Hay actividad física o de herramientas, pero ningún landmark cambia; el contador de pasos sobreestima avance. | Un monitor semántico independiente confirma que cada iteración sí completa un subobjetivo y que el objetivo final se alcanza después. |
| H11 | El origen es autorización, no control. | El conjunto de acciones que producirían progreso está vacío después del PEP, aunque existan físicamente. | Un trace del PEP muestra `ALLOW` para una acción segura de progreso y el sistema sigue estancado sin causa de trayectoria. |
| H12 | El origen es capability demasiado amplia o confundida. | El agente puede invocar la herramienta, pero usa argumentos, recursos o identidad fuera del propósito autorizado. | La capability es no falsificable, está atenuada por recurso y argumentos, y el PEP verifica la llamada concreta antes del efecto. |
| H13 | El origen es `EFFECT_UNKNOWN` y no un fallo de ejecución. | El timeout ocurre después de una llamada; un retry ciego cambia el estado o duplica un efecto. | La operación tiene idempotency key estable, reconciliación independiente confirma no ejecución y el stall persiste sin retry. |
| H14 | El origen es fail-closed demasiado amplio. | Un timeout de policy bloquea tanto acciones peligrosas como una recuperación segura y autorizada, creando un dead-end artificial. | Separar políticas por clase de efecto deja disponible una acción segura y el sistema se recupera sin abrir el camino peligroso. |
| H15 | El origen es un deadlock de recursos o lock, no control continuo. | No hay transición porque dos tareas esperan recursos, leases o confirmaciones; el estado físico puede estar quieto. | Ejecutar sin concurrencia ni locks, con el mismo controlador, reproduce el mismo estancamiento. |
| H16 | El origen es fallo físico o pérdida de controlabilidad. | Ninguna entrada admisible lleva a un estado seguro recuperable; cambiar el plan no ayuda. | Una trayectoria alternativa segura, un actuador redundante o un controlador base logra progreso con el mismo estado físico. |
| H17 | El origen es un bug de observabilidad/watchdog. | El sistema sí progresa, pero el monitor no actualiza su métrica, pierde eventos o confunde silencio de herramienta con stall. | Instrumentación independiente de estado físico y subobjetivos muestra ausencia real de progreso durante la misma ventana. |
| H18 | El origen es exceso de retries y no una propiedad del control. | Cada retry reinicia la memoria o vuelve a la misma acción, aumentando el número de repeticiones sin nueva información. | Un único intento con presupuesto y un cambio explícito de hipótesis produce el mismo ciclo. |

### Diseño mínimo de los experimentos falsadores

Los falsadores deben aislar una variable cada vez:

| Intervención | Qué separa |
|---|---|
| Controlador nominal frente a controlador base | Inducción por la ley de control. |
| Plan congelado frente a replanning adaptativo | Inducción por cadencia o reparación. |
| Policy shadow mode sin efecto frente a PEP activo | Bloqueo de autorización sin ejecutar la acción. |
| Estado completo frente a observación parcial | Incertidumbre y VOI. |
| Actuador ideal/sin saturación en simulación | Windup y límites físicos. |
| Clave de idempotencia y consulta de estado | Efecto desconocido y duplicación. |
| Single-agent frente a multi-agent | Deadlock o interacción distribuida. |
| Métrica física frente a landmark semántico | Falso progreso. |
| Retry con backoff y acción alternativa | Persistencia versus repetición ciega. |
| Replay determinista del mismo prefijo | Bug de proceso versus estado externo. |

## 11. Casos, código y prácticas contrastadas

| Sistema o caso | Evidencia | Lección para SAGR |
|---|---|---|
| ROS Navigation clásico | `clear_costmap`, `rotate_recovery`, detección de oscilación y experiencias de robot atascado ([guía ROS](https://ar5iv.labs.arxiv.org/html/1706.09068)). | Recuperación debe cambiar estado o información; repetir la misma orden no es recovery. |
| Nav2 Behavior Tree | `IsStuckCondition` y estados de fallo de controlador en la documentación ([Nav2](https://docs.ros.org/en/humble/p/nav2_behavior_tree/generated/classnav2__behavior__tree_1_1IsStuckCondition.html)). | Un detector de stuck es un predicado operacional, no una explicación causal. |
| ROSPlan | Arquitectura académica para integrar planificación en ROS ([Cashmore et al., “ROSPlan”](https://cdn.aaai.org/ojs/13699/13699-40-17217-1-2-20201228.pdf)). | El límite entre plan y ejecución necesita feedback, estado y monitorización. |
| Kubernetes admission | Dry-run, `sideEffects`, `failurePolicy`, reconciliación y mutación por etapas ([docs](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers)). | El PEP debe conocer efectos laterales y no prometer reversibilidad inexistente. |
| OPA | `undefined`, readiness, fail-open/fail-closed delegado al caller y decision logs ([operations](https://www.openpolicyagent.org/docs/operations), [logs](https://www.openpolicyagent.org/docs/management-decision-logs)). | Un policy engine no decide por sí solo qué hacer cuando está caído. |
| Cedar | Default deny, `forbid` sobre `permit`, errores omitidos con diagnósticos ([authorization](https://docs.cedarpolicy.com/auth/authorization.html)). | Default deny y fail-closed ante error son decisiones distintas. |
| Docker | Rootless, user namespaces y seccomp allowlist ([rootless](https://docs.docker.com/engine/security/rootless), [seccomp](https://docs.docker.com/engine/security/seccomp)). | Aislar capacidad de proceso no reemplaza autorización de negocio ni compensación. |
| AWS Durable Execution | Semánticas at-least-once/at-most-once e idempotency keys ([docs](https://docs.aws.amazon.com/durable-execution/patterns/best-practices/idempotency)). | Un timeout después de un efecto debe entrar en `UNKNOWN`, no en retry ciego. |
| Microsoft Azure Architecture Center | Retry, compensación, punto de no retorno y revisión humana ([pattern](https://github.com/MicrosoftDocs/architecture-center/blob/main/docs/patterns/compensating-transaction.md)). | Compensation es específica de dominio y puede fallar; debe auditarse y reanudarse. |
| NASA Resilient Autonomy | MM-RTA, EVAA, abortar misión o volver a base ([NASA Armstrong](https://www.nasa.gov/centers-and-facilities/armstrong/autonomous-systems)). | Runtime assurance debe tener modos de salida, no solo una bandera de error. |
| Simplex | Cambio de autoridad de controlador avanzado a baseline monitorizado ([Black-Box Simplex](https://arxiv.org/abs/2102.12981)). | Recovery seguro necesita un monitor independiente del agente avanzado. |
| ISO 10218 | Stop, reset, restart interlock y prevención de reinicio inesperado ([ISO 10218-2](https://www.iso.org/cms/live/live/en/sites/isoorg/contents/data/standard/07/39/73934.html)). | Reiniciar una máquina segura no debe reactivar automáticamente una acción peligrosa. |
| NASA AdvoCATE/GSN | Argumentos estructurados y evidencia para assurance cases ([AdvoCATE](https://www.faa.gov/about/office_org/headquarters_offices/ang/redac/redac-sas-201503-advocate.pdf)). | La evidencia de seguridad debe incluir monitores, fallback, límites y residual risk. |

## 12. Resultados negativos y límites de la investigación

1. **[N] No se encontró una definición académica transversal de `control-induced stall`.** La búsqueda exacta encontró usos aeronáuticos de *stall*, oscilaciones inducidas por piloto/controlador, snippets de watchdogs de agentes y trabajos robóticos que hablan de *stuck*, *deadlock* u oscilación.
2. **[N] No se encontró un estándar que combine en una sola taxonomía** teoría de control, reparación de planes, autorización, side effects y escalación humana bajo el nombre `policy-constrained recovery`.
3. **[N] No se encontró una garantía general de recovery autónomo** después de una llamada con efecto externo desconocido. Las fuentes de workflows convergen en idempotencia, reconciliación, compensación específica y escalación.
4. **[N] No se encontró un detector universal de progreso semántico.** Los trabajos disponibles usan proposiciones, landmarks, autómatas de tarea o métricas de dominio; no existe una métrica única transferible sin modelar el objetivo.
5. **[N] No se encontró un principio universal de fail-closed.** OPA deja el comportamiento al integrador, Cedar evita un error global mediante skip-on-error y Kubernetes expone políticas configurables. La decisión depende de la clase de efecto.
6. **[N] No se encontró evidencia para atribuir una causa concreta a un runtime SAGR**, porque por petición expresa no se inspeccionó el runtime ni se ejecutaron pruebas.
7. **[N] No se verificó en producción** el audit de frameworks de agentes de 2026; se usó como preprint y como señal de riesgo, no como prueba universal de todos los despliegues.
8. **[N] La documentación de ROS no constituye prueba de seguridad formal.** Las observaciones de “se atasca” y “limpiar costmap ayuda” sirven como casos operativos, no como estimación general de frecuencia ni garantía.
9. **[N] Dry-run no elimina por sí solo efectos out-of-band.** Las propias docs de Kubernetes exigen declaración y reconciliación, lo que confirma el límite de la abstracción.
10. **[N] Safety case no equivale a corrección de cada decisión runtime.** ISO/NASA/GSN organizan argumentos y evidencia; no convierten una política o recovery no verificados en seguros automáticamente.

## 13. Implicaciones de diseño

### Etiqueta recomendada

Usar `CONTROL_INDUCED_STALL` solo como **clase superior de observabilidad**, con campos obligatorios:

```text
stall_kind:
  - oscillation
  - saturation_windup
  - local_minimum
  - planner_dead_end
  - execution_livelock
  - authz_block
  - effect_unknown
  - recovery_dead_end
  - physical_uncontrollable

causal_confidence: 0..1
progress_metric:
progress_window:
last_confirmed_state:
last_confirmed_effect:
policy_decision:
candidate_recoveries:
safe_fallback:
human_escalation:
```

La etiqueta superior no debe ocultar `stall_kind`. Si aún no hay contrafactual, usar `STALL_SUSPECTED`, no `CONTROL_INDUCED`.

### Orden de prioridades

1. Proteger personas, recursos y límites físicos.
2. Evitar nuevos efectos mientras haya `EFFECT_UNKNOWN`.
3. Verificar autorización de la acción concreta antes del efecto.
4. Mantener el prefijo confirmado del plan.
5. Preferir información que pueda cambiar la decisión.
6. Cambiar de estrategia después de detectar repetición, no incrementar indefinidamente el retry.
7. Escalar antes del punto de no retorno.
8. Registrar evidencia suficiente para que el incidente pueda falsar la atribución inicial.

### Conclusión

La hipótesis más resistente es: **“control-induced stall” describe una familia de fallos de liveness en la que el lazo de control, el planificador, el monitor o la política mantienen al sistema dentro de un conjunto seguro pero no progresivo; la familia se descompone en mecanismos ya nombrados por disciplinas maduras.”** La frase es útil como etiqueta de triage, pero peligrosa como explicación final.

La política de recuperación debe unir tres pruebas independientes: **alcanzabilidad de una trayectoria segura**, **progreso semántico verificable** y **autorización de cada efecto**. Cuando cualquiera falla, el sistema no debe responder con un restart ciego: debe distinguir reparación, fallback, compensación, espera con reconciliación y escalación humana. El caso más importante para seguridad es el estado ambiguo: un proceso puede parecer parado cuando en realidad un efecto ya ocurrió, y un policy engine puede parecer disponible cuando no produjo una decisión definida. En ambos casos, fallar cerrado en la frontera de efectos, conservar el estado y demostrar el siguiente paso es más seguro que perseverar.

## 14. Registro de búsquedas

Todas las consultas de esta tabla se realizaron el **2026-09-21**. “No encontrado” significa que no apareció una fuente canónica relevante en los resultados revisados.

| Consulta buscada | Resultado | URLs o fuente representativa |
|---|---|---|
| `"control-induced stall" control theory` | [N] No apareció categoría canónica; resultados principalmente de stall aeronáutico y control clásico. | [FAA Airplane Flying Handbook](https://www.faa.gov/sites/faa.gov/files/regulations_policies/handbooks_manuals/aviation/airplane_handbook/06_afh_ch5.pdf) |
| `"control-induced stall" robotics OR planning OR agent` | [N] No apareció definición académica transversal; aparecieron robot stuck, control-driven planning y un caso de servo burnout. | [Kinodynamic planning](http://ai.stanford.edu/~latombe/papers/IJRR-kino/final.pdf) |
| `"control-induced instability" oscillation hysteresis control` | [O] Sí aparecieron categorías establecidas de oscilación, histéresis, saturación y windup, no un paraguas único. | [NASA actuator saturation](https://ntrs.nasa.gov/api/citations/19940028235/downloads/19940028235.pdf) |
| `control theory actuator saturation integral windup limit cycles paper` | [O] Saturación, windup, pérdida de lazo y recuperación lenta. | [Åström y Rundqwist](http://cse.lab.imtlucca.it/~bemporad/teaching/controllodigitale/pdf/Astrom-ACC89.pdf) |
| `control systems oscillation limit cycle hysteresis relay feedback paper` | [O] Ciclos límite y chattering en relés/histéresis. | [Johansson et al.](https://www.diva-portal.org/smash/get/diva2%3A340579/FULLTEXT01.pdf) |
| `control systems chattering switching hysteresis hybrid systems Zeno behavior paper` | [O] Zeno, chattering y sistemas híbridos tienen definiciones distintas. | [Zhang et al.](https://web.ece.ucsb.edu/~hespanha/ece229/references/ZhangJohanssonHSCC00.pdf) |
| `control-induced oscillations planner controller interaction robotics paper` | [O] Campos de control pueden producir ciclos límite; planner/control interaction es un tema, pero no con esa etiqueta paraguas. | [Reactive circular fields](https://arxiv.org/pdf/2210.16106v1) |
| `feedback control no progress liveness stability autonomous systems paper` | [O] Seguridad y liveness se separan en sistemas autónomos. | [Rules of the Road](https://dl.acm.org/doi/abs/10.1109/TRO.2023.3247951) |
| `robot navigation stuck oscillation recovery behavior local planner paper` | [O] ROS documenta oscilation reset, clear costmap, rotate recovery y agotamiento de recuperaciones. | [ROS Navigation Tuning Guide](https://ar5iv.labs.arxiv.org/html/1706.09068) |
| `automated planning dead-end detection heuristics paper` | [O] Traps, invariants, dead-ends y nogoods son categorías formales de planning. | [ICAPS 2016](https://ojs.aaai.org/index.php/ICAPS/article/view/13774), [ICAPS 2017](https://ojs.aaai.org/index.php/ICAPS/article/view/13802) |
| `semantic progress monitoring autonomous agent planning execution paper` | [O] Se encontraron monitoreo semántico de planes y progreso por proposiciones/automata; no una métrica universal. | [Semantic monitoring](https://www.sciencedirect.com/science/article/abs/pii/S0921889008001152), [PMLR active perception](https://proceedings.mlr.press/v119/ghasemi20a/ghasemi20a.pdf) |
| `plan repair value of information decision theoretic failure recovery` | [O] Diagnóstico probabilístico, selección de reparación y VOI. | [AAAI 1994](https://cdn.aaai.org/AAAI/1994/AAAI94-223.pdf), [ICAPS 2014](https://ojs.aaai.org/index.php/ICAPS/article/view/13624) |
| `safe replanning trajectory recovery robot planner failure prediction` | [O] GP prediction, MPC, recovery state y safe replanning. | [GP recovery](https://arxiv.org/html/2402.01617v1) |
| `when to replan path oscillation stuck robot` | [O] Replanning demasiado frecuente puede oscilar; demasiado infrecuente puede atascar. | [Adaptive replanning](https://arxiv.org/html/2304.12046v3) |
| `policy constrained planning safety shield POMDP` | [O] Shields, HJ filters y CMDP restringen acciones inseguras; pueden afectar liveness. | [Safe POMDP shielding](https://arxiv.org/abs/2309.10216), [CONCUR 2020](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.CONCUR.2020.3) |
| `capability security confused deputy least authority paper` | [O] Confused deputy, object capabilities y least authority están establecidos. | [Hardy](https://www.cs.utexas.edu/~witchel/S25-380L/papers/hardy88confused.pdf), [Wagner](https://dl.acm.org/doi/10.1145/1134744.1134745) |
| `capability gate authorization concrete arguments agent tool calls` | [O] Preprint de 2026 distingue exposure/capability gate de autorización por argumentos. | [ScopeGate](https://arxiv.org/abs/2606.28679) |
| `policy engine fail closed fail open undefined decision` | [O] OPA deja la elección al integrador; `undefined` puede ser falta de policy. | [OPA Operations](https://www.openpolicyagent.org/docs/operations) |
| `Cedar authorization default deny policy evaluation error` | [O] Cedar usa default deny y forbid-overrides-permit, pero skip-on-error. | [Cedar](https://docs.cedarpolicy.com/auth/authorization.html) |
| `Kubernetes dry-run admission side effects reconciliation` | [O] Dry-run requiere conocer/suprimir side effects; webhooks con efectos necesitan reconciliación. | [Dynamic Admission Control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers) |
| `sandbox seccomp rootless capability security Docker` | [O] User namespace, rootless y seccomp allowlist limitan capacidades de ejecución. | [Docker rootless](https://docs.docker.com/engine/security/rootless), [Docker seccomp](https://docs.docker.com/engine/security/seccomp) |
| `side effect uncertainty retries idempotency compensation workflow` | [O] At-least-once, at-most-once, claves de idempotencia y compensación no son rollback perfecto. | [AWS](https://docs.aws.amazon.com/durable-execution/patterns/best-practices/idempotency), [Microsoft](https://github.com/MicrosoftDocs/architecture-center/blob/main/docs/patterns/compensating-transaction.md) |
| `human escalation autonomous systems safety monitor intervention` | [O] NIST/NRC/NASA documentan roles humanos, operación por excepción, intervención y runtime assurance. | [NIST Playbook](https://airc.nist.gov/docs/AI_RMF_Playbook.pdf), [NRC](https://www.nrc.gov/docs/ML1027/ML102720251.pdf), [NASA MM-RTA](https://www.nasa.gov/centers-and-facilities/armstrong/autonomous-systems) |
| `safety case GSN autonomous systems standard` | [O] Safety/assurance cases y GSN organizan reclamaciones y evidencia; no son un recovery runtime. | [NASA AdvoCATE](https://www.faa.gov/about/office_org/headquarters_offices/ang/redac/redac-sas-201503-advocate.pdf), [GSN SCSC](https://scsc.uk/gsn) |
| `ISO 10218 restart interlock emergency stop robot standard` | [O] ISO 10218-2:2025 cubre stop, reset, interlock de start/restart y prevención de reinicio inesperado. | [ISO 10218-2](https://www.iso.org/cms/live/live/en/sites/isoorg/contents/data/standard/07/39/73934.html) |

## 15. Fuentes priorizadas y fecha de consulta

Las URLs siguientes fueron consultadas o verificadas en los resultados el **2026-09-21**. Los enlaces de cada sección anterior contienen el uso concreto de la fuente.

| Fuente | Tipo | Fecha de la fuente, cuando está disponible | Fecha de consulta |
|---|---|---:|---:|
| Lipovetzky, Muise, Geffner, *Traps, Invariants, and Dead-Ends* | P / ICAPS | 2016-03-30 | 2026-09-21 |
| Steinmetz, Hoffmann, *Critical-Path Dead-End Detection versus NoGoods* | P / ICAPS | 2017-06-05 | 2026-09-21 |
| Scala, *Plan Repair for Resource Constrained Tasks* | P / ICAPS | 2014-05-11 | 2026-09-21 |
| *Decision-Theoretic Plan Failure Debugging and Repair* | P / AAAI | 1994 | 2026-09-21 |
| Ghasemi, Bulgur, Topcu, *Task-Oriented Active Perception* | P / PMLR | 2020 | 2026-09-21 |
| Mohammad, Higgins, Bezzo, *GP-based Robust Motion Planning* | P / arXiv + experiments | 2024-02-02 | 2026-09-21 |
| Honda et al., *When to Replan?* | P / arXiv | 2024-02-27, versión consultada | 2026-09-21 |
| Sheng, Parker, Feng, *Safe POMDP Online Planning via Shielding* | P / arXiv | 2024, versión consultada | 2026-09-21 |
| Mehmood et al., *Black-Box Simplex Architecture* | P / NASA Formal Methods | 2022 | 2026-09-21 |
| Hardy, *The Confused Deputy* | P / ACM | 1988 | 2026-09-21 |
| Rajani, Garg, Rezk, *On access control, capabilities...* | P / IEEE CSF | 2016 | 2026-09-21 |
| OPA Operations and Decision Logs | D / CNCF project | documentación viva | 2026-09-21 |
| Cedar Authorization | D / Amazon Cedar | documentación consultada | 2026-09-21 |
| Kubernetes Dynamic Admission Control | D / Kubernetes | documentación consultada | 2026-09-21 |
| Docker rootless y seccomp | D / Docker | documentación consultada | 2026-09-21 |
| AWS Durable Execution, Idempotency and retries | D / AWS | documentación consultada | 2026-09-21 |
| Microsoft Compensating Transaction pattern | D / Microsoft Architecture Center | 2026-04-16 | 2026-09-21 |
| NIST AI RMF Playbook | S / NIST | actualizado 2026-06-10, base 2023 | 2026-09-21 |
| IEC 61508 Functional Safety FAQ | S / IEC | documentación consultada | 2026-09-21 |
| ISO 10218-1/-2:2025 | S / ISO | 2025-02 | 2026-09-21 |
| NASA Resilient Autonomy / MM-RTA | C/S / NASA | página 2021-12-07 | 2026-09-21 |
| NASA R2U2 runtime verification | C/S / NASA | página actualizada 2026-06-22 | 2026-09-21 |

**Cierre epistemológico:** la evidencia apoya que los controladores pueden causar oscilación, windup, mínimos locales, pérdida de liveness y recuperación tardía; que los planificadores pueden entrar en dead-ends o reparar mal; que las policies pueden eliminar el conjunto de acciones recuperables; y que los retries pueden convertir una incertidumbre de efecto en duplicación. La evidencia no justifica afirmar que todo eso sea una única categoría llamada `control-induced stall`. La clasificación correcta debe conservar el síntoma común y exigir una causa falsable.

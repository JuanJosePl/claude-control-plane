# 36 — Diccionario de Definiciones Estables

**Fecha:** 2026-09-21
**Compilado por:** Claude Sonnet 4.6 (meta-auditoría)
**Propósito:** Definición estable de cada concepto clave usado en la investigación. Cuando un término cambió de significado entre documentos, se registra la historia.

---

## estado de ejecución

**Definición adoptada:** Conjunto de información suficiente para determinar el comportamiento futuro del agente: posición en el plan, herramientas disponibles, contexto de memoria, efectos ejecutados hasta el momento, y política activa.

**Uso en GPT:** Variable entre NOTAS; NOTAS_SISTEMAS_CLASICOS usa "estado" como análogo a estado de máquina de estados (s ∈ S); NOTAS_AGENTES_ACADEMIA usa "estado" como "contexto + historial de acciones".

**Uso en segunda pasada:** 10_MODELO_DE_ESTADO_Y_TRAYECTORIA define estado como tupla (contexto, memoria, trayectoria, efectos, política). Más preciso.

**Diferencia material:** La inclusión de "política activa" como componente del estado es nueva en la segunda pasada y es crítica para governance de continuación.

---

## trayectoria

**Definición adoptada:** Secuencia ordenada de estados de ejecución, transiciones, acciones, evidencias y efectos desde el inicio del intento hasta el momento actual, incluyendo las ramas exploradas y descartadas.

**Variante en literatura:** ReflectiChain usa "trajectory" como secuencia de acciones y states; Trajectory Graphs (2607.27443) usa grafos de trayectoria para diagnóstico predictivo.

**Uso en GPT:** Usada implícitamente, no definida formalmente.

**Uso en segunda pasada:** 10_MODELO_DE_ESTADO_Y_TRAYECTORIA la adopta como unidad arquitectónica central.

**Diferencia material:** La inclusión de "ramas descartadas" es específica de esta investigación y no aparece en la literatura con ese nombre; en planning clásico se llama "search tree with pruned branches".

---

## progreso

**Definición adoptada:** Reducción mensurable de la distancia al objetivo, evaluable en al menos una de estas dimensiones: (a) progreso absoluto (tareas completadas / total), (b) progreso marginal (delta por acción), (c) progreso semántico (acercamiento al estado objetivo según evaluación funcional).

**Distinción crítica:** Actividad ≠ Progreso. Un agente puede ejecutar 30 acciones distintas y seguir en el mismo estado funcional (ReflectiChain documenta esto como Semantic-Execution Drift).

**Uso en GPT:** "Progreso" no definido formalmente; tratado como observable binario.

**Uso en segunda pasada:** 11_RECONSTRUCCION_DEL_PROBLEMA distingue explícitamente las tres dimensiones.

---

## recuperación (recovery)

**Definición adoptada:** El proceso de restaurar la capacidad del agente para hacer progreso hacia el objetivo después de una interrupción, clasificada según su causa y su viabilidad de recuperación.

**Variante en Recoverability (2609.13672):** "Recoverability" como propiedad del sistema — si, dado un error, existe al menos una secuencia de acciones que restaura el estado a uno válido.

**Nota de reformulación:** En esta investigación, "recovery" fue gradualmente reemplazado por "governance de la continuación" como concepto más preciso. Recovery sigue siendo correcto para stalls por loop/contexto. "Governance de la continuación" es el concepto para stalls por política con alternativa viable.

**Historia del término:** Dossier → "recovery". Pasada GPT → "SAGR recovery". Segunda pasada → "governance de la continuación". La nomenclatura cambió por evidencia, no por preferencia.

---

## rollback

**Definición adoptada:** Restauración del estado de ejecución a un checkpoint anterior válido, sin implicar la generación de una alternativa ni la recuperación de la intención original.

**Distinción de recovery:** Rollback es un mecanismo; recovery es el objetivo. Un rollback puede ser el primer paso de una recovery, o puede ser el único paso si el objetivo se abandona.

**Uso en literatura:** AgentRewind (2608.14380) implementa rollback de estado con rewind memory. Temporal/LangGraph implementan rollback de estado de workflow.

---

## regresión

**Definición adoptada (multi-sentido):**

- **Regresión de estado operativo:** volver a un checkpoint anterior de la ejecución (sinónimo de rollback en este contexto).
- **Regresión de trayectoria:** cambio de rama activa a una rama anterior sin borrar el historial.
- **Regresión histórica (negativo):** NO borrar evidencia ni trayectoria al hacer un rollback — este es un invariante de SAGR.
- **Regresión de conocimiento:** uso de información de un intento fallido anterior para evitar repetirlo (equivalente a "failed path memory").
- **Regresión de plan:** retroceder a un nodo anterior del plan manteniendo el contexto del intento fallido.
- **Regresión de comportamiento:** comparación del comportamiento actual con uno conocido como correcto (uso en evaluación/testing).
- **Regresión de producto (testing):** sentido clásico de software testing — no se usa en este sentido en esta investigación.

**Nota:** La polisemia del término "regresión" fue una fuente de confusión en el dossier original. Los siete sentidos son distintos y no intercambiables.

---

## stall

**Definición adoptada:** Estado de ejecución en que el agente no hace progreso mensurable hacia el objetivo durante un período o número de acciones que supera un umbral determinado.

**Tipos distinguidos en la investigación:**
- Stall por loop: el agente repite acciones o estados.
- Stall por degradación de contexto: el agente pierde información crítica.
- Stall por agotamiento de opciones: todas las rutas exploradas han fallado.
- Stall por bloqueo de política (STALL_POLICY): una acción necesaria fue bloqueada por el sistema de autorización/guardrails.

**Diferencia entre tipos:** Solo STALL_POLICY puede potencialmente resolverse con governance de continuación. Los otros tipos pueden resolverse con checkpoint + restart o compaction.

---

## control-induced stall / policy-induced stall

**Definición adoptada:** STALL_POLICY — stall causado por el bloqueo de una acción necesaria por parte del sistema de control (guardrails, políticas de autorización, restricciones de seguridad), cuando existe al menos una acción alternativa que lograría el objetivo sin violar la política.

**Estado en literatura:** NOT FOUND como término canónico. Término descriptivo creado en esta investigación. Los papers usan: "stalled execution," "execution failure," "policy violation," "blocked action."

**Importancia:** La existencia de esta categoría es crítica para SAGR porque distingue stalls recuperables via governance de stalls que requieren escalada humana o restart.

---

## HARD STOP

**Definición adoptada:** Terminación definitiva de la ejecución cuando: (a) no existe alternativa policy-compliant conocida, (b) el presupuesto de recovery está agotado, (c) la acción bloqueada era la única ruta al objetivo, o (d) la incertidumbre de seguridad es demasiado alta.

**Fuente primaria:** Recoverability (2609.13672) formaliza la decisión HARD STOP como el caso donde `grant` no puede concederse (no existe recovery path válido). AgentRewind implementa terminación cuando no hay checkpoint útil.

---

## RECOVERABLE STOP

**Definición adoptada:** Interrupción temporal de la ejecución cuando existe al menos una ruta alternativa policy-compliant que podría lograr el objetivo, y la governance de continuación puede identificarla con costo razonable.

**Fuente primaria:** Recoverability (2609.13672) formaliza como el caso donde `grant` puede concederse condicionalmente (existe recovery path válido, sujeto a verificación).

---

## efectos laterales (side effects)

**Definición adoptada:** Cambios en el estado del mundo externo causados por las acciones del agente que persisten independientemente del contexto del agente: modificaciones de archivos, llamadas a APIs externas, cambios en bases de datos, emails enviados, commits realizados, etc.

**Distinción de estado:** El estado del agente es interno y recuperable. Los efectos laterales son externos y en general irreversibles o costosos de revertir.

**Relevancia para SAGR:** Una governance de continuación correcta debe contabilizar los efectos ya producidos para no repetirlos (no re-enviar un email, no re-commitear) y para saber qué está ya "hecho" del objetivo.

---

## evidencia

**Definición adoptada (en contexto CCP):** Artefacto verificable que demuestra que una tarea fue completada con el comportamiento esperado, conteniendo al menos: `task_id`, `contract_hash`, `output_hash`, `timestamp`, y `reviewer_identity`.

**Distinción de observación:** La observación es lo que el agente ve. La evidencia es lo que queda después de la tarea para auditoría independiente.

**Uso en SAGR:** La evidencia de la trayectoria (qué se intentó, qué produjo, qué fue bloqueado) es el insumo para la decisión de governance de continuación.

---

## contexto

**Definición adoptada:** Información disponible para el agente en la ventana de contexto actual: instrucciones, historial de conversación, tool calls y resultados, memoria activa, y cualquier información inyectada por el harness.

**Distinción de memoria:** El contexto es volátil (se compacta, se pierde). La memoria es persistida externamente y puede reconstruirse.

**Distinción de estado:** El contexto es lo que el agente procesa; el estado es la representación formal de dónde está en la ejecución.

---

## memoria (episódica / de trabajo / de trayectoria)

**Definición adoptada:**
- **Memoria episódica:** registro persistente de episodios completos, recuperable para referencia futura.
- **Memoria de trabajo:** contenido activo en el contexto durante la ejecución; volátil.
- **Memoria de trayectoria:** registro de los pasos de ejecución, checkpoints, acciones y resultados, diseñado para reconstrucción y governance. Puede incluir "failed path memory" — los caminos fallados para evitar repetirlos.

**Fuente:** AgentRewind (2608.14380) implementa "rewind memory" como una forma de memoria de trayectoria.

---

## verificación post-recuperación

**Definición adoptada:** Proceso de confirmar que, después de una recovery o de ejecutar una acción alternativa, el agente está en un estado válido que: (a) no viola ninguna política, (b) no duplcó efectos laterales, (c) mantiene evidencia coherente, y (d) representa progreso real hacia el objetivo.

**Fuente:** Recoverability (2609.13672) formaliza la verificación post-recovery como un componente explícito del sistema.

---

## presupuesto de recuperación

**Definición adoptada:** Límite explícito de recursos (tokens, tiempo, llamadas, herramientas, subagentes) asignados a un intento de recovery, después del cual el sistema debe escalar o ejecutar un HARD STOP.

**Fuente:** BAGEN (2606.00198) propone uncertainty-aware budget estimation. ExTS (2608.23848) implementa budget-constrained search. Irreversibility Budget (2609.00275) propone accounting a nivel de flota.

**Nota:** No existe un "recovery budget" como primitiva de producto nombrada. El concepto surge de la composición de varios papers.

---

## governance de la continuación

**Definición adoptada:** Capa de control que decide qué puede hacer un agente cuando ya no puede hacer lo que planeaba, verificando que cualquier alternativa: (a) logra el objetivo original o una aproximación autorizada, (b) no reproduce el efecto de la acción bloqueada por otro medio (non_bypass_verify), y (c) opera dentro del presupuesto de recovery asignado.

**Estado en literatura:** NOT FOUND como término canónico. Término derivado en esta investigación como reformulación más precisa de "SAGR". El paper más cercano es 2604.07833 ("runtime governance for policy-constrained execution") pero usa "execution governance" en sentido más amplio.

**Historia:** Dossier → "SAGR recovery". Pasada GPT → "SAGR como composición con primitivas conocidas". Segunda pasada → "governance de la continuación" como reformulación más precisa que distingue de recovery clásico.

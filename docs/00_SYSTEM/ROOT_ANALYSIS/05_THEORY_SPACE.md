# 05 — THEORY SPACE

> Fases 6 y 7 del protocolo maestro: generar teorías explicativas, modelos competidores,
> hipótesis arquitectónicas y auditarias críticamente PAC y el modelo "compilador de gobernanza".

---

## 1. Generación de teorías explicativas

### Teoría T1 — Sistema de gobernanza de agentes

| Campo | Valor |
|---|---|
| ENUNCIADO CENTRAL | CCP es un sistema que aplica políticas humanas sobre el comportamiento de un agente de código, con gates de evidencia y autorización. |
| QUÉ PARTE EXPLICA MEJOR | F1-F8: hooks, registries, evidence gate, owner decisions. |
| QUÉ PARTE NO EXPLICA | La investigación de frontera (M001-M007): no es solo aplicar políticas, es entender qué políticas faltan. |
| QUÉ PREDICE QUE DEBERÍA EXISTIR | Un motor de políticas unificado y observable. |
| ¿EXISTE? | PARCIALMENTE — PAC es prototipo; la mayoría son regex bash. |
| QUÉ PREDICE QUE NO DEBERÍA EXISTIR | Duplicación política/enforcement. EXISTE. |
| QUÉ EXPERIMENTO LA FALSIFICARÍA | Demostrar que las políticas no gobiernan efectivamente el comportamiento del agente. |
| NIVEL DE SOPORTE | MEDIO |

### Teoría T2 — Compilador de gobernanza

| Campo | Valor |
|---|---|
| ENUNCIADO CENTRAL | CCP compila especificación de intención (reglas) en enforcement (hooks) con observación y aprendizaje. |
| QUÉ PARTE EXPLICA MEJOR | Prototipo PAC: YAML → regex bash. READY-01/02 colapsan conceptualmente. |
| QUÉ PARTE NO EXPLICA | Decisiones humanas, RCA, aceptación de riesgo, investigación de frontera. |
| QUÉ PREDICE QUE DEBERÍA EXISTIR | Una especificación central canónica de la que se derive todo enforcement. |
| ¿EXISTE? | NO — PAC es prototipo; reglas y regex coexisten manualmente. |
| QUÉ PREDICE QUE NO DEBERÍA EXISTIR | Traducción manual de política a regex. EXISTE. |
| QUÉ EXPERIMENTO LA FALSIFICARÍA | Demostrar que PAC produce drift o FP inaceptable en producción. |
| NIVEL DE SOPORTE | DÉBIL-MEDIO (prototipo soportado, producción no) |

### Teoría T3 — Sistema de control con retroalimentación

| Campo | Valor |
|---|---|
| ENUNCIADO CENTRAL | CCP es un lazo de feedback que detecta desviaciones (incidentes, bypasses, drift) y las corrige con controles y regresiones. |
| QUÉ PARTE EXPLICA MEJOR | INC-001 → CTRL-001 → REG-001 → EV-006; F7 bugs → REG-002..REG-009. |
| QUÉ PARTE NO EXPLICA | LABYRINTH-1: el nodo de observación no produce datos suficientes y el nodo de implementación está bloqueado. |
| QUÉ PREDICE QUE DEBERÍA EXISTIR | Ciclo cerrado para todo incidente relevante. |
| ¿EXISTE? | PARCIALMENTE — cerrado para reactivo, roto para preventivo/proactivo. |
| QUÉ PREDICE QUE NO DEBERÍA EXISTIR | Problemas residuales sin mecanismo de observación. EXISTE (H-01). |
| QUÉ EXPERIMENTO LA FALSIFICARÍA | Un incidente recurrente sin control posterior. |
| NIVEL DE SOPORTE | MEDIO |

### Teoría T4 — Sistema de conocimiento acumulativo

| Campo | Valor |
|---|---|
| ENUNCIADO CENTRAL | CCP acumula conocimiento sobre qué construir, qué no construir, y por qué, a través de movimientos documentados. |
| QUÉ PARTE EXPLICA MEJOR | `CCP_EXPLORATION_ENGINE.md`, M001-M007, reclasificación de hipótesis, what-not-to-build. |
| QUÉ PARTE NO EXPLICA | Los hooks y enforcement runtime: son mecanismos, no conocimiento. |
| QUÉ PREDICE QUE DEBERÍA EXISTIR | Motor de inferencia o al menos recuperación activa de conocimiento. |
| ¿EXISTE? | NO — el conocimiento vive en Markdown y requiere sesiones para reactivarse. |
| QUÉ PREDICE QUE NO DEBERÍA EXISTIR | Reinvestigación de lo ya establecido. PARCIALMENTE EXISTE (riesgo sin agente persistente). |
| QUÉ EXPERIMENTO LA FALSIFICARÍA | Demostrar que el sistema no aprende de movimientos previos. |
| NIVEL DE SOPORTE | MEDIO |

### Teoría T5 — Infraestructura de confianza

| Campo | Valor |
|---|---|
| ENUNCIADO CENTRAL | CCP es una infraestructura que permite confiar en el trabajo de un agente de código mediante trazabilidad, reversibilidad y verificación. |
| QUÉ PARTE EXPLICA MEJOR | Evidence gate, registries, Git provenance, rollback, maintenance. |
| QUÉ PARTE NO EXPLICA | Por qué gran parte del esfuerzo fue investigar si el problema residual era material. |
| QUÉ PREDICE QUE DEBERÍA EXISTIR | Verificación determinista de todo cambio importante. |
| ¿EXISTE? | PARCIALMENTE — maintenance 12/12 para estructura; no para comportamiento nativo. |
| QUÉ PREDICE QUE NO DEBERÍA EXISTIR | Cambios sin evidencia. EXISTE como riesgo (reviewer humano puede fallar). |
| QUÉ EXPERIMENTO LA FALSIFICARÍA | Un cambio importante aceptado sin evidencia válida. |
| NIVEL DE SOPORTE | MEDIO |

### Teoría T6 — Sistema de capacidades controladas

| Campo | Valor |
|---|---|
| ENUNCIADO CENTRAL | CCP habilita/deshabilita capacidades del agente según contexto, permisos y gates. |
| QUÉ PARTE EXPLICA MEJOR | `settings.json` allow/ask/deny; fases autorizadas; skills habilitadas. |
| QUÉ PARTE NO EXPLICA | Investigación de frontera y decisión de qué capacidades deberían existir. |
| QUÉ PREDICE QUE DEBERÍA EXISTIR | Un registro de capacidades y su estado. |
| ¿EXISTE? | PARCIALMENTE — implícito en skills y settings. |
| QUÉ PREDICE QUE NO DEBERÍA EXISTIR | Capacidades sin dueño claro. PARCIALMENTE EXISTE. |
| QUÉ EXPERIMENTO LA FALSIFICARÍA | Una capacidad activada sin autorización. |
| NIVEL DE SOPORTE | MEDIO |

### Teoría T7 — Pipeline de transformación de especificaciones

| Campo | Valor |
|---|---|
| ENUNCIADO CENTRAL | CCP transforma intención humana en especificación, ejecución, verificación y evidencia. |
| QUÉ PARTE EXPLICA MEJOR | F1-F8 como pipeline secuencial con entregables y gates. |
| QUÉ PARTE NO EXPLICA | M001-M007: no es pipeline lineal, es exploración cíclica. F9 NOT JUSTIFIED contradice pipeline. |
| QUÉ PREDICE QUE DEBERÍA EXISTIR | F9 como implementación. |
| ¿EXISTE? | NO — F9 fue research, no implementación. |
| QUÉ PREDICE QUE NO DEBERÍA EXISTIR | Investigación sin fase de implementación inmediata. EXISTE. |
| QUÉ EXPERIMENTO LA FALSIFICARÍA | F9 NOT JUSTIFIED. |
| NIVEL DE SOPORTE | DÉBIL para todo CCP; FUERTE para F1-F8. |

### Teoría T8 — Sistema híbrido (candidato principal)

| Campo | Valor |
|---|---|
| ENUNCIADO CENTRAL | CCP es una combinación de gobernanza, pipeline, ciclo de control y sistema de conocimiento; ningún modelo puro es suficiente. |
| QUÉ PARTE EXPLICA MEJOR | Todo: F1-F8 como pipeline; incidentes como control loop; M001-M007 como conocimiento; gates como gobernanza. |
| QUÉ PARTE NO EXPLICA | Por qué la investigación no se cerró en una arquitectura más simple. |
| QUÉ PREDICE QUE DEBERÍA EXISTIR | Múltiples mecanismos conectados por un propósito común. |
| ¿EXISTE? | Sí. |
| QUÉ PREDICE QUE NO DEBERÍA EXISTIR | Mecanismos aislados sin conexión con el propósito. PARCIALMENTE EXISTE (native runtime unknown). |
| QUÉ EXPERIMENTO LA FALSIFICARÍA | Demostrar que un modelo puro explica todo mejor. |
| NIVEL DE SOPORTE | FUERTE |

---

## 2. Competing Models

| Dimensión | T1 Gobernanza | T2 Compilador | T3 Control loop | T4 Conocimiento | T5 Confianza | T6 Capacidades | T7 Pipeline | T8 Híbrido |
|---|---|---|---|---|---|---|---|---|
| Poder explicativo (F1-F8) | Alto | Medio | Alto | Bajo | Alto | Medio | Muy alto | Muy alto |
| Poder explicativo (M001-M007) | Bajo | Medio | Medio | Alto | Medio | Bajo | Bajo | Alto |
| Complejidad que absorbe | Media | Alta (si PAC) | Media | Baja | Media | Media | Baja | Alta |
| Piezas que eliminaría | Ninguna | Duplicación política | Ninguna | Ninguna | Ninguna | Ninguna | Investigación | Ninguna |
| Piezas que derivaría | Ninguna | Política→regex | Controles de incidentes | Ninguna | Ninguna | Capacidades | Ninguna | Ninguna |
| Dependencias que crea | Ninguna | Motor PAC | Observación H-01 | Motor de conocimiento | Ninguna | Registry de caps | Ninguna | Ninguna |
| Información que pierde | Investigación | Decisiones humanas | Proactivo | Runtime | Materialidad | Propósito | Frontera | Ninguna crítica |
| Capacidad de evolución | Media | Alta (datos/config) | Media | Alta | Media | Media | Baja | Alta |
| Capacidad de verificación | Alta | Media | Media | Baja | Alta | Media | Alta | Alta |
| Reversibilidad | Alta | Media | Alta | Alta | Alta | Alta | Alta | Alta |

**Conclusión:** T8 (híbrido) tiene mayor poder explicativo con menor información perdida.

---

## 3. Hipótesis arquitectónicas

### H1 — PAC como arquitectura raíz

| Campo | Valor |
|---|---|
| ID | H1 |
| NOMBRE | PAC as Root Architecture |
| DESCRIPCIÓN | Reemplazar `.claude/rules/*.md` + regex manual por un YAML canónico compilado a patrones bash y verificable. |
| QUÉ EXPLICA | READY-01/02 colapsan; duplicación política desaparece; reparaciones son edits de YAML. |
| QUÉ NO EXPLICA | Evidence gate, native runtime, H-01, decisiones humanas. |
| QUÉ ABSORBE | 4 políticas PARTIAL; P1'/P2' patterns; NH-09 normalización. |
| QUÉ ELIMINA | Duplicación política/enforcement; decisión READY-01/02 separadas. |
| QUÉ VUELVE DERIVABLE | Regex de `bash-firewall.sh` a partir de YAML. |
| QUÉ SIMPLIFICA | Añadir/modificar políticas. |
| QUÉ NUEVA COMPLEJIDAD CREA | Motor de compilación; validación de que la compilación no introduce drift; manejo de FP classes (PAC-EF-02). |
| QUÉ ROMPE | Trust boundary actual si PAC tiene bug; F9-D01=A (requiere autorización). |
| QUÉ REQUIERE | Autorización owner; decisión R2 (implementación post-F8) y R3 (representación de política). |
| IMPLICACIONES PARA | hooks: `bash-firewall.sh` generado; policies: YAML canónico; evidence: tests de compilación; state: nuevo componente. |
| FALSIFICADOR | PAC produce drift o FP no manejable en corpus expandido. |
| EXPERIMENTO MÍNIMO | Expandir corpus PAC a 25 políticas y verificar zero semantic drift (M007/M008 ya en progreso). |
| CONFIANZA INICIAL | MEDIA |

### H2 — Compilador de gobernanza

| Campo | Valor |
|---|---|
| ID | H2 |
| NOMBRE | Governance Compiler |
| DESCRIPCIÓN | CCP como compilador de intención → especificación → enforcement → observación → aprendizaje → nueva especificación. |
| QUÉ EXPLICA | Pipeline F1-F8; prototipo PAC; ciclo de control. |
| QUÉ NO EXPLICA | Decisión humana, RCA, investigación de frontera. |
| QUÉ ABSORBE | H1, parte de T2/T3. |
| QUÉ ELIMINA | Nada — añade una capa conceptual. |
| QUÉ VUELVE DERIVABLE | Política, patterns, parte de tests. |
| QUÉ SIMPLIFICA | Razonamiento sobre el sistema. |
| QUÉ NUEVA COMPLEJIDAD CREA | Metáfora que puede forzar al sistema a encajar en un modelo que no es completo. |
| QUÉ ROMPE | Nada si se usa como lente, no como arquitectura. |
| QUÉ REQUIERE | Separar lo compilable de lo no compilable. |
| IMPLICACIONES PARA | Todo el sistema. |
| FALSIFICADOR | Demostrar que la mayoría de las decisiones no son compilables. |
| EXPERIMENTO MÍNIMO | Listar qué partes de CCP son compilables y cuáles no. |
| CONFIANZA INICIAL | MEDIA-BAJA |

### H3 — Evidence-gated completion como núcleo

| Campo | Valor |
|---|---|
| ID | H3 |
| NOMBRE | Evidence as Core Primitive |
| DESCRIPCIÓN | La primitiva central de CCP es que ninguna tarea contractual se cierra sin evidencia verificable. |
| QUÉ EXPLICA | TaskCompleted gate; EVIDENCE_REGISTRY; maintenance; incident learning. |
| QUÉ NO EXPLICA | Política, investigación de frontera, native runtime. |
| QUÉ ABSORBE | F2, F4, F7, F8-A. |
| QUÉ ELIMINA | Ninguna. |
| QUÉ VUELVE DERIVABLE | Formato de evidence, checks requeridos. |
| QUÉ SIMPLIFICA | Criterio de DONE. |
| QUÉ NUEVA COMPLEJIDAD CREA | Ninguna — ya implementado. |
| QUÉ ROMPE | Nada. |
| QUÉ REQUIERE | Nada adicional. |
| IMPLICACIONES PARA | evidence gate, registries, maintenance. |
| FALSIFICADOR | Una tarea importante cerrada sin evidencia. |
| EXPERIMENTO MÍNIMO | Verificar que `task-completed-evidence.sh` bloquea payload sin evidence. |
| CONFIANZA INICIAL | ALTA |

### H4 — Human-in-the-loop como trust boundary permanente

| Campo | Valor |
|---|---|
| ID | H4 |
| NOMBRE | Permanent Human Trust Boundary |
| DESCRIPPIÓN | El reviewer humano (Git diff + owner gates) es y seguirá siendo el trust boundary último de CCP. |
| QUÉ EXPLICA | F9-D04; no implementar A-05/A-07/G-N5; READY-03 aceptación de residual. |
| QUÉ NO EXPLICA | Cómo escalar sin humano; cómo detectar fallos del humano. |
| QUÉ ABSORBE | Decisiones de trust boundary. |
| QUÉ ELIMINA | Necesidad de self-verifying system. |
| QUÉ VUELVE DERIVABLE | Nada. |
| QUÉ SIMPLIFICA | Arquitectura actual. |
| QUÉ NUEVA COMPLEJIDAD CREA | No escala automáticamente; depende de disponibilidad y calidad del humano. |
| QUÉ ROMPE | Nada. |
| QUÉ REQUIERE | HRQS (M008) para calidad de revisión. |
| IMPLICACIONES PARA | hooks, Git workflow, owner gates. |
| FALSIFICADOR | Incidente no detectado por reviewer humano. |
| EXPERIMENTO MÍNIMO | Auditar un mes de diffs buscando bypasses aceptados. |
| CONFIANZA INICIAL | ALTA (estado actual) |

### H5 — Incident learning escalable

| Campo | Valor |
|---|---|
| ID | H5 |
| NOMBRE | Scalable Incident Learning |
| DESCRIPCIÓN | El framework INC → RCA → CONTROL → REGRESSION → EVIDENCIA puede escalar a múltiples incidentes sin rediseño. |
| QUÉ EXPLICA | INC-001; F7 bugs convertidos en regresiones. |
| QUÉ NO EXPLICA | Cómo se detecta el incidente; qué pasa sin incidentes orgánicos (LABYRINTH-1). |
| QUÉ ABSORBE | F4, parte de F7. |
| QUÉ ELIMINA | Nada. |
| QUÉ VUELVE DERIVABLE | Controles y regresiones a partir de incidentes. |
| QUÉ SIMPLIFICA | Proceso post-incidente. |
| QUÉ NUEVA COMPLEJIDAD CREA | Ninguna si se mantiene ligero. |
| QUÉ ROMPE | Nada. |
| QUÉ REQUIERE | Más incidentes para validar. |
| IMPLICACIONES PARA | INCIDENT_REGISTRY, CONTROL_REGISTRY, REGRESSION_REGISTRY. |
| FALSIFICADOR | Incidente recurrente sin control posterior. |
| EXPERIMENTO MÍNIMO | Simular 3 incidentes y verificar que el proceso produce control+regresión+evidencia. |
| CONFIANZA INICIAL | MEDIA |

### H6 — Control plane como lenguaje de políticas ejecutables

| Campo | Valor |
|---|---|
| ID | H6 |
| NOMBRE | Executable Policy Language |
| DESCRIPCIÓN | CCP evoluciona hacia un lenguaje declarativo de políticas que el runtime interpreta. |
| QUÉ EXPLICA | H1; PAC; posible unificación de rules + hooks. |
| QUÉ NO EXPLICA | Evidence, reviewer, decisiones humanas. |
| QUÉ ABSORBE | `.claude/rules/*.md`, `bash-firewall.sh`. |
| QUÉ ELIMINA | Duplicación. |
| QUÉ VUELVE DERIVABLE | Enforcement a partir de especificación. |
| QUÉ SIMPLIFICA | Curado de políticas. |
| QUÉ NUEVA COMPLEJIDAD CREA | Motor de ejecución; validación semántica. |
| QUÉ ROMPE | Arquitectura actual si se reemplaza completamente. |
| QUÉ REQUIERE | R2 + R3. |
| IMPLICACIONES PARA | hooks, policies, evals. |
| FALSIFICADOR | Políticas que no pueden expresarse en el lenguaje. |
| EXPERIMENTO MÍNIMO | Implementar 5 políticas reales en lenguaje declarativo y ejecutarlas. |
| CONFIANZA INICIAL | MEDIA-BAJA |

### H7 — Assurance layer universal

| Campo | Valor |
|---|---|
| ID | H7 |
| NOMBRE | Universal Assurance Layer |
| DESCRIPCIÓN | CCP podría envolver cualquier agente de código, no solo Claude Code. |
| QUÉ EXPLICA | Diseño desacoplado del runtime nativo; hooks basados en payload genérico. |
| QUÉ NO EXPLICA | Por qué se construyó específicamente para Claude Code. |
| QUÉ ABSORBE | Portabilidad conceptual. |
| QUÉ ELIMINA | Nada. |
| QUÉ VUELVE DERIVABLE | Nada. |
| QUÉ SIMPLIFICA | Narrativa comercial. |
| QUÉ NUEVA COMPLEJIDAD CREA | Ninguna si se mantiene como propiedad emergente. |
| QUÉ ROMPE | Nada. |
| QUÉ REQUIERE | Validar con otro agente. |
| IMPLICACIONES PARA | hooks, settings.json. |
| FALSIFICADOR | Hooks dependen de payload específico de Claude Code. |
| EXPERIMENTO MÍNIMO | Mapear payloads de otro agente a los hooks actuales. |
| CONFIANZA INICIAL | BAJA |

### H8 — Capacidades dinámicas

| Campo | Valor |
|---|---|
| ID | H8 |
| NOMBRE | Dynamic Capability System |
| DESCRIPCIÓN | CCP gestiona capacidades del agente dinámicamente según contexto, riesgo y estado. |
| QUÉ EXPLICA | `settings.json` allow/ask/deny; fases; skills. |
| QUÉ NO EXPLICA | Por qué las capacidades son estáticas en su mayoría. |
| QUÉ ABSORBE | Permisos, fases, skills. |
| QUÉ ELIMINA | Nada. |
| QUÉ VUELVE DERIVABLE | Configuración de permisos a partir de riesgo. |
| QUÉ SIMPLIFICA | Razonamiento sobre permisos. |
| QUÉ NUEVA COMPLEJIDAD CREA | Motor de capacidades; riesgo dinámico. |
| QUÉ ROMPE | Nada. |
| QUÉ REQUIERE | Modelo de riesgo operacional. |
| IMPLICACIONES PARA | settings.json, hooks, skills. |
| FALSIFICADOR | Capacidad activada sin correspondencia de riesgo. |
| EXPERIMENTO MÍNIMO | Mapear cada permiso a una fase/riesgo. |
| CONFIANZA INICIAL | MEDIA |

### H9 — Organismo de aprendizaje

| Campo | Valor |
|---|---|
| ID | H9 |
| NOMBRE | Learning Organism |
| DESCRIPCIÓN | CCP es un organismo que aprende de la interacción con el agente, el humano y el entorno. |
| QUÉ EXPLICA | Exploration Engine, incident learning, M001-M007. |
| QUÉ NO EXPLICA | Runtime deterministico; evidence gate. |
| QUÉ ABSORBE | T4 conocimiento, T3 control loop. |
| QUÉ ELIMINA | Nada. |
| QUÉ VUELVE DERIVABLE | Nada directamente. |
| QUÉ SIMPLIFICA | Narrativa del sistema vivo. |
| QUÉ NUEVA COMPLEJIDAD CREA | Metáfora que puede confundir. |
| QUÉ ROMPE | Nada. |
| QUÉ REQUIERE | No aplica. |
| IMPLICACIONES PARA | documentación, cultura del sistema. |
| FALSIFICADOR | Sistema no cambia tras incidente ni investigación. |
| EXPERIMENTO MÍNIMO | Demostrar cambio efectivo post-incidente. |
| CONFIANZA INICIAL | MEDIA-BAJA (metafórica) |

### H10 — Infraestructura de reversibilidad

| Campo | Valor |
|---|---|
| ID | H10 |
| NOMBRE | Reversibility Infrastructure |
| DESCRIPCIÓN | El propósito primario de CCP es hacer que todo cambio del agente sea reversible y auditable. |
| QUÉ EXPLICA | Checkpoints, Git provenance, rollback, fail-closed design. |
| QUÉ NO EXPLICA | Evidence gate, política, investigación. |
| QUÉ ABSORBE | Parte de T5 confianza. |
| QUÉ ELIMINA | Nada. |
| QUÉ VUELVE DERIVABLE | Nada. |
| QUÉ SIMPLIFICA | Criterio de diseño. |
| QUÉ NUEVA COMPLEJIDAD CREA | Ninguna. |
| QUÉ ROMPE | Nada. |
| QUÉ REQUIERE | Nada. |
| IMPLICACIONES PARA | hooks, Git workflow, installer. |
| FALSIFICADOR | Cambio no reversible. |
| EXPERIMENTO MÍNIMO | Intentar rollback de F7/F8 checkpoints. |
| CONFIANZA INICIAL | ALTA |

---

## 4. Auditoría de PAC

### 4.1 Preguntas del protocolo

| Pregunta | Respuesta |
|---|---|
| ¿PAC es realmente una arquitectura raíz? | PARCIAL. Resuelve representación de política pero no runtime nativo, evidence gate, decisiones humanas, H-01. |
| ¿O PAC es solo un componente de una arquitectura más profunda? | Es un componente importante de la arquitectura de gobernanza, no la raíz completa. |
| ¿PAC resuelve un problema local de representación? | Sí — el problema de que política y enforcement viven en representaciones separadas. |
| ¿PAC es una instancia de un patrón que aparece en otras áreas? | Sí — es un caso de "derivación automática" que también falla en contract_hash/artifact_hash. |
| ¿Qué parte de CCP NO describe PAC? | Evidence, reviewer humano, decisión de fases, native runtime, incident learning. |
| ¿Qué quedaría sin compilar si PAC existiera completamente? | Decisiones humanas, RCA, aceptación de riesgo, investigación de frontera. |
| ¿PAC elimina la necesidad de sincronización manual o la desplaza? | La desplaza: en lugar de sincronizar Markdown↔regex, se sincroniza YAML↔compiler↔regex. |
| ¿Qué complejidad nueva introduce PAC? | Motor de compilación; validación de no-drift; manejo de FP classes (PAC-EF-02). |
| ¿Existiría la misma lógica bajo otro nombre si no fuera PAC? | Sí — cualquier motor de políticas declarativo. |

### 4.2 Veredicto

PAC sobrevive como **hipótesis arquitectónica local fuerte** pero **no como arquitectura raíz de CCP**. Es un componente de la decisión raíz R3 (representación de política).

---

## 5. Auditoría de "Compilador de gobernanza"

### 5.1 Preguntas del protocolo

| Pregunta | Respuesta |
|---|---|
| ¿Qué parte de CCP no es compilable? | Decisiones del Owner, RCA, aceptación de riesgo, investigación de frontera, HRQS humano. |
| ¿Qué requiere intervención humana incluso en ese modelo? | Especificación de políticas, autorización de fases, definición de N, revisión final. |
| ¿Qué información se pierde en la compilación? | Intención semántica, contexto de negocio, juicio de materialidad. |
| ¿Qué capas funcionan con un modelo completamente diferente? | Evidence gate (validación determinista), incident learning (ciclo humano), investigación (exploración). |
| ¿Es "compilador" la metáfora correcta? | Parcial. Funciona para política→enforcement; no para todo CCP. |
| ¿Qué evidencia del repositorio soporta esto? | Prototipo PAC; duplicación política/enforcement; READY-01/02 colapsables. |
| ¿Qué evidencia la contradice? | F9-D01=A; F9-D04=B; decisión humana central; H-01 sin datos. |

### 5.2 Veredicto

"Compilador de gobernanza" es una **metáfora útil pero incompleta**. Aplica bien a la capa de política (R3) pero no puede ser el modelo dominante de CCP. Sobrevive como lente parcial, no como arquitectura raíz.

---

## 6. Resumen de la fase 6+7

- **Teoría más sólida:** T8 (híbrido) — mayor poder explicativo, menor información perdida.
- **Teoría con mayor soporte empírico:** T3 (control loop) para incidentes reactivos; H3 (evidence as core) para F2/F4/F7/F8.
- **Hipótesis arquitectónica más prometedora:** H1 (PAC) para resolver duplicación política, aunque limitada a R3.
- **Hipótesis más conservadora y bien soportada:** H4 (human trust boundary) y H10 (reversibility infrastructure).
- **PAC:** sobrevive como componente local, no como raíz.
- **Compilador de gobernanza:** metáfora parcial; no arquitectura raíz.
- **UNKNOWN persistente:** H-01 materiality; native runtime behavior.

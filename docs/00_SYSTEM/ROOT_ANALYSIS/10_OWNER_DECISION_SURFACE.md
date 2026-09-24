# 10 — OWNER DECISION SURFACE

> Fase 12 del protocolo maestro: presentar el mapa completo de decisiones que corresponden al
> Owner, con el Decision Collapse Map y respuestas a las 32 preguntas finales.

---

## 1. Decisiones para el Owner

### 1.1 READY-01 — AC-02 Authorization Decision

```text
═══════════════════════════════════════════════════════════
DECISIÓN: READY-01
═══════════════════════════════════════════════════════════

ENUNCIADO PRECISO:
¿Las 4 reparaciones propuestas a políticas (POL-05, POL-08, POL-10, POL-13)
constituyen una "mejora documental" permitida bajo F9-D01=A, o un "cambio de regla"
que requiere autorización separada?

POR QUÉ EXISTE:
4 políticas son PARTIAL y producen UNKNOWN en R-3. Las reparaciones las hacen
EXPLICIT, mejorando la tasa SAFE de ~75% a ~87.5% (experimental).

DECISIÓN RAÍZ DE LA QUE DEPENDE:
R3 (representación de política) y R2 (autorización post-F8).

─────────────────────────────────────────────────────────
OPCIÓN A — SÍ, son mejora documental
─────────────────────────────────────────────────────────
DESCRIPCIÓN: Aprobar las 4 adiciones textuales (8 oraciones en total) a
.claude/rules/*.md como clarificación, no como cambio de regla.

QUÉ CAMBIA SI SE ACEPTA:
  → en el código: 8 oraciones nuevas en 4 archivos .md.
  → en la arquitectura: ningún cambio de enforcement.
  → en las políticas: POL-05/08/10/13 pasan de PARTIAL a EXPLICIT.
  → en los tests: ninguno nuevo requerido (la semántica no cambia).
  → en la documentación: posible actualización de índice de políticas.

QUÉ CAMBIA SI SE RECHAZA:
  → Las políticas permanecen PARTIAL.
  → R-3 sigue produciendo UNKNOWN para esos casos.
  → L1-C Condition 2 queda insatisfecha.

QUÉ OTRAS DECISIONES DESAPARECEN si se acepta A:
  → Necesidad de autorizar AC-02 como rule change separado.

QUÉ OTRAS DECISIONES APARECEN si se acepta A:
  → Implementación inmediata sin más gates.

RIESGO DE A: Bajo — las reparaciones son más restrictivas, no más permisivas.
RIESGO DE B: Bajo-medio — UNKNOWN persistente en R-3.
REVERSIBILIDAD DE A: ALTA (git revert atómico).
REVERSIBILIDAD DE B: ALTA.

DEPENDENCIAS: Ninguna; independiente de READY-02/03/04.

IMPACTO EN:
  → Sistema de hooks: ninguno.
  → Sistema de evidencia: ninguno.
  → Sistema de estados: L1-C Condition 2 satisfecha.
  → Sistema de decisiones del Owner: una menos si se acepta.
  → Roadmap futuro: habilita L1-C minimal.

TIEMPO ESTIMADO DE IMPLEMENTACIÓN: < 15 minutos.
CONFIANZA EN LA INFORMACIÓN DISPONIBLE: ALTA.
ESTADO ACTUAL: READY.
═══════════════════════════════════════════════════════════
```

### 1.2 READY-02 — NH-02 Pattern + Level-1 Normalization Authorization

```text
═══════════════════════════════════════════════════════════
DECISIÓN: READY-02
═══════════════════════════════════════════════════════════

ENUNCIADO PRECISO:
¿Autorizar añadir los patrones P1' y P2' más la normalización NH-09
(2 sed lines) a bash-firewall.sh? P3 explícitamente fuera de scope.

POR QUÉ EXISTE:
Gaps sintácticos conocidos: printenv NAMED_SECRET, ${VAR}, quoted variants.
Estos bypasses son de alto riesgo práctico y bajo perfil de FP.

DECISIÓN RAÍZ DE LA QUE DEPENDE:
R2 (autorización post-F8) y R3 (representación de política).

─────────────────────────────────────────────────────────
OPCIÓN A — SÍ, autorizar P1'+P2'+NH-09
─────────────────────────────────────────────────────────
DESCRIPCIÓN: Añadir ~6 líneas a bash-firewall.sh: 2 sed de normalización +
2 entradas de regex.

QUÉ CAMBIA SI SE ACEPTA:
  → en el código: ~6 líneas nuevas en bash-firewall.sh.
  → en la arquitectura: introduce Level-1 normalization como paso intermedio.
  → en las políticas: ningún cambio (solo enforcement).
  → en los tests: fixtures de regresión para P1'/P2'/NH-09.
  → en la documentación: actualizar handbook si aplica.

QUÉ CAMBIA SI SE RECHAZA:
  → Bypasses sintácticos permanecen abiertos.
  → L1-C Condition 1 queda insatisfecha.
  → B-path (humano + staging) sigue siendo la única mitigación.

QUÉ OTRAS DECISIONES DESAPARECEN si se acepta A:
  → Necesidad de autorizar P1'/P2' por separado.

QUÉ OTRAS DECISIONES APARECEN si se acepta A:
  → Posible futura autorización de P3 tras FP testing.

RIESGO DE A: Bajo-medio — P1'/P2' tienen LOW FP; NH-09 es SAFE_NORMALIZATION.
RIESGO DE B: Medio — bypasses conocidos no bloqueados automáticamente.
REVERSIBILIDAD DE A: ALTA (git revert).
REVERSIBILIDAD DE B: ALTA.

DEPENDENCIAS: Ninguna; independiente de READY-01/03/04. NH-10 ya satisfecho.

IMPACTO EN:
  → Sistema de hooks: bash-firewall.sh cambia.
  → Sistema de evidencia: nuevos REG/EV si se añaden fixtures.
  → Sistema de estados: L1-C Condition 1 satisfecha.
  → Sistema de decisiones del Owner: una menos.
  → Roadmap futuro: habilita consideración de P3.

TIEMPO ESTIMADO DE IMPLEMENTACIÓN: < 1 hora (incluyendo tests).
CONFIANZA EN LA INFORMACIÓN DISPONIBLE: ALTA.
ESTADO ACTUAL: READY.
═══════════════════════════════════════════════════════════
```

### 1.3 READY-03 — LABYRINTH-1 L1-C Closure (Risk Acceptance)

```text
═══════════════════════════════════════════════════════════
DECISIÓN: READY-03
═══════════════════════════════════════════════════════════

ENUNCIADO PRECISO:
¿Aceptar la formulación L1-C como criterio de cierre de LABYRINTH-1,
condicionado a H-01 permaneciendo por debajo de un threshold N?
Se requiere que el Owner defina N.

POR QUÉ EXISTE:
LABYRINTH-1 no puede cerrarse absolutamente. Sin aceptación explícita del
riesgo residual, la investigación continúa indefinidamente sin criterio claro.

DECISIÓN RAÍZ DE LA QUE DEPENDE:
R4 (LABYRINTH-1 closure) y R1 (trust boundary).

─────────────────────────────────────────────────────────
OPCIÓN A — SÍ, aceptar L1-C con N=1
─────────────────────────────────────────────────────────
DESCRIPCIÓN: Declarar que cualquier evento real de bypass con alternativa
viable reabre LABYRINTH-1; hasta entonces, el residual se mitiga con B-path.

QUÉ CAMBIA SI SE ACEPTA:
  → en el código: ningún cambio.
  → en la arquitectura: ningún cambio.
  → en las políticas: posible documento de aceptación de riesgo.
  → en los tests: ninguno.
  → en la documentación: actualizar PROJECT_STATE/Exploration Engine con
     LABYRINTH-1 = CONDITIONALLY_CLOSED.

QUÉ CAMBIA SI SE RECHAZA:
  → LABYRINTH-1 permanece OPEN.
  → Investigación activa continúa sin criterio de cierre.
  → Overhead de research persistente.

QUÉ OTRAS DECISIONES DESAPARECEN si se acepta A:
  → Necesidad de implementar AC-03/CDT-02 ahora.
  → Tracks NH-08 como investigación activa.

QUÉ OTRAS DECISIONES APARECEN si se acepta A:
  → Operación de monitoreo H-01 con trigger N=1.

RIESGO DE A: UNKNOWN — H-01 materiality no resuelta.
RIESGO DE B: Medio — research overhead sin fin.
REVERSIBILIDAD DE A: ALTA (owner puede reabrir con una declaración).
REVERSIBILIDAD DE B: ALTA.

DEPENDENCIAS: READY-01/02 recomendados pero no obligatorios.

IMPACTO EN:
  → Sistema de hooks: ninguno.
  → Sistema de evidencia: ninguno.
  → Sistema de estados: LABYRINTH-1 cambia de OPEN a CONDITIONALLY_CLOSED.
  → Sistema de decisiones del Owner: cierra agenda de investigación principal.
  → Roadmap futuro: enfocado a monitoreo y triggers.

TIEMPO ESTIMADO DE IMPLEMENTACIÓN: < 30 minutos (documentación).
CONFIANZA EN LA INFORMACIÓN DISPONIBLE: MEDIA (H-01 desconocido).
ESTADO ACTUAL: READY — REQUIERE INPUT N.
═══════════════════════════════════════════════════════════
```

### 1.4 READY-04 — Enhanced-B Denial Message Authorization

```text
═══════════════════════════════════════════════════════════
DECISIÓN: READY-04
═══════════════════════════════════════════════════════════

ENUNCIADO PRECISO:
¿Autorizar modificar bash-firewall.sh y task-completed-evidence.sh para
emitir mensajes de denegación estructurados (Enhanced-B)?

POR QUÉ EXISTE:
Los mensajes actuales son mínimos. Revisores humanos necesitan más contexto
para clasificar stalls, especialmente FP como PAC-EF-02.

DECISIÓN RAÍZ DE LA QUE DEPENDE:
R2 (autorización post-F8).

─────────────────────────────────────────────────────────
OPCIÓN A — SÍ, autorizar Enhanced-B
─────────────────────────────────────────────────────────
DESCRIPCIÓN: Cambiar formato de stderr en los hooks para incluir policy_id,
prohibited_outcome, next_action, escalation_path_reference.

QUÉ CAMBIA SI SE ACEPTA:
  → en el código: formato de salida en 2 hooks.
  → en la arquitectura: ningún cambio de lógica.
  → en las políticas: ninguno.
  → en los tests: fixtures de mensaje.
  → en la documentación: referencia a NH-10 §12.

QUÉ CAMBIA SI SE RECHAZA:
  → Mensajes mínimos persisten.
  → Mayor fricción humana al revisar stalls.

QUÉ OTRAS DECISIONES DESAPARECEN si se acepta A:
  → Ninguna (es opcional de calidad).

QUÉ OTRAS DECISIONES APARECEN si se acepta A:
  → Posible estandarización de formatos de denegación.

RIESGO DE A: Bajo — solo cambio de output.
RIESGO DE B: Bajo — fricción persistente.
REVERSIBILIDAD DE A: ALTA.
REVERSIBILIDAD DE B: ALTA.

DEPENDENCIAS: NH-10 satisfecho (handbook §12).

IMPACTO EN:
  → Sistema de hooks: cambio de output.
  → Sistema de evidencia: ninguno.
  → Sistema de estados: ninguno.
  → Sistema de decisiones del Owner: mejora calidad de revisión.
  → Roadmap futuro: habilita futura automatización de clasificación.

TIEMPO ESTIMADO DE IMPLEMENTACIÓN: < 1 hora.
CONFIANZA EN LA INFORMACIÓN DISPONIBLE: ALTA.
ESTADO ACTUAL: READY.
═══════════════════════════════════════════════════════════
```

---

## 2. Decision Collapse Map

```text
┌─────────────────────────────────────────────────────┐
│ OWNER MINIMUM DECISION SET                          │
└─────────────────────────────────────────────────────┘

DECISIÓN RAÍZ 1 — R2: ¿Autorizar implementación post-F8?
    ↓
    Si NO (actual):
      → READY-02 bloqueada
      → READY-04 bloqueada
      → PAC production bloqueado
      → CDT-02 bloqueado
    Si SÍ:
      → Se desbloquean para evaluación por contrato

DECISIÓN RAÍZ 2 — R3: ¿Mantener política manual o adoptar PAC?
    ↓
    Si PAC:
      → READY-01 desaparece (reparaciones son YAML edits)
      → READY-02 se simplifica (patterns generados)
      → Duplicación política desaparece
    Si manual:
      → READY-01 y READY-02 permanecen como decisiones separadas

DECISIÓN RAÍZ 3 — R4: ¿Aceptar L1-C como cierre de LABYRINTH-1?
    ↓
    Si YES + N=1:
      → READY-03 resuelta
      → Agenda NH-08/AC-03/CDT-02 se detiene (monitor-only)
      → Investigación de LABYRINTH-1 cierra
    Si NO:
      → LABYRINTH-1 OPEN
      → Research overhead continúa

DECISIÓN RAÍZ 4 — R1: ¿Expandir trust boundary técnico?
    ↓
    Si NO (actual):
      → A-05/A-07/G-N5 diferidos
      → Git+reviewer permanece
    Si SÍ:
      → Requiere trigger externo + nueva fase

DECISIÓN RAÍZ 5 — R5: ¿Investigar runtime nativo ahora?
    ↓
    Si NO (actual):
      → F9-D02=B
      → Incertidumbre aceptada
    Si SÍ:
      → Requiere ambiente + probes

DECISIONES INDEPENDIENTES
    ↓
    READY-04 (depende solo de NH-10, ya satisfecho)
    ARCH-001..004 (ya tomadas)
    F8-A/B (ya implementadas)

DECISIONES AÚN UNKNOWN
    ↓
    H-01 materiality (requiere datos de campo)
    F10-F12 shape (requiere problema+evidencia)
    Commercial viability (H-03)
```

---

## 3. Respuestas a las 32 preguntas finales

| # | Pregunta | Respuesta con evidencia |
|---|---|---|
| 1 | ¿Qué es realmente CCP? | Infraestructura de confianza delegada: trust boundaries anidados que convierten trabajo de agente en evidencia verificable + decisión humana [09]. |
| 2 | ¿Qué hemos construido vs qué intentábamos construir? | Construimos evidence gate, hooks, registries, maintenance e incident learning. Intentábamos también autonomía segura post-bloqueo (LABYRINTH-1), que quedó como research sin implementación [02]. |
| 3 | ¿Dónde difieren intención y realidad? | Intención: agente gobernado con mínima fricción. Realidad: humano es trust boundary final; muchos problemas residuales requieren decisión humana o datos de campo [04, 09]. |
| 4 | ¿Cuál es el system model más preciso? | Híbrido: gobernanza + pipeline + ciclo de control + sistema de conocimiento [01]. |
| 5 | ¿Existe un control loop completo? ¿Dónde está roto? | Cerrado para incidentes reactivos; roto para LABYRINTH-1 por falta de observación (H-01) e implementación bloqueada (F9-D01=A) [01, 09]. |
| 6 | ¿Cuál es el flujo de información real? | Intención → hook → decisión política → block/allow → registro → evidencia → revisión humana → aprendizaje [01]. |
| 7 | ¿Qué información se duplica / pierde / deriva manualmente? | Duplicada: política (Markdown+regex), decisiones (múltiples archivos). Perdida: intención semántica, had_alternative. Derivada manualmente: regex, contract_hash, artifact_hash, PROJECT_STATE [04]. |
| 8 | ¿Cuáles son las decisiones raíz? | R1 trust boundary, R2 implementación post-F8, R3 representación de política, R4 LABYRINTH-1 closure, R5 native runtime [03]. |
| 9 | ¿Cuántas decisiones pendientes colapsan bajo decisiones raíz? | 18+ decisiones visibles colapsan a 5 raíces; READY-01/02 bajo R3; READY-03 bajo R4 [03]. |
| 10 | ¿Cuál es el problema raíz? | Cómo confiar en el trabajo de un agente de IA sin poder verificarlo completamente de forma automática [09]. |
| 11 | ¿Qué patrones se repiten? | Independencia del verificador aparece con nombres distintos; política vs enforcement reaparece en F8, READY-01, PAC [02]. |
| 12 | ¿Qué está duplicado? ¿Qué debería ser derivado? | Política duplicada; decisiones dispersas. Regex, contract_hash, artifact_hash, PROJECT_STATE deberían derivarse [04, 06]. |
| 13 | ¿Cuál es la teoría explicativa más sólida? | Sistema híbrido (T8): absorbe build, control loop, gobernanza y conocimiento [05]. |
| 14 | ¿Qué teoría tiene mayor poder explicativo? | T8 híbrido — menor información perdida [05]. |
| 15 | ¿Cuáles son las arquitecturas candidatas? | Sistema híbrido, compilador de gobernanza, sistema de gobernanza pura, sistema de conocimiento [05]. |
| 16 | ¿Sobrevive PAC como arquitectura raíz? | NO como raíz completa; SÍ como componente local para R3 [05]. |
| 17 | ¿Sobrevive el modelo de "compilador de gobernanza"? | NO como modelo dominante; SÍ como metáfora parcial para la capa de política [05]. |
| 18 | ¿Qué está en el espacio negativo? | Motor de políticas unificado, clasificación automática de stalls, observación nativa, datos H-01, motor de inferencia [06]. |
| 19 | ¿Qué podría eliminarse? | Duplicación política/enforcement, archivos de decisiones dispersos, tracks NH-08/AC-03/CDT-02 si L1-C se acepta [06]. |
| 20 | ¿Cuáles son los invariantes reales? | Evidence-gated completion, fail-closed, Project State authority, Owner auth P0, F7/F8 frozen, evidence append-only, maintenance 12/12, human reviewer boundary [08]. |
| 21 | ¿Cuál es la superficie de fallo? | Acumulación regex en bash-firewall, evidencia incorrecta, payload nativo no detectado, materialización LABYRINTH-1, omisión reviewer humano [08]. |
| 22 | ¿Cuál es el breakpoint? | 2026-09-20 (F9 owner gate closure); más investigación sin trigger no reduce incertidumbre [09]. |
| 23 | ¿Estamos convergiendo o divergiendo? | Convergencia en build; divergencia en research de frontera; breakpoint alcanzado [09]. |
| 24 | ¿Cuál es la figura oculta? | Arquitectura de trust boundaries anidados para delegar confianza [09]. |
| 25 | ¿Cuál es la missing piece? | Motor de derivación de política (PAC o equivalente) [09]. |
| 26 | ¿Cuál es el root principle? | Confianza mediante evidencia verificable y decisiones humanas explícitas, no controles automáticos ilimitados [09]. |
| 27 | ¿Cuál es la arquitectura candidata principal? | Sistema híbrido con posible adopción local de PAC para políticas [05, 09]. |
| 28 | ¿Qué la falsifica? | Un modelo puro que explique build + research con menos información perdida [05]. |
| 29 | ¿Cuál es el experimento mínimo? | Expandir corpus PAC a 25 políticas y verificar zero semantic drift [09]. |
| 30 | ¿Qué decisiones quedan para el Owner? | READY-01, READY-02, READY-03 (con N), READY-04 [esta sección]. |
| 31 | ¿Cuál es el Decision Collapse Map? | 5 decisiones raíz (R1-R5) que colapsan 18+ decisiones [03, esta sección]. |
| 32 | ¿Qué cambia bajo cada decisión raíz? | R2 desbloquea implementación; R3 colapsa READY-01/02; R4 cierra LABYRINTH-1; R5 resuelve incertidumbre nativa [03]. |

---

## 4. Recomendación analítica (no decisión)

Basado en el análisis:

1. **READY-03 con N=1** tiene el mayor impacto con menor coste: cierra LABYRINTH-1 sin código.
2. **READY-01 + READY-02** tienen B/C > 1 y habilitan L1-C minimal con cambios pequeños.
3. **READY-04** es opcional pero valiosa para calidad de revisión humana.
4. **R3 (PAC)** es la decisión arquitectónica más importante a largo plazo, pero requiere R2 (autorización post-F8) y validación de FP.

**Nota:** Esta es una recomendación analítica, no una decisión del Owner. Solo el Owner puede autorizar READY-01/02/03/04.

---

## 5. Resumen de la fase 12

- **Decisiones pendientes del Owner:** READY-01, READY-02, READY-03 (requiere N), READY-04.
- **Decisiones raíz:** 5 (R1-R5).
- **Colapso máximo:** R3 (PAC) puede absorber READY-01/02; R4 (L1-C) puede cerrar LABYRINTH-1.
- **Recomendación:** READY-03 primero; luego READY-01+02; READY-04 opcional.
- **UNKNOWN crítico:** H-01 materiality; native runtime; F10-F12 shape.
- **32 preguntas respondidas** con referencias a evidencia de los documentos anteriores.

# 09 — SYNTHESIS

> Fase 11 del protocolo maestro: mirar CCP como un único sistema, identificar la figura oculta,
> la missing piece, el root principle, el breakpoint y proyectar caminos estructurales.

---

## 1. The Hidden Figure

Cuando se quitan los nombres de fases, movimientos y documentos, la estructura que permanece es:

```text
INTENCIÓN HUMANA
      ↓
ESPECIFICACIÓN (reglas, planes, decisiones)
      ↓
ENFORCEMENT AUTOMÁTICO (hooks, evidence gate)
      ↓
OBSERVACIÓN (logs, maintenance, stalls)
      ↓
EVIDENCIA + REVIEWER HUMANO
      ↓
APRENDIZAJE (incidentes, controles, regresiones)
      ↓
NUEVA ESPECIFICACIÓN
```

Pero hay una **asimetría crítica**: el ciclo está cerrado para incidentes reactivos (INC-001) pero **roto para el problema residual de frontera** (LABYRINTH-1). La figura oculta es un **sistema de gobernanza anidado** donde cada capa delega lo que no puede resolver a la siguiente, hasta llegar al humano.

**Figura oculta:** CCP es una **arquitectura de trust boundaries anidados** que convierte la pregunta "¿está terminado?" en una cadena de evidencia, verificación y decisión humana. No es un agente, ni un compilador, ni un dashboard: es una **infraestructura de confianza delegada**.

---

## 2. Missing Piece

### 2.1 Definición

**MISSING PIECE:** Un **motor de derivación de política** que unifique la intención humana (reglas), su representación canónica y su enforcement automatizado, eliminando la duplicación actual entre `.claude/rules/*.md` y `bash-firewall.sh`.

### 2.2 Evidencia que la sugiere

1. **Duplicación política/enforcement**: política vive en Markdown humano y regex bash [VERIFICADO en 04].
2. **Investigación extensa sobre políticas PARTIAL**: M002-M007 gastaron múltiples movimientos en reparaciones, taxonomías de bypass y prototipo PAC [DOCUMENTADO en 02].
3. **PAC como breakout candidate**: M007 demostró que un YAML puede compilar a patrones bash sin drift, y que READY-01/02 colapsan conceptualmente bajo PAC [VERIFICADO en 05].

### 2.3 Problemas actuales que explica

- READY-01 y READY-02 son decisiones separadas solo porque la arquitectura actual mantiene dos representaciones.
- M002-M007 tuvieron que existir para razonar sobre algo que un motor de políticas habría absorbido.
- `bash-firewall.sh` acumula regex manualmente (FS-1).

### 2.4 Decisiones actuales que conecta

- R3 (representación de política) es la decisión raíz que conecta READY-01, READY-02 y PAC.
- F9-D01=A bloquea la implementación de este motor sin nuevo problema+evidencia.

### 2.5 Componentes que podría absorber

- `.claude/rules/*.md` como representación canónica (o reemplazada por YAML PAC).
- Patrones P1'/P2' y normalización NH-09 como salida del compiler.
- Parte de `bash-firewall.sh` como generado.

### 2.6 Componentes que podría eliminar

- Duplicación política/enforcement.
- Decisiones READY-01/02 separadas (se convierten en especificación YAML).
- Revisión manual de cobertura política vs patterns.

### 2.7 Complejidad que reduce

- Añadir/modificar políticas pasa de editar 2+ lugares a editar YAML.
- Tests de regresión pueden generarse desde la especificación.
- Auditoría de cobertura se vuelve trivial.

### 2.8 Nueva complejidad que crea

- Motor de compilación YAML → regex.
- Validación de que la compilación no introduce drift ni FP (ej. PAC-EF-02).
- Cambio de trust boundary si el compiler tiene bug.

### 2.9 Falsificador

- PAC (o cualquier motor equivalente) produce drift o FP no manejable en corpus real.

### 2.10 Experimento mínimo

- Expandir corpus PAC a 25 políticas y ejecutar compiler; verificar zero semantic drift y aceptable FP rate.

### 2.11 Nivel de confianza

**MEDIA** — soportada por prototipo y por el poder explicativo de las 3 observaciones, pero no verificada en producción.

---

## 3. Root Principle

### 3.1 Enunciado

> **La confianza en el trabajo del agente se construye mediante evidencia verificable y decisiones humanas explícitas, no mediante controles automáticos ilimitados.**

### 3.2 ¿De dónde emerge?

- F2 creó evidence-gated completion como núcleo.
- F3-F8 añadieron verificación, incident learning y fail-closed.
- F9-D01/D04/D05 rechazaron expandir controles automáticos sin evidencia o requerimiento externo.
- M001-M007 mostraron que muchos problemas de "autonomía segura" no son técnicos, sino de autorización y materialidad.

### 3.3 ¿Qué predice?

- Nuevo control automático solo si hay evidencia de un fallo que lo justifique.
- Decisiones del Owner permanecen como trust boundary último.
- Sistemas de gobernanza simples y transparentes superan a los complejos cuando no hay datos.

### 3.4 ¿Qué contradice?

- Implementar A-05/A-07/G-N5 sin requerimiento externo (F9-D04=B lo bloquea).
- Adoptar PAC en producción sin validación de FP.
- Cualquier propuesta de "autonomía total del agente".

### 3.5 ¿Qué cambia si es verdadero?

- El diseño futuro prioriza evidencia y transparencia sobre sofisticación.
- El Owner no se delega decisiones de riesgo.
- La frontera entre humano y máquina es una decisión consciente, no un accidente técnico.

---

## 4. Convergencia vs Divergencia

### 4.1 Indicadores de CONVERGENCIA (con evidencia)

| Indicador | Evidencia |
|---|---|
| Menos piezas con cada fase | F9 cerró sin añadir runtime; M008 agotó NOW-EXECUTABLE. |
| Más reutilización | PAC prototipo reutiliza especificación para generar enforcement. |
| Menos decisiones abiertas | 5 decisiones raíz colapsan 18+ decisiones visibles. |
| Menos mecanismos de compensación | Si R3 (PAC) y R4 (L1-C) se aceptan, 3 cadenas de compensación se reducen. |
| Mayor derivación automática | PAC permite derivar regex de YAML. |
| Mayor estabilidad | F7/F8 congelados; F9-D01=A evita cambios arbitrarios. |
| Mayor poder explicativo con menos componentes | T8 híbrido explica build + research sin añadir arquitectura nueva. |

### 4.2 Indicadores de DIVERGENCIA (con evidencia)

| Indicador | Evidencia |
|---|---|
| Cada movimiento crea más movimientos | M001 → M002 → ... → M007; cada uno abrió nuevas ramas. |
| Más documentos que sistema | `docs/research/CCP_FINAL_RECONCILIATION/` tiene >60 documentos. |
| Más estados que seguir manualmente | Exploration Engine mantiene decenas de estados de tracks. |
| Reaparición de problemas con nombres distintos | Independencia del verificador apareció como F-FALSE_PASS-01, B-1, PI-1, CDT-02, AC-03 [02]. |
| Más mecanismos de compensación | 3 cadenas identificadas en 06. |

### 4.3 Veredicto

**CONVERGENCIA ESTRUCTURAL PARCIAL.** El sistema converge en el build (F1-F8 cerrados, M008 agotado) pero diverge en la investigación de frontera porque el problema residual (LABYRINTH-1) no tiene datos de campo. La convergencia real depende de R4 (READY-03) y R3 (PAC o manual consolidado).

---

## 5. The Breakpoint

### 5.1 Definición

El breakpoint es el punto donde hacer más investigación sin nueva autorización o datos deja de producir progreso proporcional.

### 5.2 Evidencia

- F9 research concluyó `NOT JUSTIFIED`.
- M007 produjo PAC prototipo, HRQS y query-log.sh — los últimos mejoras autorizables sin owner decisions.
- M008 agotó NOW-EXECUTABLE.
- H-01 sigue sin datos de campo; no se puede resolver por diseño.
- READY-01/02/03/04 son decisiones del Owner, no investigaciones.

### 5.3 Cuándo ocurrió

**2026-09-20** — cierre del Owner Decision Gate F9.
**Confirmado 2026-09-23** — M008 completó todo lo ejecutable sin autorización.

### 5.4 Causa

El sistema alcanzó el límite de lo que puede resolver con investigación sintética y prototipos. Los bloqueadores restantes son autorización humana y datos de campo.

### 5.5 Consecuencia

Cualquier nueva investigación sin trigger concreto o decisión del Owner añade documentos pero no reduce incertidumbre estructural.

### 5.6 Qué pasa si no se corrige

No es un "error" que requiera corrección inmediata, pero sí un estado que debe reconocerse. Seguir investigando sería divergencia controlada.

---

## 6. Proyección Estructural

### 6.1 Camino A — Continuar como hasta ahora

**¿Qué tiende a aumentar?**
- Documentos de research.
- Tracks en Exploration Engine.
- Decisiónespendientes sin resolver.

**¿Qué tenderá a volverse más complejo?**
- `bash-firewall.sh` si se añaden más patterns manualmente.
- Registros de decisiones si no se consolidan.

**¿Cuándo podría bloquearse?**
- Cuando el corpus de research sea más grande que el sistema mismo.
- Cuando reviewer humano no pueda mantener HRQS ante más FP classes.

### 6.2 Camino B — Limpiar arquitectura actual

**¿Qué podría reducirse?**
- Duplicación política si se adopta PAC.
- Archivos de decisiones si se consolida un índice.
- Tracks de investigación si READY-03 cierra LABYRINTH-1.

**¿Qué permanecería?**
- Evidence gate, incident learning, maintenance, Git+reviewer trust boundary.

**¿Cuánto mejora la situación?**
- Reducción significativa de fricción en curado de políticas.
- Cierre operativo de LABYRINTH-1.
- Menor overhead de investigación.

### 6.3 Camino C — Cambio de paradigma

**¿Qué podría desaparecer?**
- `bash-firewall.sh` manual (reemplazado por compiler output).
- Revisión manual de cobertura política.
- Gran parte de `docs/research/` si el motor de políticas absorbe las preguntas.

**¿Qué se volvería derivado?**
- Enforcement a partir de especificación.
- Tests de regresión a partir de políticas.
- Mensajes de denegación a partir de metadatos de política.

**¿Qué simplificación máxima sería posible?**
- Owner escribe intención + políticas.
- Sistema deriva enforcement, tests y mensajes.
- Humano solo acepta riesgo residual y autoriza cambios de fase.

**Costo:** requiere confiar en un motor de compilación; cambia trust boundary; necesita validación extensa.

---

## 7. Resumen de la fase 11

- **Figura oculta:** CCP es una arquitectura de trust boundaries anidados para delegar confianza desde el agente hasta el humano.
- **Missing Piece:** motor de derivación de política (PAC o equivalente) que unifique reglas y enforcement.
- **Root Principle:** confianza mediante evidencia verificable y decisiones humanas explícitas, no controles automáticos ilimitados.
- **Convergencia/Divergencia:** convergencia en build; divergencia en research de frontera; breakpoint alcanzado.
- **Breakpoint:** 2026-09-20 (F9 owner gate closure); más investigación sin trigger no reduce incertidumbre.
- **Camino recomendado:** Camino B (limpiar arquitectura actual) conREADY-01/02/03/04 según autorización del Owner.

# 14 — Re-auditoría de seguridad

**Fecha:** 2026-09-21
**Investigador:** Claude Sonnet 4.6 (segunda pasada)
**Pregunta central:** ¿Cuáles son los riesgos de seguridad de implementar SAGR?

---

## 1. Superficie de ataque nueva que SAGR introduce

SAGR no solo tiene los riesgos de un agente normal. Añade una superficie de ataque específica porque es un sistema que, ante un bloqueo de policy, busca formas de continuar.

### 1.1 Riesgo SA-01 — SAGR como asistente de bypass

**Descripción:** Un actor malicioso o un prompt mal especificado puede conseguir que SAGR clasifique un HARD_STOP como RECOVERABLE y genere una alternativa que logre el objetivo prohibido por otro camino.

**Ejemplo concreto:** Policy bloquea "escribir en /etc/passwd." SAGR genera alternativa "usar un script que modifica un archivo temporal que luego se renombra a /etc/passwd via un proceso con permisos." El outcome es el mismo; el camino es distinto.

**Severidad:** CRÍTICA. Si SAGR es susceptible a esto, es peor que no tener SAGR — introduce un bypass sistemático con apariencia de legitimidad.

**Mitigación posible:** bypass_detect con red-teaming extensivo + human approval gate para toda acción de recovery que afecte recursos sensibles + allowlist de tipos de recovery (solo recovery de acciones de bajo riesgo).

**Estado de la mitigación:** NO IMPLEMENTADA. No existe protocolo formal de bypass detection. [HYPOTHESIS]

---

### 1.2 Riesgo SA-02 — Amplificación de errores por recovery automático

**Descripción:** Un agente en estado incorrecto (contexto corrupto, objetivo mal entendido) que detecta un STALL puede intentar recovery, generando más acciones incorrectas sobre un estado ya dañado. El recovery amplifica el error en lugar de corregirlo.

**Ejemplo concreto:** El agente interpreta incorrectamente el objetivo. Las primeras acciones son inocuas pero erróneas. El policy guard bloquea una acción que viola un constraint. SAGR clasifica como RECOVERABLE y genera 3 acciones alternativas que siguen siendo erróneas pero desde ángulos diferentes, produciendo más efectos secundarios incorrectos.

**Severidad:** ALTA. Los sistemas de recovery que no verifican el estado semántico antes de actuar pueden hacer más daño que un hard stop.

**Mitigación posible:** Verificación de estado semántico antes de iniciar recovery (¿el objetivo sigue siendo válido?). Límite de intentos de recovery por sesión. Evidence gate antes de recovery.

**Estado de la mitigación:** PARCIALMENTE DISPONIBLE — el evidence gate del CCP puede adaptarse. El límite de intentos no está especificado. [INFERRED]

---

### 1.3 Riesgo SA-03 — Side effects irreversibles durante exploración de ramas

**Descripción:** SAGR-Explore genera candidatos de acciones alternativas. En sistemas con side effects reales (APIs externas, bases de datos, sistemas de archivos), la exploración puede causar efectos irreversibles antes de adjudicar qué rama es correcta.

**Severidad:** ALTA. Esto es el problema fundamental de planning bajo incertidumbre con acciones irreversibles.

**Mitigación posible:** Exploración solo sobre acciones con side effects reversibles o en sandbox. Registro en side_effects_log antes de cada acción de exploración. Irreversibility Budget (2609.00275) como control de cuánto "daño de exploración" es aceptable.

**Estado de la mitigación:** PARCIALMENTE DISPONIBLE — el Irreversibility Budget proporciona el marco teórico; la implementación requiere que cada herramienta declare su reversibilidad. [INFERRED]

---

### 1.4 Riesgo SA-04 — Escalación no-controlada del budget de ejecución

**Descripción:** Un agente en recovery puede gastar tanto o más que el run original. Sin un budget separado y hard-capped para recovery, SAGR puede multiplicar el gasto total.

**Severidad:** MEDIA. El riesgo financiero es real pero bounded por el max_budget_usd del SDK.

**Mitigación:** Recovery budget separado con límite fijo (e.g., max 20% del budget original). Si el recovery budget se agota, HARD_STOP automático.

**Estado de la mitigación:** No existe como feature — es una configuración que un implementador debe diseñar. [INFERRED]

---

### 1.5 Riesgo SA-05 — Stale context en recovery desde checkpoint

**Descripción:** Al restaurar un checkpoint, el agente recupera el estado de S_a (contexto) en ese momento. Si el entorno S_e cambió significativamente desde ese checkpoint (el mundo avanzó), el contexto restaurado puede ser inconsistente con el estado actual del entorno.

**Severidad:** MEDIA-ALTA. AgentRewind lo reconoce explícitamente: "actualmente restaura solo controlled state." LangGraph documenta que replay puede producir resultados diferentes.

**Mitigación:** Verificación del estado del entorno antes de ejecutar desde checkpoint. Marcar el checkpoint como "stale" si detecta cambios en el entorno relevantes.

**Estado de la mitigación:** CONCEPTUALMENTE CLARA, no implementada en ningún sistema conocido como feature automática. [INFERRED]

---

## 2. Riesgos del dossier original que se confirman

Los riesgos identificados en NOTAS_CONTROL_SEGURIDAD §5 se confirman sin cambios:

- "Policy-constrained recovery con alternativa autorizada tiene conflicto de interés estructural con proveedores" — CONFIRMADO (ver NH-03)
- "El mismo modelo no puede verificar sus propias alternativas como no-bypass" — CONFIRMADO (ver hipótesis de LLM self-correction arXiv:2310.01798)
- "El default correcto para incertidumbre es HARD_STOP" — CONFIRMADO; esta segunda pasada lo refuerza como principio de seguridad

---

## 3. Postura de seguridad recomendada para cualquier implementación de SAGR

**Principio de mínima superficie:**
- SAGR-Govern debe ser un componente separado del agente principal — el mismo agente no puede gobernarse a sí mismo en recovery
- Todo recovery de acciones de alto riesgo (filesystem writes, API calls con side effects, credenciales) requiere human approval gate
- El recovery budget debe tener un hard cap no configurable en runtime (para evitar que el agente lo "ajuste")
- Cada recovery attempt debe registrarse en el audit trail del CCP con evidencia verificable

**Principio de fail-closed:**
- Si SAGR-Classify no puede determinar con suficiente confianza si es RECOVERABLE o HARD_STOP, la clasificación por defecto es HARD_STOP
- Si SAGR-Govern no puede verificar que A' no es un bypass, la decisión por defecto es ESCALATE_HUMAN o HARD_STOP

**Principio de blast radius:**
- Las primeras implementaciones de SAGR deben restringirse a acciones con side effects bajos (lectura, escritura de archivos de trabajo, consultas no-destructivas)
- La expansión a acciones de alto impacto solo después de validación extensiva y con revisión humana integrada

[INFERRED — basado en principios de seguridad de sistemas de governance]

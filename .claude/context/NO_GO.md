<!--
NO_GO.md — Anti-patrones permanentes de este proyecto
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUIÉN LO LEE : TODOS los agentes (vía context-no-go skill)
CUÁNDO       : al arrancar cualquier subagente
TAMAÑO MAX   : 30 líneas — debe ser escaneable en segundos

QUÉ PONER AQUÍ:
  ✔ Errores que ya cometiste y no quieres repetir
  ✔ Decisiones que parecen lógicas pero son trampas en tu dominio
  ✔ Anti-patrones específicos de tu negocio o stack
  ✔ Formato: "NO hacer X — razón breve (consecuencia si se ignora)"

DIFERENCIA CON SECURITY_RULES.md:
  NO_GO.md    = errores de diseño, producto o proceso
  SECURITY_RULES.md = vulnerabilidades técnicas de seguridad

CÓMO CONECTA CON EL ENGRANAJE:
  • .claude/rules/no-go.md es un espejo compacto de este archivo (cargado siempre)
  • El skill /no-go verifica acciones contra esta lista bajo demanda
  • bash-firewall.sh cubre el subconjunto técnicamente detectable
  • El resto funciona como guidance + audit

EJEMPLOS DE BUENOS NO-GO:
  - NO construir módulo X sin validar que Y existe → [consecuencia real]
  - NO proyectar ingresos sin supuestos declarados → [quemó tiempo en el pasado]
  - NO delegar decisiones de arquitectura sin evidencia → [decisión revertida]

ANTI-PATRONES UNIVERSALES (mantener siempre, son parte del control plane):
  - NO secrets en código/docs/git
  - NO cross-tenant access sin tenant_id verificado en cada query
  - NO fabricar fuentes, métricas o evidencia
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BORRAR ESTE BLOQUE AL COMPLETAR
-->

# CONTEXT PACK — NO-GO

## Universales (control plane — no modificar)
- NO secrets en código, docs ni git
- NO cross-tenant access sin tenant_id verificado en cada query
- NO fabricar fuentes, métricas ni evidencia

## Específicos de este proyecto
- NO {{acción}} — {{razón + consecuencia}}
- NO {{acción}} — {{razón + consecuencia}}
- NO {{acción}} — {{razón + consecuencia}}

Si una acción coincide → DETENER y reportar al usuario antes de continuar.

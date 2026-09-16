# RULE — NO-GO (global)

Anti-patrones prohibidos permanentemente. Espejo de `.claude/context/NO_GO.md`. Verificable con `/no-go`.

<!--
INSTRUCCIONES: Completar con los anti-patrones permanentes de TU proyecto.
Formato: "NO hacer X — razón breve"
Ver .claude/context/NO_GO.md para el contenido completo.
Mantener las primeras 4 líneas (secrets, cross-tenant, fabricar datos, cuello de botella operativo)
que son universales.
-->

- NO secrets en código/docs/git
- NO cross-tenant access sin tenant_id verificado
- NO fabricar fuentes, métricas o evidencia
- NO convertir a una sola persona en cuello de botella operativo
- NO {{acción específica #1}} — {{razón breve}}
- NO {{acción específica #2}} — {{razón breve}}
- NO {{acción específica #3}} — {{razón breve}}

Si una acción coincide → DETENER y reportar.

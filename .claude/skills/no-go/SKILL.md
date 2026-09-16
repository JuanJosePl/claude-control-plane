---
name: no-go
description: Verifica si una acción propuesta coincide con algún anti-patrón del registro NO-GO permanente.
user-invocable: true
---

# /no-go — Verificación Anti-Patrón

Verifica si una acción o propuesta viola los anti-patrones permanentes del proyecto.

## Uso

```
/no-go <descripción de la acción propuesta>
```

## Pasos

1. Leer `.claude/context/NO_GO.md` y `.claude/rules/no-go.md`.
2. Comparar la acción propuesta contra cada entrada del registro.
3. Reportar matches exactos y parciales.

## Anti-patrones verificados

- Secrets en código/docs/git
- Cross-tenant access (sin tenant_id)
- Review gating (invitar a reseña selectivamente)
- Mensajería sin opt-in documentado (Ley 1581)
- Bots WhatsApp genéricos (Meta ene-2026)
- Migrations sin rollback
- Deploy a producción sin verificación
- Decisiones sin evidencia trazable
- Hardcoded provider dependency
- Fabricar fuentes o métricas
- Convertir a Juan en cuello de botella operativo
- Proyectar ingresos sin fórmula/supuestos declarados
- Construir los 15 módulos sin validación comercial previa

## Formato de salida

```
=== VERIFICACIÓN NO-GO ===
Acción: {acción propuesta}

MATCH(ES):
  ✗ {anti-patrón} — motivo: {explicación breve}

RESULTADO: BLOQUEADO ✗ — no proceder.
       ó   LIMPIO ✔ — no se detectaron coincidencias.
```

Si BLOQUEADO: proponer alternativa que no viole el anti-patrón.

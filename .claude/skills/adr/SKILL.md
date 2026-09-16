---
name: adr
description: Registra una decisión arquitectónica en DECISION_REGISTRY.md con formato ARCH-XXX estructurado.
user-invocable: true
---

# /adr — Architectural Decision Record

Añade una decisión trazable a `DECISION_REGISTRY.md`.

## Uso

```
/adr
Title: <título breve>
Decision: <la decisión tomada>
Rationale: <por qué>
Alternatives: <qué se descartó>
Reversibility: HIGH | MEDIUM | LOW | IRREVERSIBLE
Risk: LOW | MEDIUM | HIGH | CRITICAL
Evidence: <EV-XXX o descripción de la fuente>
```

## Pasos

1. Leer `DECISION_REGISTRY.md` → obtener el último número ARCH-XXX.
2. Calcular siguiente: ARCH-{N+1:03d}.
3. Añadir entrada:

```markdown
## ARCH-{NNN} — {Title}
- **Date:** {YYYY-MM-DD}
- **Status:** APROBADA
- **Type:** architecture
- **Decision:** {texto}
- **Rationale:** {texto}
- **Alternatives considered:** {texto}
- **Reversibility:** {nivel}
- **Risk:** {nivel}
- **Evidence:** {EV-XXX o descripción}
```

4. Si la decisión afecta `ACTIVE_DECISIONS` en PROJECT_STATE → actualizar ese campo.
5. Confirmar: "ARCH-{NNN} registrado."

<!-- INSTRUCCIONES
CORE.md — Identidad técnica del proyecto
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUIÉN LO LEE : researcher, architect, implementer, security-auditor
               (inyectado por SubagentStart.additionalContext)
CUÁNDO       : al arrancar cualquier subagente
TAMAÑO MAX   : 100 líneas — si crece más, mover detalles a domain skills

QUÉ PONER AQUÍ:
  ✔ Nombre del proyecto y en una línea qué hace
  ✔ Stack técnico DECIDIDO (no opciones, sólo lo elegido y por qué)
  ✔ Lista de módulos/componentes principales (numerados)
  ✔ 5–7 reglas fundamentales (las que todo agente debe respetar)
  ✔ Convenciones de código (nombres de archivos, tablas, variables)
  ✔ Mapa de fuentes de verdad (dónde está qué en el repo)

QUÉ NO PONER (tiene su propio archivo):
  ✗ Estado de fases    → CURRENT_STATE.md
  ✗ Decisiones         → DECISIONS.md
  ✗ Compliance/legal   → SECURITY_RULES.md
  ✗ Anti-patrones      → NO_GO.md
  ✗ Contexto comercial → BUSINESS.md

CÓMO CONECTA CON EL ENGRANAJE:
  Este archivo es el "pasaporte técnico" del proyecto. Sin él, los
  subagentes no saben qué stack usan ni qué convenciones respetar.
  La skill context-core lo carga en el contexto del subagente antes
  de que el agente ejecute su primera acción.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BORRAR ESTE BLOQUE AL COMPLETAR
-->

# CONTEXT PACK — CORE

## Proyecto
**{{PROJECT_NAME}}** — {{descripción en una línea}}
**Equipo:** {{nombres y roles}}
**Horizonte:** {{fecha objetivo · país/mercado}}

## Stack decidido
- **Backend:** {{tecnología + por qué}}
- **Frontend:** {{tecnología}}
- **DB:** {{tecnología + estrategia de multitenancy si aplica}}
- **Infra:** {{docker/cloud/VPS}}

## Módulos principales
{{0. Nombre | 1. Nombre | 2. Nombre ...}}

## Reglas fundamentales
1. {{regla crítica #1}}
2. {{regla crítica #2}}
3. {{...}}

## Convenciones de código
```
{{Archivos: camelCase.ts | Componentes: PascalCase.tsx | Tablas DB: snake_case}}
```

## Fuentes de verdad
- `PROJECT_STATE.md` — estado operativo (fase, bloqueantes, checkpoint)
- `DECISION_REGISTRY.md` — decisiones con evidencia y reversibilidad
- `ARTIFACT_MANIFEST.md` — checklist de entregables por fase

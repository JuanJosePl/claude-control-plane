# 35 — Auditoría de Consistencia entre Documentos

**Fecha:** 2026-09-21
**Auditor:** Claude Sonnet 4.6 (meta-auditoría)
**Alcance:** Inconsistencias entre los 6 NOTAS_*.md (GPT), los archivos 00–31 (CLAUDE_SECOND_PASS), y el dossier original.

---

## Inconsistencia 1: Cobertura de RIR ("70%" vs sin cuantificación)

**Archivo A:** `docs/research/CCP_SAGR_RESEARCH_DOSSIER.md` §11 — "RIR cubre el 70% de la composición SAGR"
**Archivo B:** `docs/research/SAGR_DEEP_RESEARCH/NOTAS_AUDITORIA_DOSSIER.md` §4 — señala que "70%" no tiene rúbrica ni denominador; clasifica como precisión falsa
**Archivo C:** `docs/research/SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/18_JUICIOS_FINALES_AUDITADOS.md` — no usa porcentajes para RIR

**Naturaleza:** Cifra no justificada en dossier original, corregida en pasadas posteriores. Sin inconsistencia residual entre NOTAS y CLAUDE_SECOND_PASS.

**Resolución:** RESUELTA en documentos de segunda pasada. La cifra "70%" no debe usarse en ningún documento futuro sin rúbrica demostrable.

**Estado:** CERRADA.

---

## Inconsistencia 2: Descripción de OSGuard ("hard stop only" vs feedback + retry)

**Archivo A:** `CCP_SAGR_RESEARCH_DOSSIER.md` §4 P12, §5, §11 — OSGuard como "fixed retry budget, terminates after N retries, hard stop only"
**Archivo B:** `NOTAS_AUDITORIA_DOSSIER.md` §2 — OSGuard corregido con fuente primaria: bloqueo → feedback → revisión de acción → re-chequeo → límite 2 reintentos
**Archivo C:** `05_ERRORES_Y_CORRECCIONES.md` — lista la corrección formalmente

**Naturaleza:** Error factual en dossier, correctamente corregido en NOTAS y segunda pasada. Sin inconsistencia residual.

**Resolución:** RESUELTA. La descripción correcta es la de NOTAS_AUDITORIA_DOSSIER.

**Estado:** CERRADA.

---

## Inconsistencia 3: Término "generate_alternative" — ¿es el único bloqueante?

**Archivo A:** `20_CLAUDE_FINAL_SYNTHESIS.md` §"Los dos únicos problemas que realmente importan" — lista `generate_alternative` y `non_bypass_verify` como los dos únicos bloqueantes técnicos no resueltos
**Archivo B:** `18_JUICIOS_FINALES_AUDITADOS.md` §J-06 — "SP-3 (generate A' ≠ bypass) no tiene implementación conocida" — correctamente acotado a SP-3
**Archivo C:** Meta-auditoría (esta pasada) — PolicyGuide (2608.19861) y SafeAgent (2604.17562) implementan generate_alternative para workflows estructurados; el gap es en open-ended agents

**Naturaleza:** Inconsistencia entre "ninguno implementó esto" (20_CLAUDE) y la evidencia de que PolicyGuide y SafeAgent implementan versiones estructuradas.

**Resolución:** PARCIALMENTE RESUELTA. La formulación correcta es: "generate_alternative para agentes de tasks abiertos (no-workflow-structured) no tiene implementación pública conocida." PolicyGuide y SafeAgent cubren el dominio estructurado. El gap genuino es narrower que lo articulado en el archivo 20.

**Estado:** REQUIERE CORRECCIÓN MENOR en archivo 20_CLAUDE_FINAL_SYNTHESIS (el lenguaje "nadie" debe limitarse a "open-ended agents").

---

## Inconsistencia 4: HEAD del repositorio ("035a573" vs "74f7d1e")

**Archivo A:** `CCP_SAGR_RESEARCH_DOSSIER.md` — declara `BASELINE: Repository HEAD 035a573`
**Archivo B:** `NOTAS_AUDITORIA_DOSSIER.md` §1 — detecta que HEAD real es `74f7d1e`; `git diff --name-only 035a573..HEAD` muestra 2 archivos documentales adicionales
**Archivo C:** `00_INVENTARIO_DEL_TRABAJO_GPT.md` §9 — confirma divergencia y nota que es material para reproducibilidad

**Naturaleza:** El dossier usó un baseline incorrecto (desactualizado). La divergencia es solo documental (2 archivos), no de runtime. La inconsistencia afecta reproducibilidad, no la conclusión técnica.

**Resolución:** RESUELTA documentalmente. No hay impacto en la conclusión técnica. El HEAD correcto al 2026-09-21 es `74f7d1e`.

**Estado:** CERRADA.

---

## Inconsistencia 5: Clasificación de "control-induced stall" — ¿categoría formal o descripción informal?

**Archivo A:** `CCP_SAGR_RESEARCH_DOSSIER.md` — usa "control-induced stall" como categoría establecida
**Archivo B:** `06_BUSQUEDA_INDEPENDIENTE.md` B-05 — "NO ENCONTRADO como término canónico" en literatura
**Archivo C:** `NOTAS_CONTROL_SEGURIDAD.md` — usa el término libremente sin señalar que es informal

**Naturaleza:** El dossier presenta un término inventado como si fuera categoría de la literatura. NOTAS_CONTROL_SEGURIDAD lo perpetúa sin señalarlo. 06_BUSQUEDA_INDEPENDIENTE lo corrige.

**Resolución:** RESUELTA en segunda pasada. El término es descriptivo e inventado por la investigación, no una categoría de la literatura. El 36_DICCIONARIO_DEFINICIONES debe aclararlo.

**Estado:** CERRADA con nota al diccionario.

---

## Inconsistencia 6: "No existe formalización de recovery" vs papers que la demuestran

**Archivo A:** `CCP_SAGR_RESEARCH_DOSSIER.md` §7 — "no existe clasificación formal HARD STOP vs RECOVERABLE STOP"
**Archivo B:** `NOTAS_AUDITORIA_DOSSIER.md` §3 — corrige con Recoverability (2609.13672)
**Archivo C:** `11_RECONSTRUCCION_DEL_PROBLEMA.md` — acepta la corrección y construye sobre ella

**Naturaleza:** Error factual en dossier, correctamente corregido. Sin inconsistencia residual.

**Resolución:** RESUELTA. Recoverability (2609.13672) formaliza la clasificación.

**Estado:** CERRADA.

---

## Inconsistencia 7: Claim "3 casos en 4 semanas" — ¿umbral o hipótesis?

**Archivo A:** `20_CLAUDE_FINAL_SYNTHESIS.md` §"La cereza del pastel" — "Si la respuesta es 'al menos 3', SAGR vale la pena construirlo"
**Archivo B:** `18_JUICIOS_FINALES_AUDITADOS.md` — H-01 listado como Unknown con alta urgencia, sin umbral cuantitativo
**Archivo C:** `12_RECONSTRUCCION_DEL_MODELO.md`, `15_REAUDITORIA_DE_ECONOMIA.md` — no especifican umbral

**Naturaleza:** El archivo 20 presenta un umbral concreto (3 casos, 4 semanas) que no aparece derivado en ningún otro documento. La justificación no está articulada. Esto es inconsistente con el rigor del resto de la investigación.

**Resolución:** REQUIERE CORRECCIÓN. El umbral "3 en 4 semanas" es HYPOTHESIS sin base demostrada. Debe presentarse como ejemplo operacional illustrativo, no como umbral decisional. Ver 38_AUDITORIA_FINAL_DEL_MASTER §D para la auditoría completa.

**Estado:** PENDIENTE — se resuelve en 38_AUDITORIA_FINAL_DEL_MASTER.

---

## Resumen

| ID | Naturaleza | Estado |
|----|-----------|--------|
| IC-1 | RIR "70%" sin rúbrica | CERRADA |
| IC-2 | OSGuard "hard stop only" incorrecto | CERRADA |
| IC-3 | "generate_alternative" — gap narrower de lo declarado | REQUIERE CORRECCIÓN MENOR |
| IC-4 | HEAD del repo desactualizado en dossier | CERRADA |
| IC-5 | "control-induced stall" como categoría formal | CERRADA con nota |
| IC-6 | "No existe formalización de recovery" | CERRADA |
| IC-7 | Umbral "3 casos en 4 semanas" sin base | PENDIENTE (→ 38_AUDITORIA) |

**Inconsistencias materiales pendientes:** 1 (IC-7)
**Inconsistencias menores pendientes:** 1 (IC-3 — lenguaje en 20_CLAUDE)

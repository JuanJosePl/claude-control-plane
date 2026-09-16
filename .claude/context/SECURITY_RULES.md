<!-- INSTRUCCIONES
SECURITY_RULES.md — Restricciones de seguridad no negociables
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUIÉN LO LEE : architect, implementer, security-auditor
CUÁNDO       : al arrancar esos subagentes
TAMAÑO MAX   : 60 líneas

QUÉ PONER AQUÍ:
  ✔ Restricciones de seguridad técnicas no negociables
  ✔ Controles de acceso a datos (multitenancy, RLS, auth)
  ✔ Manejo de secretos y variables de entorno
  ✔ Validación de inputs (SQL injection, XSS, etc.)
  ✔ Referencias a compliance técnico (OWASP, estándares sectoriales)

DIFERENCIA CON NO_GO.md:
  SECURITY_RULES = vulnerabilidades técnicas de seguridad
  NO_GO = errores de diseño, producto o proceso

CÓMO CONECTA CON EL ENGRANAJE:
  • bash-firewall.sh y secret-guard.sh son el enforcement técnico
  • Este archivo es el contexto para que los agentes tomen decisiones correctas
  • security-auditor lo usa como checklist de auditoría
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BORRAR ESTE BLOQUE AL COMPLETAR
-->

# CONTEXT PACK — SECURITY RULES

## Universales (mantener siempre)
- Secrets NUNCA en código → siempre variables de entorno
- No leer/exponer `.env`, `*.pem`, `*.key`, `~/.ssh/*`, `~/.aws/credentials`
- Parameterized queries siempre; nunca concatenar SQL
- Ante duda de verificación → reportar `UNKNOWN`, nunca "probably fine"

## Específicos de este proyecto
- {{Control de acceso: cómo se aíslan los datos por tenant/usuario}}
- {{Auth: qué mecanismo, qué tokens, cómo se validan}}
- {{Inputs externos: qué se valida, dónde, con qué librería}}
- {{APIs externas: cómo se autentican, qué webhooks se validan}}

## Referencias
- {{OWASP Top 10:2025 — link}}
- {{Estándar sectorial si aplica}}

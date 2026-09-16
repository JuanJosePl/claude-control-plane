# RULE — SECURITY (global)

Recordatorio permanente. El **enforcement real** está en hooks P0 (bash-firewall, secret-guard) y
en `permissions` de settings.json.

- Secrets NUNCA en código ni documentación → variables de entorno.
- No leer/exponer `.env`, `.env.*`, `*.pem`, `*.key`, `*.pfx`, `~/.ssh/*`, `~/.aws/credentials`.
- No `git add` de archivos de secretos.
- Parameterized queries siempre; nunca concatenar SQL.
- Aislamiento de datos en cada query (tenant_id, RLS, o el mecanismo que definas en SECURITY_RULES.md).
- Ante duda de verificación → `UNKNOWN`, nunca "probably fine".

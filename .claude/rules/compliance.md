# RULE — COMPLIANCE (global)

<!--
INSTRUCCIONES: Completar según el país y regulación de tu proyecto.
  Colombia → Ley 1581 (Habeas Data)
  Europa   → GDPR
  México   → LFPDPPP
  USA      → CCPA / HIPAA (si health)

Principios universales (mantener siempre):
  - Consentimiento explícito antes de captar datos personales
  - consent_records como tabla de primera clase
  - NO reactivar bases sin opt-in previo
  - NO review gating (Google abr-2026)
  - WhatsApp: opt-in + plantillas aprobadas + HMAC validation
-->

# Completar con las reglas específicas de tu jurisdicción

- Consentimiento explícito antes de captar datos personales.
- `consent_records` = tabla de primera clase (opt-in con timestamp/canal/finalidad).
- NO reactivar bases sin opt-in previo.
- NO review gating — invitar a reseña a TODOS los clientes con opt-in por igual.
- Ante duda de verificación → reportar `UNKNOWN`, nunca "probably fine".

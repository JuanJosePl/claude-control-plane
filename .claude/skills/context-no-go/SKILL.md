---
name: context-no-go
description: Carga el context pack NO_GO.md — anti-patrones prohibidos permanentemente
---

# Context: NO_GO

Lee y aplica `.claude/context/NO_GO.md` antes de responder.

```
Read(".claude/context/NO_GO.md")
```

Si una acción coincide con un anti-patrón → DETENER y reportar antes de proceder.

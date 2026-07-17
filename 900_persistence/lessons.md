# Lessons Learned

> Conocimiento acumulado: errores cometidos, cómo se resolvieron y qué hacer distinto.
> Objetivo: que ningún agente repita un error ya resuelto en una sesión anterior.

## Índice

> Mantener sincronizado: al registrar una lección, añadir su fila aquí.
> Buscar por ID (`L-XXX`) para localizar la lección sin leer todo el archivo.

| ID | Lección | Fecha |
|---|---|---|
| L-001 | Duplicar `.claude/` (raíz vs `template/.claude/`) autocontiene el entregable pero crea riesgo de desincronización | 2026-07-17 |

## Formato

```
### L-001 — <título de la lección>
- **Contexto:** qué se estaba haciendo.
- **Problema:** qué salió mal o qué no era obvio.
- **Solución / aprendizaje:** qué funcionó y por qué.
- **Cómo aplicarlo:** regla accionable para el futuro.
- **Fecha:** YYYY-MM-DD
```

---

## Lecciones

### L-001 — Duplicar `.claude/` (raíz vs `template/.claude/`) autocontiene el entregable pero crea riesgo de desincronización
- **Contexto:** Se copiaron (no movieron) `.claude/agents` y `.claude/skills` de la raíz a `template/.claude/` para que el entregable `template/` fuera autocontenido y usable de forma independiente.
- **Problema:** Al haber dos copias físicas de los mismos skills/agentes, cualquier cambio futuro en la raíz (correcciones, nuevas versiones) no se propaga automáticamente a `template/.claude/`, y viceversa. Sin disciplina o automatización, ambas copias pueden divergir silenciosamente.
- **Solución / aprendizaje:** Se documentó explícitamente que la raíz es la fuente de verdad y `template/.claude/` es un reflejo; se registró como tarea pendiente (T-002) evaluar un script de re-copia.
- **Cómo aplicarlo:** Antes de dar por cerrada una sesión que tocó skills/agentes, verificar si `template/.claude/` necesita re-sincronizarse; no asumir que un cambio en la raíz ya se refleja en el entregable.
- **Fecha:** 2026-07-17

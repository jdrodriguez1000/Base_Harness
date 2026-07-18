# Assumptions

> Supuestos que se dan por ciertos pero NO están confirmados.
> Si un supuesto se confirma → se promueve a [[decisions]] o [[constrains]].
> Si se refuta → se documenta la corrección en [[lessons]].

## Índice

> Mantener sincronizado: al registrar o cambiar el estado de un supuesto, actualizar su fila aquí.
> Buscar por ID (`A-XXX`) para localizar el supuesto sin leer todo el archivo.

| ID | Supuesto | Estado | Fecha |
|---|---|---|---|
| A-001 | Si el bloque de agentes/evaluación/observabilidad de `methodology.md` supera ~250 líneas, se divide en `methodology.md` (proceso) + `agents-and-evaluation.md` | sin validar | 2026-07-17 |
| A-002 | `interview_document.md` se conserva como traza junto a `discovery.md` tras la síntesis del writer (no se descarta) | sin validar | 2026-07-17 |

## Formato

```
### A-001 — <supuesto>
- **Estado:** sin validar | confirmado | refutado
- **Impacto si es falso:** qué se rompe o cambia si el supuesto no se cumple.
- **Cómo validarlo:** acción para confirmar o descartar.
- **Fecha:** YYYY-MM-DD
```

---

## Supuestos

### A-001 — Gatillo de división de `methodology.md` en dos archivos
- **Estado:** sin validar
- **Impacto si es falso:** Si el umbral (~250 líneas) resulta arbitrario o el bloque agentes/evaluación/observabilidad crece de forma distinta a lo previsto, la división podría hacerse en el momento equivocado (muy pronto, fragmentando innecesariamente; o muy tarde, con el archivo ya difícil de navegar).
- **Cómo validarlo:** Revisar el tamaño real de ese bloque en próximas iteraciones de `methodology.md`; si se cruza el umbral, ejecutar la división en `methodology.md` (proceso) + `agents-and-evaluation.md` y confirmar que la tabla de contenidos y las referencias cruzadas siguen siendo navegables.
- **Fecha:** 2026-07-17

### A-002 — Conservar `interview_document.md` como traza junto a `discovery.md`
- **Estado:** sin validar
- **Impacto si es falso:** Si el usuario prefiere descartar el log crudo tras la síntesis (p. ej. por ruido o privacidad de las respuestas del humano), habría que documentar un paso de limpieza en el skill `discovery-protocol` (borrar o archivar `interview_document.md` una vez generado `discovery.md`), y ajustar la plantilla `interview_temp.md`/su ubicación en consecuencia.
- **Cómo validarlo:** Confirmar con el usuario, al construir o probar el flujo del Prototipador (T-022) o en una sesión posterior, si el log crudo debe persistir como traza auditable o descartarse tras la síntesis.
- **Fecha:** 2026-07-17

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

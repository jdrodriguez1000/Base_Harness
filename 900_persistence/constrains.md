# Constraints

> Restricciones firmes que acotan el proyecto: técnicas, de negocio, legales, de tiempo o de recursos.
> A diferencia de [[assumptions]], una restricción NO es negociable dentro del alcance actual.
> A diferencia de [[decisions]], no es una elección nuestra: es una condición impuesta.

## Índice

> Mantener sincronizado: al registrar una restricción, añadir su fila aquí.
> Buscar por ID (`C-XXX`) para localizar la restricción sin leer todo el archivo.

| ID | Restricción | Tipo | Fecha |
|---|---|---|---|
| C-001 | El harness debe ser agnóstico al proyecto y al agente | técnica | 2026-07-17 |

## Formato

```
### C-001 — <restricción>
- **Tipo:** técnica | negocio | legal | tiempo | recursos
- **Descripción:** en qué consiste la restricción.
- **Origen:** quién o qué la impone.
- **Implicación:** cómo condiciona el trabajo.
- **Fecha:** YYYY-MM-DD
```

---

## Restricciones

### C-001 — El harness debe ser agnóstico al proyecto y al agente
- **Tipo:** técnica
- **Descripción:** No puede acoplarse a un stack, lenguaje o herramienta de IA específica; debe funcionar con Claude Code, Codex, opencode y Gemini.
- **Origen:** Requisito fundacional del proyecto.
- **Implicación:** Evitar dependencias propietarias; preferir formatos abiertos (Markdown, archivos de texto) y una fuente única de verdad reutilizable.
- **Fecha:** 2026-07-17
